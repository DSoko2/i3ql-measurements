## Initialization
# Make sure mongolite prerequests are installed https://jeroen.github.io/mongolite/index.html#requirements-linux-mac

if (!"mongolite" %in% installed.packages())
  install.packages("mongolite", dependencies = TRUE)
if (!"timelineS" %in% installed.packages())
  install.packages("timelineS", dependencies = TRUE)
if (!"tidyverse" %in% installed.packages())
  install.packages("tidyverse", dependencies = TRUE)
library(mongolite)
library(timelineS)
library(tidyverse)

dbUrl <- "mongodb://127.0.0.1:27017/i3ql-benchmarks"
db <- mongo(url = dbUrl)

### Get available test executions
loadExecutions <- function() {
  collectionNames <-
    db$run('{"listCollections":1}')$cursor$firstBatch$name
  explodedCollectionNames <- strsplit(collectionNames, "\\.")
  
  executions = c()
  for (exColName in explodedCollectionNames) {
    executions <-
      c(executions,
        paste(exColName[1], exColName[2], exColName[3], sep = "."))
  }
  executions <- unique(executions)
  
  return(executions)
}

getBenchmarkName <- function(executionName) {
  return(sub("\\.[^.]*\\.[^.]*$", "", executionName))
}

getQueryName <- function(executionName) {
  return(sub("^[^.]*\\.", "", sub("\\.[^.]*$", "", executionName)))
}

getExecutionGroup <- function(executionName) {
  return(sub("^[^.]*\\.[^.]*\\.", "", executionName))
}

inflateExecutionInfo <- function(data) {
  info <- data %>%
    mutate(
      group = getExecutionGroup(execution),
      benchmark = getBenchmarkName(execution),
      query = getQueryName(execution)
    )
  
  return(info)
}

# Adds the column groupLabels with the related value defined by the parameter according to it's group
applyGroupLabels <- function(data, groupLabels) {
  return(data %>% left_join(groupLabels, "group"))
}

### Load all data from a collection
loadData <- function(executions, dataType) {
  data <- NULL
  for (execution in executions) {
    collectionName <- paste(execution, dataType, sep = ".")
    collection <- mongo(collection = collectionName, url = dbUrl)
    data <- bind_rows(data, mutate(collection$find(), execution))
  }
  
  return(data)
}