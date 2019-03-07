# pm25-stateMeans.R
# author: C.V. Cosgriff, Harvard Chan School
#
# 23 December 2017
#
# This R script calculates the mean pm25 levels by state. Because the extraction
# results in a lot of negative values, we first clean the data before 
# calculating the state mean.

args = commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  stop("This script requires a start year to run.", call.=FALSE)
}

startYear <- args[1]
endYear <- as.numeric(startYear) + 2 # The data is formatted as a two year interval

# The data directory provided for the assignment on Odyssey
data_dir <- "/n/regal/bst262/pm25"

# Use the years, data directory, and the structure of the data directory to 
# generate a path to the appropriate pm25 data file.
coding <- paste0(startYear, "01_", endYear, "12")
file_path <- paste0(data_dir, "/", coding, "/", "GWR_PM25_NA_", coding, "-RH35-NoNegs.asc")

# Output the path, useful for debugging
print(file_path)

library(raster)
library(rgdal) # requires module for gdal and geos to be loaded as well

# Function to calculate the mean pm25 level by state given the full extraction
# as an input, x. Because of the presence of negative values at some points in 
# the extraction, and because we don't want those points to distort our mean,
# we use sapply to set any value that is below 0 to NA, and then calculate the
# mean with na.rm = TRUE. 
state_mean <- function(x) {
  if (!is.null(x)) {
    x <- sapply(x, function(y) if (!is.na(y) & y <= 0) y <- NA else y)
    mean(x, na.rm = TRUE) 
  }
  else NA
}

state_data <- readOGR(dsn = "./shape/")
pm25 <- raster(file_path)
v <- extract(pm25, state_data)

pm25_state_means <- unlist(lapply(v, state_mean))
result <- data.frame(state = state_data$NAME10, mean_pm25 = pm25_state_means)

write.csv(result, paste0("pm25-state_mean-", startYear, "-", endYear, ".csv"))
