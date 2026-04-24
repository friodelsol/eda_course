library(data.table)
library(ggplot2)

runoff_stations <- readRDS('./data/04/runoff_stations.rds')
runoff_day <- readRDS('./data/04/runoff_day.rds')

#01
runoff_stats <- runoff_day[, .(
  mean_day   = mean(value),
  median_day = median(value),
  min_day    = min(value),
  max_day    = max(value)
), by = sname]

runoff_stats_long <- melt(
  runoff_stats,
  id.vars = "sname",
  variable.name = "statistic",
  value.name = "runoff"
)

ggplot(runoff_stats_long,
       aes(x = sname, y = runoff,
           color = statistic, shape = statistic)) +
  geom_point(size = 3) +
  theme_bw() +
  labs(x = "Station", y = "Runoff",
       title = "Summary Statistics per Station") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

#02
library(moments)

runoff_extra <- runoff_day[, .(
  skewness = skewness(value),
  cv       = sd(value) / mean(value)
), by = sname]

runoff_stats <- runoff_stats[runoff_extra, on = "sname"]

runoff_shape <- runoff_day[, .(
  skewness = skewness(value),
  cv       = sd(value) / mean(value)
), by = sname]

#03
runoff_month <- readRDS('./results/04/runoff_month.rds')
runoff_summary <- readRDS('./results/04/runoff_summary.rds')
runoff_month <- runoff_month[
  runoff_summary[, .(sname, runoff_class)],
  on = "sname"
]

colset_4 <-  c("#D35C37", "#BF9A77", "#D6C6B9", "#97B8C2")

ggplot(runoff_month,
       aes(x = factor(month),
           y = value,
           fill = runoff_class)) +
  geom_boxplot() +
  facet_wrap(~ sname, scales = "free") +
  theme_bw() +
  labs(x = "Month", y = "Monthly runoff")

#04
ggplot(runoff_day,
       aes(x = sname, y = value)) +
  geom_boxplot(fill = colset_4[4]) +
  theme_bw() +
  labs(x = "Station", y = "Daily runoff") +
  theme(axis.text.x = element_text(angle = 90))
#many outliers and mostly upper‑tail extremes
#As runoff is non‑Gaussian
#Floods are rare but physically real

#05

# Area classes
runoff_summary[, area_class := "small"]
runoff_summary[area >= 10000 & area < 80000, area_class := "medium"]
runoff_summary[area >= 80000, area_class := "large"]
runoff_summary[, area_class := factor(area_class, levels = c("small", "medium", "large"))]

# Altitude classes
runoff_summary[, alt_class := "low"]
runoff_summary[altitude >= 200 & altitude < 600, alt_class := "medium"]
runoff_summary[altitude >= 600, alt_class := "high"]
runoff_summary[, alt_class := factor(alt_class, levels = c("low", "medium", "high"))]

runoff_stats <- readRDS('./results/04/runoff_stats.rds')
plot_dt <- runoff_stats[
  runoff_summary[, .(sname, area, area_class, alt_class)],
  on = "sname"
]

ggplot(plot_dt,
       aes(x = mean_day,
           y = area,
           color = area_class,
           size = alt_class)) +
  geom_point(alpha = 0.85) +
  scale_color_manual(values = c("small"  = "#D35C37",
                                "medium" = "#BF9A77",
                                "large"  = "#97B8C2")) +
  scale_size_manual(values = c("low" = 3,
                               "medium" = 5,
                               "high" = 7)) +
  theme_bw() +
  labs(
    x = "Mean daily runoff",
    y = "Catchment area",
    color = "area_class",
    size = "alt_class"
  )

#explorer's questions 01
#They are exactly the same: Median = 0.5 quantile = 50th percentile
#Different names, same statistical concept.

#explorer's questions 02
#Because the distribution is: Positively skewed and dominated by flood extremes
#mean is sensitive to extremes and median isn’t

#explorer's questions 03
#LOBI and REES are very close geographically but often show different runoff statistics

