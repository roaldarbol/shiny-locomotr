temp.data <- suppressMessages(readxl::read_excel(Sys.glob('*2.xlsx'), col_names = FALSE))

arr <- data.frame(which(is.na(temp.data), arr.ind = TRUE))
arr <- arr[['row']]