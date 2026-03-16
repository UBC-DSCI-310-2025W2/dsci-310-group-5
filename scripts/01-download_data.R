"Usage:
  download_data.R --input=<url> [--output=<path>]

Options:
  --input=<url>   URL to download data from
  --output=<path> Path to save output [default: data/raw/raw_bechdel.csv]
" -> doc

library(docopt)
opt <- docopt(doc)

dir.create(dirname(opt$output), recursive = TRUE, showWarnings = FALSE)
write.csv(read.csv(opt$input), opt$output, row.names = FALSE)
