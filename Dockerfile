FROM rocker/r-ver:4.4.2

WORKDIR /project

# System dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libgit2-dev \
    libglpk-dev \
    libzmq3-dev \
    build-essential \
    wget \
    git \
    python3-pip \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# R packages
RUN R -e "install.packages('renv', repos='https://cloud.r-project.org')"

# Copy project
COPY . .

# Restore renv
RUN R -e "renv::restore(prompt = FALSE)"

# Run notebook
CMD ["Rscript", "-e", "rmarkdown::render('src/analysis_movie-revenue.ipynb')"]