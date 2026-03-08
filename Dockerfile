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

# Install Jupyter
RUN pip3 install jupyterlab --break-system-packages

# Install R packages
RUN R -e "install.packages(c('renv', 'IRkernel'), repos='https://cloud.r-project.org')"
RUN R -e "IRkernel::installspec(user=FALSE)"

# Copy project and restore renv
COPY renv.lock .
RUN R -e "renv::restore(prompt=FALSE)"

COPY notebooks/analysis_movie-revenue.ipynb /project/notebooks/
COPY data/ /project/data/

EXPOSE 8888
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser", "--allow-root"]