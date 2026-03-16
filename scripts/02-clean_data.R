"Usage:
  02-clean_data.R --input=<path> [--output=<path>]

Options:
  --input=<path>   Path to raw data
  --output=<path>  Path to save cleaned data [default: data/processed/clean_bechdel.csv]
" -> doc

library(docopt)
library(dplyr)

main <- function(input, output) {
  data <- read.csv(input) %>%
    select(budget, domgross) %>%
    filter(!is.na(budget), !is.na(domgross), budget > 0, domgross > 0) %>%
    mutate(log_budget = log(budget), log_domgross = log(domgross))

  dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
  write.csv(data, output, row.names = FALSE)
}

opt <- docopt(doc)
main(opt$input, opt$output)
