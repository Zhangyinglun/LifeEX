# csv地址
df.path <- file.path("www/data/LifeExpectancy.csv")
# xlsx地址
df.path <- file.path("www/data/LifeExpectancy.xlsx")


#词云写入该方法，返回图片
#year：词云使用的年份，默认2022
getWrodCloudPlot <- function(year){
  print(paste('Running getWrodCloudPlot! year=',year))
  return(ggplot(iris)+geom_bar(aes(x = Species)))
}

#寿命前top_rank位国家写入该方法，返回图片
#top_rank：取1~top_rank 数量的国家
getRankPlot <- function(top_year,top_rank){
  print(paste('Running getRankPlot! top_rank=',top_rank,'top_year=',top_year))
  return(ggplot(iris)+geom_bar(aes(x = Species)))
}

#绘制地图写入该方法，返回图片
#date：数据时间
#position：展示的位置,可能传入如下字符串 [Global,Europe,Asia,North America,South America,Africa,Australia]
getMapPlot <- function(date,position){
  print(paste('Running getMapPlot!','date=',date,'position=',position))
  return(ggplot(iris)+geom_bar(aes(x = Species)))
}

#绘制折线图写入该方法，返回图片
#start_date：数据起始时间
#end_date：数据结束时间
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
