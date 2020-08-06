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

##Subset and aggregate emissions per year from coal sources:
library(dplyr)
Coal <- grepl("Fuel Comb.*Coal", SCC$EI.Sector)
Coal_combustion <- SCC[Coal,]
NEI_Coal <- NEI[(NEI$SCC %in% Coal_combustion$SCC),]
Coal_emissions <- summarise(group_by(NEI_Coal, year), Emissions=sum(Emissions))

##Plot emissions and save into a .png file:
library(ggplot2)
png("plot4.png", width = 700)
g <- ggplot(Coal_emissions, aes(factor(year), Emissions/1000, fill = year))
g + geom_bar(stat = "identity") + xlab("Year") + ylab("PM2.5 in Ktons") + 
  ggtitle("Emissions from coal combustion-related sources in Kilotons from 1999 to 2008")
dev.off()

