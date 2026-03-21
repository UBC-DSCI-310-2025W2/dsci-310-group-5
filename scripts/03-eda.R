"Usage:
  03-eda.R --input=<path> --output=<path> --output_data=<path>

Options:
  --input=<path>   Path to data
  --output=<path>  Path/filename prefix
  --output_data=<path> Path to save data with log transformations
" -> doc

library(docopt)
library(ggplot2)
library(dplyr)

main <- function(input, output,output_data) {
  movie_data  <- read.csv(input)
  out <- dirname(output)
  dir.create(out, recursive = TRUE, showWarnings = FALSE)

  writeLines(capture.output(summary(movie_data )), paste0(out, "/eda_summary.txt"))
  writeLines(capture.output(str(movie_data )), paste0(out, "/eda-movie_data.txt"))

  png(paste0(out, "/figure1-eda_boxplot.png"))
  par(mfrow = c(1, 2))
  boxplot(movie_data $budget, main = "Boxplot of Movie Budget", ylab = "Budget (USD)")
  boxplot(movie_data $domgross, main = "Boxplot of Movie Revenue", ylab = "Revenue (USD)")
  par(mfrow = c(1,1))

  png(paste0(out, "/figure2-eda_histogram.png"))
  par(mfrow = c(1, 2))
  hist(movie_data $budget, main = "Histogram of Movie Budget", xlab = "Budget (USD)")
  hist(movie_data $domgross, main = "Histogram of Movie Revenue", xlab = "Revenue (USD)")
  par(mfrow = c(1,1))

  ggsave(paste0(out, "/figure3-eda_revenue_vs_budget.png"),
    ggplot(movie_data , aes(budget, domgross)) + geom_point() + geom_smooth(method = "lm") +
    labs(title = "Domestic Revenue vs Movie Budget", x = "Budget (USD)", y = "Revenue (USD)"))

  write.csv(data.frame(correlation = cor(movie_data $budget, movie_data $domgross)), paste0(out, "/eda_correlation.csv"), row.names = FALSE)

  movie_data <- movie_data %>%
    mutate(log_budget = log(budget), log_domgross = log(domgross))

  write.csv(movie_data, output_data, row.names = FALSE)

  ggsave(paste0(out, "/figure4-eda_log_revenue_vs_log_budget.png"),
    ggplot(movie_data, aes(log_budget, log_domgross)) + geom_point() + geom_smooth(method = "lm") +
    labs(title = "Log(Revenue) vs Log(Budget)", x = "Log(Budget)", y = "Log(Revenue)"))

  write.csv(head(movie_data, 6), paste0(out, "/table3_first_six_rows_log.csv"), row.names = FALSE)

}

opt <- docopt(doc)
main(opt$input, opt$output, opt$output_data)
