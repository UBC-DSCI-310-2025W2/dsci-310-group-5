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

opt <- docopt(doc)
data <- read.csv(opt$input)
out <- dirname(opt$output)
dir.create(out, recursive = TRUE, showWarnings = FALSE)

set.seed(120)
split <- initial_split(data, prop = 0.7)
train <- training(split)
test <- testing(split)

knn_recipe <- recipe(log_domgross ~ log_budget, data = train) |>
  step_scale(all_predictors()) |>
  step_center(all_predictors())

knn_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = tune()) |>
  set_engine("kknn") |>
  set_mode("regression")

knn_vfold <- vfold_cv(train, v = 10, strata = log_domgross)
knn_wkflw <- workflow() |>
  add_recipe(knn_recipe) |>
  add_model(knn_spec)

set.seed(120)
gridvals <- tibble(neighbors = seq(from = 1, to = 200, by = 3))
knn_results <- knn_wkflw |>
  tune_grid(resamples = knn_vfold, grid = gridvals) |>
  collect_metrics() |>
  filter(.metric == "rmse")

kmin <- knn_results |> filter(mean == min(mean)) |> pull(neighbors)
knn_spec_min <- nearest_neighbor(weight_func = "rectangular", neighbors = kmin) |>
  set_engine("kknn") |>
  set_mode("regression")

knn_fit <- workflow() |> add_recipe(knn_recipe) |> add_model(knn_spec_min) |> fit(data = train)

preds <- knn_fit |> predict(test) |> bind_cols(test) |> rename(log_domgross_pred = .pred)

metrics <- preds |> metrics(truth = log_domgross, estimate = log_domgross_pred) |>
  filter(.metric == "rmse")
write.csv(metrics, paste0(out, "/knn_metrics.csv"), row.names = FALSE)
write.csv(data.frame(neighbors = kmin), paste0(out, "/knn_best_k.csv"), row.names = FALSE)

preds_sorted <- preds |> arrange(log_budget)
p <- ggplot(preds_sorted, aes(x = log_budget, y = log_domgross)) +
  geom_point(alpha = 0.6) +
  geom_line(aes(y = log_domgross_pred), color = "blue") +
  labs(title = paste0("KNN Regression (K = ", kmin, "): Predicted vs Actual"),
       x = "Log(Movie Budget)", y = "Log(Domestic Revenue)") +
  theme_minimal()
ggsave(paste0(out, "/knn_pred.png"), p)
