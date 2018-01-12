shapes <- read.csv("google_transit/shapes.txt", stringsAsFactors = FALSE)
routes <- read.csv("google_transit/routes.txt", stringsAsFactors = FALSE)
trips <- read.csv("google_transit/trips.txt", stringsAsFactors = FALSE)

routes <- merge(routes, trips)

write_route_coordinates_to_csv_file <- function(route_identifier) {
  route_points <- routes[routes$route_short_name == route_identifier, ]
  route_points <- shapes[shapes$shape_id %in% unique(route_points$shape_id)[length(unique(route_points$shape_id))], ] # from past experience, when their are multiple route_points$shape_id, the last one is what you want
  route_points <- route_points[order(route_points[, "shape_id"], route_points[, "shape_pt_sequence"]), ]
  route_points <- route_points[, c("shape_pt_lon", "shape_pt_lat")]
  colnames(route_points) <- c("longitude", "latitude")
  write.csv(route_points, paste0("routes/", route_identifier, ".csv"), row.names = FALSE)
}

route_identifiers <- unique(routes$route_short_name)
for(route_identifier in route_identifiers) {
  write_route_coordinates_to_csv_file(route_identifier)
}

