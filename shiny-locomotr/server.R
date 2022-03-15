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
    
    output$bearsUploaded <- reactive({
        if(!is.null(input$bears)) return(TRUE)
    })
    
    output$opponentUploaded <- reactive({
        if(!is.null(input$opponent)) return(TRUE)
    })
    
    output$varsSelected <- reactive({
        if(!is.null(input$xvariable)) return(TRUE)
    })
    
    outputOptions(output, 'bearsUploaded', suspendWhenHidden=FALSE)
    outputOptions(output, 'opponentUploaded', suspendWhenHidden=FALSE)
    outputOptions(output, 'varsSelected', suspendWhenHidden=FALSE)
    
    # Variable input
    # outSheet <- reactive({
    #     mydata <- bearsWrangled()
    #     if (class(mydata) == 'list'){
    #         names <- names(data.list)
    #     } else {
    #         names = NULL
    #     }
    #     return(names)
    # })
    
    outNames <- reactive({
        mydata <- bearsWrangled()
        # if (length(mydata) == 1){
        #     mydata <- mydata[[1]]
        mydata <- mydata[-1]
        names <- names(mydata)
        # } else if (class(mydata) == 'list'){
        #     names <- names(mydata[outSheet])
        # }
        return(names)
    })
    
    bearsName <- reactive({
        temp.data <- bearsRaw()
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
    
    bearsRaw <- reactive({
        raw.data <- suppressMessages(readxl::read_excel(Sys.glob(input$bears$datapath), col_names = FALSE))
        return(raw.data)
    })
    
    opponentRaw <- reactive({
        raw.data <- suppressMessages(readxl::read_excel(Sys.glob(input$opponent$datapath), col_names = FALSE))
        return(raw.data)
    })
    
    bearsWrangled <- reactive({
            raw.data <- bearsRaw()
            bearsWrangled <- wrangle_data(raw.data, modification = input$modify)
        return(bearsWrangled)
    })
    
    opponentWrangled <- reactive({
        raw.data <- opponentRaw()
        opponentWrangled <- wrangle_data(raw.data, modification = input$modify)
        return(opponentWrangled)
    })

    
    # Bears Scatterplot
    output$bearsScatter <- renderPlotly({
        x <- input$xvar
        y <- input$yvar
        # if (is.null(input$sheet)){
        #     df <- bearsWrangled()[[1]]
        # } else if (!is.null(input$sheet)){
        #     df <- bearsWrangled()[[input$sheet]]
        # }
        scatterPlot(bearsWrangled(), x, y, bearsName())
    })
    
    # Opponent scatterplot
    output$opponentScatter <- renderPlotly({
        x <- input$xvar
        y <- input$yvar
        # if (is.null(input$sheet)){
        #     df <- opponentWrangled()[[1]]
        # } else if (!is.null(input$sheet)){
        #     df <- opponentWrangled()[[input$sheet]]
        # }
        scatterPlot(opponentWrangled(), x, y, opponentName())
    })
    
    # Bears Bar
    output$bearsBar <- renderPlotly({
        y <- input$yvar
        # if (length(bearsWrangled() == 1)){
        #     df <- bearsWrangled()[[1]]
        # } else {
        #     df <- bearsWrangled()[[input$sheet]]
        # }
        barPlot(bearsWrangled(), y, title = bearsName())
    })
    
    # Opponent Bar
    output$opponentBar <- renderPlotly({
        y <- input$yvar
        # if (length(opponentWrangled()) == 1){
        #     df <- opponentWrangled()[[1]]
        # } else {
        #     df <- opponentWrangled()[[input$sheet]]
        # }
        barPlot(opponentWrangled(), y, title = opponentName())
    })
    
    output$combBears <- renderPlotly({
        y <- input$yvar
        
        ymin1 <- min(bearsWrangled()[y])
        ymin2 <- min(opponentWrangled()[y])
        ymin <- min(c(ymin1, ymin2))
        ymax1 <- max(bearsWrangled()[y])
        ymax2 <- max(opponentWrangled()[y])
        ymax <- max(c(ymax1, ymax2))
        
        barPlot(bearsWrangled(), y, ymin, ymax, title = bearsName())
    })
    
    output$combOpponent <- renderPlotly({
        y <- input$yvar
        
        ymin1 <- min(bearsWrangled()[y])
        ymin2 <- min(opponentWrangled()[y])
        ymin <- min(c(ymin1, ymin2))
        ymax1 <- max(bearsWrangled()[y])
        ymax2 <- max(opponentWrangled()[y])
        ymax <- max(c(ymax1, ymax2))
        
        barPlot(opponentWrangled(), y, ymin, ymax, title = opponentName())
    })
    
})
