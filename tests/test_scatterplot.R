library(testthat)
library(ggplot2)

if (file.exists("R/scatterplot.R")) {
  source("R/scatterplot.R")
} else {
  source("../R/scatterplot.R")
}

test_data <- data.frame(budget = c(1, 2, 3), domgross = c(2, 4, 6))
test_data_knn <- data.frame(
  budget = c(1, 2, 3),
  domgross = c(2, 4, 6),
  domgross_pred = c(2.1, 4.1, 6.1)
)

test_that("make_scatter_plot returns ggplot with points and LM smooth", {
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

test_that("make_scatter_plot supports se = FALSE (linear regression)", {
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

test_that("make_scatter_plot supports pred_line without smooth (KNN)", {
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

test_that("make_scatter_plot returns ggplot object from return()", {
  p <- make_scatter_plot(test_data, budget, domgross, "t", "x", "y", smooth_method = NULL)
  expect_true(inherits(p, "ggplot"))
})

test_that("make_scatter_plot sets title and axis labels in labs()", {
  p <- make_scatter_plot(
    test_data,
    budget,
    domgross,
    title = "My title",
    x_lab = "X axis",
    y_lab = "Y axis",
    smooth_method = NULL
  )
  expect_equal(p$labels$title, "My title")
  expect_equal(p$labels$x, "X axis")
  expect_equal(p$labels$y, "Y axis")
})

test_that("make_scatter_plot uses pred_line_color for the prediction line", {
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
