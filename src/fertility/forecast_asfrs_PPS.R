# Forecast Finnish ASFRs using the Postponement Scenario Model (PPS) from
# the PFS package and plot the results

# Init --------------------------------------------------------------------

library(yaml)
library(dplyr)
library(pfs)
library(readr)
library(ggplot2)

# Constants ---------------------------------------------------------------

# input and output paths
setwd(".")
paths <- list()
paths$input <- list(
  asfrs_input = "./dat/fertility/finnish_asfrs.csv"
)
paths$output <- list(
  asfrs_forecast = "./out/PPS_forecast_asfrs.csv",
  asfrs_forecast_plot = "./out/PPS_forecast_asfrs.pdf"
)

config <- read_yaml("./cfg/config.yaml")

# constants specific to this analysis
cnst <- within(list(), {
  age_groups = c(15, 20, 25, 30, 35, 40, 45)
})

# Load Finnish ASFRs -------------------------------------------------------

asfrs_input <-
  read_csv(paths$input$asfrs_input)

# select jumpoff-ASFRs
jumpoff_asfrs <-
  asfrs_input %>%
  filter(year == config$forecast$jumpoff) %>%
  pull(asfr)

# Forecast ASFRs -----------------------------------------------------------

# define forecast object
forecast_definition <-
  DefineForecast(
    jumpoff_asfrs = jumpoff_asfrs,
    forecast_horizon = config$forecast$h,
    ages = cnst$age_groups,
    wlast = config$forecast$wlast,
    target_tfr = config$forecast$target_tfr,
    target_mab = config$forecast$target_mab,
    asfr_growth_rate = config$forecast$asfr_growth_rate,
    timestep_of_steepest_growth = config$forecast$timestep_of_steepest_growth,
    randomness = 'finland1995-2024'
  )

# predict target ASFRs
target_asfrs <-
  PredictTargetASFRs(forecast_definition)$optimized_target_asfrs

# predict trajectory towards the target ASFRs
trajectory <-
  PredictTrajectoryToTargetASFRs(forecast_definition, target_asfrs)

# make the forecast simulations
sim_asfrs <-
  SampleRandomWalkASFRs(forecast_definition, trajectory,
                        nsim = config$simulations$nsim)

sim_asfrs <-
  sim_asfrs %>%
  array2DF() %>%
  rename(asfr = Value) %>%
  mutate(sim = as.numeric(sim),
         h = as.numeric(h))

# Plot ASFR forecasts together with observed ASFR --------------------------

# Prepare data for plotting
sim_asfrs_plot <-
  sim_asfrs %>%
  mutate(year = h + config$forecast$jumpoff,
         model = "PPS",
         age = case_when(age == 15 ~ "15 - 19",
                         age == 20 ~ "20 - 24",
                         age == 25 ~ "25 - 29",
                         age == 30 ~ "30 - 34",
                         age == 35 ~ "35 - 39",
                         age == 40 ~ "40 - 44",
                         age == 45 ~ "45 - 49")) %>%
  select(-c(h)) %>%
  relocate(year, age, model, sim, asfr)

obs_asfrs <-
  asfrs_input %>%
  mutate(model = "observed",
         sim = NA) %>%
  relocate(year, age, model, sim, asfr)

asfrs_plot <- rbind(obs_asfrs, sim_asfrs_plot)

# Plot
plot_asfrs_forecast_obs <-
  ggplot(asfrs_plot, aes(x = year, y = asfr)) +
  geom_line(
    data = subset(asfrs_plot, model == "PPS" & sim <= 250),
    aes(group = sim),
    alpha = 0.035
  ) +
  geom_point(
    data = subset(asfrs_plot, model == "observed"),
    size = 0.2
  ) +
  facet_wrap(~ age, nrow = 4) +
  geom_vline(
    xintercept = 2025,
    color = "darkgrey",
    linetype = "dotted"
  ) +
  scale_x_continuous(
    breaks = seq(1990, 2050, by = 10),
    labels = seq(1990, 2050, by = 10)
  ) +
  labs(
    title = "Finnish age-specific fertility rates: PPS forecasts (250 simulations) and observed",
    x = "Year",
    y = "ASFR"
  )

# Export ------------------------------------------------------------------

# export results of analysis
write_csv(sim_asfrs, file = paths$output$asfrs_forecast)
ggsave(
  paths$output$asfrs_forecast_plot,
  plot = plot_asfrs_forecast_obs,
  width = config$figspec$dimensions$width,
  units = "mm"
)
