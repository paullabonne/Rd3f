rpyd3f
================

R and Python code for creating a dataframe out of the [Forex
Factory](https://www.forexfactory.com) online economic calendar.

- The `Python` code in `get_ff.py` scrapes the HTML source page of the
  economic calendar for each day.
- The `R` code in `build_ff.Rmd` creates a dataframe out of these HTML
  source pages.
- The `R` code in `cleaning.Rmd` cleans the data and categorises the
  variables into groups, e.g., inflation.  
- The `R` code in `summary.Rmd` provides a summary of the resulting
  dataset.

``` r
library(dplyr)
library(knitr)
library(arrow)

df = read_parquet("data/df_FF_clean.parquet")

df_day = df %>%
  filter(date == "2023-12-08")

kable(df_day, format = "html")
```

<table>
<thead>
<tr>
<th style="text-align:left;">
date
</th>
<th style="text-align:left;">
release_time
</th>
<th style="text-align:left;">
geo
</th>
<th style="text-align:left;">
currency
</th>
<th style="text-align:left;">
event
</th>
<th style="text-align:left;">
event_id
</th>
<th style="text-align:left;">
impact
</th>
<th style="text-align:left;">
Description
</th>
<th style="text-align:left;">
FF Notes
</th>
<th style="text-align:left;">
FF Notice
</th>
<th style="text-align:left;">
Frequency
</th>
<th style="text-align:left;">
Measures
</th>
<th style="text-align:right;">
forecast
</th>
<th style="text-align:right;">
observation
</th>
<th style="text-align:right;">
previous_obs
</th>
<th style="text-align:right;">
error
</th>
<th style="text-align:right;">
change
</th>
<th style="text-align:left;">
freq
</th>
<th style="text-align:left;">
target
</th>
<th style="text-align:left;">
type
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
2023-12-08
</td>
<td style="text-align:left;">
2023-12-08 08:00:00
</td>
<td style="text-align:left;">
Germany
</td>
<td style="text-align:left;">
EUR
</td>
<td style="text-align:left;">
final cpi m/m
</td>
<td style="text-align:left;">
132167
</td>
<td style="text-align:left;">
Low Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
The ‘Previous’ listed is the ‘Actual’ from the Preliminary release and
therefore the ‘History’ data will appear unconnected. There are 2
versions of CPI released about 15 days apart - Preliminary and Final.
The Preliminary release is the earliest and thus tends to have the most
impact;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, about 11 days after the month ends;
</td>
<td style="text-align:left;">
Change in the price of goods and services purchased by consumers;
</td>
<td style="text-align:right;">
-0.4
</td>
<td style="text-align:right;">
-0.4
</td>
<td style="text-align:right;">
-0.4
</td>
<td style="text-align:right;">
0.0
</td>
<td style="text-align:right;">
0.0
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Nov 2023
</td>
<td style="text-align:left;">
inflation
</td>
</tr>
<tr>
<td style="text-align:left;">
2023-12-08
</td>
<td style="text-align:left;">
2023-12-08 10:30:00
</td>
<td style="text-align:left;">
UK
</td>
<td style="text-align:left;">
GBP
</td>
<td style="text-align:left;">
consumer inflation expectations
</td>
<td style="text-align:left;">
133271
</td>
<td style="text-align:left;">
Low Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released quarterly, about 20 days after the survey is conducted;
</td>
<td style="text-align:left;">
Percentage that consumers expect the price of goods and services to
change during the next 12 months;
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
3.3
</td>
<td style="text-align:right;">
3.6
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
-0.3
</td>
<td style="text-align:left;">
quarterly
</td>
<td style="text-align:left;">
2023 Q3
</td>
<td style="text-align:left;">
inflation
</td>
</tr>
<tr>
<td style="text-align:left;">
2023-12-08
</td>
<td style="text-align:left;">
2023-12-08 14:30:00
</td>
<td style="text-align:left;">
Canada
</td>
<td style="text-align:left;">
CAD
</td>
<td style="text-align:left;">
capacity utilization rate
</td>
<td style="text-align:left;">
132628
</td>
<td style="text-align:left;">
Low Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released quarterly, about 75 days after the quarter ends;
</td>
<td style="text-align:left;">
Percentage of available resources being utilized by manufacturers,
builders, mines, oil extractors, and utilities;
</td>
<td style="text-align:right;">
81.4
</td>
<td style="text-align:right;">
79.7
</td>
<td style="text-align:right;">
79.6
</td>
<td style="text-align:right;">
1.7
</td>
<td style="text-align:right;">
0.1
</td>
<td style="text-align:left;">
quarterly
</td>
<td style="text-align:left;">
2023 Q3
</td>
<td style="text-align:left;">
economic growth
</td>
</tr>
<tr>
<td style="text-align:left;">
2023-12-08
</td>
<td style="text-align:left;">
2023-12-08 14:30:00
</td>
<td style="text-align:left;">
USA
</td>
<td style="text-align:left;">
USD
</td>
<td style="text-align:left;">
average hourly earnings m/m
</td>
<td style="text-align:left;">
129757
</td>
<td style="text-align:left;">
High Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
This is the earliest data related to labor inflation. Source changed
series calculation formula as of Feb 2010;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, usually on the first friday after the month ends;
</td>
<td style="text-align:left;">
Change in the price businesses pay for labor, excluding the farming
industry;
</td>
<td style="text-align:right;">
0.3
</td>
<td style="text-align:right;">
0.4
</td>
<td style="text-align:right;">
0.2
</td>
<td style="text-align:right;">
-0.1
</td>
<td style="text-align:right;">
0.2
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Nov 2023
</td>
<td style="text-align:left;">
inflation
</td>
</tr>
<tr>
<td style="text-align:left;">
2023-12-08
</td>
<td style="text-align:left;">
2023-12-08 14:30:00
</td>
<td style="text-align:left;">
USA
</td>
<td style="text-align:left;">
USD
</td>
<td style="text-align:left;">
non-farm employment change
</td>
<td style="text-align:left;">
129755
</td>
<td style="text-align:left;">
High Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
This is vital economic data released shortly after the month ends. The
combination of importance and earliness makes for hefty market impacts;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, usually on the first friday after the month ends;
</td>
<td style="text-align:left;">
Change in the number of employed people during the previous month,
excluding the farming industry;
</td>
<td style="text-align:right;">
184000.0
</td>
<td style="text-align:right;">
199000.0
</td>
<td style="text-align:right;">
150000.0
</td>
<td style="text-align:right;">
-15000.0
</td>
<td style="text-align:right;">
49000.0
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Nov 2023
</td>
<td style="text-align:left;">
employment
</td>
</tr>
<tr>
<td style="text-align:left;">
2023-12-08
</td>
<td style="text-align:left;">
2023-12-08 14:30:00
</td>
<td style="text-align:left;">
USA
</td>
<td style="text-align:left;">
USD
</td>
<td style="text-align:left;">
unemployment rate
</td>
<td style="text-align:left;">
129756
</td>
<td style="text-align:left;">
High Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, usually on the first friday after the month ends;
</td>
<td style="text-align:left;">
Percentage of the total work force that is unemployed and actively
seeking employment during the previous month;
</td>
<td style="text-align:right;">
3.9
</td>
<td style="text-align:right;">
3.7
</td>
<td style="text-align:right;">
3.9
</td>
<td style="text-align:right;">
0.2
</td>
<td style="text-align:right;">
-0.2
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Nov 2023
</td>
<td style="text-align:left;">
employment
</td>
</tr>
<tr>
<td style="text-align:left;">
2023-12-08
</td>
<td style="text-align:left;">
2023-12-08 16:00:00
</td>
<td style="text-align:left;">
USA
</td>
<td style="text-align:left;">
USD
</td>
<td style="text-align:left;">
prelim uom consumer sentiment
</td>
<td style="text-align:left;">
130448
</td>
<td style="text-align:left;">
High Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
There are 2 versions of this data released 14 days apart – Preliminary
and Revised. The Preliminary release is the earlier and thus tends to
have the most impact;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, around the middle of the current month;
</td>
<td style="text-align:left;">
Level of a composite index based on surveyed consumers;
</td>
<td style="text-align:right;">
62.0
</td>
<td style="text-align:right;">
69.4
</td>
<td style="text-align:right;">
61.3
</td>
<td style="text-align:right;">
-7.4
</td>
<td style="text-align:right;">
8.1
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Dec 2023
</td>
<td style="text-align:left;">
confidence
</td>
</tr>
<tr>
<td style="text-align:left;">
2023-12-08
</td>
<td style="text-align:left;">
2023-12-08 16:00:00
</td>
<td style="text-align:left;">
USA
</td>
<td style="text-align:left;">
USD
</td>
<td style="text-align:left;">
prelim uom inflation expectations
</td>
<td style="text-align:left;">
130447
</td>
<td style="text-align:left;">
Medium Impact Expected
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
There are 2 versions of this data released 14 days apart – Preliminary
and Revised. The Preliminary release is the earlier and thus tends to
have the most impact;
</td>
<td style="text-align:left;">
NA
</td>
<td style="text-align:left;">
released monthly, around the middle of the current month;
</td>
<td style="text-align:left;">
Percentage that consumers expect the price of goods and services to
change during the next 12 months;
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
3.1
</td>
<td style="text-align:right;">
4.5
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
-1.4
</td>
<td style="text-align:left;">
monthly
</td>
<td style="text-align:left;">
Dec 2023
</td>
<td style="text-align:left;">
inflation
</td>
</tr>
</tbody>
</table>

- Note that these data are protected by the
  [copyright](https://www.forexfactory.com/notices#copyrightof) of Fair
  Economy, Inc.
