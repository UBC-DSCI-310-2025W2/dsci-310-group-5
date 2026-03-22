# date: 2026-03-16

# declare clean and all targets as phoney targets
.PHONEY: all clean

# to generate all targets, run: make all
all: results/NA_after_filter.txt results/NA_before_filter.txt results/eda-movie_data.txt \
results/eda_correlation.csv results/eda_summary.txt results/exp_rmspe_knn.txt results/exp_rmspe_lr.txt \
results/figure1-eda_boxplot.png results/figure2-eda_histogram.png results/figure3-eda_revenue_vs_budget.png \
results/figure4-eda_log_revenue_vs_log_budget.png results/figure5_linear_regression_pred.png \
results/figure6_knn_pred.png results/knn_preds.csv results/linear_regression_summary.txt \
results/no_budget_count.txt results/no_budget_filtered.txt results/no_domgross_count.txt \
results/no_domgross_filtered.txt results/table10_knn_cv_metrics.csv results/table11_knn_metrics.csv \
results/table1_first_six_rows.csv results/table2_zero_revenue.csv results/table3_first_six_rows_log.csv \
results/table4_train_mean.csv results/table5_test_mean.csv results/table6_linear_regression_preds.csv \
results/table7_linear_regression_metrics.csv results/table8_knn_tune_results.csv results/table9_knn_min.csv

# generating cleaned dataframe and cleaned data outputs 
data/processed/clean_bechdel.csv results/table1_first_six_rows results/table2_zero_revenue: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="data/processed/clean_bechdel.csv" \
		--output_results="results/" 

results/NA_after_filter.txt: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="results/NA_after_filter.txt" \
		--output_results="results/"x

results/NA_before_filter.txt: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="results/NA_before_filter.txt" \
		--output_results="results/"

results/no_budget_count.txt: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="results/no_budget_count.txt" \
		--output_results="results/"

results/no_budget_filtered.txt: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="results/no_budget_filtered.txt" \
		--output_results="results/"

results/no_domgross_count.txt: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="results/no_domgross_count.txt" \
		--output_results="results/"

results/no_domgross_filtered.txt: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="results/no_domgross_filtered.txt" \
		--output_results="results/"

# generate figures for EDA 

results/figure1-eda_boxplot.png: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/figure1-eda_boxplot.png" 

results/figure2-eda_histogram.png: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input=data/processed/clean_bechdel.csv \
		--output="results/figure2-eda_histogram.png" 

results/figure3-eda_revenue_vs_budget.png: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/figure3-eda_revenue_vs_budget.png" 

results/figure4-eda_log_revenue_vs_log_budget.png: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/figure4-eda_log_revenue_vs_log_budget.png" 

results/figure5_linear_regression_pred.png: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/figure5_linear_regression_pred.png"

results/figure6_knn_pred.png: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/figure6_knn_pred.png" 

results/eda-movie_data.txt: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/eda-movie_data.txt"

results/eda_correlation.csv: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/eda_correlation.csv" 

results/eda_summary.csv: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/eda_summary.csv" 

results/eda_summary.txt: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/eda_summary.txt" 

results/clean_bechdel.csv: data/processed/clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/clean_bechdel.csv"

# generate figures for linear regression 

results/table1_first_six_rows.csv: results/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table1_first_six_rows.csv" 

results/table2_zero_revenue.csv: results/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/,04-model-linear_regression.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table2_zero_revenue.csv"

results/table3_first_six_rows_log.csv: results/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table3_first_six_rows_log.csv"

results/table4_train_mean.csv: results/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table4_train_mean.csv" 

results/table5_test_mean.csv: results/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table5_test_mean.csv:" 

results/table6_linear_regression_preds.csv: results/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table6_linear_regression_preds.csv" 

results/table7_linear_regression_metrics.csv: results/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table7_linear_regression_metrics.csv" 

results/exp_rmspe_lr.txt: results/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/clean_bechdel.csv" \
		--output="results/exp_rmspe_lr.txt" 

results/linear_regression_summary.txt: results/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/clean_bechdel.csv" \
		--output="results/linear_regression_summary.txt" 

# generate tables and figures for knn regression 

results/table8_knn_tune_results.csv: results/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table8_knn_tune_results.csv" 

results/table9_knn_min.csv: results/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table9_knn_min.csv"

results/knn_preds.csv: results/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/clean_bechdel.csv" \
		--output="results/knn_preds.csv" 

results/exp_rmspe_knn.txt: results/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/clean_bechdel.csv" \
		--output="results/exp_rmspe_knn.txt" 

results/table10_knn_cv_metrics.csv: results/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table10_knn_cv_metrics.csv" 

results/table11_knn_metrics.csv: results/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/clean_bechdel.csv" \
		--output="results/table11_knn_metrics.csv" 

# render quarto report in HTML and PDF 
reports/analysis_movie-revenue.html: results reports/analysis_movie-revenue.qmd
	quarto render reports/analysis_movie-revenue.qmd --to html

reports/analysis_movie-revenue.pdf: results reports/analysis_movie-revenue.qmd
	quarto render reports/analysis_movie-revenue.qmd --to pdf

# to clean/delete all target files generated for quarto document, run: make clean
clean:
	rm -rf results
	rm -rf reports/analysis_movie-revenue.html \
		reports/analysis_movie-revenue.pdf