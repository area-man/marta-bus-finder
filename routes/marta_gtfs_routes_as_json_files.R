shapes <- read.csv("google_transit/shapes.txt", stringsAsFactors = FALSE)
routes <- read.csv("google_transit/routes.txt", stringsAsFactors = FALSE)
trips <- read.csv("google_transit/trips.txt", stringsAsFactors = FALSE)

write_route_coordinates_json_file <- function(route_identifier) {
  geojson <- merge(routes, trips)
  geojson <- geojson[geojson$route_short_name == route_identifier, ]
  geojson <- shapes[shapes$shape_id %in% unique(geojson$shape_id)[1], ] # select only one geometry/"shape_id" per route
  geojson <- geojson[order(geojson[, "shape_id"], geojson[, "shape_pt_sequence"]), ]
  geojson$id <- seq(1:nrow(geojson))
  geojson <- geojson[, c("id", "shape_pt_lon", "shape_pt_lat")]
  colnames(geojson) <- c("id", "x", "y")
  geojson <- toJSON(geojson)
  write(geojson, paste0("routes/", route_identifier, ".json"))
}

route_identifiers <- unique(routes$route_short_name)
for(route_identifier in route_identifiers) {
  write_route_coordinates_json_file(route_identifier)
}