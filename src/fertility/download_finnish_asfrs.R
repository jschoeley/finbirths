# Download Finnish ASFRs

# Init --------------------------------------------------------------------

library(yaml)
library(dplyr)
library(pxweb)
library(readr)

# Constants ---------------------------------------------------------------

# input and output paths
setwd(".")
paths <- list()
paths$input <- list(
  statfinurl = paste0(
    "https://pxdata.stat.fi/PxWeb/api/v1/en/",
    "StatFin/synt/12ds.px"
  )
)
paths$output <- list(
  finnish_asfrs.csv = "./dat/fertility/finnish_asfrs.csv"
)

# constants specific to this analysis
cnst <- within(list(), {
  ages = c("15-19", "20-24", "25-29", "30-34",
           "35-39", "40-44", "45-49")
})

# Download data -----------------------------------------------------------

finnish_asfrs <-
  pxweb_get_data(
  url = paths$input$statfinurl,
  query = list(
    "timeperiod_y" = "*", # all available years
    "ikaryhma_10_20180101" = cnst$ages # maternal age
  ),
  column.name.type = "text",
  variable.value.type = "text"
) |>
  transmute(
    year = as.integer(Year),
    age  = `Age of mother`,
    asfr = as.numeric(`Fertility rate`)
  )

# Export ------------------------------------------------------------------

# export results of analysis
write_csv(finnish_asfrs, file = paths$output$finnish_asfrs.csv)
