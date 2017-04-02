# This script prepare the data for analysis and modeling.
# Loading libraries to be used.
library(readr)
library(caTools)
library(tidyr)

# Read in data
blogs_data = read_lines('~/R/Capstone Project/en_US/en_US.blogs.txt')
news_data = read_lines('~/R/Capstone Project/en_US/en_US.news.txt')
twitter_data = readLines('~/R/Capstone Project/en_US/en_US.twitter.txt')
combined_data = c(blogs_data, news_data, twitter_data)

# Sample and combine data  
set.seed(1234)
n = 1/1000
combined = sample(combined_data, length(combined_data) * n)

# Split into train and validation data sets
split = sample.split(combined, 0.8)
train = subset(combined, split == T)
valid = subset(combined, split == F)

# Tokenization
library(quanteda)
# Transfer to quanteda corpus format and segment into sentences (functions.R)
train = f_corpus(train)

# Tokenize (This function comes from script functions.R)
train1 = f_tokenize(train)
train2 = f_tokenize(train, 2)
train3 = f_tokenize(train, 3)
train4 = f_tokenize(train, 4)

# Frequency tables ####
f_frequency = function(x, minCount = 1) {
  x = x %>%
    group_by(NextWord) %>%
    summarize(count = n()) %>%
    filter(count >= minCount)
  x = x %>% 
    mutate(freq = count / sum(x$count)) %>% 
    select(-count) %>%
    arrange(desc(freq))
}

dfTrain1 = data_frame(NextWord = train1)
dfTrain1 = f_frequency(dfTrain1)

dfTrain2 = data_frame(NextWord = train2)
dfTrain2 = f_frequency(dfTrain2) %>%
  separate(NextWord, c('word1', 'NextWord'), " ")

dfTrain3 = data_frame(NextWord = train3)
dfTrain3 = f_frequency(dfTrain3) %>%
  separate(NextWord, c('word1', 'word2', 'NextWord'), " ")

dfTrain4 = data_frame(NextWord = train4)
dfTrain4 = f_frequency(dfTrain4) %>%
  separate(NextWord, c('word1', 'word2', 'word3', 'NextWord'), " ")

# Save Data ####
saveRDS(dfTrain1, file = '~/R/Capstone Project/new_code/data/dfTrain1.rds')
saveRDS(dfTrain2, file = '~/R/Capstone Project/new_code/data/dfTrain2.rds')
saveRDS(dfTrain3, file = '~/R/Capstone Project/new_code/data/dfTrain3.rds')
saveRDS(dfTrain4, file = '~/R/Capstone Project/new_code/data/dfTrain4.rds')
