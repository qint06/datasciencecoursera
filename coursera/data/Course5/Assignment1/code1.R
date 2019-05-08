data <- read.csv("activity.csv")
data$date <- as.POSIXct(data$date)

daySteps <- tapply(data$steps, data$date, sum, na.rm = TRUE)

barplot(daySteps)


summary(daySteps)


activityPattern <- aggregate(steps~interval, data, mean, na.rm=TRUE)
plot1 <- plot(activityPattern, type="l")

data$interval[which.max(activityPattern$step)]

sum(is.na(data))

imputeData <- merge(data, activityPattern, by = 'interval')
imputeData <- imputeData[order(imputeData$date,imputeData$interval),] 
stepNA <- is.na(imputeData$steps.x)
imputeData$steps.x[stepNA] <- imputeData$steps.y[stepNA]
imputeData <- imputeData[,1:3]
names(imputeData)[2] <- 'steps'

daySteps2 <- tapply(imputeData$steps, imputeData$date, sum)
summary(daySteps2)


imputeData$daytype <- 'weekday'
weekenddays <- weekdays(as.Date(imputeData$date)) %in% c('Saturday', 'Sunday')
imputeData$daytype[weekenddays] <- 'weekend'
as.factor(imputeData$daytype)



daySteps3 <- aggregate(steps ~ interval + daytype, imputeData, mean)
library(lattice)
plot3 <- xyplot(daySteps3$steps ~ interval | daytype, daySteps3, type='l', layout = c(1,2))

print(plot3)







