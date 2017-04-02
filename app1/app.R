#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  title = 'Word Predictor Project',
  
  # Theme
  theme = shinytheme("flatly"),
  
  # Application title
  titlePanel("Word Prediction App - Capstone Project"),
  
  # Sidebar ####    
  sidebarLayout(
    
    sidebarPanel(
      
      # Text input
      textInput("text", label = ('Please enter a phrase'), value = ''),
      
      # Submit and clear buttons
      actionButton("btn_submit", "Predict"),
      actionButton("btn_clear", "Clear"),
      
      # Number of words slider input
      sliderInput('slider',
                  'Maximum number of words',
                  min = 0,  max = 1000,  value = 10
      ),
      
      # Table output
      DT::dataTableOutput('table')),
    
    # Mainpanel ####
    
    mainPanel(
      
      wellPanel(
        
        # Link to report
        helpText(a('Short Slide deck about the app',
                   href='http://rpubs.com/akselix/word_prediction', 
                   target = '_blank')
        ),
        
        # Link to repo
        helpText(a('Code sources on github',
                   href='https://github.com/akselix/capstone_swiftkey/tree/master/shiny',
                   target = '_blank')
        ),
        
        # Wordcloud output
        plotOutput('wordcloud')
      )
    ) 
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
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
  output$wordcloud = renderPlot(
    wordcloud_rep(
      prediction()$NextWord,
      prediction()$freq,
      colors = brewer.pal(8, 'Dark2'),
      scale=c(4, 0.5),
      max.words = 300
    )
  )
}

# Run the application 
shinyApp(ui = ui, server = server)

