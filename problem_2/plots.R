# Reading given file and taking only those with dates between 1/2/2007 - 2/2/2007
power_consumption <- read.table("./household_power_consumption.txt", 
                   sep = ";", header = TRUE)
power_consumption <- power_consumption[grep("\\b[12]/2/2007", power_consumption[, "Date"]), ]

# Plot 1 -------- 
# Histogram for Global_active_power
png(filename = "plot1.png")
hist(as.numeric(power_consumption$Global_active_power), 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", 
     ylab = "Frequency",
     col = "red")
dev.off()

# Plot 2 --------
# Combine Date and Time
dateTime <- paste(power_consumption$Date, power_consumption$Time) 
# Create new column in power_consumption to have the new dateTimes
power_consumption$Date_Time <- as.POSIXct(strptime(dateTime, format = "%d/%m/%Y %H:%M:%S"))

png(filename = "plot2.png")
# Create line plot
plot(as.numeric(power_consumption$Global_active_power) ~ power_consumption$Date_Time,
     type = "l",
     xlab = "",
     ylab = "Global Active Power (kilowatts)")
dev.off()

# Plot 3 --------
png(filename = "plot3.png")
# Use with() to address multiple lines
with(power_consumption, {
  # Create line plot
  plot(Sub_metering_1 ~ Date_Time,
       type = "l",
       xlab = "",
       ylab = "Energy sub metering",
       col = "black")
  lines(Sub_metering_2 ~ Date_Time, col = "red")
  lines(Sub_metering_3 ~ Date_Time, col = "blue")
})

# Add legend in top right of plot
legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       lty = 1,
       lwd = 1,
       col = c("black", "red", "blue"))
dev.off()

# Plot 4 --------
png(filename = "plot4.png")
# mfrow creates 2x2 grid, mar controls margins of the plots, oma controls outer margins
par(mfrow = c(2,2), mar = c(5,5,2,0), oma = c(0,0,2,2))

with(power_consumption, {
  # Plots are from left to right, top to bottom
  plot(Global_active_power ~ Date_Time, 
       type = "l",
       xlab = "",
       ylab = "Global Active Power")
  plot(Voltage ~ Date_Time, 
       type = "l",
       xlab = "datetime",
       ylab = "Voltage")
  plot(Sub_metering_1 ~ Date_Time,
       type = "l",
       xlab = "",
       ylab = "Energy sub metering")
  lines(Sub_metering_2 ~ Date_Time,
        col = "red")
  lines(Sub_metering_3 ~ Date_Time,
        col = "blue")
  legend("topright",
         legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
         lty = 1,
         lwd = 1,
         bty = "n",
         col = c("black", "red", "blue"))
  plot(Global_reactive_power ~ Date_Time,
       type = "l",
       xlab = "datetime",
       ylab = "Global_rective_power")
})
dev.off()
