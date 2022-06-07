#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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
library(RColorBrewer)
library(vroom)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$mocapUploaded <- reactive({
        if(!is.null(input$mocap)) return(TRUE)
    })
    
    output$varsSelected <- reactive({
        if(!is.null(input$xvariable)) return(TRUE)
    })
    
    outputOptions(output, 'mocapUploaded', suspendWhenHidden=FALSE)
    outputOptions(output, 'varsSelected', suspendWhenHidden=FALSE)
    
    # Variable input
    # outSheet <- reactive({
    #     mydata <- mocapWrangled()
    #     if (class(mydata) == 'list'){
    #         names <- names(data.list)
    #     } else {
    #         names = NULL
    #     }
    #     return(names)
    # })
    
    outNames <- reactive({
        # if (length(mydata) == 1){
        #     mydata <- mydata[[1]]
        mydata <- mocap_data[-1]
        names <- names(mydata)
        # } else if (class(mydata) == 'list'){
        #     names <- names(mydata[outSheet])
        # }
        return(names)
    })
    
    bodyparts <- reactive({
      data <- mocap_data()
      bodyparts <- unique(data$bodypart)
      return(bodyparts)
    })
    
    frames <- reactive({
      data <- mocap_data()
      frames <- unique(data$frame)
      return(frames)
    })
    
    
    # output$xvar <- renderUI({
    #     selectInput('xvar', 'Select X Variable', outNames(), selected = 'Min')
    # })
    # 
    output$bodypart <- renderUI({
        selectInput('bodypart', 'Select bodypart', bodyparts())
    })
    
    output$frame <- renderUI({
      frames <- frames()
      frames_min <- min(frames)
      frames_max <- max(frames)
      sliderInput("frame", "Frames:",
                  min = frames_min, max = frames_max,
                  value = c(frames_min,frames_max))
    })
    
    # output$sheet <- renderUI({
    #     selectInput('sheet', 'Select Data Sheet', outSheet(), selected = 'Overall')
    # })
    
    mocap_raw <- reactive({
        data_raw <- suppressMessages(vroom::vroom(Sys.glob(input$mocap$datapath)))
        return(data_raw)
    })
    
    mocap_data <- reactive({
      data_tidy <- tidy_anipose(mocap_raw())
      data_augmented <- augment_poses(data_tidy, 30, 30)
      return(data_augmented)
    })
    
    mocap_data_filtered <- reactive({
      data <- mocap_data()
      frame_min <- input$frame[1]
      frame_max <- input$frame[2]
      data_filtered <- data %>% 
        filter(between(frame, frame_min, frame_max))
      return(data_filtered)
    })
    
    # mocap Scatterplot
    output$mocap_line <- renderPlotly({
        # x <- input$xvar
        # y <- input$yvar
        # if (is.null(input$sheet)){
        #     df <- mocapWrangled()[[1]]
        # } else if (!is.null(input$sheet)){
        #     df <- mocapWrangled()[[input$sheet]]
        # }
        plot <- mocap_data_filtered() %>%
          filter(bodypart == input$bodypart) %>%
          ggplot(aes(frame, v)) +
          geom_line()
        ggplotly(plot)
    })
    
    output$mocap_pose <- renderPlotly({
      mocap_data_filtered()  %>%
        plot_ly(
          x = ~x,
          y = ~y,
          frame = ~frame,
          color = ~bodypart,
          type = 'scatter',
          mode = 'markers',
          showlegend = TRUE
        ) %>%
        layout(
          yaxis = list(
            scaleanchor = "x",
            scaleratio = 1
          )
        ) %>% 
        animation_opts(
          frame = 10,
          transition = 0
        )
    })
    
    
})
