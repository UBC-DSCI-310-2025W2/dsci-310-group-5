# Downloads the Bechdel Test movie CSV from the given URL and writes it to data/raw: reads --input (URL) and writes one CSV to --output.

"Usage:
  01-download_data.R --input=<url> --output=<path>

Options:
  --input=<url>   URL to download data from
  --output=<path> Path to save output [default: data/raw/raw_bechdel.csv]
" -> doc

library(docopt)

source("R/data-validation.R")

main <- function(input, output) {
  dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
  write.csv(read.csv(input), output, row.names = FALSE)
  validate_csv_file_format(output)
}

opt <- docopt(doc)
main(opt$input, opt$output)