library(testthat)

source("../../R/filter-data.R")

# simple cases 
one_col <- data.frame(a = c(0, 1, 2, 3))
one_col_output <- data.frame(a = c(1, 2, 3)) 
# need to assign row labels because the function keeps the original row labels
row.names(one_col_output) <- c(2, 3, 4) # https://www.statology.org/change-row-names-in-r/

three_cols <- data.frame(a = c(0, 1, 2, 3),
                         b = c(1, 0, 3, 4),
                         c = c(1, 2, 3, 4))
three_cols_output <- data.frame(a = c(2, 3),
                                b = c(3, 4), 
                                c = c(3, 4))
row.names(three_cols_output) <- c(3, 4)

mixed_data_type <- data.frame(a = c(0, 1, 2, 3), 
                           numbers = c("zero", "one", "two","three"),
                           numbers2 = c("one", 0, 2, "three"))
mixed_data_type_output <- data.frame(a = c(2, 3),
                                  numbers = c("two","three"),
                                  numbers2 = c(2, "three"))
row.names(mixed_data_type_output) <- c(3, 4)

# simple case tests
test_that("`filter_data` returns a data frame with all rows containing a
          0 filtered out when given a single column data frame", {
  expect_equal(filter_data(one_col), one_col_output)
})

test_that("`filter_data` returns a data frame with all rows containing a  
          0 filtered out when given a data frame with multiple columns", {
  expect_equal(filter_data(three_cols), three_cols_output)
})

test_that("`filter_data` returns a data frame with all rows containing a  
          0 filtered out when given data containing 0s in numeric and character data type columns", {
  expect_equal(filter_data(mixed_data_type), mixed_data_type_output)
})

# edge cases
all_zeros <- data.frame(zeros = c(0, 0, 0))
all_zeros_output <- data.frame(zeros = double()) # provides a different output from the function if don't specify data type 
row.names(all_zeros_output) <- as.character() # function returns indices/row names as character data type 

all_zeros_character <- data.frame(string = c("0", "0", "0"))
all_zeros_character_output <- data.frame(string = character())
row.names(all_zeros_character_output) <- as.character()

one_row_zero <- data.frame(a = c(0),
                      b = c(1),
                      c = c(2))
one_row_zero_output <- data.frame(a = double(),
                             b = double(),
                             c = double())
row.names(one_row_zero_output) <- as.character()

two_row_one_zero <- data.frame(a = c(1, 1),
                      b = c(1, 2),
                      c = c(0, "3"))
two_row_one_zero_output <- data.frame(a = c(1),
                             b = c(2),
                             c = as.character(c(3)))
row.names(two_row_one_zero_output) <- c(2)

no_zero <- data.frame(a = c(1, 2),
                      b = c(3, 4))
no_zero_output <- data.frame(a = c(1, 2),
                             b = c(3, 4))
row.names(no_zero_output) <- c(1, 2)

# edge case tests
test_that("`filter_data` returns a data frame with no rows when given a data frame 
          with all values as numeric 0s", {
  expect_equal(filter_data(all_zeros), all_zeros_output)
})

test_that("`filter_data` returns a data frame with no rows when given a data frame 
          with all values as character type 0s", {
  expect_equal(filter_data(all_zeros_character), all_zeros_character_output)
})

test_that("`filter_data` returns a data frame with no rows when given a data frame with one 
          row with a 0", {
  expect_equal(filter_data(one_row_zero), one_row_zero_output)
})

test_that("`filter_data` returns a data frame with one row when given a data frame with 
          two rows with one containing a 0", {
  expect_equal(filter_data(two_row_one_zero), two_row_one_zero_output)
})

test_that("`filter_data` returns the original data frame when given data with no 0s", {
  expect_equal(filter_data(no_zero), no_zero_output)
})

# error/abnormal cases
not_data_frame <- c(1, 2, 3, 0)

string <- "data"

empty_data_frame <- data.frame()

na_input <- NA

test_that("`filter_data` returns an error when the input provided is not a data frame", {
  expect_error(filter_data(not_data_frame))
})

test_that("`filter_data` returns an error when the input provided is not a data frame", {
  expect_error(filter_data(string))
})

test_that("`filter_data` returns an error when the input provided is an empty data frame", {
  expect_error(filter_data(empty_data_frame))
})

test_that("`filter_data` returns an error when the input provided is NA", {
  expect_error(filter_data(na_input))
})

