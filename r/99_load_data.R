rm(list = ls());

library(geojsonsf);
library(sf);
library(tidyverse);

if (!file.exists("data/doc.kml")) {
  cologne_playground_kmz <- "https://geoportal.stadt-koeln.de/ArcGIS/rest/services/Spielangebote/MapServer/0/query?text=&geometry=&geometryType=esriGeometryPoint&inSR=&spatialRel=esriSpatialRelIntersects&relationParam=&objectIds=&where=objectid+is+not+null&time=&returnCountOnly=false&returnIdsOnly=false&returnGeometry=true&maxAllowableOffset=&outSR=4326&outFields=*&f=kmz";
  download.file(url = cologne_playground_kmz, destfile = "data/cologne_playground.kmz", method = "curl");
  unzip("data/cologne_playground.kmz", exdir = "data");
}

cologne_sf <- sf::st_read(dsn = "data/doc.kml", stringsAsFactors = F);
# all the meta-data is stored as html document unfortunately

cologne_df <- as_tibble(cologne_sf);
