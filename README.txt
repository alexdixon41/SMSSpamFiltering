SMS SPAM FILTERING USING LOGISTIC REGRESSION MODEL

Instructions for extracting features and training models:
1. Run FeatureDetection.py to create the feature set files. Choose between .csv or .arff output format via the prompt at runtime.
2. Run logistic_regression.R to view visualization of any missing data, CDF plots for all continuous variables, histogram for the 
	discrete variable contains_currency, confusion matrix and ROC curve for each of the testing options.

Note: The raw data file, 'SMSSpamCollection' must be in the same folder as 'FeatureDetection.py' in order to extract the features.
	Also, the output file generated by 'FeatureDetection.py' will be placed in the same folder as 'FeatureDetection.py'. Before running
	'logistic_regression.R' the file 'output.csv' should be in the same folder as 'logistic_regression.R'.