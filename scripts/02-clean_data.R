"Usage:
  02-clean_data.R --input=<path> [--output=<path>]

Options:
  --input=<path>   Path to raw data
  --output=<path>  Path to save cleaned data [default: data/processed/clean_bechdel.csv]
" -> doc

library(docopt)
library(dplyr)

opt <- docopt(doc)

data <- read.csv(opt$input) %>%
  select(budget, domgross) %>%
  filter(!is.na(budget), !is.na(domgross), budget > 0, domgross > 0) %>%
  mutate(log_budget = log(budget), log_domgross = log(domgross))

dir.create(dirname(opt$output), recursive = TRUE, showWarnings = FALSE)
write.csv(data, opt$output, row.names = FALSE)
