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

##Subset and aggregate emissions from motor vehicle sources in Baltimore:
library(dplyr)
Baltimore_vehicles <- subset(NEI, fips == 24510 & type == "ON-ROAD")
Baltimore_ve <- summarise(group_by(Baltimore_vehicles, year), Emissions=sum(Emissions))

##Plot emissions and save into a .png file:
png("plot5.png", width = 550)
g <- ggplot(Baltimore_ve, aes(factor(year), Emissions, fill = year))
g + geom_bar(stat = "identity") + xlab("Year") + ylab("PM2.5 in tons") + 
  ggtitle("Emissions from motor vehicle sources in Baltimore City from 1999 to 2008")
dev.off()
