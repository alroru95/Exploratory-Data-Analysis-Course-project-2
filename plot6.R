##Download zip file and save it in a folder on working directory:
if (!file.exists("./Project2")) {dir.create("./Project2")}
site2 <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(site, "./Project2/EPA.zip", method = "curl")

##Unzip file in the new directory:
unzip("./Project2/EPA.zip", exdir = "./Project2")

##Read both files and check their features:
NEI <- readRDS("./Project2/summarySCC_PM25.rds")
SCC <- readRDS("./Project2/Source_Classification_Code.rds")
str(NEI)
str(SCC)

##Subset and aggregate emissions from motor vehicle sources in Baltimore and Los Angeles:
library(dplyr)
NEI$year <- factor(NEI$year, levels = c("1999", "2002", "2005", "2008"))

Baltimore_vehicles <- subset(NEI, fips == "24510" & type == "ON-ROAD")
LA_vehicles <- subset(NEI, fips == "06037" & type == "ON-ROAD")

Baltimore_emissions <- aggregate(Baltimore_vehicles[,"Emissions"], by = list(Baltimore_vehicles$year), sum)
colnames(Baltimore_emissions) <- c("year", "Emissions")
Baltimore_emissions$City <- paste(rep("Baltimore City", 4))

LA_emissions <- aggregate(LA_vehicles[,"Emissions"], by = list(LA_vehicles$year), sum)
colnames(LA_emissions) <- c("year", "Emissions")
LA_emissions$City <- paste(rep("Los Angeles", 4))
LAB_emissions <- as.data.frame(rbind(Baltimore_emissions, LA_emissions))

##Plot emissions and save into a .png file:
library(ggplot2)
png("plot6.png", width = 600)
g <- ggplot(LAB_emissions, aes(factor(year), Emissions, fill = year))
g + geom_bar(stat = "identity") + facet_grid(.~City) + xlab("Year") + ylab("PM2.5 in tons") + 
  ggtitle("Motor Vehicle Emissions in Baltimore and Los Angeles from 1999 to 2008")
dev.off()
