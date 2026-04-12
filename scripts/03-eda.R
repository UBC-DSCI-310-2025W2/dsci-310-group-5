# This script performs the EDA for the analysis: reads cleaned data from --input, writes log_bechdel.csv under --output, and writes EDA tables and figures under --output_results.

"Usage:
  03-eda.R --input=<path> --output=<path> --output_results=<path>

Options:
  --input=<path>   Path to data
  --output=<path>  Path to save processed data (log_bechdel.csv) 
  --output_results=<path>    Path to save figures (table1, table2, table3)

" -> doc

library(docopt)
library(ggplot2)
library(dplyr)
library(wrangler)
source("R/data-validation.R")

main <- function(input, output, output_results) {
  movie_data  <- read.csv(input)
  validate_clean_bechdel(movie_data)
  out <- output_results
  dir.create(output, recursive = TRUE, showWarnings = FALSE)
  dir.create(out, recursive = TRUE, showWarnings = FALSE)

  # Tabular EDA: five-number summaries and column types
  write.csv(as.data.frame(do.call(cbind, lapply(movie_data, summary))), paste0(out, "eda_summary.csv"), row.names = TRUE)
  write.csv(as.data.frame(lapply(movie_data, function(x) class(x))), paste0(out, "eda-movie_data.csv"), row.names = FALSE)

  # Boxplot of Movie Budget and Revenue
  png(paste0(out, "figure1-eda_boxplot.png"))
  par(mfrow = c(1, 2))
  boxplot(movie_data$budget, main = "Boxplot of Movie Budget", ylab = "Budget in USD")
  boxplot(movie_data$domgross, main = "Boxplot of Movie Revenue", ylab = "Revenue in USD")
  par(mfrow = c(1,1))

  png(paste0(out, "figure2-eda_histogram.png"))
  par(mfrow = c(1, 2))
  hist(movie_data$budget, main = "Histogram of Movie Budget", xlab = "Budget in USD")
  hist(movie_data$domgross, main = "Histogram of Movie Revenue", xlab = "Revenue in USD")
  par(mfrow = c(1,1))

  ggsave(paste0(out, "figure3-eda_revenue_vs_budget.png"),
    make_scatter_plot(
      movie_data,
      budget,
      domgross,
      title = "Domestic Revenue vs Movie Budget",
      x_lab = "Budget (USD)",
      y_lab = "Revenue (USD)"
    ))

  write.csv(data.frame(correlation = cor(movie_data$budget, movie_data$domgross)), paste0(out, "eda_correlation.csv"), row.names = FALSE)

  movie_data <- movie_data %>%
    mutate(
      log_budget = log_transform(budget, col_name = "budget"),
      log_domgross = log_transform(domgross, col_name = "domgross")
    )
  validate_log_bechdel(movie_data)
  path = file.path(output, "log_bechdel.csv")
  write.csv(movie_data, path, row.names = FALSE)

  ggsave(paste0(out, "figure4-eda_log_revenue_vs_log_budget.png"),
    make_scatter_plot(
      movie_data,
      log_budget,
      log_domgross,
      title = "Log(Revenue) vs Log(Budget)",
      x_lab = "Log(Budget)",
      y_lab = "Log(Revenue)"
    ))

  write.csv(head(movie_data, 6), paste0(out, "table3_first_six_rows_log.csv"), row.names = FALSE)

}

opt <- docopt(doc)

main(opt$input, opt$output, opt$output_results)