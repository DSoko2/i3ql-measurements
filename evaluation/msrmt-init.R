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