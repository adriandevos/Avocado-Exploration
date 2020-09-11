# :avocado: Avocado Prices: Analyzing Seasonality and Pattern Trends :avocado:
Data dive into avocado sales trends
*From the Hass Avocado Board website*

The table below represents weekly 2018 retail scan data for National retail volume (units) and price. Retail scan data comes directly from retailers’ cash registers based on actual retail sales of Hass avocados. Starting in 2013, the table below reflects an expanded, multi-outlet retail data set. Multi-outlet reporting includes an aggregation of the following channels: grocery, mass, club, drug, dollar and military. The Average Price (of avocados) in the table reflects a per unit (per avocado) cost, even when multiple units (avocados) are sold in bags. The Product Lookup codes (PLU’s) in the table are only for Hass avocados. Other varieties of avocados (e.g. greenskins) are not included in this table.

## Data Exploration 
Upon first glance, we see that the region column has 3 distinct location types: Region, State, City/Area. 
It's impossible to understand exactly how state and city/area overlap with Region, so I will just analyze each location type seperately to avoid overlap.

The first column in the dataset is just a count of the observations so I will eliminate it.
```
avo<-avo[-1]
```

Additionally, 3 columns are named by avocado PLU, which is difficult to understand and read. So I will rename these columns to match the avocado type.  
```
avo$smallHass<-avo$X4046
avo$largeHass<-avo$X4225
avo$xlHass<-avo$X4770
avo<-avo[-(4:6)] #remove old column names
```
So we are left with a dataset with **18,249 observations and 13 columns!**

Lets format the date column correctly and put it into ascending order. This will make subsetting the data easier later.

```
avo$Date <- as.Date(avo$Date, "%Y-%m-%d")
avo<-avo[order(as.Date(avo$Date, format="%Y-%m-%d")),]
```
We see that this dataset includes two types of avocados. **I'm hoping to understand how conventional and organic avocados differ in price and volume of sales, and also how seasonality affects price and sales.**
```
levels(avo$type)
[1] "conventional" "organic"  
```

Upon first glance, we see conventional avocados accounting for 97.2% of sales, while organic avocados account for only 2.8%
```
avo %>% 
  group_by(type) %>% 
  summarise(Average_Volume=mean(Total.Volume)) %>%
  mutate(Percent=prop.table(Average_Volume)*100)
```

| Type         | Average Volume | Average Price |   
|--------------|----------------|---------------|
| Conventional | 1,653,213      | 97.2%         |  
| organic      | 47,811         | 2.81%         |  
                                           
