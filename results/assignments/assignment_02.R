library(data.table)
library(ggplot2)

runoff_stations <- readRDS('./data/runoff_stations_raw.rds')
runoff_day <- readRDS('./data/runoff_day_raw.rds')

station_phys <- runoff_stations[, .(sname, area, altitude)]
station_phys

station_phys_tidy <- melt(
  station_phys,
  id.vars = "sname",
  variable.name = "variable",
  value.name = "value"
)

station_phys_tidy

ggplot(runoff_stations,
       aes(x = area, y = altitude, label = sname)) +
  geom_point(aes(color = area), size = 3) +
  geom_text(vjust = -0.8, size = 3) +
  scale_color_gradient(
    low = "#1f4e79",
    high = "#8ecae6",
    name = "size"
  ) +
  theme_bw() +
  labs(
    x = "area",
    y = "altitude"
  )

ggplot(runoff_stations,
       aes(x = lon, y = lat, label = sname)) +
  geom_point(aes(color = altitude), size = 3) +
  geom_text(hjust = 0, nudge_x = 0.03, size = 3) +
  scale_color_gradient(
    low = "darkgreen",
    high = "firebrick",
    name = "altitude"
  ) +
  theme_bw() +
  labs(
    x = "lon",
    y = "lat"
  )

station_periods <- runoff_day[
  , .(
    start = min(date),
    end   = max(date)
  ),
  by = sname
]

ggplot(station_periods) +
  geom_segment(
    aes(
      x = start,
      xend = end,
      y = reorder(sname, start),
      yend = reorder(sname, start)
    ),
    linewidth = 1
  ) +
  theme_bw() +
  labs(
    x = "Year",
    y = "Station",
    title = "Periods of available runoff data per station"
  )

missing_years <- runoff_day[
  value < 0,
  .(date),
  by = sname
]

ggplot(station_periods) +
  geom_segment(
    aes(
      x = start,
      xend = end,
      y = reorder(sname, start),
      yend = reorder(sname, start)
    ),
    linewidth = 1
  ) +
  geom_point(
    data = missing_years,
    aes(
      x = date,
      y = sname
    ),
    color = "red",
    alpha = 0.5
  ) +
  theme_bw()

#explorer's questions 01
#Which are the units for area and runoff in our records?
#The unit for area is km2 and for runoff is m3/s

#explorer's questions 02

mean_area <- runoff_stations[, mean(area)]
mean_area

mean_runoff <- runoff_day[, mean(value)]
mean_runoff

#explorer's questions 03

mean_runoff_station <- runoff_day[
  , .(mean_runoff = mean(value)),
  by = sname
]

p1 <- ggplot(mean_runoff_station,
       aes(x = reorder(sname, mean_runoff), y = mean_runoff)) +
  geom_col() +
  coord_flip() +
  theme_bw() +
  labs(
    x = "Station",
    y = "Mean runoff (m³/s)",
    title = "Average runoff per station"
  )

ggsave("./results/assignments/02_graph.png", p1)

#explorer's questions 04

ggplot(runoff_stations, aes(x = altitude, y = area)) +
  geom_point(size = 3) +
  theme_bw() +
  labs(
    x = "Altitude (m a.s.l.)",
    y = "Catchment area (km²)"
  )
#there is a clear relationship
#High-altitude stations - Small catchments
#Low-altitude stations - Large catchments

