library(readxl)

# URL du fichier Excel hébergé sur Google Drive
excel_url <- "https://drive.google.com/uc?export=download&id=1GTR1mjUYI1Sj9-KjTMdZNccgsVncS0WQ"

# Téléchargement et lecture du fichier Excel
temp_file <- tempfile(fileext = ".csv")
download.file(excel_url, temp_file, mode = "wb")
abattoirs_tonnages <- read.csv(temp_file, sep = ";")


# Supprimer le fichier temporaire après utilisation
unlink(temp_file)


# Ajouter une colonne "weight_ovin" basée sur le tonnage ovin
abattoirs_tonnages$weight_ovin <- sqrt(abattoirs_tonnages$ovin) / max(sqrt(abattoirs_tonnages$ovin))

# Ajouter une colonne "weight_bovin" basée sur le tonnage bovin
abattoirs_tonnages$weight_bovin <- sqrt(abattoirs_tonnages$bovin) / max(sqrt(abattoirs_tonnages$bovin))

# Ajouter une colonne "weight_porc" basée sur le tonnage porc
abattoirs_tonnages$weight_porc <- sqrt(abattoirs_tonnages$porc) / max(sqrt(abattoirs_tonnages$porc))

tonnage_map <- leaflet() %>%
  addProviderTiles("OpenStreetMap.Mapnik") %>%
  addCircleMarkers(data = abattoirs_tonnages, lat = ~Y, lng = ~X,
                   radius = ~weight_ovin * 10,
                   color = "green", fillOpacity = 0.7) %>%
  addCircleMarkers(data = abattoirs_tonnages, lat = ~Y, lng = ~X,
                   radius = ~weight_bovin * 10,
                   color = "blue", fillOpacity = 0.7) %>%
  addCircleMarkers(data = abattoirs_tonnages, lat = ~Y, lng = ~X,
                   radius = ~weight_porc * 10,
                   color = "orange", fillOpacity = 0.7) %>%
  setView(lng = 2.5, lat = 46.8, zoom = 6)  # Ajuster la vue

tonnage_map
