"Usage:
  01-download_data.R --input=<url> --output=<path>

Options:
  --input=<url>   URL to download data from
  --output=<path> Path to save output [default: data/raw/raw_bechdel.csv]
" -> doc

library(docopt)

main <- function(input, output) {
  dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
  write.csv(read.csv(input), output, row.names = FALSE)
}

opt <- docopt(doc)
main(opt$input, opt$output)