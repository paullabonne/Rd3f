# Rd3f

R code for creating a dataframe out of the [Forex
Factory](https://www.forexfactory.com) online economic calendar.

- `build_df()` creates or update a dataframe out of Forex Factory HTML
  source pages.
- `clean_df()` cleans and categorises the data.

``` r
source("forex.R")
```

``` r
# load the raw dataset generated previously (optional)
df = read_parquet("data/df_ff_raw.parquet")

# set the dates to scrap from forex factory 
date_start = "2024-04-07"
date_end = "2024-04-11"

# update the dataset
df_updated = build_df(date_start, date_end, df) # can be left empty if a new dataframe should be created
```

    [1] "2024-04-07 scraped"
    [1] "2024-04-08 scraped"
    [1] "2024-04-09 scraped"
    [1] "2024-04-10 scraped"
    [1] "2024-04-11 scraped"


     dataframe successfully updated 

``` r
# clean the dataset
df_clean = clean_df(df_updated)
```


     dataframe successfully cleaned 

#### Snapshot of the dataframe

``` r
library(dplyr)
library(knitr)

df_day = df_clean %>%
  filter(date == "2024-04-11")

kable(df_day, format = "html")
```

| date       | geo       | currency | event                     | impact | event_id |  forecast | observation | previous_obs |  error |   change | type            |
|:-----------|:----------|:---------|:--------------------------|:-------|:---------|----------:|------------:|-------------:|-------:|---------:|:----------------|
| 2024-04-11 | UK        | GBP      | rics house price balance  | low    | 135799   | -6.00e+00 |   -4.00e+00 |     -1.0e+01 | -2e+00 |  6.0e+00 | inflation       |
| 2024-04-11 | Australia | AUD      | mi inflation expectations | low    | 137249   |        NA |    4.60e+00 |      4.3e+00 |     NA |  3.0e-01 | inflation       |
| 2024-04-11 | China     | CNY      | cpi y/y                   | medium | 135149   |  4.00e-01 |    1.00e-01 |      7.0e-01 |  3e-01 | -6.0e-01 | inflation       |
| 2024-04-11 | China     | CNY      | ppi y/y                   | medium | 135150   | -2.80e+00 |   -2.80e+00 |     -2.7e+00 |  0e+00 | -1.0e-01 | inflation       |
| 2024-04-11 | Italy     | EUR      | industrial production m/m | low    | 134726   |  6.00e-01 |    1.00e-01 |     -1.4e+00 |  5e-01 |  1.5e+00 | economic growth |
| 2024-04-11 | Euro Area | EUR      | main refinancing rate     | high   | 135510   |  4.50e+00 |    4.50e+00 |      4.5e+00 |  0e+00 |  0.0e+00 | monetary_pol    |
| 2024-04-11 | USA       | USD      | core ppi m/m              | high   | 136015   |  2.00e-01 |    2.00e-01 |      3.0e-01 |  0e+00 | -1.0e-01 | inflation       |
| 2024-04-11 | USA       | USD      | ppi m/m                   | high   | 136014   |  3.00e-01 |    2.00e-01 |      6.0e-01 |  1e-01 | -4.0e-01 | inflation       |
| 2024-04-11 | USA       | USD      | unemployment claims       | high   | 136537   |  2.16e+05 |    2.11e+05 |           NA |  5e+03 |       NA | employment      |
| 2024-04-11 | USA       | USD      | natural gas storage       | low    | 135935   |  1.40e+10 |    2.40e+10 |     -3.7e+10 | -1e+10 |  6.1e+10 | NA              |

- Note that these data are protected by the
  [copyright](https://www.forexfactory.com/notices#copyrightof) of Fair
  Economy, Inc.
