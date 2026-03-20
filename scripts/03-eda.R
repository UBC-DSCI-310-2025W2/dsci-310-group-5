"Usage:
  03-eda.R --input=<path> --output=<path>

Options:
  --input=<path>   Path to data
  --output=<path>  Path/filename prefix (e.g. results/eda)
" -> doc

library(docopt)
library(ggplot2)

main <- function(input, output) {
  data <- read.csv(input)
  out <- dirname(output)
  dir.create(out, recursive = TRUE, showWarnings = FALSE)

  writeLines(capture.output(summary(data)), paste0(out, "/eda_summary.csv"))
  writeLines(capture.output(str(data)), paste0(out, "/eda-movie_data.csv"))

  png(paste0(out, "/figure1-eda_boxplot.png"))
  par(mfrow = c(1, 2))
  boxplot(data$budget, main = "Boxplot of Movie Budget", ylab = "Budget in USD")
  boxplot(data$domgross, main = "Boxplot of Movie Revenue", ylab = "Revenue in USD")

  png(paste0(out, "/figure2-eda_histogram.png"))
  par(mfrow = c(1, 2))
  hist(data$budget, main = "Histogram of Movie Budget", xlab = "Budget in USD")
  hist(data$domgross, main = "Histogram of Movie Revenue", xlab = "Revenue in USD")

  ggsave(paste0(out, "/figure3-eda_revenue_vs_budget.png"),
    ggplot(data, aes(budget, domgross)) + geom_point() + geom_smooth(method = "lm") +
    labs(title = "Domestic Revenue vs Movie Budget", x = "Budget (USD)", y = "Revenue (USD)"))

  write.csv(data.frame(correlation = cor(data$budget, data$domgross)), paste0(out, "/eda_correlation.csv"), row.names = FALSE)

  ggsave(paste0(out, "/figure4-eda_log_revenue_vs_log_budget.png"),
    ggplot(data, aes(log_budget, log_domgross)) + geom_point() + geom_smooth(method = "lm") +
    labs(title = "Log(Revenue) vs Log(Budget)", x = "Log(Budget)", y = "Log(Revenue)"))
}

opt <- docopt(doc)
main(opt$input, opt$output)
