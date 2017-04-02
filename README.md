Word Prediction Project - Data Sources
================

GitHub Documents
----------------

This repository contains the R scripts used for the project. Folder 'app1' contains the scripts for the shiny app. The rest of the files correspond to a 5-slide presentation about the application.

About the Shiny App
-------------------

The shiny app contains the following scripts:

-   **data\_prep.R**: This script was utilized to prepare the ngrams and calculating the probabilities of the words. Only 10% of the raw data was used here.

-   **functions.R**: This script contains all the functions used in the application: tokenize, prediction, frequencies, etc.

-   **global.R**: This script is the first script to run when the app is loading. Its purpose is to load the ngram files from the data folder. These files were created previously by using the data\_prep script.

-   **server.R**: This script contains all the R code for the application.

-   **ui.R**: This script contains all the code for the frontend of the application, which gets translated into html.

Shiny Application
-----------------

![<https://cwillig.shinyapps.io/word_prediction_app/>](word_pred_app.png)

The application is very easy to use.

1.  Type the phrase you would like to predict a word from.

2.  Click on submit button to run the model.

3.  (Optional): Define the number of words you want the model to give you back. By default is set to 5.

4.  Check the sorted result list and select the word most appropriate for your context.
