library(data.table)
library(ggplot2)

runoff_stations <- readRDS('./data/runoff_stations_raw.rds')
runoff_day <- readRDS('./data/runoff_day_raw.rds')

rees_runoff_day <- runoff_day[sname == 'REES']

ggplot(data = rees_runoff_day) +
  geom_line(aes(x = date, y = value))

ggplot(data = rees_runoff_day) +
  geom_point(aes(x = date, y = value))

ggplot(data = rees_runoff_day, 
       aes(x = date, y = value)) +
  geom_point() +
  geom_line()

rees_dier_runoff_day <- runoff_day[sname == 'REES' | sname == 'DIER']

ggplot(data = rees_dier_runoff_day) +
  geom_line(aes(x = date, y = value, col = sname))

ggplot(data = runoff_day, aes(x = date, y = value)) +
  geom_line() +
  facet_wrap(~sname) + 
  theme_bw()

ggplot(data = runoff_day, aes(x = date, y = value)) +
  geom_line() +
  facet_wrap(~sname, scales = "free_y") + 
  theme_bw()

runoff_stations_tidy <- runoff_stations[, .(sname, area, altitude)]

ggplot(data = runoff_stations_tidy, aes(x = area, y = altitude)) +
  geom_point() + geom_text(aes(label = sname))

