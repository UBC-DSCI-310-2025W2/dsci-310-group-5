library(pointblank)
library(tidyselect)

bechdel_columns <- c("budget", "domgross")
bechdel_log_columns <- c("log_budget", "log_domgross")
model_feature_cols <- c("log_budget")

# Correct data file format
validate_csv_file_format <- function(path) {
  tbl <- read.csv(path, nrows = 5)
  agent <- interrogate(
    tbl |>
      create_agent(label = "csv_file_format") |>
      col_exists(columns = bechdel_columns)
  )
  if (!all(agent$validation_set$all_passed)) stop("Incorrect data file format.")
  agent
}

# Correct column names
validate_column_names <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "bechdel_column_names") |>
      col_exists(columns = bechdel_columns)
  )
  if (!all(agent$validation_set$all_passed)) stop("Incorrect column names.")
  agent
}

# Correct column names -log transformed data
validate_log_column_names <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "modeling_log_column_names") |>
      col_exists(columns = bechdel_log_columns)
  )
  if (!all(agent$validation_set$all_passed)) stop("Incorrect log transformed column names.")
  agent
}

# No empty observations
no_empty_obs <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "movie_budget_domgross_complete") |>
      rows_complete(columns = all_of(bechdel_columns))
  )
  if (!all(agent$validation_set$all_passed)) stop("Empty observations there.")
  agent
}

# No empty observations - log transformed data
log_no_empty_obs <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "modeling_log_no_empty") |>
      rows_complete(columns = all_of(bechdel_log_columns))
  )
  if (!all(agent$validation_set$all_passed)) stop("Empty (log) observations there.")
  agent
}

# No duplicate observations
no_duplicate_obs <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "bechdel_no_duplicate_rows") |>
      rows_distinct()
  )
  if (!all(agent$validation_set$all_passed)) stop("Duplicate observations.")
  agent
}

# No duplicate observations - log transformed data
log_no_duplicate_obs <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "bechdel_log_no_duplicate_rows") |>
      rows_distinct()
  )
  if (!all(agent$validation_set$all_passed)) stop("Duplicate (log) observations.")
  agent
}

# Correct data types in each column
numeric_types <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "budget_domgross_numeric") |>
      col_is_numeric(columns = all_of(bechdel_columns))
  )
  if (!all(agent$validation_set$all_passed)) stop("Incorrect data types in each column.")
  agent
}

# Correct data types in each column - log transformed data
log_numeric_types <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "modeling_log_numeric") |>
      col_is_numeric(columns = all_of(bechdel_log_columns))
  )
  if (!all(agent$validation_set$all_passed)) stop("Incorrect data types in each (log) column.")
  agent
}

# Missingness not beyond expected threshold
na_threshold <- function(tbl, max_prop = 0.1) {
  mx <- max(colMeans(is.na(tbl[bechdel_columns])))
  agent <- interrogate(
    data.frame(max_na_prop = mx) |>
      create_agent(label = "missingness_budget_domgross") |>
      col_vals_lte(columns = max_na_prop, value = max_prop)
  )
  if (!all(agent$validation_set$all_passed)) stop("Missingness beyond expected threshold.")
  agent
}

# Missingness not beyond expected threshold - log transformed data
log_na_threshold <- function(tbl, max_prop = 0.1) {
  mx <- max(colMeans(is.na(tbl[bechdel_log_columns])))
  agent <- interrogate(
    data.frame(max_na_prop = mx) |>
      create_agent(label = "missingness_log") |>
      col_vals_lte(columns = max_na_prop, value = max_prop)
  )
  if (!all(agent$validation_set$all_passed)) stop("Missingness beyond expected threshold (log transformed data).")
  agent
}

# No outlier or anomalous values
no_outliers <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "budget_domgross_bounds") |>
      col_vals_between(columns = budget, left = 0, right = 1e12, na_pass = TRUE) |>
      col_vals_between(columns = domgross, left = 0, right = 1e12, na_pass = TRUE)
  )
  if (!all(agent$validation_set$all_passed)) stop("Outlier or anomalous values.")
  agent
}

# No outlier or anomalous values - log transformed data
log_no_outliers <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "log_bounds") |>
      col_vals_between(columns = log_budget, left = 0, right = 30, na_pass = TRUE) |>
      col_vals_between(columns = log_domgross, left = 0, right = 35, na_pass = TRUE)
  )
  if (!all(agent$validation_set$all_passed)) stop("Outlier or anomalous values (log transformed data).")
  agent
}

# No anomalous correlations between features/explanatory variables (train data)
feature_corr <- function(train, feature_cols = model_feature_cols, max_abs_cor = 0.9) {
  x <- train[, feature_cols, drop = FALSE]
  if (ncol(x) < 2) return(NULL)
  corr_matrix <- cor(x, use = "pairwise.complete.obs")
  mx <- max(abs(corr_matrix[row(corr_matrix) != col(corr_matrix)]))
  agent <- interrogate(
    data.frame(max_abs_inter_feature_r = mx) |>
      create_agent(label = "train_inter_feature_cor") |>
      col_vals_lte(columns = max_abs_inter_feature_r, value = max_abs_cor)
  )
  if (!all(agent$validation_set$all_passed)) stop("Anomalous correlations between features/explanatory variables (train data)")
  agent
}
