#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(dplyr)
library(tibble)
library(ggplot2)
library(plotly)
library(shinyWidgets)
library(RColorBrewer)
library(png)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    # Application title
    setBackgroundImage(src = "bears.jpg"),
    titlePanel(h1(img(height = 1)), windowTitle = 'Bears Analytics'),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            titlePanel(h1(img(width = 200, src="Bears-Analytics-3.png"), align="center")),
            # titlePanel(h1('Bears Analytics', align="center")),
            passwordInput('passwd', label='Enter Password'),
            conditionalPanel(condition= "input.passwd == 'Bears'",
                             
                             conditionalPanel(condition="output.bearsUploaded",
                                              # conditionalPanel(condition="!is.null(output.outSheet)",
                                              #                  uiOutput('sheet')),
                                              uiOutput('yvar'),
                                              uiOutput('xvar')),
                             
                             conditionalPanel(condition="output.bearsUploaded",
                                              radioButtons('modify', 'Options:', 
                                                           c('Total' = 'total',
                                                             'Per 40 Mins' = 'forty',
                                                             'Per Match' = 'match'))),
                             # selectInput(
                             #     "aspect", "Select Aspect",
                             #     c("Boxscore", "Offensive", "Defensive")
                             # ),
                             fileInput("bears", "Select Bears Boxscore",
                                       multiple = FALSE,
                                       accept = c(
                                           ".xlsx")),
                             fileInput("opponent", "Select Opponent Boxscore",
                                       multiple = FALSE,
                                       accept = c(
                                           ".xlsx")))
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Bar Graphs",
                         fluidRow(
                             conditionalPanel(condition="output.bearsUploaded && !output.opponentUploaded",
                                              plotlyOutput("bearsBar")),
                             conditionalPanel(condition="output.opponentUploaded && !output.bearsUploaded",
                                              plotlyOutput("opponentBar")),
                             conditionalPanel(condition="output.bearsUploaded && output.opponentUploaded",
                                              plotlyOutput("combBears"),
                                              plotlyOutput("combOpponent"))
                             
                         )
                ),
                
                tabPanel("Graphs",
                         fluidRow(
                         conditionalPanel(condition="output.bearsUploaded",
                                          plotlyOutput("bearsScatter")),
                         conditionalPanel(condition="output.opponentUploaded",
                                          plotlyOutput("opponentScatter"))
                         )
                ),
                tabPanel("Modelling")
            )
        )
    )
))
