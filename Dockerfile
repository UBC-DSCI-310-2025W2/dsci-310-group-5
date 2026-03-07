FROM rocker/r-ver:4.5.2

WORKDIR /analysis

# install required R packages
RUN R -e "install.packages(c('fivethirtyeight','dplyr','ggplot2','tidymodels'), repos='https://cloud.r-project.org/')"

# copy project files
COPY . .

# run the analysis
CMD ["Rscript", "analysis.R"]

# Run the R script
CMD ["Rscript", "analysis_movie-revenue.ipynb"]