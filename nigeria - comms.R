setwd("~/Desktop")
library(sf)
library(ggplot2)

nigeria_internet_shp <- st_read("nigeria_internet/nigeria_internet.shp")

ggplot() +
  geom_sf(data = nigeria_internet_shp, aes(fill = nga_commun)) +
  scale_fill_continuous() 

library(rnaturalearth)
library(rnaturalearthdata)

africa_map <- ne_countries(scale = "medium", continent = "Africa", returnclass = "sf")

xlim <- c(1, 15)  # West to East
ylim <- c(3, 15)  # South to North

# Assuming 'nigeria_internet_shp' is your data and 'nga_commun' is the variable to display
ggplot() +
  geom_sf(data = africa_map, fill = "lightgray") +  # Add the Africa background
  geom_sf(data = nigeria_internet_shp, aes(fill = nga_commun)) +
  scale_fill_continuous() +
  theme_minimal() + 
  coord_sf(xlim = xlim, ylim = ylim) +  # Set the limits to the specified extent
  theme(panel.grid.major = element_blank(),  # Remove major grid lines
        panel.grid.minor = element_blank())  +  # Remove minor grid lines
  labs(
    fill = "Population with no access\nto communications (in %)",  # Add a legend title
    title = "Communications Access Risk Score\nin Nigeria"
    ) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5)
    )   # Set the legend direction to horizontal




