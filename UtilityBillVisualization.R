library(ggplot2)
library(ggthemes)
library(readr)
library(dplyr)
library(lubridate)


#Load all temperature information for into dataframe
TemperaturesFull<-read_csv("Temperatures.csv", col_names=TRUE , col_types="Dd")

#Only include temperatures for 2021
Temperatures<-TemperaturesFull %>% dplyr::filter(Date >="2021-01-01" & Date <= "2021-12-31")

#Load all bill information for into dataframe
ElectricBill<-read_csv("ElectricBill.csv", col_types="Dnnn")


ElectricBill$Date<-ElectricBill$Date %m-% months(1)
ElectricBill$Date<-ElectricBill$Date - dweeks(2)

#Merging was performed in order to display both of the dataframes in a single plot
allData <- merge(Temperatures, ElectricBill, by = 'Date', all.x=TRUE)

ggplot(allData, aes(x=Date)) +
  geom_col(aes(y=kWhUsed/BillingPeriod),width=20,show.legend=FALSE, fill="#73AB4D") +
  geom_line(aes(y=TempAvg/5),size=.8,show.legend=FALSE, colour="#DD942F") +
  theme(plot.title = element_text(hjust = .5), axis.ticks = element_blank()) +
  scale_y_continuous(name="Average kWh Used Per Day", sec.axis=sec_axis(~.*5,name="Temperature")) +
  scale_x_date(date_breaks = "1 month", name="Date", date_labels="%B") +
  labs(title="Daily Electric Usage Compared to Daily Temperatures in 2021") +
  theme(plot.title = element_text(colour="#191919", size=16,face="bold", hjust=0.5)) +
  theme(axis.title.x = element_text(colour="#191919", size=12,face="bold", hjust=0.5)) +
  theme(axis.title.y = element_text(colour="#191919", size=12,face="bold", hjust=0.5)) +
  theme(panel.background = element_rect(fill="#F0F0F0")) +
  theme(axis.text.x = element_text(angle = 30, vjust = 1, hjust=0))+
  theme(plot.background = element_rect(fill="#F0F0F0"))
