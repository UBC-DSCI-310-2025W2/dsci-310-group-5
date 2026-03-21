# date: 2026-03-16

# declare clean and all targets as phoney targets
.PHONEY: all clean

all: results/clean_bechdel.csv results/eda-movie_data.csv results/eda_correlation.csv results/eda_summary.csv \
results/figure1-eda_boxplot.png results/figure2-eda_histogram.png results/figure3-eda_revenue_vs_budget.png \
results/figure4-eda_log_revenue_vs_log_budget.png results/figure5_linear_regression_pred.png \
results/figure6_knn_pred.png results/knn_preds.csv results/linear_regression_summary.csv \
results/table1_first_six_rows.csv results/table2_zero_revenue.csv results/table3_first_six_rows_log.csv \
results/table4_train_mean.csv results/table5_test_mean.csv results/table6_linear_regression_preds.csv \
results/table7_knn_tune_results.csv results/table7_linear_regression_metrics.csv results/table8_knn_best_k.csv \
results/table8_knn_cv_metrics.csv results/table8_knn_min.csv results/table9_knn_metrics.csv \
reports/analysis_movie-revenue.html reports/analysis_movie-revenue.pdf

# cleaning the data
data/processed/clean_bechdel.csv: 02-clean_data.R
	Rscript scripts/02-clean_data.R
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

# generate figures for EDA 
results/figure1-eda_boxplot.png figure2-eda_histogram.png figure3-eda_revenue_vs_budget.png: scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

results/figure4-eda_log_revenue_vs_log_budget.png results/figure5_linear_regression_pred.png results/figure6_knn_pred.png: scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

# generate data/csv files EDA
results/eda-movie_data.csv results/eda_correlation.csv results/eda_summary.csv: scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

# generate tables and figures for linear regression 
results/table1_first_six_rows.csv results/table2_zero_revenue.csv results/table3_first_six_rows_log.csv: 04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

results/table4_train_mean.csv results/table5_test_mean.csv results/table6_linear_regression_preds.csv: 04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

results/linear_regression_summary.csv results/table7_linear_regression_metrics.csv:
	Rscript scripts/04-model-linear_regression.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

# generate tables and figures for knn regression: 
results/table7_knn_tune_results.csv results/table8_knn_best_k.csv results/table8_knn_cv_metrics.csv: 05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

results/table8_knn_min.csv results/table9_knn_metrics.csv results/knn_preds.csv: 05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_dir="results"

# render quarto report in HTML and PDF 
reports/analysis_movie-revenue.html: results reports/analysis_movie-revenue.qmd
	quarto render reports/analysis_movie-revenue.qmd --to html

reports/analysis_movie-revenue.pdf: results reports/analysis_movie-revenue.qmd
	quarto render reports/analysis_movie-revenue.qmd --to pdf

# clean/delete files from makefile 
clean:
	rm -rf results
	rm -rf reports/analysis_movie-revenue.html \
		reports/analysis_movie-revenue.pdf

