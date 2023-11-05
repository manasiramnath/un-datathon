schools_df <- st_read("Nigeria_-_Schools/Nigeria_-_Schools.shp")

schools_sf <- st_as_sf(schools_df, wkt = "geometry")


library(dplyr)

schools_by_lga <- schools_sf %>%
  group_by(lganame) %>%
  summarise(num_schools = n()) %>%
  ungroup()

# Merge the LGA geometries with the number of schools
#lga_data <- st_join(schools_by_lga, schools_sf, by = "lganame")

lga_schools <- st_as_sf(schools_by_lga, wkt = "geometry")

ggplot() +
  geom_sf(data = lga_schools,  aes(fill = num_schools)) +
  labs(title = "Schools in Nigeria") +
  theme_minimal()

ggplot() +
  geom_sf(data = lga_schools, aes(fill = num_schools)) +
  labs(title = "Schools in Nigeria") +
  scale_fill_gradient(low = "lightblue", high = "darkblue") +  # Adjust the fill color scale
  theme_minimal()

nigeria_internet_df <- as.data.frame(nigeria_internet_shp)

# Perform a left join based on the 'lganame' column
combined_data <- left_join(nigeria_internet_df, schools_by_lga, by = "lganame")

# Convert the resulting data frame back to a spatial dataset if needed
combined_data <- st_as_sf(combined_data)

combined_data2 = combined_data
combined_data2$num_schools <- ifelse(combined_data2$num_schools > 500, 500, combined_data2$num_schools)

ggplot() +
  geom_sf(data = combined_data2, aes(fill = num_schools)) +
  scale_fill_gradient(low = "lightblue", high = "darkblue") 

library(rnaturalearth)
library(rnaturalearthdata)

africa_map <- ne_countries(scale = "medium", continent = "Africa", returnclass = "sf")

xlim <- c(1, 15)  # West to East
ylim <- c(3, 15)  # South to North

library(viridis)
plot2 <- ggplot() +
  geom_sf(data = africa_map, fill = "lightgray") +
  geom_sf(data = combined_data2, aes(fill = num_schools)) +
  scale_fill_gradientn(
    colors = rev(magma(6)),
    breaks = c(0, 100, 200, 300, 400, 500),
    labels = c("100", "200", "300", "400", "500", ">500")
  ) +
  theme_minimal() +
  coord_sf(xlim = xlim, ylim = ylim) +  # Set the limits to the specified extent
  theme(panel.grid.major = element_blank(),  # Remove major grid lines
        panel.grid.minor = element_blank())  +  # Remove minor grid lines
  labs(
    fill = "Number of schools by LGA",  # Add a legend title
    title = "Location of schools\nin Nigeria"
  ) +
  theme(
    legend.position = "bottom",
    plot.title = element_text(hjust = 0.5)
  ) 
  
ggsave("nigeria_schools_map.png", plot =plot2, device = "png", width = 8, height = 6, dpi = 300)

library(htmlwidgets)
library(leaflet)
library(plotly)

plot1_widget <- ggplotly(plot1, tooltip = "all")
plot2_widget <- ggplotly(plot2, tooltip = "all")

library(crosstalk)

# Use bscols to display two plots side by side with a swipe bar
swipe_map <- bscols(
  plot1_widget,
  plot2_widget,
  width = c(6, 6),
  swipe = TRUE
)

library(htmltools)
browsable(swipe_map)

