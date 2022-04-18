library(maps)
library(ggplot2)
library(tidyverse)
library(readxl)
library(dplyr)
library(readr)
library(stringr)
library(jiebaRD) 
library(jiebaR)
library(wordcloud)
library(wordcloud2)

df1.path <- file.path("www/data/LifeExpectancy.csv")
df.path <- file.path("www/data/LifeExpectancy.xlsx")
df1 <- read.csv(df1.path)

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


getWrodCloudPlot <- function(year){
  word<-na.omit(df1) 
  a<-data.frame(country = word$geo.name,
                freq = (word[ , c(year)]))
  par(pin = c(5.5,5.5))
  #return(wordcloud(a$country,a$freq,min.freq = 214599,scale=c(1,0.1),colors = a$freq))
  return(wordcloud2(a,color = "random-light",size = 0.3))
}

getRankPlot <- function(top_year,top_rank){
  word<-na.omit(df1) 
  top_year<-str_c("X",top_year)
  a<-data.frame(country = word$geo.name,
                freq = word[ , c(top_year)])
  word1<-a[order(a$freq,decreasing = T),]
  word2<-data.frame(co = word1$country,
                    population = word1$freq)
  word2$co <- factor(word2$co,levels=word2$co)
  print(word2[top_rank,]$population)
  p <- ggplot(word2[1:top_rank,],aes(x=co,y=population,fill =population))
  #+ylim (word2[top_rank+1,]$population, word2[1,]$population)
  #coord_cartesian(ylim = range(df$Y))
  #coord_cartesian(ylim = range(word2[1:top_rank,]$population))
  p+geom_bar(stat = 'identity')+
    theme(axis.text.x = element_text(angle = 30, hjust = 1))+
    coord_flip(ylim = range(word2[1:top_rank,]$population))
    #coord_cartesian()+
 #p+coord_cartesian(lim = range(word2[1:top_rank,]$population))
}

#position=[Global,Europe,Asia,North America,South America,Africa,Australia]
getMapPlot <- function(date,position){
  df <- read_excel('www/data/lex-by-gapminder.xlsx', sheet = 2)
  map <- map_data('world')
  map_continent <- read.csv('www/data/gapminder.csv')
  map_continent <- unique(subset(map_continent, select=c(country,continent)))
  colnames(map)[5] <- "country"
  map <- filter(map,map$country != 'French Southern and Antarctic Lands')
  map$country[which(map$country=='South Sudan')] <- 'Sudan'
  map$country[which(map$country=='USA')] <- 'United States'
  map$country[which(map$country=='Democratic Republic of the Congo')] <- 'Congo, Dem. Rep.'
  map$country[which(map$country=='Republic of Congo')] <- 'Congo, Rep.'
  map_full <- left_join(map,map_continent,by = c('country'))
  colnames(df)[1] <- "country"
  life_map <- right_join(df,map_full,by = c("country"))
  
  
  plain <- theme(
    axis.text = element_blank(),
    axis.line = element_blank(),
    axis.ticks = element_blank(),
    panel.border = element_blank(),
    panel.grid = element_blank(),
    axis.title = element_blank(),
    panel.background = element_rect(fill = "transparent"),
    plot.background = element_rect(fill = "transparent"),
    plot.title = element_text(hjust = 0.5)
  )
  
  if (position != 'Global'){
    life_map <- filter(life_map,life_map$continent == position)
  }
  
  res_plot <- ggplot(life_map,mapping = aes(x = long, y = lat,group = group,
                                fill = unlist(life_map[date])))+
    geom_polygon(color = 'gray') +
    scale_fill_distiller(palette ="Spectral",na.value="white")+
    plain
  
  return(res_plot)
  
}


getRelatedDataPlot <- function(related_country,factor){
  if (factor == 'GDP') {
    return(relation_gdp(related_country))
  } 
  if (factor == 'Earthquake') {
    return(relation_earthquake(related_country))
  }
}

relation_gdp <- function(country) {
  # connect df and gdp
  expectancy <- df[df[["geo.name"]] == country,]   # Pick the country
  geo <- expectancy$geo 
  if (any(grepl(geo, gdp_c$geo))) {
      g <- gdp_c[gdp_c[['geo']] == geo,]
      g <- g[,3:length(g)]
      
      # drop unused information
      life <- expectancy[,5:length(expectancy)]   
      # Add GDP values of each year to the same dataframe
      life[2,] <- NA
        for (i in 1:length(g)){
          life[2,as.character(colnames(g)[i])] <- g[,i]  
        }
      # Add year as a row  
      life<- rbind(life, as.numeric(colnames(life)))
      # Transpose dataframe
      life <- t(life)
      # Setup column names
      colnames(life) <- c('expectlife','gdp','year')
      df_life <- data.frame(life)
      
      # Setup scale factor for multiple lines plotting shown in the same plot
      scaleFactor <- max(df_life$expectlife,na.rm=TRUE) / max(df_life$gdp, na.rm=TRUE)
      
      # ggplot  
        mainplot <- ggplot(data = df_life)+
          geom_jitter(mapping = aes(x = year, y = expectlife, col="Expect Life"))+
          geom_jitter(mapping = aes(x = year, y = gdp * scaleFactor, col = "GDP"))+
          ggtitle((as.character(country)))+
          
          scale_y_continuous(
            # Features of the first axis
            name = "Average Life Expectancy",
            # Add a second axis and specify its features
            sec.axis=sec_axis(~./scaleFactor, name="GDP")
          )
        suppressWarnings(print(mainplot))
    } else{
      print('No such country found in GDP record')
    }
  
}


relation_earthquake <- function(country) {
  # connect df and earthquake
  expectancy <- df[df[["geo.name"]] == country,]
  geo <- expectancy$geo.name
  if (any(grepl(geo, earthquake$country))) {
    e <- earthquake[earthquake[['country']] == geo,]
    e <- e[,2:length(e)]
    
    # drop unused information
    life <- expectancy[,5:length(expectancy)]
    # Add earthquake death of each year to the same dataframe
    life[2,] <- NA
    for (i in 1:length(e)){
      life[2,as.character(colnames(e)[i])] <- as.numeric(e[,i])
    }
    # Add year as a row  
    life<- rbind(life, as.numeric(colnames(life)))
    # Transpose dataframe
    life <- t(life)
    # Setup column names
    colnames(life) <- c('expectlife','earthquake_death','year')
    df_life <- data.frame(life)
    
    # Setup scale factor for multiple lines plotting shown in the same plot
    scaleFactor <- max(df_life$expectlife, na.rm=TRUE) / max(df_life$earthquake_death, na.rm=TRUE)
    
    # ggplot 
    mainplot <- ggplot(data = df_life)+
      geom_jitter(mapping = aes(x = year, y = expectlife, col="Expect Life"))+
      geom_jitter(mapping = aes(x = year, y = earthquake_death * scaleFactor, col = "Earthquake Death"))+
      ggtitle((as.character(country)))+
      
      scale_y_continuous(
        # Features of the first axis
        name = "Average Life Expectancy",
        # Add a second axis and specify its features
        sec.axis=sec_axis(~./scaleFactor, name="Earthquake")
      )
    suppressWarnings(print(mainplot))
  } else{
    print('No such country found in earthquake record')
  }
  
}
