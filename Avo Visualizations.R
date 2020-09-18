# AVOCADO STUDY VISUALIZATIONS
#1 GEOM_DENSITY DISTRIBUTION OF AVOCADO PRICES (2015-2018)
ggplot(avo[avo$region=="TotalUS",], aes(x=AveragePrice,fill=type))+
  geom_density()+
  facet_wrap(~type)+
  theme_minimal()+
  scale_x_continuous(labels=scales::dollar_format())+
  theme(legend.position="bottom") +
  labs(title="Distribution of Avocado Prices (2015-2018)", y="density")

#2 CONVENTIONAL VS ORGANIC AVERAGE PRICE TIME SERIES
ggplot(avo[avo$region=="TotalUS",], aes(x=Date, y=AveragePrice, col=type))+
  geom_line(size=.5)+
  facet_wrap(~type)+
  scale_y_continuous(labels=scales::dollar_format())+
  scale_x_date(date_labels = "%Y")+
  theme_minimal()

#3 CONVENTIONAL VS ORGANIC AVERAGE PRICES TIME SERIES (2017)
# average price dips significantly lower than other years, 
# particularly around the late winter/early spring
ggplot(avo[avo$region=="TotalUS",], aes(x=Date, y=AveragePrice, col=type))+ 
  geom_line(size=.5)+
  facet_wrap(~type)+
  scale_x_date(date_labels = "%b",
               limit=c(as.Date("2017-01-01"),as.Date("2017-12-31")))+
  scale_y_continuous(labels=scales::dollar_format())+
  theme_minimal()

#4 Conventional/Organic Time Series Scaled Monthly
options(repr.plot.width=8, repr.plot.height=6)
monthly_conventional<-ggplot(conventional, aes(x=Date, y=AveragePrice)) + 
  geom_hline(yintercept=max(conventional$AveragePrice), linetype='dashed',color='red')+
  geom_hline(yintercept=min(conventional$AveragePrice), linetype="dashed", color = "red")+
  geom_line(color="#814E11") + 
  scale_y_continuous(labels=scales::dollar_format())+
  labs(title="Conventional Avocados", subtitle="Scaled Monthly")+
  theme_minimal() 

monthly_organic<-ggplot(organic, aes(x=Date, y=AveragePrice))+
  geom_hline(yintercept=max(organic$AveragePrice), linetype='dashed', color='red')+
  geom_hline(yintercept=min(organic$AveragePrice), linetype='dashed', color='red')+
  geom_line(color="#83E265")+
  scale_y_continuous(labels=scales::dollar_format())+
  labs(title="Organic Avocados",subtitle="Scaled Monthly")+
  theme_minimal()

grid.arrange(monthly_conventional, monthly_organic, nrow=1, ncol=2)

#5 Conventional/Organic Total Volume Time Series
monthly_volume_conventional<-ggplot(conventional, aes(x=Date, y=Total.Volume)) + 
  geom_bar(stat='identity', fill="#83E265") + 
  geom_smooth(method="loess", color="red", se=FALSE)+
  labs(title="Conventional Avocados")+
  theme_minimal() 

monthly_volume_organic<-ggplot(organic, aes(x=Date, y=Total.Volume)) + 
  geom_bar(stat='identity', fill="#814E11") + 
  geom_smooth(method="loess", color="red", se=FALSE)+
  labs(title="Organic Avocados")+
  theme_minimal() 
grid.arrange(monthly_volume_conventional, monthly_volume_organic, nrow=1, ncol=2)

#7 Distirbution of Avocado Prices by Year
ggplot(seasonal_df, aes(x=AveragePrice,fill=as.factor(year)))+
  geom_density(alpha=.5,show.legend = FALSE)+
  theme_minimal()+
  facet_wrap(~year)+
  scale_x_continuous(labels=scales::dollar_format())+
  labs(title="Distribution of Avo Price by Year", x="Average Price", y="Density")

#6 US Regional Volume Purchased & Average Price (regression)
ggplot(data = avo[avo$region == c("West", "SouthCentral", "Northeast", "Southeast", 
                                  "Midsouth", "Plains", "GreatLakes"),], 
       aes(x = Date, y = Total.Volume, color = region, group = region)) +
  geom_smooth(method = "loess", se=FALSE) +
  geom_point(size = 1, alpha = 0.3 ) +
  scale_x_date(date_labels = "%Y")+
  scale_y_continuous(labels = comma)+
  ylab("Total Volume of Avocados Purchased") +
  theme_bw() +
  theme(axis.title.x = element_blank(), legend.position = "bottom")

ggplot(data = avo[avo$region == c("West", "SouthCentral", "Northeast", "Southeast", 
                                  "Midsouth", "Plains", "GreatLakes"),], 
       aes(x = Date, y = AveragePrice, color = region, group = region)) +
  geom_smooth(method = "loess", se=FALSE) +
  geom_point(size = 1, alpha = 0.3 ) +
  scale_y_continuous(labels=scales::dollar_format())+
  scale_x_date(date_labels = "%Y")+
  ylab("Average Price per Avocado\n(US Dollars)") +
  theme_bw() +
  theme(axis.title.x = element_blank(), legend.position = "bottom")

#Seasonality Patterns 
conv_patterns <- seasonal_df %>% filter(type == "conventional") %>%
  group_by(monthabb) %>% summarize(avg=mean(AveragePrice)) %>%
  ggplot(aes(x=monthabb, y=avg)) + geom_point(color="#F35D5D", aes(size=avg)) + geom_line(group=1, color="#7FB3D5") + 
  theme_minimal() + theme(legend.position="none") + 
  scale_y_continuous(labels=scales::dollar_format())+
  labs(title="Conventional Avocados", x="Month", y="Average Price")

org_patterns <- seasonal_df %>% 
  filter(type == "organic") %>%
  group_by(monthabb) %>% 
  summarize(avg=mean(AveragePrice)) %>%
  ggplot(aes(x=monthabb, y=avg)) + 
  geom_point(color="#F35D5D", aes(size=avg)) + geom_line(group=1, color="#58D68D") + 
  theme_minimal() + 
  scale_y_continuous(labels=scales::dollar_format())+
  theme(legend.position="none") + 
  labs(title="Organic Avocados", x="Month", y="Average Price")

grid.arrange(conv_patterns, org_patterns, nrow=2)

