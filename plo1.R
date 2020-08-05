##Download zip file and save it in a folder on working directory:
if (!file.exists("./Project2")) {dir.create("./Project2")}
site <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(site, "./Project2/EPA.zip", method = "curl")

##Unzip file in the new directory:
unzip("./Project2/EPA.zip", exdir = "./Project2")

##Read both files and check their features:
NEI <- readRDS("./Project2/summarySCC_PM25.rds")
SCC <- readRDS("./Project2/Source_Classification_Code.rds")
str(NEI)
str(SCC)

##Aggregate emissions per year:
year_emissions <- aggregate(Emissions ~ year, NEI, FUN = sum)

##Plot emissions and save into a .png file:
png("plot1.png") ##Default size
with(year_emissions, barplot(height = Emissions/1000, names.arg = year, col = unclass(year),
                             xlab = "Year", ylab = "PM2.5 in Ktons", main = "Annual Emissions PM2.5 from 1999 to 2008"))
dev.off()
