library(plumber)
r <- plumb('echo.R')
r$run(port=8080)
