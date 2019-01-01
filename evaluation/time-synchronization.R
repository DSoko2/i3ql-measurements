# Calculates the offset as mean of all reference section enter timestamps
evalTimeOffsets <- function(eventData) {
  sectionEnterMean <-
    filter(eventData, grepl("^section\\..*\\.enter$", event)) %>%
    group_by(node, execution) %>%
    summarize(timeOffset = mean(time)) %>%
    ungroup
  
  return(sectionEnterMean)
}

# Provides evaluation data about the error of each section entry over all nodes
timeOffsetSectionPrecision <- function() {
  sectionPrecision <- prepareSectionDuration() %>%
    group_by(section, execution) %>%
    summarise(
      min = min(enterTime),
      QT1 = quantile(enterTime, probs = 0.25),
      median = median(enterTime),
      mean = mean(enterTime),
      QT3 = quantile(enterTime, probs = 0.75),
      max = max(enterTime),
      sd = sd(enterTime)
    )
  ungroup
  
  return(sectionPrecision)
}

# Provides evaluation data about the error of all section enters over all nodes
timeOffsetPrecision <- function() {
  precision <- prepareSectionDuration() %>%
    group_by(execution, section) %>%
    mutate(error = mean(enterTime) - enterTime) %>%
    ungroup %>%
    group_by(execution) %>%
    summarise(
      min = min(error),
      QT1 = quantile(error, probs = 0.25),
      median = median(error),
      mean = mean(error),
      QT3 = quantile(error, probs = 0.75),
      max = max(error),
      sd = sd(error)
    ) %>%
    ungroup
  
  return(precision)
}

# Applies the time offset to the time field of data
applyTimeOffsets <- function(data, timeOffsets) {
  adjustedData <- data %>%
    left_join(timeOffsets, by = c("node", "execution")) %>%
    mutate(time = time - timeOffset) %>%
    arrange(time)
  
  return(adjustedData)
}

# Evaluates the start and the end of a measurement, by taking the timestamps of the first and last latency event
evalTimeStartEnd <- function(alignedEventData) {
  startEnd <-
    filter(eventData, grepl("^latency\\..*$", event)) %>%
    group_by(execution) %>%
    summarize(startTime = min(time), endTime = max(time)) %>%
    ungroup
  
  return(startEnd)
}

# Drops all rows from data, which have a timestamp outside the start and end of the measurement
applyTimeStartEnd <- function(data, timeStartEnd) {
  adjustedData <-
    data %>%
    left_join(timeStartEnd, by = "execution") %>%
    filter(time >= startTime & time <= endTime)
  
  return(adjustedData)
}