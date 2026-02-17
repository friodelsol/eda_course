library(data.table)

list.files("./data/raw")

list.files("./data/raw/runoff_day/")

runoff_stations <- fread('data/raw/runoff_stations.csv')
runoff_stations

#overview of datatable
str(runoff_stations)

#content of the column
runoff_stations$area

#summary of column
summary(runoff_stations)
summary(runoff_stations$area)
summary(runoff_stations$altitude)

fread('./data/raw/runoff_day/6335020_Q_Day.Cmd.txt')

runoff_stations[, sname := factor(abbreviate(station))]
runoff_stations[, id := factor(id)]
runoff_stations[, lat := round(lat, 3)]
runoff_stations[, lon := round(lon, 3)]
runoff_stations[, altitude := round(altitude, 0)]

raw_path <- './data/raw/runoff_day/'
fnames <- list.files(raw_path)
n_station <- length(fnames)

id_length <- 7

runoff_day_raw <- data.table()

id_sname <- runoff_stations[, .(id, sname)]

saveRDS(runoff_stations, './data/runoff_stations_raw.rds')

file_count <- 1
temp_dt <- fread(paste0(raw_path, fnames[file_count]))

station_id <- substr(fnames[file_count], 1, id_length)
temp_dt <- cbind(id = factor(station_id), temp_dt)

temp_dt <- id_sname[temp_dt, on = 'id']

runoff_day_raw <- rbind(runoff_day_raw, temp_dt)
runoff_day_raw[, 'hh:mm' := NULL]

colnames(runoff_day_raw)[3:4] <- c('date', 'value')
#setnames(runoff_day_raw, "YYYY-MM-DD", "date")
#setnames(runoff_day_raw, "Value", "value")
runoff_day_raw[, date := as.Date(date)]
saveRDS(runoff_day_raw, './data/runoff_day_raw.rds')

runoff_coordinates <- runoff_stations[, .(sname, lat, lon)]
runoff_coordinates <- melt(runoff_coordinates, id.vars = 'sname')
runoff_coordinates