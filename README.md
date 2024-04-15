# Rd3f

R code for creating a dataframe out of the [Forex
Factory](https://www.forexfactory.com) online economic calendar.

- `build_df` creates or update a dataframe out of Forex Factory HTML
  source pages.
- `clean_df` cleans and categorises the data.

``` r
source("forex.R")
```

``` r
# load the raw dataset generated previously 
df = read_parquet("data/df_ff_raw.parquet")

# set the dates to scrap from forex factory 
date_start = "2024-01-01"
date_end = "2024-04-14"

# update the dataset
df_updated = build_df(date_start, date_end, df)
```

    [1] "2024-01-01 scraped"
    [1] "2024-01-02 scraped"
    [1] "2024-01-03 scraped"
    [1] "2024-01-04 scraped"
    [1] "2024-01-05 scraped"
    [1] "2024-01-06 scraped"
    [1] "2024-01-07 scraped"
    [1] "2024-01-08 scraped"
    [1] "2024-01-09 scraped"
    [1] "2024-01-10 scraped"
    [1] "2024-01-11 scraped"
    [1] "2024-01-12 scraped"
    [1] "2024-01-13 scraped"
    [1] "2024-01-14 scraped"
    [1] "2024-01-15 scraped"
    [1] "2024-01-16 scraped"
    [1] "2024-01-17 scraped"
    [1] "2024-01-18 scraped"
    [1] "2024-01-19 scraped"
    [1] "2024-01-20 scraped"
    [1] "2024-01-21 scraped"
    [1] "2024-01-22 scraped"
    [1] "2024-01-23 scraped"
    [1] "2024-01-24 scraped"
    [1] "2024-01-25 scraped"
    [1] "2024-01-26 scraped"
    [1] "2024-01-27 scraped"
    [1] "2024-01-28 scraped"
    [1] "2024-01-29 scraped"
    [1] "2024-01-30 scraped"
    [1] "2024-01-31 scraped"
    [1] "2024-02-01 scraped"
    [1] "2024-02-02 scraped"
    [1] "2024-02-03 scraped"
    [1] "2024-02-04 scraped"
    [1] "2024-02-05 scraped"
    [1] "2024-02-06 scraped"
    [1] "2024-02-07 scraped"
    [1] "2024-02-08 scraped"
    [1] "2024-02-09 scraped"
    [1] "2024-02-10 scraped"
    [1] "2024-02-11 scraped"
    [1] "2024-02-12 scraped"
    [1] "2024-02-13 scraped"
    [1] "2024-02-14 scraped"
    [1] "2024-02-15 scraped"
    [1] "2024-02-16 scraped"
    [1] "2024-02-17 scraped"
    [1] "2024-02-18 scraped"
    [1] "2024-02-19 scraped"
    [1] "2024-02-20 scraped"
    [1] "2024-02-21 scraped"
    [1] "2024-02-22 scraped"
    [1] "2024-02-23 scraped"
    [1] "2024-02-24 scraped"
    [1] "2024-02-25 scraped"
    [1] "2024-02-26 scraped"
    [1] "2024-02-27 scraped"
    [1] "2024-02-28 scraped"
    [1] "2024-02-29 scraped"
    [1] "2024-03-01 scraped"
    [1] "2024-03-02 scraped"
    [1] "2024-03-03 scraped"
    [1] "2024-03-04 scraped"
    [1] "2024-03-05 scraped"
    [1] "2024-03-06 scraped"
    [1] "2024-03-07 scraped"
    [1] "2024-03-08 scraped"
    [1] "2024-03-09 scraped"
    [1] "2024-03-10 scraped"
    [1] "2024-03-11 scraped"
    [1] "2024-03-12 scraped"
    [1] "2024-03-13 scraped"
    [1] "2024-03-14 scraped"
    [1] "2024-03-15 scraped"
    [1] "2024-03-16 scraped"
    [1] "2024-03-17 scraped"
    [1] "2024-03-18 scraped"
    [1] "2024-03-19 scraped"
    [1] "2024-03-20 scraped"
    [1] "2024-03-21 scraped"
    [1] "2024-03-22 scraped"
    [1] "2024-03-23 scraped"
    [1] "2024-03-24 scraped"
    [1] "2024-03-25 scraped"
    [1] "2024-03-26 scraped"
    [1] "2024-03-27 scraped"
    [1] "2024-03-28 scraped"
    [1] "2024-03-29 scraped"
    [1] "2024-03-30 scraped"
    [1] "2024-03-31 scraped"
    [1] "2024-04-01 scraped"
    [1] "2024-04-02 scraped"
    [1] "2024-04-03 scraped"
    [1] "2024-04-04 scraped"
    [1] "2024-04-05 scraped"
    [1] "2024-04-06 scraped"
    [1] "2024-04-07 scraped"
    [1] "2024-04-08 scraped"
    [1] "2024-04-09 scraped"
    [1] "2024-04-10 scraped"
    [1] "2024-04-11 scraped"
    [1] "2024-04-12 scraped"
    [1] "2024-04-13 scraped"
    [1] "2024-04-14 scraped"


     dataframe successfully updated 

``` r
# clean the dataset
df_clean = clean_df(df)
```


     dataframe successfully cleaned 

``` r
library(dplyr)
library(knitr)

df_day = df %>%
  filter(date == "2024-04-11")

kable(df_day, format = "html")
```

| currency | event                             | forecast | observation | previous_obs | impact | event_id | date       |
|:---------|:----------------------------------|:---------|:------------|:-------------|:-------|:---------|:-----------|
| GBP      | RICS House Price Balance          | -6%      | -4%         | -10%         | NA     | 135799   | 2024-04-11 |
| JPY      | M2 Money Stock y/y                | 2.4%     | 2.5%        | 2.4%         | NA     | 139618   | 2024-04-11 |
| AUD      | MI Inflation Expectations         |          | 4.6%        | 4.3%         | NA     | 137249   | 2024-04-11 |
| CNY      | CPI y/y                           | 0.4%     | 0.1%        | 0.7%         | NA     | 135149   | 2024-04-11 |
| CNY      | PPI y/y                           | -2.8%    | -2.8%       | -2.7%        | NA     | 135150   | 2024-04-11 |
| EUR      | Italian Industrial Production m/m | 0.6%     | 0.1%        | -1.4%        | NA     | 134726   | 2024-04-11 |
| GBP      | BOE Credit Conditions Survey      |          |             |              | NA     | 135702   | 2024-04-11 |
| EUR      | Eurogroup Meetings                |          |             |              | NA     | 135586   | 2024-04-11 |
| EUR      | Main Refinancing Rate             | 4.50%    | 4.50%       | 4.50%        | NA     | 135510   | 2024-04-11 |
| EUR      | Monetary Policy Statement         |          |             |              | NA     | 135511   | 2024-04-11 |
| USD      | Core PPI m/m                      | 0.2%     | 0.2%        | 0.3%         | NA     | 136015   | 2024-04-11 |
| USD      | PPI m/m                           | 0.3%     | 0.2%        | 0.6%         | NA     | 136014   | 2024-04-11 |
| USD      | Unemployment Claims               | 216K     | 211K        | 222k         | NA     | 136537   | 2024-04-11 |
| EUR      | ECB Press Conference              |          |             |              | NA     | 135509   | 2024-04-11 |
| USD      | FOMC Member Williams Speaks       |          |             |              | NA     | 140132   | 2024-04-11 |
| USD      | FOMC Member Barkin Speaks         |          |             |              | NA     | 140140   | 2024-04-11 |
| USD      | Natural Gas Storage               | 14B      | 24B         | -37B         | NA     | 135935   | 2024-04-11 |
| GBP      | MPC Member Greene Speaks          |          |             |              | NA     | 140133   | 2024-04-11 |
| USD      | 30-y Bond Auction                 |          | 4.67\|2.4   | 4.33\|2.5    | NA     | 137320   | 2024-04-11 |
| USD      | FOMC Member Bostic Speaks         |          |             |              | NA     | 140141   | 2024-04-11 |

- Note that these data are protected by the
  [copyright](https://www.forexfactory.com/notices#copyrightof) of Fair
  Economy, Inc.
