#
# Prerequisite: the file household_power_consumption.txt in yout working directory.
#
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
png(filename="plot1.png")

hist(df$Global_active_power, 
     col="red", 
     xlim=c(0,6), 
     ylim=c(0,1200), 
     main="Global Active Power", 
     xlab="Global Active Power (kilowatts)", 
     breaks=12,  # We want to ensure we have exactly 12 bins as in assignment
     axes=F      # We want to remove the axes in order to adjust the tics  on x-axis
     )
# Construct the x-axis with tic steps of 2
axis(1, at=c(0,2,4,6)) 

# Construct the y-axis with tic steps of 200 starting at 0
axis(2, at=c(0, seq(200, 1200, 200)))

# 
# Close and save graphics device (the .png file)
#
dev.off()