FROM rocker/rstudio:4.4.2

# Install system dependencies needed for common R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /project

# Copy renv files first (better caching)
COPY renv.lock renv.lock
COPY renv/ renv/

# Install renv
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org')"

# Restore packages EXACTLY from lockfile
RUN R -e "renv::restore(prompt = FALSE)"

COPY . .

CMD ["Rscript", "src/analysis_movie-revenue.ipynb"]