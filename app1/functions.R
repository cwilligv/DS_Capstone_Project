# =================================================
# : functions.R
# : Data Science Specialization - Capstone Project
# : March 2017
# :
# : This file contains all the functions needed for the app
# :
# : Shiny Application: Word Prediction App
# :
# : Author  - Christian Willig
# =================================================


# Loading Libraries
library(dplyr)
library(quanteda)
library(wordcloud)
library(RColorBrewer)

# Transfer to quanteda corpus format and segment into sentences
f_corpus = function(x) {
  corpus(unlist(segment(x, 'sentences')))
}

# Tokenization
f_tokenize = function(x, ngramSize = 1, simplify = T) {
  
  # Do some regex magic with quanteda
  char_tolower(
    quanteda::tokenize(x,
                       removeNumbers = T,
                       removePunct = T,
                       removeSeparators = T,
                       removeTwitter = T,
                       ngrams = ngramSize,
                       concatenator = " ",
                       simplify = simplify
    ) 
  )
}

# Parse tokens from input text ####

f_input = function(x) {
  
  # If empty input, put both words empty
  if(x == "") {
    input1 = data_frame(word = "")
    input2 = data_frame(word = "")
  }
  # Tokenize with same functions as training data
  if(length(x) ==1) {
    y = data_frame(word = f_tokenize(corpus(x)))
    
  }
  # If only one word, put first word empty
  if (nrow(y) == 1) {
    input1 = data_frame(word = "")
    input2 = y
    
    # Get last 2 words    
  }   else if (nrow(y) >= 1) {
    input1 = tail(y, 2)[1, ]
    input2 = tail(y, 1)
  }
  
  #  Return data frame of inputs 
  inputs = data_frame(words = unlist(rbind(input1,input2)))
  return(inputs)
}

# Predict using stupid backoff algorithm ####

f_predict = function(x, y, n = 100) {
  
  # Predict giving just the top 1-gram words, if no input given
  if(x == "" & y == "") {
    prediction = ngram1 %>%
      select(NextWord, freq)
    
    # Predict using 3-gram model
  }   else if(x %in% ngram3$word1 & y %in% ngram3$word2) {
    prediction = ngram3 %>%
      filter(word1 %in% x & word2 %in% y) %>%
      select(NextWord, freq)
    
    # Predict using 2-gram model
  }   else if(y %in% ngram2$word1) {
    prediction = ngram2 %>%
      filter(word1 %in% y) %>%
      select(NextWord, freq)
    
    # If no prediction found before, predict giving just the top 1-gram words
  }   else{
    prediction = ngram1 %>%
      select(NextWord, freq)
  }
  
  # Return predicted word in a data frame
  return(prediction[1:n, ])
}
