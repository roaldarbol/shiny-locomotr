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

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$mocapUploaded <- reactive({
        if(!is.null(input$mocap)) return(TRUE)
    })
    
    output$opponentUploaded <- reactive({
        if(!is.null(input$opponent)) return(TRUE)
    })
    
    output$varsSelected <- reactive({
        if(!is.null(input$xvariable)) return(TRUE)
    })
    
    outputOptions(output, 'mocapUploaded', suspendWhenHidden=FALSE)
    outputOptions(output, 'opponentUploaded', suspendWhenHidden=FALSE)
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
        mydata <- mocapWrangled()
        # if (length(mydata) == 1){
        #     mydata <- mydata[[1]]
        mydata <- mydata[-1]
        names <- names(mydata)
        # } else if (class(mydata) == 'list'){
        #     names <- names(mydata[outSheet])
        # }
        return(names)
    })
    
    mocapName <- reactive({
        temp.data <- mocapRaw()
        teamName <- temp.data[[1,1]]
        return(teamName)
    })
    
    opponentName <- reactive({
        temp.data <- opponentRaw()
        teamName <- temp.data[[1,1]]
        return(teamName)
    })
    
    output$xvar <- renderUI({
        selectInput('xvar', 'Select X Variable', outNames(), selected = 'Min')
    })
    
    output$yvar <- renderUI({
        selectInput('yvar', 'Select Y Variable', outNames(), selected = 'Pts')
    })
    
    # output$sheet <- renderUI({
    #     selectInput('sheet', 'Select Data Sheet', outSheet(), selected = 'Overall')
    # })
    
    mocapRaw <- reactive({
        raw.data <- suppressMessages(readxl::read_excel(Sys.glob(input$mocap$datapath), col_names = FALSE))
        return(raw.data)
    })
    
    
    mocapWrangled <- reactive({
            raw.data <- mocapRaw()
            mocapWrangled <- wrangle_data(raw.data, modification = input$modify)
        return(mocapWrangled)
    })

    
    # mocap Scatterplot
    output$mocapScatter <- renderPlotly({
        x <- input$xvar
        y <- input$yvar
        # if (is.null(input$sheet)){
        #     df <- mocapWrangled()[[1]]
        # } else if (!is.null(input$sheet)){
        #     df <- mocapWrangled()[[input$sheet]]
        # }
        scatterPlot(mocapWrangled(), x, y, mocapName())
    })
    
    # mocap Bar
    output$mocapBar <- renderPlotly({
        y <- input$yvar
        # if (length(mocapWrangled() == 1)){
        #     df <- mocapWrangled()[[1]]
        # } else {
        #     df <- mocapWrangled()[[input$sheet]]
        # }
        barPlot(mocapWrangled(), y, title = mocapName())
    })
    
    
    output$combmocap <- renderPlotly({
        y <- input$yvar
        
        ymin1 <- min(mocapWrangled()[y])
        ymin2 <- min(opponentWrangled()[y])
        ymin <- min(c(ymin1, ymin2))
        ymax1 <- max(mocapWrangled()[y])
        ymax2 <- max(opponentWrangled()[y])
        ymax <- max(c(ymax1, ymax2))
        
        barPlot(mocapWrangled(), y, ymin, ymax, title = mocapName())
    })
    
})
