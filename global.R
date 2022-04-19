library(shiny)
library(dplyr)
library(ggplot2)
library(wordcloud2)
#df.path <- file.path("www/data/LifeExpectancy.csv")
#df_csv <- read.csv(df.path)
function.path <- file.path("www/function/function.R")
source(function.path)

# Read raw data
df <- read_excel(file.path(getwd(),"www/data/lex-by-gapminder.xlsx"), sheet = 2)  # Expected life of each country since 1800
df_region <- read_excel(file.path(getwd(),"/www/data/lex-by-gapminder.xlsx"), sheet = 3)  # Expected life of each region since 1800
df_global <- read_excel(file.path(getwd(),"/www/data/lex-by-gapminder.xlsx"), sheet = 4)  # Explected life global since 1800
gdp <- read_excel(file.path(getwd(),"/www/data/GM-GDP per capita - Dataset - v27.xlsx"), sheet = 'data-GDP-per-capita-in-columns', skip = 3) # GDP of each country since 1800
earthquake <- read_csv(file.path(getwd(),"/www/data/earthquake_deaths_annual_number.csv")) # Earthquake death of each country since 1800

# Data Cleaning
# replace character into numerics, 10K -- 10000
for (i in 2:length(colnames(earthquake))) {
  if (sapply(earthquake,class)[i] == 'character'){
    earthquake[[colnames(earthquake)[i]]] <- as.numeric(sub('k','e3',earthquake[[colnames(earthquake)[i]]]))
  }
  0}
# delete rows with blank country name
gdp_c <- gdp[!is.na(gdp[["Country Name"]]),]