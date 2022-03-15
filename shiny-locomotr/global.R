# Import data
# temp.data <- suppressMessages(readxl::read_excel(Sys.glob('*1.xlsx'), col_names = FALSE))
# data <- wrangle_boxscore(temp.data)

# Data wrangling function ----
wrangle_data <- function(data, modification){
  
  # if (type == 'Boxscore'){
    teamName <- data[[1,1]]
    data <- na_if(data, '-')
    
    # Wrangle data into ONE readable data table
    c <- ncol(data)
    extra <- suppressMessages(as_tibble_row(1:c, .name_repair = "unique"))
    extra[1:nrow(extra), 1:ncol(extra)] <- NA
    data2 <- data %>%
      filter(row_number() >= which(data[1] == teamName)[2])
    data <- data %>%
      filter(row_number() < which(data[1] == teamName)[2]) %>%
      select(1:(which(is.na(data[1,]))[1]-1))
    data2 <- rbind(data2[1:2,], extra, data2[3:nrow(data2),])
    data <- cbind(data, data2[,-(1:2)])
    
    for (i in 1:ncol(data)){
      data[1,i] <- paste0(data[1,i],
                          ifelse(!is.na(data[2,i]), data[2,i], ''), 
                          ifelse(!is.na(data[3,i]), data[3,i], '')
      )
    }
    data <- data[-(2:3),]
    colnames(data) <- as.character(unlist(data[1,]))
    data <- data[-c(1, nrow(data)), ]
    colnames(data)[1] <- 'Player'
    percent.cols <- which(grepl('%', colnames(data)))
    for (i in percent.cols){
      for (j in 1:nrow(data)){
        if (!is.na(data[j,i])){
          data[j,i] <- gsub('.{1}$', '', data[j,i])
        }
      }
    }
    data[2:ncol(data)] <- mutate_all(data[2:ncol(data)], function(x) as.numeric(as.character(x)))
    
    # Use Modify
    temp <- c('Player', 'GP', 'Min')
    a <- which(colnames(data) %in% temp)
    b <- which(grepl('%', colnames(data)))
    c <- c(a,b)
    d <- c(1:ncol(data))
    e <- as.vector(d[!d %in% c])
    
    if (modification == 'forty'){
      for (i in 1:nrow(data)){
        factor <- data[i,'Min']/40
        for (j in e){
          data[i,j] <- suppressWarnings(as.numeric(data[i,j])/factor)
        }
      }
    } else if (modification == 'match'){
      for (i in 1:nrow(data)){
        factor <- data[i,'GP']
        for (j in e){
          data[i,j] <- suppressWarnings(as.numeric(data[i,j])/factor)
        }
      }
    } 
    
    # data.list <- list()
    # data.list[[1]] <- data
    # data <- data.list
    
  # } 
  #else if (type == 'Offensive'){
  #   teamName <- data[[7,1]]
  #   data <- na_if(data, '-')
  #   data[nrow(data)+1,] <- NA
  #   data[nrow(data)+1,] <- NA
  #   data$row.na <- NA
  #   data$new.sheet <- NA
  #   
  #   for (i in 1:nrow(data)){
  #     data$row.na[i] <- as.logical(all(is.na(data[i,])))
  #   }
  #   
  #   for (i in 3:(nrow(data)-2)){
  #     if (data$row.na[i-1] == TRUE && data$row.na[i-2] == TRUE){
  #       data$new.sheet[i] <- 'Start'
  #     } else if (data$row.na[i+1] == TRUE && data$row.na[i+2] == TRUE){
  #       data$new.sheet[i] <- 'Stop'
  #     }
  #   }
  #   
  #   start <- which(data$new.sheet == 'Start')
  #   stop <- which(data$new.sheet == 'Stop')
  #   stop <- stop[-1]
  #   data <- data[,-((ncol(data)-1):ncol(data))]
  #   data.list <- list()
  #   
  #   for (i in 1:length(start)){
  #     data.list[[i]] <- data.frame(data[start[i]:stop[i],])
  #     names(data.list)[i] <- data[[start[i],1]]
  #     colnames(data.list[[i]]) <- data.list[[i]][1,]
  #     data.list[[i]] <- data.list[[i]] %>% 
  #       slice(-1)
  #   }
  #   
  #   k <- i+1
  #   data.list[[k]] <- data.frame(data[6:(start[1]-1),])
  #   colnames(data.list[[k]]) <- data.list[[k]][1,]
  #   names(data.list)[k] <- data.list[[k]][1,1]
  #   data.list[[k]] <- data.list[[k]] %>% 
  #     slice(-1)
  #   data.list <- data.list[c(k, 1:(k-1))]
  #   
  #   data <- data.list
  # }
  
    return(data)
  }

# Plotly plot ----
scatterPlot <- function(data, x, y, title){
  coul <- brewer.pal(4, "Spectral")
  coul <- colorRampPalette(coul)(nrow(data))
  bgcol <- ifelse(title=='Bakken Bears', '#E2E7F9', '#FB8856')
  point.plot <- plotly::plot_ly(data=data,
                                x= ~get(x), 
                                y= ~get(y), 
                                color= ~Player,
                                colors = coul, #nrow(data$Player),
                                type='scatter',
                                mode='markers',
                                width=800,
                                height=400)
  
  point.plot <- plotly::layout(point.plot,
                               title=title,
                               yaxis = list(title = y),
                               xaxis = list(title = x),
                               margin=5
                               # paper_bgcolor=bgcol
                               # plot_bgcolor=bgcol
  )
  return(point.plot)
}

barPlot <- function(data, y, ymin = NULL, ymax = NULL, title){
  coul <- brewer.pal(4, "Spectral")
  coul <- colorRampPalette(coul)(nrow(data))
  bgcol <- ifelse(title=='Bakken Bears', '#E2E7F9', '#FB8856')
  
  data2 <- data[order(data[,y], decreasing = TRUE),]
  data2$Player <- factor(data2$Player, levels = data2[['Player']])
  
  bar.plot <- plotly::plot_ly(data=data2,
                                x= ~Player, 
                                y= ~get(y), 
                                color= ~Player,
                                colors = coul, #nrow(data$Player),
                                type='bar',
                                # mode='markers',
                                width=800,
                                height=500
                              )
  
  if (!is.null(ymin) && !is.null(ymax)){
    bar.plot <- plotly::layout(bar.plot,
                               title=title,
                               yaxis = list(title = y,
                                            range = c(ymin, ymax)),
                               xaxis = list(title='',
                                            tickangle = 45),
                               margin=5
    )
  } else {
    bar.plot <- plotly::layout(bar.plot,
                             title=title,
                             yaxis = list(title = y),
                             xaxis = list(title='',
                                          tickangle = 45),
                             margin=5
    )
  }
  return(bar.plot)
}

# data <- wrangle_boxscore(temp.data)

