library(tibbletime)
library(ggplot2)
library(formattable)
avo<-read.csv("avocado.csv")
 
avo$smallHass<-avo$X4046
avo$largeHass<-avo$X4225
avo$xlHass<-avo$X4770
avo<-avo[-1]
avo<-avo[-(4:6)] #remove unused count variable
avo$Date <- as.Date(avo$Date, "%Y-%m-%d")
avo<-avo[order(as.Date(avo$Date, format="%Y-%m-%d")),]
my_colors <- c("#3E7DCC", "#8F9CB3", "#00C8C8", "#F9D84A", "#8CC0FF", "#4D525A")
levels(avo$type)

avo %>% 
  group_by(type) %>% 
  summarise(Average_Volume=mean(Total.Volume)) %>%
  mutate(Percent=prop.table(Average_Volume)*100)

organic<-avo[which(avo$type=="organic"),]
conventional<-avo[which(avo$type=="conventional"),]

organic <- as_tbl_time(organic, index=Date)
organic <- as_period(organic, '1 month')

conventional <-as_tbl_time(conventional, index=Date)
conventional <-as_period(conventional, '1 month')
#average weekly price = $1.8


#avo<-as_tbl_time(avo,index=Date)
#avo<-as_period(avo, "1 month")

seasonal_df<-avo
seasonal_df$month_year <- format(as.Date(avo$Date), "%Y-%m")
seasonal_df$month <- format(as.Date(avo$Date), "%m")
seasonal_df$year <- format(as.Date(avo$Date), "%Y")
seasonal_df$monthabb <- sapply(seasonal_df$month, function(x) month.abb[as.numeric(x)])
seasonal_df$monthabb = factor(seasonal_df$monthabb, levels = month.abb)

organic_seasonal<-seasonal_df[which(seasonal_df$type=="organic"),]
conventional_seasonal<-seasonal_df[which(seasonal_df$type=="conventional"),]

organic_seasonal$month <- format(as.Date(organic_seasonal$Date), "%m")
organic_seasonal$year <- format(as.Date(organic_seasonal$Date), "%Y")
organic_seasonal$monthabb <- format(as.Date(organic_seasonal$Date), "%Y-%m")

conventional_seasonal$month <- format(as.Date(conventional_seasonal$Date), "%m")
conventional_seasonal$year <- format(as.Date(conventional_seasonal$Date), "%Y")
conventional_seasonal$monthabb <- format(as.Date(conventional_seasonal$Date), "%Y-%m")


conv_seasonality <- seasonal_df %>%
  filter(type == "conventional", year == c("2015", "2016", "2017")) %>%
  group_by(year, monthabb) %>% summarize(avg=mean(AveragePrice))
  
organic_seasonality <- seasonal_df %>%
  filter(type == "organic", year == c("2015", "2016", "2017")) %>%
  group_by(year, monthabb) %>% summarize(avg=mean(AveragePrice))

conv2<-ggplot(conv_seasonality, aes(x=monthabb, y=avg,group=year)) +
  geom_line(color="#F9D84A")+
  facet_wrap(~as.factor(year))+
  scale_y_continuous(labels=scales::dollar_format())+
  labs(x="Month",y="Average Price", title="Conventional Avocados\nAverage Price over Time")+
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

org2<-ggplot(organic_seasonality, aes(x=monthabb, y=avg,group=year)) +
  geom_line(color="#8F9CB3")+
  facet_wrap(~as.factor(year)) +
  scale_y_continuous(labels=scales::dollar_format())+
  labs(x="Month",y="Average Price", title="Organic Avocados\nAverage Price over Time")+
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))   
grid.arrange(conv2, org2, nrow=2)







