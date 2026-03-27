#' Filters out values of 0 from all numeric columns in a given dataset
#'
#' @param data A dataframe with at least one numeric vector. 
#'
#' @return A numeric vector where all rows with a value of 0 are filtered out 

data <- data.frame(a = c(0,1,2,3),
                   b = c(1,2,3,4))

filter_data <- function(data) {
  if (!is.data.frame(data)) {
    stop("Error: Input must be a dataframe")
  } 
  if (if_all(data, !is.numeric)) { # referenced https://dplyr.tidyverse.org/reference/across.html 
    stop("Error: dataframe must have a numeric column")
  }
  if (is.data.frame(data)) { 
    numeric_columns <- colnames(data[, sapply(data, is.numeric)]) # referenced https://www.statology.org/r-get-column-names/
  }
}