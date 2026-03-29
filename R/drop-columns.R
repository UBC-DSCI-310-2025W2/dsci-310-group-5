#' Drops specified columns from a given data set
#'
#'
#' @param data A data frame that includes the columns to be dropped
#' @param columns A character vector of column names to drop
#'
#' @return A new data frame with the specified columns dropped
#' 
#' @examples 
#' drop_columns(data.frame(a = c(1, 2, 3),
#'                         b = c(4, 5, 6),
#'                         c = c(7, 8, 9)), c("a", "c"))
#' drop_columns(data.frame(a = c(1, 2, 3),
#'                         b = c(4, 5, 6),
#'                         c = c(7, 8, 9)), "b")
#'                         
#' If 'columns' argument is null, the original data frame is returned unchanged
#' An error is thrown if a column name in 'columns' does not exist in 'data'.
#'                         
#' @export

drop_columns <- function(data, columns) {
  if (!is.data.frame(data)) {
    stop("Error: 'data' must be a data frame")
  }
  
  if (is.null(columns)) {
    return(data)
  }
  
  if (!is.character(columns)) {
    stop("Error: 'columns' must be a vector of column names (strings)")
  }
  
  invalid_cols <- columns[!(columns %in% names(data))]
  if (length(invalid_cols) > 0) {
    stop(paste("Error: the following columns given are not in the data:", 
               paste(invalid_cols, collapse = ", ")))
  }
  
  dropped_col_data <- data[, !(names(data) %in% columns), drop = FALSE]
  return(dropped_col_data)
}
