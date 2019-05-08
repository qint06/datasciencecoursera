This is R markdown file for project 1.

Read in data used for project.

    data <- read.csv("activity.csv")
    data$date <- as.POSIXct(data$date)

Calculate the total number of steps taken per day Plot the total number
of steps taken per day

    daySteps <- tapply(data$steps, data$date, sum, na.rm = TRUE)

    barplot(daySteps, xlab = 'Date', ylab = 'Number of Steps', main =  'Number of Steps per Day')

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-2-1.png)

Show the summary of number of steps taken each day

    results <- summary(daySteps)

*Mean: 9354.2295082 *Median: 1.039510^{4}

Time series plot of 5-minute interval

    activityPattern <- aggregate(steps~interval, data, mean, na.rm=TRUE)
    plot(activityPattern, type="l", xlab = 'Steps', ylab = 'Interval', main = 'Time Series Plot')

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-4-1.png)

5-minute interval contains maximum number of steps

    MostInterval <- data$interval[which.max(activityPattern$step)]

\*maxInterval: 835

Number of NAs

    NumNa <- sum(is.na(data))

numberNAs: 2304

Filling missing data with daily average steps

    imputeData <- merge(data, activityPattern, by = 'interval')
    imputeData <- imputeData[order(imputeData$date,imputeData$interval),] 
    stepNA <- is.na(imputeData$steps.x)
    imputeData$steps.x[stepNA] <- imputeData$steps.y[stepNA]
    imputeData <- imputeData[,1:3]
    names(imputeData)[2] <- 'steps'

Plot to show number of steps taken each day

    filledDaySteps <- tapply(imputeData$steps, imputeData$date, sum)

    barplot(filledDaySteps, xlab = 'Date', ylab = 'Number of Steps', main =  'Number of Steps per Day')

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-8-1.png)

Show the summary of number of steps taken each day

    filledSum <- summary(filledDaySteps)

*Mean: 1.076618910^{4} *Median: 1.076618910^{4}

Generate daytype as factor, and plot steps by ‘weekday’ and ‘weekend’

    imputeData$daytype <- 'weekday'
    weekenddays <- weekdays(as.Date(imputeData$date)) %in% c('Saturday', 'Sunday')
    imputeData$daytype[weekenddays] <- 'weekend'
    imputeData$daytype <- as.factor(imputeData$daytype)

    daySteps3 <- aggregate(steps ~ interval + daytype, imputeData, mean)
    library(lattice)
    plot <- xyplot(daySteps3$steps ~ interval | daytype, daySteps3, type='l', layout = c(1,2))

    print(plot)

![](PA1_template_files/figure-markdown_strict/unnamed-chunk-10-1.png)
