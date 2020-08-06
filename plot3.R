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

##Subset and aggregate emissions per year and type in Baltimore:
library(dplyr)
Baltimore <- subset(NEI, fips == 24510)
Baltimore_ty <- group_by(Baltimore, year, type) ##Rearrange data set by year and type
Baltimore_emissions <- summarise(Baltimore_ty, Emissions=sum(Emissions)) ##Sum emmissions by year and type

##Plot emissions and save into a .png file:
library(ggplot2)
png("plot3.png", width = 600)
g <- ggplot(Baltimore_emissions, aes(factor(year), Emissions, fill = type))
g + geom_bar(stat = "identity") + facet_grid(.~type) + xlab("Year") + 
  ylab("PM2.5 in Ktons") + ggtitle("Baltimore Emissions by Source type and Year")
dev.off()
