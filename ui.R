library(shinythemes)

sidebar_panel_width = 3

ui <- fluidPage(
  theme = shinytheme('sandstone'),
  navbarPage('Global Life Expectancy',
             tabPanel("Welcome",
                      fluidRow(
                        column(12, align="center",
                               plotOutput('welcome_plot'))
                        )
                      ),
             tabPanel("Top Countries",
                      fluidPage(
                        sidebarPanel(
                          width = sidebar_panel_width,
                          'Please selet',
                          sliderInput('top_rank', 
                                      label = 'Top rank',
                                      min = 0, 
                                      max = 100, 
                                      value = 30),
                          selectInput(
                            inputId =  "top_year", 
                            label = "Select year:", 
                            choices = 1800:2100,
                            selected = 2022
                          )
                        ),
                        mainPanel(
                          plotOutput('top_plot')
                        )
                      )
                    ),
             tabPanel("Global View",
                      fluidPage(
                        sidebarPanel(
                          width = sidebar_panel_width,
                          'Please selet',
                          selectInput(
                            inputId =  "map_dates", 
                            label = "Select year:", 
                            choices = 1800:2100,
                            selected = 2022
                          ),
                          selectInput("map_position", 
                                      label = "Select position",
                                      choices = list("Global" = "Global", 
                                                     "Europe" = "Europe", 
                                                     "Asia" = "Asia",
                                                     "North America" = "North America",
                                                     "South America" = "South America",
                                                     'Africa' = 'Africa',
                                                     'Australia' = 'Australia'), 
                                    selected = 'Global')
                      ),
                        mainPanel(plotOutput('map_plot'))
                      )
                    ),
             tabPanel("Related Data",
                      fluidPage(
                        sidebarPanel(
                          width = sidebar_panel_width,
                          textInput("related_country", label = 'Country', value = "China"),
                          dateRangeInput("related_dates", label = "Date range", start = '1990-01-01'),
                        ),
                        mainPanel(plotOutput('related_data_plot'))
                      )
                    )
  )
)