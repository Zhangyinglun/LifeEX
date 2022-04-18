
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
                freq = word[ , c(year)])
  return(wordcloud(a$country,a$freq,min.freq = 10,scale=c(0.5,0.5)))
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
  print(paste('Running getMapPlot!','date=',date,'position=',position))
  return(ggplot(iris)+geom_bar(aes(x = Species)))
}


getRelatedDataPlot <- function(related_country,start_date,end_date){
  print(paste(getwd()))
  df <- read_excel(file.path(getwd(),"www/data/lex-by-gapminder.xlsx"), sheet = 2)
  df_region <- read_excel(file.path(getwd(),"/www/data/lex-by-gapminder.xlsx"), sheet = 3)
  df_global <- read_excel(file.path(getwd(),"/www/data/lex-by-gapminder.xlsx"), sheet = 4)
  
  
  gdp <- read_excel(file.path(getwd(),"/www/data/GM-GDP per capita - Dataset - v27.xlsx"), sheet = 'data-GDP-per-capita-in-columns', skip = 3) 
  
  earthquake <- read_csv(file.path(getwd(),"/www/data/earthquake_deaths_annual_number.csv"))
  
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
