# declare phony targets (targets that don't produce a file)
.PHONY: all clean

# to generate all targets, run: make all
all: reports/analysis_movie-revenue.html reports/analysis_movie-revenue.pdf

# to generate cleaned data files, run: make data
data: data/processed/log_bechdel

# to generate all files for the EDA, run: make eda 
eda: results/eda-movie_data.csv results/eda-movie_data.txt results/eda_correlation.csv results/eda_summary.csv \
results/eda_summary.txt results/figure1-eda_boxplot.png results/figure2-eda_histogram.png \
results/figure3-eda_revenue_vs_budget.png results/figure4-eda_log_revenue_vs_log_budget.png \
results/NA_after_filter.txt results/NA_before_filter.txt results/no_budget_count.txt results/no_budget_filtered.txt \
results/no_domgross_count.txt results/no_domgross_filtered.txt results/table1_first_six_rows.csv \
results/table2_zero_revenue.csv results/table3_first_six_rows_log.csv

# to generate all files for the linear regression analysis, run: make lr
lr: results/exp_rmspe_lr.txt results/figure5_linear_regression_pred.png results/linear_regression_summary.txt \
results/linear_regression_summary.csv results/table3_first_six_rows_log.csv results/table4_train_mean.csv \
results/table5_test_mean.csv results/table6_linear_regression_preds.csv results/table7_linear_regression_metrics.csv

# to generate all files for knn regression analysis, run: make knn
knn: results/exp_rmspe_knn.txt results/figure6_knn_pred.png results/knn_preds.csv \
results/table10_knn_cv_metrics.csv results/table11_knn_metrics.csv results/table8_knn_tune_results.csv \
results/table9_knn_min.csv 

# to generate a pdf of quarto document, run: make pdf
pdf: reports/analysis_movie-revenue.pdf

# to generate a html of quarto document, run: make html
html: reports/analysis_movie-revenue.html

# generate cleaned dataframe and cleaned data outputs 
data/processed/clean_bechdel.csv \
results/NA_after_filter.txt \
results/NA_before_filter.txt \
results/no_budget_count.txt \
results/no_budget_filtered.txt \
results/no_domgross_count.txt \
results/no_domgross_filtered.txt \
results/table1_first_six_rows.csv \
results/table2_zero_revenue.csv: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="data/processed/clean_bechdel.csv" \
		--output_results="results/" 

# generate figures for EDA 
results/figure1-eda_boxplot.png \
results/figure2-eda_histogram.png \
results/figure3-eda_revenue_vs_budget.png \
results/figure4-eda_log_revenue_vs_log_budget.png \
results/eda-movie_data.csv \
results/eda-movie_data.txt \
results/eda_correlation.csv \
results/eda_summary.csv \
results/eda_summary.txt \
data/processed/log_bechdel.csv \
results/table3_first_six_rows_log.csv: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="data/processed/" \
		--output_results="results/"

# generate figures for linear regression 
results/figure5_linear_regression_pred.png \
results/table4_train_mean.csv \
results/table5_test_mean.csv \
results/table6_linear_regression_preds.csv \
results/table7_linear_regression_metrics.csv \
results/exp_rmspe_lr.txt \
results/linear_regression_summary.txt \
results/linear_regression_summary.csv: data/processed/log_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="data/processed/log_bechdel.csv" \
		--output="results/"

# generate tables and figures for knn regression 
results/figure6_knn_pred.png \
results/table8_knn_tune_results.csv \
results/table9_knn_min.csv \
results/knn_preds.csv \
results/exp_rmspe_knn.txt \
results/table10_knn_cv_metrics.csv \
results/table11_knn_metrics.csv: data/processed/log_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="data/processed/log_bechdel.csv" \
		--output="results/" 

# render quarto report in HTML and PDF 
reports/analysis_movie-revenue.html: reports/analysis_movie-revenue.qmd \
	data/processed/log_bechdel.csv \
	results/NA_after_filter.txt \
	results/NA_before_filter.txt \
	results/no_budget_count.txt \
	results/no_budget_filtered.txt \
	results/no_domgross_count.txt \
	results/no_domgross_filtered.txt \
	results/table1_first_six_rows.csv \
	results/table2_zero_revenue.csv \
	results/figure1-eda_boxplot.png \
	results/figure2-eda_histogram.png \
	results/figure3-eda_revenue_vs_budget.png \
	results/figure4-eda_log_revenue_vs_log_budget.png \
	results/eda-movie_data.csv \
	results/eda-movie_data.txt \
	results/eda_correlation.csv \
	results/eda_summary.csv \
	results/eda_summary.txt \
	results/table3_first_six_rows_log.csv \
	results/figure5_linear_regression_pred.png \
	results/table4_train_mean.csv \
	results/table5_test_mean.csv \
	results/table6_linear_regression_preds.csv \
	results/table7_linear_regression_metrics.csv \
	results/exp_rmspe_lr.txt \
	results/linear_regression_summary.txt \
	results/linear_regression_summary.csv \
	results/figure6_knn_pred.png \
	results/table8_knn_tune_results.csv \
	results/table9_knn_min.csv \
	results/knn_preds.csv \
	results/exp_rmspe_knn.txt \
	results/table10_knn_cv_metrics.csv \
	results/table11_knn_metrics.csv 
		quarto render reports/analysis_movie-revenue.qmd --to html

reports/analysis_movie-revenue.pdf: reports/analysis_movie-revenue.qmd \
	data/processed/log_bechdel.csv \
	results/NA_after_filter.txt \
	results/NA_before_filter.txt \
	results/no_budget_count.txt \
	results/no_budget_filtered.txt \
	results/no_domgross_count.txt \
	results/no_domgross_filtered.txt \
	results/table1_first_six_rows.csv \
	results/table2_zero_revenue.csv \
	results/figure1-eda_boxplot.png \
	results/figure2-eda_histogram.png \
	results/figure3-eda_revenue_vs_budget.png \
	results/figure4-eda_log_revenue_vs_log_budget.png \
	results/eda-movie_data.csv \
	results/eda-movie_data.txt \
	results/eda_correlation.csv \
	results/eda_summary.csv \
	results/eda_summary.txt \
	results/table3_first_six_rows_log.csv \
	results/figure5_linear_regression_pred.png \
	results/table4_train_mean.csv \
	results/table5_test_mean.csv \
	results/table6_linear_regression_preds.csv \
	results/table7_linear_regression_metrics.csv \
	results/exp_rmspe_lr.txt \
	results/linear_regression_summary.txt \
	results/linear_regression_summary.csv \
	results/figure6_knn_pred.png \
	results/table8_knn_tune_results.csv \
	results/table9_knn_min.csv \
	results/knn_preds.csv \
	results/exp_rmspe_knn.txt \
	results/table10_knn_cv_metrics.csv \
	results/table11_knn_metrics.csv 
		quarto render reports/analysis_movie-revenue.qmd --to pdf

# to clean/delete all target files generated for quarto document, run: make clean
clean:
	rm -rf data/processed/
	rm -rf results/
	rm -rf reports/analysis_movie-revenue.html \
		reports/analysis_movie-revenue.pdf