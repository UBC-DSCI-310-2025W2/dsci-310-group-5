library(ggplot2)

#' Scatter plots for budget vs revenue analysis
#'
#' @param data A data frame.
#' @param x Column name for the x axis.
#' @param y Column name for the y axis.
#' @param title Plot title.
#' @param x_lab x-axis label.
#' @param y_lab y-axis label.
#' @param smooth_method Passed to ggplot2::geom_smooth() `method`.
#'   Use `NULL` for no smooth.
#' @param se Whether to show the smooth confidence ribbon.
#' @param point_alpha Alpha for ggplot2::geom_point().
#' @param pred_line Optional; name of the column of fitted y values (string).
#' @param pred_line_color Color for the prediction line.
#'
#' @return A ggplot2::ggplot scatterplot.
#'
#' @examples
#' df <- data.frame(
#'   budget = c(16000, 26000, 36000),
#'   domgross = c(26000, 46000, 66000)
#' )
#' make_scatter_plot(
#'   df,
#'   budget,
#'   domgross,
#'   title = "Domestic revenue vs budget",
#'   x_lab = "Budget (USD)",
#'   y_lab = "Revenue (USD)"
#' )
#'
#' df$pred <- df$domgross
#' make_scatter_plot(
#'   df,
#'   budget,
#'   domgross,
#'   title = "With prediction line",
#'   x_lab = "Budget",
#'   y_lab = "Revenue",
#'   smooth_method = NULL,
#'   pred_line = "pred"
#' )
#'
#' @export
make_scatter_plot <- function(data, x, y, title, x_lab, y_lab, smooth_method = "lm", se = TRUE,
                              point_alpha = 1, pred_line = NULL, pred_line_color = "blue") {
  if (!is.data.frame(data)) {
    stop("Error: 'data' must be a data frame")
  }

  nm <- names(data)
  axes <- list(x = substitute(x), y = substitute(y))
  for (param in names(axes)) {
    expr <- axes[[param]]
    if (!is.symbol(expr)) next
    col <- as.character(expr)
    if (!col %in% nm) {
      stop(paste0("Error: '", param, "' column does not exist in 'data': ", col))
    }
  }

  if (!is.null(pred_line)) {
    if (!is.character(pred_line)) {
      stop("Error: 'pred_line' must be a vector of column names (strings)")
    }
    invalid_pred <- pred_line[!(pred_line %in% nm)]
    if (length(invalid_pred) > 0) {
      stop(paste(
        "Error: the following columns given are not in the data:",
        paste(invalid_pred, collapse = ", ")
      ))
    }
  }

  p <- eval(substitute(ggplot(data, aes(x, y)), list(x = substitute(x), y = substitute(y)))) +
    geom_point(alpha = point_alpha)

  if (!is.null(smooth_method)) {
    p <- p + geom_smooth(
      method = smooth_method,
      se = se,
      formula = y ~ x
    )
  }

  if (!is.null(pred_line)) {
    p <- p + geom_line(
      aes(y = .data[[pred_line]]),
      color = pred_line_color
    )
  }

  p <- p + labs(
    title = title,
    x = x_lab,
    y = y_lab
  )

  return(p)
}
