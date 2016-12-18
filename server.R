library(shiny)
library(leaflet)
library(jsonlite)

marta_bus_url <- "http://developer.itsmarta.com/BRDRestService/BRDRestService.svc/GetAllBus"
marta_bus_route_url <- "http://developer.itsmarta.com/BRDRestService/RestBusRealTimeService/GetBusByRoute/"
# api key needed for marta rail json service # http://www.itsmarta.com/app-developer-resources.aspx

shinyServer(function(input, output, session) {
  
  map <- leaflet() %>%
    addTiles(options = tileOptions(zIndex = -1000)) %>%
    fitBounds(-84.540089, 33.643822, -84.172734, 33.871885) 
  output$map <- renderLeaflet(map)
  
  observeEvent(input$update_bus_locations_button, {
    
    route_id <- input$route_select
    marta_bus_route_url_string <- paste0(marta_bus_route_url, route_id)
    print(marta_bus_route_url_string)
    transit_records <- fromJSON(marta_bus_route_url_string, flatten=TRUE)
    print(transit_records$LONGITUDE)
    leafletProxy("map") %>%
      addCircleMarkers(
        lng = as.numeric(transit_records$LONGITUDE),
        lat = as.numeric(transit_records$LATITUDE),
        radius = 0,
        opacity = 0,
        weight = 0,
        color = "#777777",
        fillColor = "#000000",
        fillOpacity = 0,
        popup = paste(transit_records$MSGTIME, "<br>", transit_records$DIRECTION),
        label = transit_records$ROUTE,
        labelOptions = labelOptions(textsize = "12px", noHide = TRUE, offset = c(0,0)))
  })
  
  observeEvent(input$geolocation, {
    print(input$accuracy)
    leafletProxy("map") %>%
      addCircleMarkers(
        lng = input$long,
        lat = input$lat
      )
  })
  
})