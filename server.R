library(shiny)
library(leaflet)
library(jsonlite)

marta_bus_url <- "http://developer.itsmarta.com/BRDRestService/BRDRestService.svc/GetAllBus"
marta_bus_route_url <- "http://developer.itsmarta.com/BRDRestService/RestBusRealTimeService/GetBusByRoute/" # internet archive copy: # marta_bus_route_url <- "https://web-beta.archive.org/web/20141116024315/http://developer.itsmarta.com/BRDRestService/BRDRestService.svc/GetAllBus"
# api key needed for rail flavor # http://www.itsmarta.com/app-developer-resources.aspx

server <- function(input, output, session) {
  
  map <- leaflet() %>%
    addTiles(options = tileOptions(zIndex = -1000)) %>%
    fitBounds(-84.540089, 33.643822, -84.172734, 33.871885)
  output$map <- renderLeaflet(map)
  
  observeEvent(input$update_bus_locations_button, {
    
    route_id <- input$route_select
    marta_bus_route_url_string <- paste0(marta_bus_route_url, route_id)
    transit_records <- jsonlite:::fromJSON(marta_bus_route_url_string, flatten=TRUE)
    print(transit_records)
    leafletProxy("map") %>% removeMarker("bus_marker")
    leafletProxy("map") %>% clearPopups()
    
    leafletProxy("map") %>%
      addMarkers(layerId = "bus_marker",
        lng = as.numeric(transit_records$LONGITUDE),
        lat = as.numeric(transit_records$LATITUDE),
        popup = paste(transit_records$MSGTIME, "<br>", transit_records$DIRECTION),
        label = transit_records$ROUTE,
        options = markerOptions(zIndexOffset = 1000),
        labelOptions = labelOptions(textsize = "16px", noHide = TRUE, direction = "auto", zIndexOffset = 1000,
                                    style = list(
                                      'color'='#FFFFFF',
                                      'border-color'='#0099CC',
                                      'background-color'='#FF6600'
                                      )))
  })
  
  observeEvent(input$geolocation, {
    print(input$accuracy)
    leafletProxy("map") %>%
      addMarkers(layerId = "shared_location",
        lng = input$long,
        lat = input$lat,
        icon = list(iconUrl = "https://github.com/Scarygami/poke-icon/raw/master/images/39.png", iconSize = c(35, 35)),
        options = markerOptions(zIndexOffset = 1000)
      )
  })
  
}