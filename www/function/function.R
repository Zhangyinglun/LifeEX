library(maps)
library(ggplot2)
library(tidyverse)
library(readxl)
library(dplyr)


library(readr)
library(stringr)
df1.path <- file.path("www/data/LifeExpectancy.csv")

df.path <- file.path("www/data/LifeExpectancy.xlsx")


library(jiebaRD) 
library(jiebaR)
library(wordcloud)
library(wordcloud2)
df <- read.csv(df1.path)
getWrodCloudPlot <- function(year){
  word<-na.omit(df) 
  a<-data.frame(country = word$geo.name,
                freq = (word[ , c(year)]^3))
  par(pin = c(5.5,5.5))
  return(wordcloud(a$country,a$freq,min.freq = 214599,scale=c(1,0.1),colors = a$freq))
}


getRankPlot <- function(top_year,top_rank){
  word<-na.omit(df) 
  top_year<-str_c("X",top_year)
  a<-data.frame(country = word$geo.name,
                freq = word[ , c(top_year)])
  word1<-a[order(a$freq,decreasing = T),]
  word2<-data.frame(co = word1$country,
                    population = word1$freq)
  word2$co <- factor(word2$co,levels=word2$co)
  p <- ggplot(word2[1:top_rank,],aes(x=co,y=population))
  p+geom_bar(stat = 'identity')+theme(axis.text.x = element_text(angle = 30, hjust = 1))+coord_flip()
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
    geom_polygon(color = 'black') +
    scale_fill_gradient(low = 'white', high = 'red')+
    plain
  
  return(res_plot)
  
}


getRelatedDataPlot <- function(related_country,start_date,end_date){
  print(paste(getwd()))
  df <- read_excel(file.path(getwd(),"www/data/lex-by-gapminder.xlsx"), sheet = 2)
  df_region <- read_excel(file.path(getwd(),"/www/data/lex-by-gapminder.xlsx"), sheet = 3)
  df_global <- read_excel(file.path(getwd(),"/www/data/lex-by-gapminder.xlsx"), sheet = 4)
  
  
  gdp <- read_excel(file.path(getwd(),"/www/data/GM-GDP per capita - Dataset - v27.xlsx"), sheet = 'data-GDP-per-capita-in-columns', skip = 3) 
  
  earthquake <- read_csv(file.path(getwd(),"/www/data/earthquake_deaths_annual_number.csv"))
  
  # replace character into numerics, 10K -- 10000
  for (i in 2:length(colnames(earthquake))) {
    if (sapply(earthquake,class)[i] == 'character'){
      print(colnames(earthquake)[i])
      earthquake[[colnames(earthquake)[i]]] <- as.numeric(sub('k','e3',earthquake[[colnames(earthquake)[i]]]))
    }
  0}

  gdp_c <- gdp[!is.na(gdp[["Country Name"]]),]
  
  return(relation_gdp(df,related_country))
  
  #print(paste('Running getRelatedDataPlot! start_date=',start_date,'end_date=',end_date,'related_country=',related_country))
  #return(ggplot(iris)+geom_bar(aes(x = Species)))
}


relation_gdp <- function(df,country) {
  expectancy <- df[df[["geo.name"]] == country,]
  geo <- expectancy$geo 
  life <- expectancy[,5:length(expectancy)]
  life[2,] <- NA
  
  if (any(grepl(geo, gdp_c$geo))) {
    g <- gdp_c[gdp_c[['geo']] == geo,]
    g <- g[,3:length(g)]
    
    for (i in 1:length(g)){
      life[2,as.character(colnames(g)[i])] <- g[,i]
    }
    
    life<- rbind(life, as.numeric(colnames(life)))
    
    life <- t(life)
    colnames(life) <- c('expectlife','gdp','year')
    
    df_life <- data.frame(life)
    
    scaleFactor <- max(df_life$expectlife) / max(df_life$gdp, na.rm=TRUE)
    
    ggplot(data = df_life)+
      geom_jitter(mapping = aes(x = year, y = expectlife, col="Expect Life"))+
      geom_jitter(mapping = aes(x = year, y = gdp * scaleFactor, col = "GDP"))+
      ggtitle((as.character(country)))+
      
      scale_y_continuous(
        
        # Features of the first axis
        name = "Average Life Expectancy",
        
        # Add a second axis and specify its features
        sec.axis=sec_axis(~./scaleFactor, name="GDP")
      )
    
  } else{
    print('No such country found in GDP record')
  }
  
  
}
