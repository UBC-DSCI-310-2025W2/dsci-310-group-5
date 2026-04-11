"Usage:
  02-clean_data.R --input=<path> --output=<path> --output_results=<path>

Options:
  --input=<path>             Path to raw data
  --output=<path>           Path to save cleaned data (clean_bechdel.csv)
  --output_results=<path>    Path to save tables (table1, table2, table3)
" -> doc

library(docopt)
library(dplyr)

source("R/data-validation.R")
source("R/drop-columns.R")
source("R/filter-data.R")

main <- function(input, output, output_results) {
  validate_csv_file_format(input)
  bechdel <- read.csv(input)
  cols_to_drop <- setdiff(names(bechdel), c("budget", "domgross"))
  movie_data <- drop_columns(bechdel, cols_to_drop)
  movie_data <- movie_data %>% mutate(budget = as.numeric(budget), domgross = as.numeric(domgross))

  dir.create(output_results, recursive = TRUE, showWarnings = FALSE)
  dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)

  write.csv(head(movie_data, 6), paste0(output_results, "/table1_first_six_rows.csv"), row.names = FALSE)

  NA_count <- sum(is.na(movie_data))
  
  writeLines(
  paste("# of null values (before filtering):", NA_count),
  file.path(output_results, "NA_before_filter.txt")
)
  
  movie_data <- movie_data %>%
    filter(!is.na(budget), !is.na(domgross))

  NA_count <- sum(is.na(movie_data))
  
  writeLines(
    paste("# of null values (after filtering):", NA_count),
    file.path(output_results, "NA_after_filter.txt")
  )
  
  writeLines(
    paste(sum(movie_data$budget == 0)),
    file.path(output_results, "no_budget_count.txt")
  )
  
  writeLines(
    paste(sum(movie_data$domgross == 0)),
    file.path(output_results, "no_domgross_count.txt")
  )
  
  write.csv(movie_data[movie_data$domgross == 0, ], paste0(output_results, "/table2_zero_revenue.csv"), row.names = FALSE)
  
  movie_data <- filter_data(movie_data)

  validate_clean_bechdel(movie_data)

  writeLines(
    paste(sum(movie_data$budget == 0)),
    file.path(output_results, "no_budget_filtered.txt")
  )
  
  writeLines(
    paste(sum(movie_data$domgross == 0)),
    file.path(output_results, "no_domgross_filtered.txt")
  )
  
  write.csv(movie_data, output, row.names = FALSE)
}

opt <- docopt(doc)
main(opt$input, opt$output, opt$output_results)