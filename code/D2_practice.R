library(data.table)
library(ggplot2)
dt <- readRDS("aggregated_yearly.rds")

summary(dt)

ndvi <- dt[variable == "NDVI"]
summary(ndvi)

ndvi_max <- ndvi[value >= 0.8353]

ndvi_min <- ndvi[value <= 0.1743]

ndvi <- ndvi[site_id %in% c("MY-PSO", "AU-TTE")]

ggplot(data = ndvi) +
  geom_line(aes(x = timestamp, y = value)) +
  facet_wrap(~site_id)

sw_lw_in <- dt[variable %in% c("SW_IN", "LW_IN")]
summary(sw_lw_in$value)

sw_lw_in_my_pso <- sw_lw_in[site_id == "MY-PSO"]

p1 <- ggplot(data = sw_lw_in_my_pso) +
  geom_line(aes(x = timestamp, y = value, color = variable))

ggsave("./results/sw_lw_in_my_pso.png", p1)
