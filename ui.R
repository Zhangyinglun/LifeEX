library(shinythemes)

sidebar_panel_width = 3

df <- read_excel(file.path(getwd(),"www/data/lex-by-gapminder.xlsx"), sheet = 2)  # Expected life of each country since 1800

ui <- fluidPage(
  theme = shinytheme('spacelab'),
  navbarPage('Global Life Expectancy',
             tabPanel("Welcome",
                      fluidRow(
                        column(12, align="center",
                               wordcloud2Output('welcome_plot',width = 1200, height = 550))
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
                                      max = 50, 
                                      value = 10),
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
                                                     "America" = "Americas",
                                                     'Africa' = 'Africa'), 
                                    selected = 'Global')
                      ),
                        mainPanel(plotOutput('map_plot'))
                      )
                    ),
             tabPanel("Related Factor",
                      fluidPage(
                        sidebarPanel(
                          width = sidebar_panel_width,
                          selectInput(inputId = 'Relation', label = 'Selecte related factor', choices = c('GDP','Earthquake'), selected = 'GDP'),
                          selectInput(inputId = 'related_country', label = 'Select Country', choices = df[['geo.name']]),
                          #textInput("related_country", label = 'Country', value = "China"),
                          #dateRangeInput("related_dates", label = "Date range", start = '1990-01-01'),
                        ),
                        mainPanel(plotOutput('related_data_plot'))
                      )
                    )
  )
)