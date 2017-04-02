# =================================================
# : server.R
# : Data Science Specialization - Capstone Project
# : March 2017
# :
# : This file contains all the server side logic of the app
# :
# : Shiny Application: Word Prediction App
# :
# : Author  - Christian Willig
# =================================================

# Libraries and options ####
source('functions.R')

library(shiny)

# Define application ####

shinyServer(function(input, output, session) {
  
  # Reactive statement for prediction function when user input changes ####
  prediction =  eventReactive(input$btn_submit, {
    
    # Get input from control
    inputText = input$text
    input1 =  f_input(inputText)[1, ]
    input2 =  f_input(inputText)[2, ]
    nSuggestion = input$slider
    
    # Predict
    prediction = f_predict(input1, input2, n = nSuggestion)
  })
  
  observeEvent(input$btn_clear, {
    updateTextInput(session, "text", value = "")
  })
  
  # Output data table ####
  output$table = DT::renderDataTable(DT::datatable(prediction(),
                                 option = list(pageLength = 5,
                                               rownames=FALSE,
                                               #autoWidth = TRUE,
                                               lengthMenu = list(c(5, 10, 100), c('5', '10', '100')),
                                               columnDefs = list(list(visible = F, targets = 2)),
                                               searching = F
                                 )
  ))
  
  # Output word cloud ####
  wordcloud_rep = repeatable(wordcloud)
  
  output$wordcloud = renderPlot({
    wordcloud_rep(
      prediction()$NextWord,
      prediction()$freq,
      colors = brewer.pal(8, 'Dark2'),
      scale=c(4, 0.00000000001),
      min.freq = 0,
      max.words = 300
    )
  })
})