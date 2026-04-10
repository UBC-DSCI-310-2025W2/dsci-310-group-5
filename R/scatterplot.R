#' Scatter plots for budget vs revenue analysis
#'
#' @param data A data frame
#' @param x column name for the x axis
#' @param y column name for the y axis
#' @param title Plot title
#' @param x_lab x-axis label
#' @param y_lab y-axis label
#' @param smooth_method Passed to ggplot2::geom_smooth() `method`
#'   Use `NULL` for no smooth
#' @param se Whether to show the smooth confidence ribbon
#' @param point_alpha Alpha for ggplot2::geom_point()
#' @param pred_line Optional; name of the column of fitted y values
#' @param pred_line_color Color for the prediction line
#'
#' @return A ggplot2::ggplot scatterplot
library(ggplot2)
make_scatter_plot <- function(data,x,y,title,x_lab,y_lab,smooth_method = "lm",se = TRUE,
    point_alpha = 1,pred_line = NULL,pred_line_color = "blue") {
  p <- ggplot(data, aes({{x}}, {{y}})) +
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
