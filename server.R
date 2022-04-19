server <- function(input, output) {
  observe({
    output$welcome_plot <- renderWordcloud2(getWrodCloudPlot("X2022"))
    output$top_plot <- renderPlot(getRankPlot(input$top_year,input$top_rank))
    output$map_plot <- renderPlot(getMapPlot(input$map_dates,input$map_position))
    #output$related_data_plot <- renderPlot(getRelatedDataPlot(input$related_country,input$Relation))
    output$related_data_plot <- renderPlot({
      if (input$Relation == "GDP Per Capita") {
      getRelatedDataPlot(input$related_country2, 'GDP')
    } else {
      getRelatedDataPlot(input$related_country1,'Earthquake')
    }
    })
    output$year_plot <- renderPlot(relation_gdpbytime(input$time))
  })
  
  output$img <- renderUI({
    tags$img(src = "https://abcscprod.azureedge.net/-/media/Project/ABCL/Internal_Images_526x230/526x230/LI/li_ph3_181_How_Has_Life_Expectancy_of_an_Average_Person_Changed_Over_Years_526_230.webp?revision=9aaa8d4f-a7dc-4ede-92e1-2c02f03e755e&modified=20210208054305&extension=webp&hash=0AA67F2B380A87C59A6AA6FCA20803DA", width = 300, height = 120)
  })
  output$img1 <- renderUI({
    tags$img(src = "https://media.istockphoto.com/vectors/global-health-icon-vector-id696300598?k=20&m=696300598&s=612x612&w=0&h=Iyzx-7J4-aTJQd5w0Galrz2_V9ntH8P7KSFV_8jhkHk=", width = 200, height = 200)
  })
  output$img2 <- renderUI({
    tags$img(src = "https://www.gannett-cdn.com/-mm-/4e57f417ab56d8147a59ed2deb8f3a4b0b446da3/c=0-108-2120-1306/local/-/media/2015/11/14/USATODAY/USATODAY/635830845228241795-ThinkstockPhotos-166142142.jpg?width=660&height=373&fit=crop&format=pjpg&auto=webp", width = 300, height = 150)
  })

}