server <- function(input, output) {
  observe({
    output$welcome_plot <- renderPlot(getWrodCloudPlot("X2022"))
    output$top_plot <- renderPlot(getRankPlot(input$top_year,input$top_rank))
    output$map_plot <- renderPlot(getMapPlot(input$map_dates,input$map_position))
    output$related_data_plot <- renderPlot(getRelatedDataPlot(input$related_country,input$related_dates[1],input$related_dates[2]))
  })

}