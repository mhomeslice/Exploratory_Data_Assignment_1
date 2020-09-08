library(ggplot2)
library(tidyverse)
setwd("~/Documents/GitHub/Exploratory_Data_Assignment_1")

##Download files
FileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(FileUrl, destfile = "household_power_consumption.zip" , method="curl") 
unzip("household_power_consumption.zip", overwrite = T)
PowerData <- read.table("./household_power_consumption.txt", header=TRUE, sep=";", 
                        na.strings = "?", colClasses = c('character','character','numeric',
                                                         'numeric','numeric','numeric','numeric','numeric','numeric'))

##Read data into R for processing, give classes to all columns
PowerData <- read.table("household_power_consumption.txt", header=TRUE, sep=";", 
                        na.strings = "?", colClasses = c('character','character','numeric',
                                                         'numeric','numeric','numeric','numeric','numeric','numeric'))

##Subset only Feb 1st and 2nd in 2007
PowerData$Date <- as.Date(PowerData$Date, "%d/%m/%Y")
PowerData2 <- subset(PowerData, Date >= as.Date("2007-2-1") & Date <= as.Date("2007-2-2"))
PowerData2 <- PowerData2[complete.cases(PowerData2), ]

##Create and name new vector with date and times merged
dateTime <- paste(PowerData2$Date, PowerData2$Time)
dateTime <- setNames(dateTime, "DateTime")

##Remove Date and Time columns
PowerData3 <- PowerData2[ ,!(names(PowerData2) %in% c("Date","Time"))]

##Bind the columns together
FinalData <- cbind(dateTime, PowerData3)
names(FinalData)[1] <- "Date_with_Time"

## Convert data from Character vector to POSIXct and POSIXlt format
FinalData$Date_with_Time <- as.POSIXct(dateTime)

hist(FinalData$Global_active_power, main="Global Active Power", 
     xlab = "Global Active Power (kilowatts)",  col="red")

##Save File and 
dev.copy(png,"plot1.png", width=480, height=480)
dev.off()
