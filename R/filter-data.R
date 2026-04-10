#' Filters out values of 0 from all numeric and character columns in a given data frame.
#'
#' @param data A data frame with at least one numeric vector. 
#'
#' @return A data frame where all rows with a numeric or character value of 0 in any column are filtered out. 
#' If there are no 0s, original data frame is returned.  
#' Indexes (row names) will contain the same values as the original data frame.
#' Rows containing the string "zero" spelled out will not be filtered. 
#' 
#' @examples 
#' filter_data(data.frame(a = c(0, 0, 1, 2),
#'                        b = c(1, 2, 3, 4),
#'                        c = c("one", "two", "three", "four"))
#'                  
#' @export

filter_data <- function(data) {
  if (!is.data.frame(data)) {
    stop("Error: Input must be a data frame")
  } 
  if (nrow(data) == 0) {
    stop("Error: Data frame must have at least one row")
  } 
  if (is.data.frame(data)) { 
    columns <- colnames(data) 
    filtered_df <- data[apply(data!=0, 1, all), ] # referenced https://www.statology.org/r-remove-rows-with-any-zero/
    indices <- row.names(data[apply(data!=0, 1, all), 0]) # https://www.statology.org/change-row-names-in-r/
    filtered_df <- data.frame(filtered_df) 
    colnames(filtered_df) <- columns 
    row.names(filtered_df) <- indices
    return(filtered_df)
  }
}

