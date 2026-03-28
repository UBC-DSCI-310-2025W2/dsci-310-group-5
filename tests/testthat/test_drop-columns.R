library(testthat)
source("../../R/drop-columns.R")

test_data <- data.frame(names = c("Emma", "Michelle", "Melody"), 
                        age = c(20, 22, 21), 
                        major = c("Psychology", "Cognitive Systems", "Kinesiology"))

# test 1 column 
test_that("drop_columns drops a single column when given a vector", {
  expect_equal(names(drop_columns(test_data, c("age"))),
               c("names", "major"))
})


test_that("drop_columns drops a single column when given a string", {
  expect_equal(names(drop_columns(test_data, "age")),
               c("names", "major"))
})


# test multiple columns 
test_that("drop_columns drops multiple columns", {
  expect_equal(names(drop_columns(test_data, c("names", "major"))),
               c("age"))
})


# test all columns dropped
test_that("drop_columns drops all columns, return empty data frame", {
  expect_equal(names(drop_columns(test_data, c("names", "age", "major"))),
               character(0))
})


# test columns dropped with names listed out of order
test_that("drop_columns drops all columns, despite out of order", {
  expect_equal(names(drop_columns(test_data, c("age", "major", "names"))),
               character(0))
})


# test no column names given 
test_that("drop_columns doesn't drop any columns with empty vector given", {
  expect_equal(names(drop_columns(test_data, c())),
               c("names", "age", "major"))
})


# test column name not in data 
test_that("drop_columns throws error when a given column name is not in the data", {
  expect_error(drop_columns(test_data, c("names", "gender")))
})


# test columns argument not in correct format
test_that("drop_columns throws error when columns argument not a vector", {
  expect_error(drop_columns(test_data, 100))
})

test_that("drop_columns throws error when columns vector elements aren't only strings", {
  expect_error(drop_columns(test_data, c(100, 10)))
})

test_that("drop_columns throws error when columns vector elements aren't only strings", {
  expect_error(drop_columns(test_data, c(100, 10, "a")))
})


# test data argument in incorrect format
test_that("drop_columns throws error when data argument isn't a data frame", {
  expect_error(drop_columns("test_data", c("names")))
})


# test null columns
test_that("drop_columns returns full dataframe when 'columns is null", {
  expect_equal(names(drop_columns(test_data, NULL)),
               c("names", "age", "major"))
})


# test null data
test_that("drop_columns throws error when 'data' is null", {
  expect_error(drop_columns(NULL, c("names")))
})
