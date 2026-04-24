library(data.table)
library(ggplot2)

runoff_year <- readRDS('./data/05/runoff_year.rds')
runoff_month <- readRDS('./data/05/runoff_month.rds')

colset_4 <-  c("#D35C37", "#BF9A77", "#D6C6B9", "#97B8C2")
theme_set(theme_bw())

#01
year_thres <- 1980
runoff_year <- runoff_year[year >= 1950]

runoff_year[year < year_thres, period := "1950-1980"]
runoff_year[year >= year_thres, period := "1981-2016"]

ggplot(runoff_year[sname %in% c("DOMA","BASR","KOEL")],
       aes(period, value, fill = period)) +
  geom_boxplot() +
  facet_wrap(~sname, scales = "free_y") +
  scale_fill_manual(values = colset_4[c(4,1)]) +
  xlab("Period") +
  ylab("Annual Runoff (m³/s)")
#Annual runoff smooths seasonal contrasts
#DOMA still shows a decrease, but timing is less clear

runoff_month[year < year_thres, period := "1950-1980"]
runoff_month[year >= year_thres, period := "1981-2016"]

ggplot(runoff_month[sname %in% c("DOMA","BASR","KOEL") & year >= 1950],
       aes(factor(month), value, fill = period)) +
  geom_boxplot() +
  facet_wrap(~sname, scales = "free_y") +
  scale_fill_manual(values = colset_4[c(4,1)]) +
  xlab("Month") +
  ylab("Runoff (m³/s)")
#Winter months (DJF) show clear increases
#Summer months show declines or higher variability
#Seasonal shift is more visible than annual

#02
runoff_day <- readRDS('./results/04/runoff_month.rds')

runoff_day[, q90 := quantile(value, 0.9), by = sname]
runoff_day[, q10 := quantile(value, 0.1), by = sname]

# Mean runoff during extremes
hl_means <- runoff_day[
  value > q90 | value < q10,
  .(mean_extreme = mean(value)),
  by = .(sname, extreme = value > q90)
]

# Number of extreme days
hl_counts <- runoff_day[
  value > q90 | value < q10,
  .N,
  by = .(sname, extreme = value > q90)
]

#03
runoff_summary_key <- readRDS('./results/05/runoff_summary_key.rds')

ggplot(runoff_summer_key[year >= 1950 & year <= 2010],
       aes(year, value)) +
  geom_smooth(method = "lm", se = FALSE, col = colset_4[1]) +
  geom_smooth(method = "loess", se = FALSE, col = colset_4[4]) +
  facet_wrap(~sname)
#Linear slopes change significantly
#Loess trends are much more stable
#Adding recent years can flip trend signs