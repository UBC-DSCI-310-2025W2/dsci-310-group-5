# Movie Budget and Box Office Revenue Analysis

Authors: Audrey Vo, Roxanna Ng, Nikita Prabhu, Philip Chen

## About
This study investigates how **movie production budget predicts domestic box office revenue**. 

Using the **Bechdel Test movie dataset** from FiveThirtyEight, we perform exploratory data analysis and build a linear regression and K-nearest neighbours model to determine whether movie budget can predict domestic box office revenue.

This project also aims to emphasize reproducible data science practices by utilizing version control using GitHub and reproducible environments using Docker containers.

## Report
Click [here](notebooks/analysis_movie-revenue.ipynb) to find the analysis report.



## Dependencies
This project uses R (version 4.4.2) and manages package dependencies using renv to ensure reproducibility.

Key packages include:

- tidyverse
- tidymodels
- dplyr
- fivethirtyeight
- ggplot2
- Jupyter Notebook

All package versions are recorded in the renv.lock file.

More information about renv can be found [here](https://rstudio.github.io/renv/)

## Running the Analysis
We use a Docker container image for project reproducibility.

### Build the Docker image
'''bash
docker build -t movie-analysis .

### Run the analysis
'''bash
docker run -p 8888:8888 -v $(pwd):/project audreyvo/dsci-310-group-5:latest

## License Information
[license info]
