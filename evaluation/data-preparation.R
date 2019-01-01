source("time-synchronization.R")

### Read in all data
configData <<- loadData(executions, "config")
eventData <<- loadData(executions, "event")
performanceData <<- loadData(executions, "performance")
throughputData <<- loadData(executions, "throughput")

### Time Offsets
timeOffsets <<- evalTimeOffsets(eventData)
eventData <<- applyTimeOffsets(eventData, timeOffsets)
performanceData <<- applyTimeOffsets(performanceData, timeOffsets)
throughputData <<- applyTimeOffsets(throughputData, timeOffsets)

### Get measurement timespan
msrmtStartEnd <<- evalTimeStartEnd(eventData)

### Init event span data
eventSpanData <<-
  # Get enter events
  eventData %>%
  filter(grepl("\\.enter$", event)) %>%
  mutate(event = sub("\\.enter$", "", event)) %>%
  rename(enterTime = time) %>%
  # Merge with related exit events
  inner_join((
    eventData %>%
      filter(grepl("\\.exit$", event)) %>%
      mutate(event = sub("\\.exit$", "", event)) %>%
      rename(exitTime = time)
  ),
  c("execution", "event")) %>%
  # Add duration
  mutate(duration = exitTime - enterTime)

# Provides information about the start, end and duration of the execution sections
prepareSectionDuration <- function() {
  sectionDuration = eventSpanData %>%
    filter(node.x == node.y) %>%
    filter(grepl("^section\\.", event)) %>%
    # Add section and benchmark field
    transmute(
      execution,
      node = node.x,
      section = sub("^.*\\.", "", event),
      enterTime,
      exitTime,
      duration,
      benchmark = getBenchmarkName(execution)
    )
}

# Provides throughput data per relation
prepareMsrmtThroughput <- function() {
  data <-
    throughputData %>%
    # Add relation field to throughputData
    mutate(relation = paste(node, relationName, sep = "#")) %>%
    # Apply time borders, add 100 to the end, since only logging 100 ms rate
    applyTimeStartEnd(msrmtStartEnd %>% mutate(endTime = endTime + 100))
  
  return(data)
}

# Provides throughput rate data per relation
prepareMsrmtThroughputRates <- function() {
  data <-
    prepareMsrmtThroughput() %>%
    # Derive by time
    group_by(execution, relation) %>%
    mutate(
      timeSpan = time - lag(time),
      intervalEventCount = eventCount - lag(eventCount),
      intervalEntryCount = entryCount - lag(entryCount)
    ) %>%
    filter(!is.na(timeSpan))
  
  return(data)
}

# Provides performance data of the measurement
prepareMsrmtPerformance <- function() {
  data <-
    performanceData %>%
    # Apply time borders, add 100 to the end, since only logging 100 ms rate
    applyTimeStartEnd(msrmtStartEnd %>% mutate(endTime = endTime + 100)) %>%
    # Set cpu time to 0 on measurement start
    group_by(node, execution) %>%
    mutate(cpuTime = cpuTime - min(cpuTime),
           time = time - startTime) %>%
    ungroup
  
  return(data)
}

# Provides the logged memory metrics of the measurement
prepareMemoryData <- function() {
  memoryData <- eventData %>%
    filter(grepl("^memory\\.", event)) %>%
    transmute(
      node,
      execution,
      measure = sub("^memory\\.", "", sub("\\.[^.]*$", "", event)),
      usage = as.numeric(sub("^memory\\..*\\.", "", event)),
      "usage [MB]" = usage / 1024 ^ 2
    )
  
  return(memoryData)
}

# Provides e2e latency information 
prepareLatencyData <- function() {
  latencyData <- eventSpanData %>%
    filter(grepl("^latency\\.", event)) %>%
    # In case of multi source events, only the latest source event is interesting, since it blocked all previous ones
    group_by(execution, event) %>%
    filter(enterTime == max(enterTime)) %>%
    ungroup %>%
    # Remove latency prefix
    mutate(trace = sub("^.*\\.", "", event))
  
  return(latencyData)
}