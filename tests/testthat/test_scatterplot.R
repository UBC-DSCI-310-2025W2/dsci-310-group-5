library(testthat)
library(ggplot2)

source("../../R/scatterplot.R")

# test input data

test_data <- data.frame(
  budget = c(1, 2, 3),
  domgross = c(2, 4, 6)
)

test_data_knn <- data.frame(
  budget = c(1, 2, 3),
  domgross = c(2, 4, 6),
  domgross_pred = c(2.1, 4.1, 6.1)
)

# expected test outputs

test_that("EDA default: ggplot with geom_point and geom_smooth (>= 2 layers)", {
  p <- make_scatter_plot(
    test_data,
    budget,
    domgross,
    title = "Domestic Revenue vs Movie Budget",
    x_lab = "Budget (USD)",
    y_lab = "Revenue (USD)"
  )
  expect_s3_class(p, "ggplot")
  b <- ggplot_build(p)
  expect_true(length(b$plot$layers) >= 2)
})

test_that("Linear regression style: LM smooth with se = FALSE builds", {
  p <- make_scatter_plot(
    test_data,
    budget,
    domgross,
    title = "Log(Revenue) vs Log(Budget)",
    x_lab = "Log(Budget)",
    y_lab = "Log(Revenue)",
    smooth_method = "lm",
    se = FALSE
  )
  expect_s3_class(p, "ggplot")
})

test_that("KNN style: points + pred line, no smooth", {
  p <- make_scatter_plot(
    test_data_knn,
    budget,
    domgross,
    title = "K = 7",
    x_lab = "Log(Movie Budget)",
    y_lab = "Log(Domestic Revenue)",
    smooth_method = NULL,
    point_alpha = 0.6,
    pred_line = "domgross_pred"
  )
  expect_s3_class(p, "ggplot")
  b <- ggplot_build(p)
  expect_true(length(b$plot$layers) >= 2)
})

test_that("Return value is a ggplot object", {
  p <- make_scatter_plot(
    test_data,
    budget,
    domgross,
    "t",
    "x",
    "y",
    smooth_method = NULL
  )
  expect_true(inherits(p, "ggplot"))
})

test_that("labs() receives title and axis labels", {
  expected_title <- "My title"
  expected_x <- "X axis"
  expected_y <- "Y axis"
  p <- make_scatter_plot(
    test_data,
    budget,
    domgross,
    title = expected_title,
    x_lab = expected_x,
    y_lab = expected_y,
    smooth_method = NULL
  )
  expect_equal(p$labels$title, expected_title)
  expect_equal(p$labels$x, expected_x)
  expect_equal(p$labels$y, expected_y)
})

test_that("pred_line_color is passed to geom_line", {
  p <- make_scatter_plot(
    test_data_knn,
    budget,
    domgross,
    title = "t",
    x_lab = "x",
    y_lab = "y",
    smooth_method = NULL,
    pred_line = "domgross_pred",
    pred_line_color = "red"
  )
  line_layer <- p$layers[[2]]
  expect_equal(line_layer$aes_params$colour, "red")
})

test_that("points only: one layer when smooth and pred_line are NULL", {
  p <- make_scatter_plot(
    test_data,
    budget,
    domgross,
    title = "Points only",
    x_lab = "x",
    y_lab = "y",
    smooth_method = NULL,
    pred_line = NULL
  )
  expect_length(p$layers, 1L)
})

# error test cases

test_that("error when pred_line names a column not in data", {
  p <- make_scatter_plot(
    test_data,
    budget,
    domgross,
    title = "t",
    x_lab = "x",
    y_lab = "y",
    smooth_method = NULL,
    pred_line = "no_such_column"
  )
  expect_error(ggplot_build(p), regexp = "not found")
})

test_that("error when x aesthetic references a column not in data", {
  p <- make_scatter_plot(
    test_data,
    !!rlang::sym("not_a_column"),
    domgross,
    title = "t",
    x_lab = "x",
    y_lab = "y",
    smooth_method = NULL
  )
  expect_error(ggplot_build(p), regexp = "aesthetics|not found")
})
