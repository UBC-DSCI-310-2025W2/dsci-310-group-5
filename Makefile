# date: 2026-03-16

# declare clean and all targets as phoney targets
.PHONEY: all clean

# to generate all targets, run: make all
all: results/NA_after_filter.txt results/NA_before_filter.txt results/eda-movie_data.txt \
results/eda_correlation.csv results/eda_summary.txt results/exp_rmspe_knn.txt results/exp_rmspe_lr.txt \
results/figure1-eda_boxplot.png results/figure2-eda_histogram.png results/figure3-eda_revenue_vs_budget.png \
results/figure4-eda_log_revenue_vs_log_budget.png results/figure5_linear_regression_pred.png \
results/figure6_knn_pred.png results/linear_regression_summary.txt results/no_budget_count.txt \
results/no_budget_filtered.txt results/no_domgross_count.txt results/no_domgross_filtered.txt \
results/table10_knn_cv_rmse.csv results/table11_knn_rmse.csv results/table1_first_six_rows.csv \
results/table2_zero_revenue.csv results/table3_first_six_rows_log.csv results/table4_train_mean.csv \
results/table5_test_mean.csv results/table6_linear_regression_preds.csv \
results/table7_linear_regression_metrics.csv results/table8_knn_best_k.csv \
results/table8_knn_tune_results.csv results/table9_knn_min.csv

# generating cleaned dataframe and cleaned data outputs 
results/clean_bechdel.csv results/table1_first_six_rows results/table2_zero_revenue: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="results/clean_bechdel.csv" \
		--output_results="results/" 

data/processed/clean_bechdel.csv: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="data/processed/clean_bechdel.csv" \
		--output_results="results/" 

results/NA_after_filter.txt: data/raw/raw_bechdel.csv scripts/02-clean_data.R 
	Rscript scripts/02-clean_data.R \
		--input="data/raw/raw_bechdel.csv" \
		--output="results/NA_after_filter.txt" \
		--output_results="results/"

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

# generate figures for linear regression 

results/table1_first_six_rows.csv: data/processed/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table1_first_six_rows.csv" 

results/table2_zero_revenue.csv: data/processed/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/,04-model-linear_regression.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table2_zero_revenue.csv"

results/table3_first_six_rows_log.csv: data/processed/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table3_first_six_rows_log.csv"

results/table4_train_mean.csv: results/eda_summary.txt scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="results/eda_summary.txt" \
		--output="results/table4_train_mean.csv" 

results/table5_test_mean.csv: results/eda_summary.txt scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="results/eda_summary.txt" \
		--output="results/table5_test_mean.csv:" 

results/table6_linear_regression_preds.csv: data/processed/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table6_linear_regression_preds.csv" 

results/linear_regression_summary.csv: data/processed/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/linear_regression_summary.csv" 

results/table7_linear_regression_metrics.csv: data/processed/clean_bechdel.csv scripts/04-model-linear_regression.R
	Rscript scripts/04-model-linear_regression.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table7_linear_regression_metrics.csv" 

results/exp_rmspe_lr.txt: results/eda_summary.txt scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/eda_summary.txt" \
		--output="results/knn_preds.csv" 

results/linear_regression_summary.txt: results/eda_summary.txt scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/eda_summary.txt" \
		--output="results/knn_preds.csv" 

# generate tables and figures for knn regression 

results/table7_knn_tune_results.csv: data/processed/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table7_knn_tune_results.csv" 

results/table8_knn_best_k.csv: data/processed/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table8_knn_best_k.csv" 

results/table8_knn_tune_results.csv: results/eda_summary.txt scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/eda_summary.txt" \
		--output="results/table8_knn_tune_results.csv" 

results/table8_knn_cv_metrics.csv: data/processed/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table8_knn_cv_metrics.csv" 

results/table8_knn_min.csv : data/processed/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table8_knn_min.csv" 

results/table9_knn_metrics.csv: data/processed/clean_bechdel.csv scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="data/processed/clean_bechdel.csv" \
		--output="results/table9_knn_metrics.csv" 

results/table9_knn_min.csv: results/eda_summary.txt scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/eda_summary.txt" \
		--output="results/table9_knn_min.csv"

results/knn_preds.csv: results/eda_summary.txt scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/eda_summary.txt" \
		--output="results/knn_preds.csv" 

results/exp_rmspe_knn.txt: results/eda_summary.txt scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/eda_summary.txt" \
		--output="results/knn_preds.csv" 

results/table10_knn_cv_rmse.csv: results/eda_summary.txt scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/eda_summary.txt" \
		--output="results/knn_preds.csv" 

results/table11_knn_rmse.csv: results/eda_summary.txt scripts/05-model-KNN.R
	Rscript scripts/05-model-KNN.R \
		--input="results/eda_summary.txt" \
		--output="results/knn_preds.csv" 

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