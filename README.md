# MARTA Bus Finder

## Demo
[https://writeandroll.com/apps/marta-bus-finder/](http://writeandroll.com/apps/marta-bus-finder/)

## Info
This is a ["Shiny App"](https://www.rstudio.com/products/shiny/shiny-user-showcase/)

To run the app yourself, you will need R installed. [(Download R for Windows)](https://cran.r-project.org/bin/windows/base/)
You will probably want to interface with R using RStudio, but it's not necessary. [(Download RStudio)](https://www.rstudio.com/products/rstudio/download/)

```r
# run once
install.packages(shiny)
install.packages(leaflet)
install.packages(jsonlite)
```

```r
# run app
library(shiny)
runApp(appDir = "C:/marta-bus-finder/")
```
