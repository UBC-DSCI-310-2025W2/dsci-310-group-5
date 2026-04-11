library(pointblank)
library(tidyselect)

bechdel_columns <- c("budget", "domgross")
bechdel_log_columns <- c("log_budget", "log_domgross")

# Correct data file format
validate_csv_file_format <- function(path) {
  tbl <- read.csv(path, nrows = 5)
  agent <- interrogate(
    tbl |>
      create_agent(label = "csv_file_format") |>
      col_exists(
        columns = all_of(bechdel_columns),
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# Correct column names
validate_column_names <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "bechdel_column_names") |>
      col_exists(
        columns = all_of(bechdel_columns),
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# Correct column names -log transformed data
validate_log_column_names <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "modeling_log_column_names") |>
      col_exists(
        columns = all_of(bechdel_log_columns),
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# No empty observations
no_empty_obs <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "movie_budget_domgross_complete") |>
      rows_complete(
        columns = all_of(bechdel_columns),
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# No empty observations - log transformed data
log_no_empty_obs <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "modeling_log_no_empty") |>
      rows_complete(
        columns = all_of(bechdel_log_columns),
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# No duplicate observations
no_duplicate_obs <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "bechdel_no_duplicate_rows") |>
      rows_distinct(actions = warn_on_fail(warn_at = 1))
  )
  # agent
}

# No duplicate observations - log transformed data
log_no_duplicate_obs <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "bechdel_log_no_duplicate_rows") |>
      rows_distinct(actions = warn_on_fail(warn_at = 1))
  )
  # agent
}

# Correct data types in each column
numeric_types <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "budget_domgross_numeric") |>
      col_is_numeric(
        columns = all_of(bechdel_columns),
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# Correct data types in each column - log transformed data
log_numeric_types <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "modeling_log_numeric") |>
      col_is_numeric(
        columns = all_of(bechdel_log_columns),
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# Missingness not beyond expected threshold
na_threshold <- function(tbl, warn_at = 0.30) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "missingness_budget_domgross") |>
      col_vals_not_null(
        columns = all_of(bechdel_columns),
        actions = warn_on_fail(warn_at = warn_at)
      )
  )
  # agent
}

# Missingness not beyond expected threshold - log transformed data
log_na_threshold <- function(tbl, warn_at = 0.30) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "missingness_log") |>
      col_vals_not_null(
        columns = all_of(bechdel_log_columns),
        actions = warn_on_fail(warn_at = warn_at)
      )
  )
  # agent
}

# No outlier or anomalous values
no_outliers <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "budget_domgross_bounds") |>
      col_vals_between(
        columns = budget,
        left = 0,
        right = 1e12,
        na_pass = TRUE,
        actions = stop_on_fail(stop_at = 1)
      ) |>
      col_vals_between(
        columns = domgross,
        left = 0,
        right = 1e12,
        na_pass = TRUE,
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# No outlier or anomalous values - log transformed data
log_no_outliers <- function(tbl) {
  agent <- interrogate(
    tbl |>
      create_agent(label = "log_bounds") |>
      col_vals_between(
        columns = log_budget,
        left = 0,
        right = 30,
        na_pass = TRUE,
        actions = stop_on_fail(stop_at = 1)
      ) |>
      col_vals_between(
        columns = log_domgross,
        left = 0,
        right = 35,
        na_pass = TRUE,
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

# No anomalous correlations between target/response variable and features/explanatory variables
validate_correlation <- function(train) {
  r <- cor(train$log_budget, train$log_domgross, use = "pairwise.complete.obs")
  if (is.na(r)) stop("Correlation between target/response variable and features/explanatory variables is NA.")
  agent <- interrogate(
    data.frame(abs_r = abs(r)) |>
      create_agent(label = "train_response_vs_log_budget_cor") |>
      col_vals_lt(
        columns = abs_r,
        value = 1,
        actions = stop_on_fail(stop_at = 1)
      )
  )
  # agent
}

validate_clean_bechdel <- function(tbl) {
  validate_column_names(tbl)
  numeric_types(tbl)
  no_empty_obs(tbl)
  no_duplicate_obs(tbl)
  na_threshold(tbl)
  no_outliers(tbl)
}

validate_log_bechdel <- function(tbl) {
  validate_log_column_names(tbl)
  log_no_empty_obs(tbl)
  log_no_duplicate_obs(tbl)
  log_numeric_types(tbl)
  log_na_threshold(tbl)
  log_no_outliers(tbl)
}
