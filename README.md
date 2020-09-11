# :avocado: Avocado Prices: Analyzing Seasonality and Pattern Trends :avocado:
Data dive into avocado sales trends
*From the Hass Avocado Board website*

The table below represents weekly 2018 retail scan data for National retail volume (units) and price. Retail scan data comes directly from retailers’ cash registers based on actual retail sales of Hass avocados. Starting in 2013, the table below reflects an expanded, multi-outlet retail data set. Multi-outlet reporting includes an aggregation of the following channels: grocery, mass, club, drug, dollar and military. The Average Price (of avocados) in the table reflects a per unit (per avocado) cost, even when multiple units (avocados) are sold in bags. The Product Lookup codes (PLU’s) in the table are only for Hass avocados. Other varieties of avocados (e.g. greenskins) are not included in this table.

## Data Exploration 
### Data Clean-Up 
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
### Exploration
We see that this dataset includes two types of avocados. 
**I'm hoping to understand how conventional and organic avocados differ in price and volume of sales, and also how seasonality & supply affects price and sales. **
```
levels(avo$type)
[1] "conventional" "organic"  
```

Upon first glance, we see conventional avocados accounting for 97.2% of sales, while organic avocados account for only 2.8%

| Type         | Average Volume | Percent       |     
|--------------|----------------|---------------|
| Conventional | 1,653,213      | 97.2%         |  
| organic      | 47,811         | 2.81%         |  
                                           
![](images/distribution.jpeg)


| Type         | Average Price  | 
|--------------|----------------|
| Conventional | $1.16          | 
| organic      | $1.65          | 

We can conclude that organic avocados are way more expensive than conventional avocados. Average price of organic avocados is **35% higher**.




![](images/time_series1.jpeg) ![](images/barplot_.jpeg)

We see average price has fluctuated dramatically over the last 3 years. For conventional avocadods average price fluctuated the most in 2017, with average prices dipping below .$50 early in the year, but peaking above $1.70 towards the end of the year. 

Conventional Avocado sales continuously rose from 2015-2016, but took a significant dip in mid-2017.
I will definitely investigate these trends later on.

