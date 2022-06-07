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
library(shinydashboard)
library(dashboardthemes)
library(tidymocap)
library(locomotr)

# Dashboard page ----
dashboardPage(
  
  # Header ----
  dashboardHeader(
    title = "Performance Analysis",
    tags$li(a(href = 'https://roald-arboel.com',
              img(src = 'locomotr-transparent.png',
                  title = "Company Home", height = "30px"),
              style = "padding-top:10px; padding-bottom:10px;"),
            class = "dropdown")
      # img(src = "locomotr-transparent.png", height=50)#",
  ),
  
  # Sidebar ----
  dashboardSidebar(
    sidebarMenu(
      menuItem("Welcome", tabName = "welcome", icon = icon("welcome")),
      menuItem("New analysis", tabName = "dashboard", icon = icon("dashboard"), startExpanded = FALSE,
               menuSubItem("Import", tabName = "import", icon = icon("download")),
               menuSubItem("Analysis", tabName = "analysis", icon = icon("dashboard")),
               menuSubItem("Export", tabName = "export", icon = icon("upload"))),
      menuItem("Progression", icon = icon("calendar"), tabName = "progression")
      # titlePanel(h1(img(width = 200, src="locomotr-transparent.png"), align="center")),
    )
  ),
  
  # Body ----
  dashboardBody(
    shinyDashboardThemes(
      theme = "blue_gradient"
    ),
    
    tabItems(
      ## Tab: New Analysis ----
      tabItem(tabName = "dashboard",
        fluidRow(
          valueBoxOutput("boxy")
        )
      ),
      
      ## Tab: Progression ----
      tabItem(
        tabName = "import",
        fluidRow(
          box(
            selectInput(
              'event',
              'Select event',
              c('Discus', 'Hammer', 'Shot put', 'Javelin'),
              selected = 'Discus'
            ),
            
            fileInput("mocap", "Select Mocap Data",
                      multiple = FALSE,
                      accept = c(
                        ".csv")
            )
          )
        )
      ),
      
      ## Tab: Analysis ----
      tabItem(
        tabName = "analysis",
        tabBox(
          width = 12,
          tabPanel(
            "Raw data",
            fluidRow(
              # conditionalPanel(condition="output.mocapUploaded",
                               uiOutput('frame'),
                               uiOutput('bodypart')
              # )
            ),
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
          
          tabPanel("Key Performance Indicators")
        )
      )
    )
  ),
)
# Vanilla ----
# Define UI for application that draws a histogram
# shinyUI(fluidPage(
#     # Application title
#   # setBackgroundColor("#475cc7"),
#     # setBackgroundImage(src = "dansk-atletik.jpeg"),
#     titlePanel(h1(img(height = 1)), windowTitle = 'Analytics'),
# 
#     # Sidebar with a slider input for number of bins
#     sidebarLayout(
#         sidebarPanel(
#             titlePanel(h1(img(width = 200, src="locomotr-transparent.png"), align="center")),
#             selectInput(
#               'event',
#               'Select event',
#               c('Discus', 'Hammer', 'Shot put', 'Javelin'),
#               selected = 'Discus'
#               ),
#             # titlePanel(h1('mocap Analytics', align="center")),
#             # passwordInput('passwd', label='Enter Password'),
#             # conditionalPanel(condition= "input.passwd == 'mocap'",
# 
#            fileInput("mocap", "Select Mocap Data",
#                      multiple = FALSE,
#                      accept = c(
#                          ".csv")
#                      ),
# 
#             conditionalPanel(condition="output.mocapUploaded",
#                              uiOutput('frame'),
#                              uiOutput('bodypart')
#             ),
#         ),
# 
#         # Show a plot of the generated distribution
#         mainPanel(
#             tabsetPanel(
#               tabPanel("Graphs",
#                        fluidRow(
#                          conditionalPanel(condition="output.mocapUploaded",
#                                           plotlyOutput("mocap_line")
#                          )
#                        )
#               ),
# 
#               tabPanel("Animation",
#                        fluidRow(
#                            conditionalPanel(condition="output.mocapUploaded",
#                                             plotlyOutput("mocap_pose"))
# 
#                        )
#               ),
# 
#               tabPanel("Key Performance Indicators")
#             )
#         )
#     )
# ))
