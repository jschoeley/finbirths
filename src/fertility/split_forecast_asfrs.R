# Split forecast 5-year age-group ASFRs into single ages
# using Quadratic Optimization (QO) as proposed in:
#
# Grigoriev, P., Michalski, A. I., Gorlishchev, V. P., Jdanov, D. A.,
# & Shkolnikov, V. M. (2018). New methods for estimating detailed fertility
# schedules from abridged data. Max Planck Institute for Demographic Research:
# Rostock, Germany.
#
# code of QOSplit function from:
#
# Michalski, A. I., Grigoriev, P., & Gorlischev, V. (2018). R programs for
# splitting abridged fertility data into a fine grid of ages using the quadratic
# optimization method. MPIDR Technical Report TR-2018-002. Rostock.
# Available at http://www.demogr.mpg.de/tr-2018-002.

# Init --------------------------------------------------------------------

library(yaml)
library(readr)
library(dplyr)
library(quadprog)

# Constants ---------------------------------------------------------------

# input and output paths
setwd(".")
paths <- list()
paths$input <- list(
  forecast_asfrs_5 = "./out/PPS_forecast_asfrs.csv"
)
paths$output <- list(
  forecast_asfrs_1 = "./out/PPS_forecast_asfrs_single_ages.csv"
)

config <- read_yaml("./cfg/config.yaml")

source("./src/fertility/QOSplit.R")

# constants specific to this analysis
cnst <- within(list(), {
  age_groups = c(15, 20, 25, 30, 35, 40, 45)
  age_widths = c(5, 5, 5, 5, 5, 5, 5)
})

# Load forecast ASFRs -----------------------------------------------------

asfrs_5 <- read_csv(paths$input$forecast_asfrs_5)

# Split ASFRs -------------------------------------------------------------

# select a single year and simulation
test_5 <-
  asfrs_5 %>%
  filter(h == 10, sim == 50) %>%
  pull(asfr)

# Split test data
test_1 <-
  QOSplit(Fx = test_5,
          L = cnst$age_groups,
          AgeInt = cnst$age_widths)

# check results by aggregating age-groups again
test_1 <-
  test_1 %>%
  mutate(Age_group = floor(Age/5) * 5) %>%
  group_by(Age_group) %>%
  summarise(ASFR = mean(ASFR))

# split all years and simulations
asfrs_1 <-
  asfrs_5 %>%
  group_by(h, sim) %>%
  group_modify(~ {
    QOSplit(
      Fx = .x$asfr,
      L = cnst$age_groups,
      AgeInt = cnst$age_widths
    ) %>%
      rename(age = Age, asfr = ASFR)
  }) %>%
  ungroup()

# Export ------------------------------------------------------------------

# export results of analysis
write_csv(asfrs_1, file = paths$output$forecast_asfrs_1)

