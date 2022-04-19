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

}