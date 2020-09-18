library(gridExtra)
library(reshape2)
#Transform data to wide format
geo.regions <- c(
  "GreatLakes", "Midsouth", "Northeast", "NorthernNewEngland", "Plains", 
  "SouthCentral", "Southeast", "West", "WestTexNewMexico"
)

# reshape data
geo.avo <- dcast(avo[avo$region %in% c(geo.regions, "TotalUS"),], year + Date + type ~ region, value.var = "Total.Volume")



