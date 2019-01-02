source("data-preparation.R")

# Sets the duration of the measurement in relation to the duration of the referenceGroups measurement times
getRelativeRuntime <- function(referenceGroup) {
  runtime <- msrmtStartEnd %>%
    inflateExecutionInfo %>%
    mutate(runtime = endTime - startTime)
  
  reference <- runtime %>%
    filter(group == referenceGroup) %>%
    transmute(query,
              referenceExecution = execution,
              referenceRuntime = runtime)
  
  relativeRuntime <- runtime %>%
    left_join(reference, "query") %>%
    mutate(relativeRuntime = runtime / referenceRuntime)
  
  return(relativeRuntime)
}

# Sets the measured memory consumption after execution in relation to referenceGroup values
getRelativeMemory <- function(referenceGroup, selectNodes) {
  memory <- prepareMemoryData() %>%
    inflateExecutionInfo %>%
    filter(measure == "after", node %in% selectNodes)
  
  reference <- memory %>%
    filter(group == referenceGroup) %>%
    transmute(query,
              node,
              referenceExecution = execution,
              referenceUsage = usage)
  
  relativeMemory <- memory %>%
    left_join(reference, c("query", "node")) %>%
    mutate(relativeUsage = usage / referenceUsage)
  
  return(relativeMemory)
}

# Sets the measured memory consumption after execution on all nodes in relation to referenceGroup values
getRelativeMemoryTotal <- function(referenceGroup) {
  memory <- prepareMemoryData() %>%
    filter(measure == "after") %>%
    group_by(execution) %>%
    summarise(usageTotal = sum(usage)) %>%
    ungroup %>%
    inflateExecutionInfo
  
  reference <- memory %>%
    filter(group == referenceGroup) %>%
    transmute(query,
              referenceExecution = execution,
              referenceUsageTotal = usageTotal)
  
  relativeMemory <- memory %>%
    left_join(reference, c("query")) %>%
    mutate(relativeUsageTotal = usageTotal / referenceUsageTotal)
  
  return(relativeMemory)
}

# Sets the measured CPU Time after execution in relation to referenceGroup values
getRelativeCpuTime <- function(referenceGroup, selectNodes) {
  cpuTime <- prepareMsrmtPerformance() %>%
    group_by(execution, node) %>%
    summarise(cpuTime = max(cpuTime)) %>%
    ungroup %>%
    filter(node %in% selectNodes) %>%
    inflateExecutionInfo
  
  reference <- cpuTime %>%
    filter(group == referenceGroup) %>%
    transmute(query,
              node,
              referenceExecution = execution,
              referenceCpuTime = cpuTime)
  
  relativeCpuTime <- cpuTime %>%
    left_join(reference, c("query", "node")) %>%
    mutate(relativeCpuTime = cpuTime / referenceCpuTime)
  
  return(relativeCpuTime)
}

# Sets the measured total CPU Time on all nodes after execution in relation to referenceGroup values
getRelativeCpuTimeTotal <- function(referenceGroup) {
  cpuTimeTotal <- prepareMsrmtPerformance() %>%
    group_by(execution, node) %>%
    summarise(cpuTime = max(cpuTime)) %>%
    ungroup %>%
    group_by(execution) %>%
    summarise(cpuTimeTotal = sum(cpuTime)) %>%
    ungroup %>%
    inflateExecutionInfo
  
  reference <- cpuTimeTotal %>%
    filter(group == referenceGroup) %>%
    transmute(query,
              referenceExecution = execution,
              referenceCpuTimeTotal = cpuTimeTotal)
  
  relativeCpuTimeTotal <- cpuTimeTotal %>%
    left_join(reference, "query") %>%
    mutate(relativeCpuTimeTotal = cpuTimeTotal / referenceCpuTimeTotal)
  
  return(relativeCpuTimeTotal)
}

# Sets the measured memory consumption after execution in relation to referenceGroup values
getRelativeLatency <- function(referenceGroup) {
  latency <- prepareLatencyData() %>%
    group_by(execution) %>%
    summarise(avgLatency = mean(duration)) %>%
    ungroup %>%
    inflateExecutionInfo
  
  reference <- latency %>%
    filter(group == referenceGroup) %>%
    transmute(query,
              referenceExecution = execution,
              referenceAvgLatency = avgLatency)
  
  relativeLatency <- latency %>%
    left_join(reference, c("query")) %>%
    mutate(relativeAvgLatency = avgLatency / referenceAvgLatency)
  
  return(relativeLatency)
}