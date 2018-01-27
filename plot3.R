#
# Prerequisite: the file household_power_consumption.txt in yout working directory.
#
# Ensure the data is available
if ( length(list.files(pattern="^household_power_consumption.txt$")) == 0 )  {
  ftemp <- tempfile(fileext=".zip")
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", destfile=ftemp)
  unzip(zipfile=ftemp, exdir=getwd())
  file.remove(ftemp) # Clean-up
}

#
# We want to exclude observations outside the interval of interest
# by filtering using the sqldf package. It requires an SQL server
# installed, though.
# Another way of doing it is to first read the whole file and then
# drop the rows outside the interval of interest.
#
library(sqldf)

sqlFilter <- "select * from file where Date = '1/2/2007' or Date = '2/2/2007'"
df <- read.csv.sql("household_power_consumption.txt", sqlFilter, sep=";")


# Date in format dd/mm/yyyy
# time in format hh:mm:ss

#
# Paste Date and Time together and parse as date and time using strptime
# and store the result as a new column in the data frame.
#
df$DateTime <- strptime(paste(df$Date, df$Time, sep=" "),"%d/%m/%Y %H:%M:%S")

#
# Remove the original Date and Time columns
#
df <- subset(df, select=-c(Date,Time))

# Open the graphics device with default 480x480 pixels
png(filename="plot3.png")

#fMax <- ceiling(max(df$Sub_metering_1, df$Sub_metering_2, df$Sub_metering_3) / 10) * 10

# We start construction of the plot using the sub metering with highest value
plot(
 df$DateTime, 
 df$Sub_metering_1,
 type="l", 
 main="", 
 xlab="", 
 ylab="Energy sub metering"
)

#
# Add the other sub-meterings
#
lines(df$DateTime, df$Sub_metering_2, col="red")
lines(df$DateTime, df$Sub_metering_3, col="blue")

#
# Add the legends
#
legend("topright", 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lty=c(1,1), 
       lwd=c(1,1), 
       col=c("black", "red", "blue")
  )


# 
# Close and save graphics device (the .png file)
#
dev.off()