FROM rocker/r-ver:4.4.2

WORKDIR /project

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    build-essential \
    libzmq3-dev \
    wget \
    git \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Copy renv files first (for caching)
COPY renv.lock renv.lock
COPY renv/ renv/

# Install renv
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org')"

# Force renv to restore using binaries when possible
RUN R -e "options(renv.download.method = 'libcurl'); renv::restore(prompt = FALSE, rebuild = FALSE)"

# Copy project files
COPY . .

# Run notebook (or R script)
CMD ["Rscript", "-e", "rmarkdown::render('src/analysis_movie-revenue.ipynb')"]