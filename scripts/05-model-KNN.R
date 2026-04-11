"Usage:
  05-model-KNN.R --input=<path> --output=<path>

Options:
  --input=<path>   Path to cleaned data
  --output=<path>  Path prefix for outputs (e.g. results/knn)
" -> doc

library(docopt)
library(dplyr)
library(ggplot2)
library(tidymodels)

source("R/scatterplot.R")

opt <- docopt(doc)
data <- read.csv(opt$input)
# out <- dirname(opt$output)
out <- opt$output
dir.create(out, recursive = TRUE, showWarnings = FALSE)

set.seed(120)
data_split <- initial_split(data, prop = 0.7)
train <- training(data_split)
test <- testing(data_split)

knn_recipe <- recipe(log_domgross ~ log_budget, data = train) |>
  step_scale(all_predictors()) |>
  step_center(all_predictors())

knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = tune()) |>
  set_engine("kknn") |>
  set_mode("regression")

set.seed(120)
knn_vfold <- vfold_cv(train, v = 10, strata = log_domgross)
knn_wkflw <- workflow() |> add_recipe(knn_recipe) |> add_model(knn_spec)

set.seed(120)
gridvals <- tibble(neighbors = seq(from = 1, to = 200, by = 3))
knn_results <- knn_wkflw |>
  tune_grid(resamples = knn_vfold, grid = gridvals) |>
  collect_metrics() |>
  filter(.metric == "rmse")

write.csv(head(knn_results, 6), paste0(out, "table8_knn_tune_results.csv"), row.names = FALSE)

knn_min <- knn_results |> filter(mean == min(mean))
write.csv(knn_min, paste0(out, "table9_knn_min.csv"), row.names = FALSE)
set.seed(120)
kmin <- knn_min |> pull(neighbors)

knn_spec_min <- nearest_neighbor(weight_func = "rectangular", neighbors = kmin) |>
  set_engine("kknn") |>
  set_mode("regression")

cv_metrics <- workflow() |>
  add_recipe(knn_recipe) |>
  add_model(knn_spec_min) |>
  fit_resamples(resamples = knn_vfold) |>
  collect_metrics() |>
  filter(.metric == "rmse")
write.csv(cv_metrics, paste0(out, "table10_knn_cv_metrics.csv"), row.names = FALSE)

knn_fit_min <- workflow() |>
  add_recipe(knn_recipe) |>
  add_model(knn_spec_min) |>
  fit(data = train)

knn_summary <- knn_fit_min |>
  predict(test) |>
  bind_cols(test) |>
  metrics(truth = log_domgross, estimate = .pred) |>
  filter(.metric == 'rmse')

write.csv(knn_summary, paste0(out, "table11_knn_metrics.csv"), row.names = FALSE)
#write.csv(data.frame(neighbors = kmin), paste0(out, "/table8_knn_best_k.csv"), row.names = FALSE)

knn_preds <- knn_fit_min |>
  predict(test) |>
  bind_cols(test) |>
  rename(log_domgross_pred = .pred)
write.csv(knn_preds |> select(log_domgross_pred, log_budget, log_domgross), paste0(out, "knn_preds.csv"), row.names = FALSE)

p <- make_scatter_plot(
  knn_preds,
  log_budget,
  log_domgross,
  title = paste0("K = ", kmin),
  x_lab = "Log(Movie Budget)",
  y_lab = "Log(Domestic Revenue)",
  smooth_method = NULL,
  point_alpha = 0.6,
  pred_line = "log_domgross_pred"
)
ggsave(paste0(out, "figure6_knn_pred.png"), p)
