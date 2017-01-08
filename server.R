library(shiny)
library(leaflet)
library(jsonlite)

# marta_bus_url <- "http://developer.itsmarta.com/BRDRestService/BRDRestService.svc/GetAllBus"
marta_bus_route_url <- "http://developer.itsmarta.com/BRDRestService/RestBusRealTimeService/GetBusByRoute/" # internet archive copy: # marta_bus_route_url <- "https://web-beta.archive.org/web/20141116024315/http://developer.itsmarta.com/BRDRestService/BRDRestService.svc/GetAllBus"
# api key needed for rail flavor # http://www.itsmarta.com/app-developer-resources.aspx

browser_location_icon <- makeAwesomeIcon(icon = "ion-android-person", library = "ion", markerColor = "orange")
bus_location_icon <- makeAwesomeIcon(icon = "ion-android-bus", library = "ion")

server <- function(input, output, session) {
  
  map <- leaflet() %>%
    addTiles(options = tileOptions(zIndex = -1000)) %>%
    fitBounds(-84.540089, 33.643822, -84.172734, 33.871885)
  output$map <- renderLeaflet(map)
  
  observeEvent(input$update_bus_locations_button, {
    
    route_id <- input$route_select
    marta_bus_route_url_string <- paste0(marta_bus_route_url, route_id)
    transit_records <- jsonlite:::fromJSON(marta_bus_route_url_string, flatten = TRUE)
    # print(str(transit_records))
    leafletProxy("map") %>% clearGroup("bus_marker")
    leafletProxy("map") %>% clearPopups()
    leafletProxy("map") %>% clearShapes()
    leafletProxy("map") %>%
      addAwesomeMarkers(group = "bus_marker",
        lng = as.numeric(transit_records$LONGITUDE),
        lat = as.numeric(transit_records$LATITUDE),
        icon = bus_location_icon,
        popup = paste(transit_records$MSGTIME, "<br>", transit_records$DIRECTION),
        label = transit_records$ROUTE,
        options = markerOptions(zIndexOffset = 1000),
        labelOptions = labelOptions(textsize = "16px", noHide = TRUE, direction = "auto", zIndexOffset = 1000,
                                    style = list(
                                      'color'='#FFFFFF',
                                      'border-color'='#0099CC',
                                      'background-color'='#FF6600'
                                      )))
    
      route_points <- read.csv(paste0("routes/", route_id,".csv"))
      # we should only fit bounds the first time the route is loaded so we don't disturb user's selected bounds
      leafletProxy("map") %>%
        fitBounds(min(route_points$longitude), min(route_points$latitude),
                  max(route_points$longitude), max(route_points$latitude))
      #
      leafletProxy("map") %>%
        addPolylines(lng = route_points$longitude,
                     lat = route_points$latitude,
                     options = pathOptions(clickable = FALSE))

  })
  
  observeEvent(input$geolocation, {
    leafletProxy("map") %>%
      addAwesomeMarkers(layerId = "browser_location_icon",
        lng = input$long,
        lat = input$lat,
        icon = browser_location_icon,
        options = markerOptions(zIndexOffset = 1000)
      )
  })

}