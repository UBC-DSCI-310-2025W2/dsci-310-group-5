# Movie Budget and Box Office Revenue Analysis

Authors: Audrey Vo, Roxanna Ng, Nikita Prabhu, Philip Chen

## About
This study investigates how **movie production budget predicts domestic box office revenue**. 

Using the **Bechdel Test movie dataset** from FiveThirtyEight, we perform exploratory data analysis and build a linear regression and K-nearest neighbours model to determine whether movie budget can predict domestic box office revenue.

Our analysis finds that both linear regression and K-nearest neighbours perform very similarly, and suggests that movie budget has a moderately predictive relationship with box office revenue, but is not a complete predictor of financial success.

This project also aims to emphasize reproducible data science practices by utilizing version control using GitHub and reproducible environments using Docker containers.

## Report
Click [here](notebooks/analysis_movie-revenue.ipynb) to find the analysis report.

## Dependencies

This project uses R (version 4.4.2) and manages R package dependencies using `renv` to ensure reproducibility. All package versions are pinned in the `renv.lock` file and will be automatically restored when building the Docker image.

Key R packages include:

| Package | Version |
|---|---|
| tidymodels | 1.4.1 |
| ggplot2 | 4.0.2 |
| dplyr | 1.1.4 |
| tidyr | 1.3.1 |
| fivethirtyeight | 0.6.2 |
| IRkernel | 1.3.2 |
| kknn | 1.4.1 |

For the full list of dependencies and their pinned versions, see [`renv.lock`](renv.lock).

More information about renv can be found [here](https://rstudio.github.io/renv/).

## Running the Analysis

The analysis runs inside a Docker container to ensure a fully reproducible environment. The steps below work on any operating system (Mac, Windows, Linux).

### Prerequisites

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/) and make sure it is **running** before proceeding.
2. Clone this repository and navigate into it:
   ```bash
   git clone https://github.com/UBC-DSCI-310-2025W2/dsci-310-group-5.git
   cd dsci-310-group-5
   ```

### Step 1 — Start the container

```bash
docker compose up
```

Docker will pull the pinned image (`nikip901/movie-revenue-test:1514b9c`) and start a JupyterLab server. Wait until you see a line in the terminal like `http://127.0.0.1:8888/lab`.

### Step 2 — Open JupyterLab

Open your browser and navigate to:

```
http://localhost:8888/lab
```

> **Port conflict:** If port `8888` is already in use, change the left side of `"8888:8888"` in `docker-compose.yml` to any free port (e.g., `"8890:8888"`) and navigate to `http://localhost:8890/lab` instead.

### Step 3 — Run the analysis

In JupyterLab, open `notebooks/analysis_movie-revenue.ipynb` and select **Kernel → Restart Kernel and Run All Cells**.

### Step 4 — Stop the container

When finished, stop the container by pressing `Ctrl + C` in the terminal, then run:

```bash
docker compose down
```
## License Information
The source code for this project is licensed under the MIT License.

The written report and analysis are licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0) license.

Please refer [here](LICENSE.md) for full license details.

## Contributions
Please refer [here](CONTRIBUTING.md) for more details on contributions. 