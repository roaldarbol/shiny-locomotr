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
  setBackgroundColor("#475cc7"),
    # setBackgroundImage(src = "dansk-atletik.jpeg"), 
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
                                              uiOutput('bodypart'),
                                              uiOutput('frame')
                                              # uiOutput('xvar')
                                              ),
            
                             fileInput("mocap", "Select Mocap Data",
                                       multiple = FALSE,
                                       accept = c(
                                           ".csv")
                                       ),
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
              tabPanel("Graphs",
                       fluidRow(
                         conditionalPanel(condition="output.mocapUploaded",
                                          plotlyOutput("mocap_line")
                         )
                       )
              ),
              
              tabPanel("Animation",
                       fluidRow(
                           conditionalPanel(condition="output.mocapUploaded",
                                            plotlyOutput("mocap_pose"))

                       )
              ),
              
              tabPanel("Modelling")
            )
        )
    )
))
