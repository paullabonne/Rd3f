library(dplyr)
library(lubridate)
library(stringr)
library(zoo)
library(magrittr)
library(tidyr)
library(arrow)
library(sjmisc) # str_contain

############################################################
###### cleaning

clean_df <- function(df) {
  df_ff <- df %>%
    mutate(
      event = tolower(event),
      geo = NA,
      geo = ifelse(currency == "AUD", "Australia", geo),
      geo = ifelse(currency == "USD", "USA", geo),
      geo = ifelse(currency == "CHF", "Switzerland", geo),
      geo = ifelse(currency == "GBP", "UK", geo),
      geo = ifelse(currency == "EUR", "Euro Area", geo),
      geo = ifelse(currency == "CAD", "Canada", geo),
      geo = ifelse(currency == "NZD", "New Zealand", geo),
      geo = ifelse(currency == "CNY", "China", geo),
      geo = ifelse(grepl("french", event), "France", geo),
      geo = ifelse(grepl("italian", event), "Italy", geo),
      geo = ifelse(grepl("spanish", event), "Spain", geo),
      geo = ifelse(grepl("german", event), "Germany", geo),
      event = str_remove(event, "french "),
      event = str_remove(event, "italian "),
      event = str_remove(event, "german "),
      event = str_remove(event, "spanish ")
    ) %>%
    filter(!is.na(geo))

  # cleaning numbers
  df_ff %<>%
    gather(forecast, observation, previous_obs, key = var, value = value) %>%
    mutate(
      value = str_remove(value, "%"),
      value = str_replace(value, "K", "000"),
      value = str_replace(value, "M", "000000"),
      value = str_replace(value, "B", "000000000"),
      value = str_remove(value, "<"),
      value = as.numeric(value)
    ) %>%
    pivot_wider(names_from = var, values_from = value) %>%
    relocate(date, geo, currency)

  # keeping only data event (excluding speeches and meetings for instance)
  df_ff %<>%
    filter(!is.na(observation))

  # finding problematic events (duplicates) and dropping them to keep only single events
  df_ff %<>%
    mutate(index = 1:nrow(df_ff)) %>%
    group_by(date, geo, event) %>%
    mutate(id_drop = ifelse(n() > 1 & index == max(index), 1, 0)) %>%
    ungroup() %>%
    filter(id_drop == 0) %>%
    select(-id_drop, -index)

  ############################################################
  ###### add some variables to the dataset

  # creating forecast error variable
  df_ff %<>%
    mutate(error = forecast - observation)

  # creating change variable
  df_ff %<>%
    mutate(change = observation - previous_obs)

  ############################################################
  ###### creating categories
  infl <- c(
    "price", "infl", "cpe", "cpi", "pce", "ppi", "pi", "hpi",
    "wage", "earnings", "earning", "wpi", "inflation", "labor cost", "cost"
  )

  empl <- c("employment", "unemployment", "claim", "claimant", "job", "labor market")

  econ_g <- c(
    "gdp", "ip", "manufacturing", "vehicle sales", "construction",
    "services", "orders", "retail sales", "economic expectations",
    "leading index", "wholesale sales", "cbi", "industrial new orders",
    "credit card spending", "capacity utilization", "corporate profits", "production", "spending", "income"
  )

  housing <- c("mortgage", "home", "building", "housing", "house", "home loans")

  confidence <- c("confidence", "sentiment", "climate", "pmi", "richmond", "chicago", "optimism", "manufacturing index", "empire state", "nfib")

  monetary_pol <- c("rate")

  df_ff %<>%
    group_by(geo, event) %>%
    mutate(
      type = NA,
      type = ifelse(any(str_contains(event, monetary_pol)) & is.na(type), "monetary_pol", type),
      type = ifelse(any(str_contains(event, empl)), "employment", type),
      type = ifelse(any(str_contains(event, econ_g)), "economic growth", type),
      type = ifelse(any(str_contains(event, confidence)), "confidence", type),
      type = ifelse(any(str_contains(event, housing)), "housing", type),
      type = ifelse(any(str_contains(event, infl)), "inflation", type),
      type = ifelse(event == "empire state manufacturing index", "confidence", type)
    ) %>%
    ungroup() %>%
    arrange(date)

  # save
  write_parquet(df_ff, "data/df_ff.parquet")

  message("\n\n\n dataframe successfully cleaned \n\n\n")

  return(df_ff)
}
