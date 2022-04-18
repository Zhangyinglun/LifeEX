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
#start_date：数据起始时间
#end_date：数据结束时间
#position：展示的位置,可能传入如下字符串 [Global,Europe,Asia,North America,South America,Africa,Australia]
getMapPlot <- function(date,position){
  print(paste('Running getMapPlot!','date=',date,'position=',position))
  return(ggplot(iris)+geom_bar(aes(x = Species)))
}

#绘制折线图写入该方法，返回图片
#start_date：数据起始时间
#end_date：数据结束时间
getRelatedDataPlot <- function(related_country,start_date,end_date){
  print(paste('Running getRelatedDataPlot! start_date=',start_date,'end_date=',end_date,'related_country=',related_country))
  return(ggplot(iris)+geom_bar(aes(x = Species)))
}
