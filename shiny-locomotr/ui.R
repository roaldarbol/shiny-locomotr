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
    setBackgroundImage(src = "dansk-atletik.jpeg"),
    titlePanel(h1(img(height = 1)), windowTitle = 'Analytics'),
    
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            titlePanel(h1(img(width = 200, src="locomotr-transparent.png"), align="center")),
            # titlePanel(h1('mocap Analytics', align="center")),
            # passwordInput('passwd', label='Enter Password'),
            # conditionalPanel(condition= "input.passwd == 'mocap'",
            #                  
                             conditionalPanel(condition="output.mocapUploaded",
                                              # conditionalPanel(condition="!is.null(output.outSheet)",
                                              #                  uiOutput('sheet')),
                                              uiOutput('yvar'),
                                              uiOutput('xvar')),
                             
                             conditionalPanel(condition="output.mocapUploaded",
                                              radioButtons('modify', 'Options:', 
                                                           c('Total' = 'total',
                                                             'Per 40 Mins' = 'forty',
                                                             'Per Match' = 'match'))),
                             # selectInput(
                             #     "aspect", "Select Aspect",
                             #     c("Boxscore", "Offensive", "Defensive")
                             # ),
                             fileInput("mocap", "Select Mocap Data",
                                       multiple = FALSE,
                                       accept = c(
                                           ".xlsx")),
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Bar Graphs",
                         fluidRow(
                             conditionalPanel(condition="output.mocapUploaded",
                                              plotlyOutput("mocapBar"))
                             
                         )
                ),
                
                tabPanel("Graphs",
                         fluidRow(
                         conditionalPanel(condition="output.mocapUploaded",
                                          plotlyOutput("mocapScatter"))
                         )
                ),
                tabPanel("Modelling")
            )
        )
    )
))
