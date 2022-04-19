library(shinythemes)

sidebar_panel_width = 3

df <- read_excel(file.path(getwd(),"www/data/lex-by-gapminder.xlsx"), sheet = 2)  # Expected life of each country since 1800
gdp <- read_excel(file.path(getwd(),"/www/data/GM-GDP per capita - Dataset - v27.xlsx"), sheet = 'data-GDP-per-capita-in-columns', skip = 3) # GDP of each country since 1800
earthquake <- read_csv(file.path(getwd(),"/www/data/earthquake_deaths_annual_number.csv")) # Earthquake death of each country since 1800

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
                      fluidRow(
                        column(
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
                          ),
                          uiOutput("img", align = 'left')
                        ),
                        column(9, plotOutput('top_plot'))
                      )
                    ),
             tabPanel("Global View",
                      fluidRow(
                        column(
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
                      column(9,plotOutput('map_plot')),
                      column(3,uiOutput("img1", align = 'left'))
                    )
                    ),
             tabPanel("Related Factor",
                      fluidRow(
                        column(
                          width = sidebar_panel_width,
                          selectInput(inputId = 'Relation', label = 'Selecte related factor', choices = c('GDP Per Capita','Earthquake')),
                          
                          conditionalPanel(
                            condition = "input.Relation == 'Earthquake'",
                            selectInput(inputId = 'related_country1', label = 'Select Country', choice = earthquake[['country']])),
                          
                          conditionalPanel(
                            condition = "input.Relation == 'GDP Per Capita'",
                            selectInput(inputId = 'related_country2', label = 'Select Country', choice = gdp[['Country Name']] ))
                            
                        ),
                        column(9,plotOutput('related_data_plot')),
                        column(12,uiOutput("img2", align = 'left')),
                      )
                    )
  )
)