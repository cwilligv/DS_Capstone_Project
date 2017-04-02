# =================================================
# : server.R
# : Data Science Specialization - Capstone Project
# : March 2017
# :
# : This file contains all the frontend/ui logic of the app
# :
# : Shiny Application: Word Prediction App
# :
# : Author  - Christian Willig
# =================================================

# Libraries
library(shiny)
library(shinythemes)



shinyUI(fluidPage(
  
  title = 'Word Predictor Project',
  
  # setting the Theme
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Word Prediction App - Capstone Project"),
  
  # Sidebar    
  sidebarLayout(
    
    sidebarPanel(
      
      # Text input
      textInput("text", label = ('1.Please enter a phrase'), value = ''),
      
      h5(strong("2.Click on predict/clear button")),
      # Submit and clear buttons
      actionButton("btn_submit", "Predict"),
      actionButton("btn_clear", "Clear"),
      
      # Number of words slider input
      sliderInput('slider',
                  '3.Adjust Maximum # of words to display',
                  min = 0,  max = 1000,  value = 5
      ),
      
      h5(strong("4.Pick one word from table below and type it in the textbox")),
      # Table output
      DT::dataTableOutput('table')),
    
    # Mainpanel
    
    mainPanel(
      
      wellPanel(
        
        h6(strong("Note: Due to shinyapps RAM limitations we've used only 10% of the raw data")),
        
        # Link to report
        helpText(a('Short Slide pack about the app',
                   href='http://rpubs.com/cwillig/263396', 
                   target = '_blank')
        ),
        
        # Link to repo
        helpText(a('Code sources on github',
                   href='https://github.com/cwilligv/DS_Capstone_Project/',
                   target = '_blank')
        ),
        
        h6(strong("Word cloud with the results from the prediction model")),
        
        # Wordcloud output
        plotOutput('wordcloud')
      )
    ) 
  )
)
)
