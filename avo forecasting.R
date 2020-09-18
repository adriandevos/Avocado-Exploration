#forecast
library(fpp2)

conv_ts <- ts(conventional[,2], start=c(2015, 1), frequency=12)
org_ts <- ts(organic[,2], start=c(2015, 1), frequency=12)
arima_model_cv <- auto.arima(conv_ts, d=1, D=1, stepwise=FALSE, approximation=FALSE, trace=TRUE)
arima_model_or <- auto.arima(org_ts, d=1, D=1, stepwise=FALSE, approximation=FALSE, trace=TRUE)
forecast_cv <- forecast(arima_model_cv, h=24)
autoplot(forecast_cv, include=60) + theme_minimal() + theme(plot.title=element_text(hjust=0.5), plot.background=element_rect(fill="#F4F6F7"),
                                                            legend.position="bottom", legend.background = element_rect(fill="#FFF9F5",
                                                                                                                       size=0.5, linetype="solid", 
                                                                                                                       colour ="black")) + 
  labs(title="Forecasting using ARIMA model \n Conventional Avocados", x="Date", y="Price")
