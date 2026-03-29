library(testthat)

source("../../R/log_transform.R")

# --- expected use test cases ---

# Test case 1: simple positive numeric vector returns correct log values
test_that("log_transform returns correct log values for a simple positive numeric vector", {
  result <- log_transform(c(1, exp(1), exp(2)))
  expect_equal(result, c(0, 1, 2))
})

# Test case 2: single positive value returns a numeric vector of length 1
test_that("log_transform works correctly on a single positive value", {
  result <- log_transform(1000)
  expect_equal(result, log(1000))
  expect_length(result, 1)
})

# Test case 3: large values typical of movie budgets transform correctly
test_that("log_transform correctly transforms movie budget-scale values", {
  budgets <- c(1.3e+07, 4.5e+07, 2.0e+07)
  result <- log_transform(budgets, col_name = "budget")
  expect_equal(result, log(budgets))
})

# Test case 4: output is numeric vector of same length as input
test_that("log_transform returns a numeric vector of the same length as input", {
  x <- c(10, 100, 1000, 10000)
  result <- log_transform(x)
  expect_true(is.numeric(result))
  expect_length(result, length(x))
})

# --- edge test cases ---

# Test case 5: vector of length 1 with value 1 returns 0
test_that("log_transform of 1 returns 0", {
  expect_equal(log_transform(1), 0)
})

# Test case 6: col_name argument appears in error message
test_that("col_name appears in error message when input is invalid", {
  expect_error(
    log_transform(c(-1, 2), col_name = "budget"),
    "budget"
  )
})

# --- error test cases ---

# Test case 7: non-numeric input throws an error
test_that("log_transform throws an error when input is not numeric", {
  expect_error(
    log_transform(c("a", "b", "c")),
    "must be a numeric vector"
  )
})

# Test case 8: input containing NA throws an error
test_that("log_transform throws an error when input contains NA values", {
  expect_error(
    log_transform(c(1, NA, 3)),
    "contains NA values"
  )
})

# Test case 9: input containing zero throws an error
test_that("log_transform throws an error when input contains zero", {
  expect_error(
    log_transform(c(0, 1, 2)),
    "zero or negative values"
  )
})

# Test case 10: input containing negative values throws an error
test_that("log_transform throws an error when input contains negative values", {
  expect_error(
    log_transform(c(-5, 1, 2)),
    "zero or negative values"
  )
})

# Test case 11: empty vector throws an error
test_that("log_transform throws an error when input is an empty vector", {
  expect_error(
    log_transform(numeric(0)),
    "must not be empty"
  )
})