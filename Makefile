# date: 2026-03-16

# declare clean and all targets as phoney targets
.PHONEY: all clean

all: results 



# generate figures for report

results/eda_boxplot.png: data\processed\clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_file=results/eda_boxplot.png

results/eda_correlation.csv: data\processed\clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_file=results/eda_correlation.csv

results/eda_histogram.png: data\processed\clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_file=results/eda_histogram.png

results/eda_scatter_log.png: data\processed\clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_file=results/eda_scatter_log.png

results/eda_scatter_raw.png: data\processed\clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_file=results/eda_scatter_raw.png

results/eda_summary.csv: data\processed\clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/03-eda.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_file=results/eda_summary.csv

results/linear_regression_metrics.csv: data\processed\clean_bechdel.csv scripts/03-eda.R
	Rscript scripts/04-model-linear_regression.R \
		--input_file=data/processed/clean_bechdel.csv \
		--output_file=results/linear_regression_metrics.csv

results/linear_regression_train_mean.csv:


results/linear_regression_test_mean.csv:

results/linear_regression_preds.csv:


results/linear_regression_pred.png:

results/linear_regression_summary.txt:

results/knn_best_k.csv:

results/knn_metrics.csv:

results/knn_pred.png:

# render quarto report in HTML and PDF 
reports/

# clean/delete files from makefile 
clean:
	rm -rf 





