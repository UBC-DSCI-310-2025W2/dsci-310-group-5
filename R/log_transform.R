#' Log Transform a Numeric Vector
#'
#' Applies a natural logarithm transformation to a numeric vector.
#' This is useful for stabilizing variance in heavily right-skewed
#' distributions, such as movie budget and box office revenue data.
#'
#' @param x A numeric vector of strictly positive values to be log transformed.
#' @param col_name A string indicating the name of the variable being
#'   transformed. Used in error messages for clarity. Default is "input".
#'
#' @return A numeric vector of the same length as `x` containing
#'   the natural log of each element.
#'
#' @examples
#' log_transform(c(1000, 5000, 20000))
#' log_transform(c(1.3e+07, 4.5e+07), col_name = "budget")
#'
#' @export
log_transform <- function(x, col_name = "input") {
  if (!is.numeric(x)) {
    stop(paste0(
      "`", col_name, "` must be a numeric vector, ",
      "got: ", class(x)
    ))
  }
  if (length(x) == 0) {
    stop(paste0("`", col_name, "` must not be empty."))
  }
  if (any(is.na(x))) {
    stop(paste0(
      "`", col_name, "` contains NA values. ",
      "Remove NAs before log transforming."
    ))
  }
  if (any(x <= 0)) {
    stop(paste0(
      "`", col_name, "` contains zero or negative values. ",
      "Log transformation requires strictly positive values."
    ))
  }
  log(x)
}