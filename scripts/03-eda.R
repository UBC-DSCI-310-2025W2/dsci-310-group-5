"Usage:
  03-eda.R --input=<path> --output=<path>

Options:
  --input=<path>   Path to data
  --output=<path>  Path/filename prefix
" -> doc

library(docopt)
library(ggplot2)

main <- function(input, output) {
  data <- read.csv(input)
  out <- dirname(output)
  dir.create(out, recursive = TRUE, showWarnings = FALSE)

  writeLines(capture.output(summary(data)), paste0(out, "/eda_summary.csv"))

  png(paste0(out, "/eda_boxplot.png"))
  par(mfrow = c(1, 2))
  boxplot(data$budget, main = "Boxplot of Movie Budget", ylab = "Budget in USD")
  boxplot(data$domgross, main = "Boxplot of Movie Revenue", ylab = "Revenue in USD")

  png(paste0(out, "/eda_histogram.png"))
  par(mfrow = c(1, 2))
  hist(data$budget, main = "Histogram of Movie Budget", xlab = "Budget in USD")
  hist(data$domgross, main = "Histogram of Movie Revenue", xlab = "Revenue in USD")

  ggsave(paste0(out, "/eda_scatter_raw.png"),
    ggplot(data, aes(budget, domgross)) + geom_point() + geom_smooth(method = "lm") +
    labs(title = "Domestic Revenue vs Movie Budget", x = "Budget (USD)", y = "Revenue (USD)"))

  write.csv(data.frame(correlation = cor(data$budget, data$domgross)), paste0(out, "/eda_correlation.csv"), row.names = FALSE)

  ggsave(paste0(out, "/eda_scatter_log.png"),
    ggplot(data, aes(log_budget, log_domgross)) + geom_point() + geom_smooth(method = "lm") +
    labs(title = "Log(Revenue) vs Log(Budget)", x = "Log(Budget)", y = "Log(Revenue)"))
}

opt <- docopt(doc)
main(opt$input, opt$output)
