library(shiny)
library(leaflet)
library(jsonlite)


# marta_bus_route_list <- unique((jsonlite:::fromJSON("http://developer.itsmarta.com/BRDRestService/BRDRestService.svc/GetAllBus", flatten=TRUE))$ROUTE)

# I'm not sure why the route list in gtfs schema below disagrees with the REST service request above. It's probably because not all routes are always active at the same time.
# marta_bus_route_list <- gsub(".csv","",list.files("C:/source/marta-bus-finder/routes"))
# marta_bus_route_list <- marta_bus_route_list[grepl("1|2|3|4|5|6|7|8|9", marta_bus_route_list)]
# marta_bus_route_list <- marta_bus_route_list[order(nchar(marta_bus_route_list), marta_bus_route_list)]
# writeClipboard(paste(paste0("\"",marta_bus_route_list,"\""),collapse=","))
marta_bus_route_list <- c("1","2","3","4","5","6","8","9","12","13","14","15","16","19","21","24","25","26","27","30","32","33","34","36","37","39","40","42","47","49","50","51","53","55","56","58","60","66","67","68","71","73","74","75","78","79","81","82","83","84","85","86","87","89","93","94","95","99","102","103","104","107","109","110","111","114","115","116","117","119","120","121","123","124","125","126","132","133","140","141","142","143","148","150","153","155","162","165","170","172","178","180","181","183","185","186","189","191","192","193","194","195","196","201","221","295","800","809","813","816","823","825","832","850","853","856","865","867","899")

ui <- bootstrapPage(
  tags$title("MARTA Bus Finder"),
  tags$style(type = "text/css", "
    html, body {
      width:100%;
      height:100%
    }
    /* .leaflet-label-right:after, .leaflet-label-right:before, .leaflet-label-left:after, .leaflet-label-left:before { display:none }"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(
    top = 10,
    right = 10,
    selectInput(
      "route_select",
      width = "100%",
      label = h1("MARTA Route #", style = "color: #003366;"), 
      choices = list(as.integer(marta_bus_route_list))[[1]], 
      selected = 1),
    actionButton(
      "update_bus_locations_button",
      "Update Bus Locations",
      width = "100%"),
    # checkboxInput("checkbox_show_route", label = "Show Route", value = TRUE),
  width = "164px"),
  absolutePanel(
    bottom = 18,
    right = 6,
    HTML("<a href='https://github.com/area-man/marta-bus-finder'>Code</a>"))
  #, includeScript("shiny_geolocation.js")
)