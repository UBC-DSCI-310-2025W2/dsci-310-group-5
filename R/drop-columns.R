#' Drops specified columns from a given data set
#'
#'
#' @param data A data frame that includes the columns to be dropped
#' @param columns A vector of column names
#'
#' @return A new data frame with the specified columns dropped

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
