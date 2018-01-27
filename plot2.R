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
png(filename="plot2.png")

plot(
  df$DateTime, 
  df$Global_active_power, 
  type="l", 
  xlab="", 
  ylab="Global Active Power (kilowatts)",
  yaxp = c(0, 6, 3) 
)


# 
# Close and save graphics device (the .png file)
#
dev.off()