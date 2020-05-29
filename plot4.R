library(dplyr)
library(lubridate)

##download the data from the source, and read the zipped file with read.csv

temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
data <- read.csv(unz(temp, "household_power_consumption.txt"), sep = ";")
unlink(temp)

## all the data cleaning is done here, the date is converted into a useful format,
## the data is filtered to only include the relevant days, a column is added which
## combines the date and time, and four variables are converted into numeric variables.

data$Date <- dmy(data$Date)
data <- filter(data, Date == "2007-02-01" | Date == "2007-02-02")
data$Global_active_power <- as.numeric(as.character(data$Global_active_power))
data$POSIX <- paste(data$Date, data$Time)
data$POSIX <- as.POSIXct(data$POSIX)
data$Sub_metering_1 <- as.numeric(as.character(data$Sub_metering_1))
data$Sub_metering_2 <- as.numeric(as.character(data$Sub_metering_2))
data$Voltage <- as.numeric(as.character(data$Voltage))
data$Global_reactive_power <- as.numeric(as.character(data$Global_reactive_power))


png(filename = "plot4.png")

par(mfrow = c(2,2))
with(data, plot(POSIX, Global_active_power,
	type = "l",
	xlab = "",
	ylab = "Global Active Power (kilowatts)"))

with(data, plot(POSIX, Voltage, type = "l"))

with(data, plot(POSIX, Sub_metering_1,
	type = "l", xlab = "",
	ylab = "Energy sub metering"))
	
	with(data, lines(POSIX, Sub_metering_2, type = "l", col = "red"))
	with(data, lines(POSIX, Sub_metering_3, type = "l", col = "blue"))
	legend("topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
		col = c("black", "red", "blue"),
		lwd = 1, cex = 0.6)

with(data, plot(POSIX, Global_reactive_power, type = "l", lwd = 0.3))

dev.off()