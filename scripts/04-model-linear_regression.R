"Usage:
  04-model-linear_regression.R --input=<path> --output=<path>

Options:
  --input=<path>   Path to cleaned data
  --output=<path>  Path prefix for outputs
" -> doc

library(docopt)
library(dplyr)
library(ggplot2)
library(tidymodels)

library(wrangler)

opt <- docopt(doc)
data <- read.csv(opt$input)
out <- dirname(opt$output)
dir.create(out, recursive = TRUE, showWarnings = FALSE)

set.seed(120)
data_split <- initial_split(data, prop = 0.7)
train <- training(data_split)
test <- testing(data_split)

train_mean <- train |> summarize(train_log_budget_mean = mean(log_budget), train_log_domgross_mean = mean(log_domgross))
test_mean <- test |> summarize(test_log_budget_mean = mean(log_budget), test_log_domgross_mean = mean(log_domgross))
write.csv(train_mean, paste0(out, "/table4_train_mean.csv"), row.names = FALSE)
write.csv(test_mean, paste0(out, "/table5_test_mean.csv"), row.names = FALSE)

lm <- lm(formula = log_domgross ~ log_budget, data = train)
writeLines(capture.output(summary(lm)), paste0(out, "/linear_regression_summary.csv"))
writeLines(capture.output(summary(lm)), paste0(out, "/linear_regression_summary.txt"))

preds <- predict(lm, test) |> bind_cols(test)
preds <- preds |> rename(log_domgross_preds = ...1) |> select(log_domgross_preds, log_budget, log_domgross)
write.csv(preds, paste0(out, "/table6_linear_regression_preds.csv"), row.names = FALSE)

preds_plot <- make_scatter_plot(
  preds,
  log_budget,
  log_domgross,
  title = "Log(Revenue) vs Log(Budget)",
  x_lab = "Log(Budget)",
  y_lab = "Log(Revenue)",
  smooth_method = "lm",
  se = FALSE
)
ggsave(paste0(out, "/figure5_linear_regression_pred.png"), preds_plot)

metrics <- metrics(preds, truth = log_domgross, estimate = log_domgross_preds) |>
  filter(.metric == "rmse")
write.csv(metrics, paste0(out, "/table7_linear_regression_metrics.csv"), row.names = FALSE)