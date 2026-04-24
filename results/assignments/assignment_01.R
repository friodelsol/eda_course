library(data.table)

# Input data
temperatures <- c(3, 6, 10, 14)
weights <- c(1, 0.8, 1.2, 1)

# Function to apply weights
apply_weights <- function(x, y) {
  x * y
}

# Compute results
results <- apply_weights(temperatures, weights)

runoff_dt <- data.table(
  month = c("January", "February", "March"),
  mean_runoff = c(120, 150, 135)  # example mean runoff values (m3/s)
)

runoff_dt[, pct_change := 
            (mean_runoff - shift(mean_runoff)) /
            shift(mean_runoff) * 100]

runoff_dt

#explorer's questions 01
#How big is the Rhine catchment (km²)?
#The Rhine River catchment has an approximate area of 185,000 km².

#explorer's questions 02
# Rhine catchment area
area_km2 <- 185000
area_m2  <- area_km2 * 1e6

# Rainfall parameters
rain_mm_hour <- 0.5
duration_h   <- 24

# Convert rainfall depth to meters
rain_m <- rain_mm_hour * duration_h / 1000

# Total precipitation volume (m3)
volume_m3 <- area_m2 * rain_m

# Increase in average discharge (m3/s)
discharge_increase <- volume_m3 / (24 * 3600)

discharge_increase
#how much would be the increase in the average river runoff?
#25694.44
#The resulting discharge increase is extremely large compared to typical Rhine flows.

#explorer's questions 03
# Distance from Alpine Rhine to North Sea (m)
distance_m <- 1200 * 1000

# Average flow velocity (m/s)
velocity <- 1

# Travel time in seconds and days
time_sec  <- distance_m / velocity
time_days <- time_sec / (24 * 3600)

time_days
#How much time does a rain drop falling at Alpine Rhine need to reach the ocean?
#13.88889
#Estimated travel time ranges from several days to a few weeks, depending on discharge conditions.

