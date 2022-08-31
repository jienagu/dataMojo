
<!-- README.md is generated from README.Rmd. Please edit that file -->

# dataMojo

<!-- badges: start -->
<!-- badges: end -->

* Installation

```
library(devtools)
devtools::install_github("jienagu/dataMojo")
```
Note: on its way to CRAN

Built on the top of data.table, `dataMojo` is a grammar of data
manipulation with data.table, providing a consistent a series of utility
functions that help you solve the most common data manipulation
challenges:

-   Calculate the row wise percentage
-   Calculate the survey type percentage table
-   Calculate the column wise percentage with desired numerator and
    denominator
-   Select columns
-   Split one column to multiple columns based on patterns
-   Filter cases based on their values
-   Fill missing values
-   Summarize and reduces multiple values down to a single summary
-   Reshape `long to wide` or `wide to long`

## Calculate the row wise percentage

Calculate the row wise percentage of a frequency table

``` r
library(dataMojo)
library(data.table)
test_df <- data.frame(
      Group = c("A", "B", "C"),
      Female = c(2,3,5),
      Male = c(10,11, 13)
    )
print(test_df)
#>   Group Female Male
#> 1     A      2   10
#> 2     B      3   11
#> 3     C      5   13
dataMojo::row_percent_convert(test_df, cols_rowsum = c("Female", "Male"))
#>   Group    Female      Male
#> 1     A 0.1666667 0.8333333
#> 2     B 0.2142857 0.7857143
#> 3     C 0.2777778 0.7222222
```

## Calculate the survey type percentage table for *single* question

``` r
library(dataMojo)
library(data.table)
   test_dt <- data.table::data.table(
      Question = c(rep("Good", 3), rep("OK", 3), rep("Bad", 3)),
      Gender = c(rep("F", 4), rep("M", 5))
    )
   print(test_dt)
#>    Question Gender
#> 1:     Good      F
#> 2:     Good      F
#> 3:     Good      F
#> 4:       OK      F
#> 5:       OK      M
#> 6:       OK      M
#> 7:      Bad      M
#> 8:      Bad      M
#> 9:      Bad      M
   dataMojo::pivot_percent_at(test_dt, 
                                 question_col = "Question", aggregated_by_cols = "Gender")
#>    Gender Question.total Question.rate1valueGood Question.rate2valueOK
#> 1:      F              4                      75                    25
#> 2:      M              5                       0                    40
#>    Question.rate3valueBad Question.count1valueGood Question.count2valueOK
#> 1:                      0                        3                      1
#> 2:                     60                        0                      2
#>    Question.count3valueBad
#> 1:                       0
#> 2:                       3
```

## Calcuate the survey type percentage table for *multiple* question

``` r
library(dataMojo)
library(data.table)
test_dt <- data.table(
      Question1 = c(rep("Good", 3), rep("OK", 3), rep("Bad", 3)),
      Question2 = c(rep("Good", 2), rep("OK", 2), rep("Bad", 5)),
      Gender = c(rep("F", 4), rep("M", 5))
    )
print(test_dt)
#>    Question1 Question2 Gender
#> 1:      Good      Good      F
#> 2:      Good      Good      F
#> 3:      Good        OK      F
#> 4:        OK        OK      F
#> 5:        OK       Bad      M
#> 6:        OK       Bad      M
#> 7:       Bad       Bad      M
#> 8:       Bad       Bad      M
#> 9:       Bad       Bad      M
dataMojo::pivot_percent_at_multi(test_dt, 
                                    question_col = c("Question1","Question2") , aggregated_by_cols = "Gender") 
#>    Gender Question1.total Question1.rate1valueGood Question1.rate2valueOK
#> 1:      F               4                       75                     25
#> 2:      M               5                        0                     40
#>    Question1.rate3valueBad Question1.count1valueGood Question1.count2valueOK
#> 1:                       0                         3                       1
#> 2:                      60                         0                       2
#>    Question1.count3valueBad Question2.total Question2.rate1valueGood
#> 1:                        0               4                       50
#> 2:                        3               5                        0
#>    Question2.rate2valueOK Question2.rate3valueBad Question2.count1valueGood
#> 1:                     50                       0                         2
#> 2:                      0                     100                         0
#>    Question2.count2valueOK Question2.count3valueBad
#> 1:                       2                        0
#> 2:                       0                        5
```

## Calculate the column wise percentage with desired numerator and denominator

This function is to calculate column-wise percentage in a new column
with desired numerator columns and denominator columns. If denominator
is 0, the percentage will be `N/A`.

``` r
library(dataMojo)
test_df <- data.frame(
      hc1 = c(2, 0, 1, 5, 6, 7, 10),
      hc2 = c(1, 0, 10, 12, 4, 1, 9 ),
      total = c(10, 2, 0, 39, 23, 27, 30)
    )
print(test_df)
#>   hc1 hc2 total
#> 1   2   1    10
#> 2   0   0     2
#> 3   1  10     0
#> 4   5  12    39
#> 5   6   4    23
#> 6   7   1    27
#> 7  10   9    30
dataMojo::col_cal_percent(test_df, 
                          new_col_name = "hc_percentage", 
                          numerator_cols = c("hc1", "hc2"), 
                          denominator_cols = "total"
                          ) 
#>   hc1 hc2 total hc_percentage
#> 1   2   1    10           30%
#> 2   0   0     2            0%
#> 3   1  10     0           N/A
#> 4   5  12    39           44%
#> 5   6   4    23           43%
#> 6   7   1    27           30%
#> 7  10   9    30           63%
```

## Select columns

Select variables in a data table. You can also use predicate functions
like is.numeric to select variables based on their properties (e.g. 1:3
selects the first column to the third column).

``` r
library(dataMojo)
library(data.table)
data("dt_dates")
dt_dates <- setDT(dt_dates)
dataMojo::select_cols(dt_dates, c("Start_Date", "Full_name"))
#>    Start_Date      Full_name
#> 1: 2019-05-01     Joe, Smith
#> 2: 2019-08-04 Alex, Robinson
#> 3: 2019-07-05     David, Big
#> 4: 2019-07-04     Julia, Joe
#> 5: 2019-04-27  Jessa, Oliver
```

## Split a column

Split a column with its special pattern, and assign to multiple columns
respectively. For example, split full name column to first name and last
name column.

``` r
data("dt_dates")
library(data.table)
data("dt_dates")
dataMojo::str_split_col(dt_dates,
              by_col = "Full_name",
              by_pattern = ", ",
              match_to_names = c("First Name", "Last Name"))
#>    Start_Date   End_Date      Full_name First Name Last Name
#> 1: 2019-05-01 2019-06-01     Joe, Smith        Joe     Smith
#> 2: 2019-08-04 2019-08-09 Alex, Robinson       Alex  Robinson
#> 3: 2019-07-05 2019-08-14     David, Big      David       Big
#> 4: 2019-07-04 2019-07-05     Julia, Joe      Julia       Joe
#> 5: 2019-04-27 2019-05-10  Jessa, Oliver      Jessa    Oliver
```

## Filter cases based on values

`filter_all()` is to return a data table with **ALL** columns (greater
than/ less than/ equal to) a desired value.

``` r
data("dt_values")
dataMojo::filter_all(dt_values, operator = "l", .2)
#>            A1         A2          A3
#> 1: 0.05785895 0.12946847 0.087393370
#> 2: 0.01923819 0.01278740 0.098913282
#> 3: 0.05195276 0.19132992 0.106693512
#> 4: 0.05032699 0.14571596 0.078407153
#> 5: 0.05952578 0.14576162 0.111872945
#> 6: 0.18180095 0.03566878 0.047573949
#> 7: 0.10973857 0.14381518 0.001265888
```

`filter_any()` is to return a data table with **ANY** columns (greater
than/ less than/ equal to) a desired value.

``` r
data("dt_values")
dataMojo::filter_any(dt_values, operator = "l", .1)
#>                A1          A2         A3
#>   1: 0.0005183129 0.785432329 0.33682885
#>   2: 0.5106083730 0.089597210 0.35534382
#>   3: 0.0140479084 0.754373487 0.68909671
#>   4: 0.0646897766 0.659908085 0.33536504
#>   5: 0.0864958912 0.824531891 0.67044835
#>  ---                                    
#> 258: 0.0368269614 0.781635831 0.68857844
#> 259: 0.4405581164 0.008710776 0.06723523
#> 260: 0.0147206911 0.600409490 0.68254910
#> 261: 0.0277955788 0.508650963 0.28767138
#> 262: 0.9901734111 0.890964948 0.09758119
```

Similarly, `filter_all_at()` is to return a data table with **ALL
selected** columns (greater than/ less than/ equal to) a desired value.

``` r
data("dt_values")
dataMojo::filter_all_at(dt_values, operator = "l", .1, c("A1", "A2"))
#>            A1         A2         A3
#> 1: 0.01923819 0.01278740 0.09891328
#> 2: 0.01134451 0.04448781 0.83378764
#> 3: 0.05962021 0.04581089 0.60585367
#> 4: 0.06966295 0.08512458 0.67216791
#> 5: 0.04913060 0.08084439 0.53249534
#> 6: 0.03235521 0.08765999 0.71016331
```

Similarly, `filter_any_at()` is to return a data table with **ANY
selected** columns (greater than/ less than/ equal to) a desired value.

``` r
data("dt_values")
dataMojo::filter_any_at(dt_values, operator = "l", .1, c("A1", "A2"))
#>                A1          A2         A3
#>   1: 0.0005183129 0.785432329 0.33682885
#>   2: 0.5106083730 0.089597210 0.35534382
#>   3: 0.0140479084 0.754373487 0.68909671
#>   4: 0.0646897766 0.659908085 0.33536504
#>   5: 0.0864958912 0.824531891 0.67044835
#>  ---                                    
#> 183: 0.0158175936 0.416905575 0.79278071
#> 184: 0.0368269614 0.781635831 0.68857844
#> 185: 0.4405581164 0.008710776 0.06723523
#> 186: 0.0147206911 0.600409490 0.68254910
#> 187: 0.0277955788 0.508650963 0.28767138
```

## Fill missing values

`fill_NA_with()` will fill NA value with a desired value in the selected
columns. If `fill_cols` is `All` (same columns type), it will apply to
the whole data table.

``` r
data("dt_missing")
dataMojo::fill_NA_with(dt_missing, fill_cols = c("Full_name"), fill_value = "pending")
#>    Start_Date   End_Date     Full_name
#> 1:       <NA> 2019-06-01       pending
#> 2: 2019-08-04 2019-08-09       pending
#> 3: 2019-07-05 2019-08-14    David, Big
#> 4: 2019-07-04 2019-07-05    Julia, Joe
#> 5: 2019-04-27 2019-05-10 Jessa, Oliver
```

## Group by and summarize

`dt_group_by()` is to group by desired columns and summarize rows within
groups.

``` r
data("dt_groups")
print(head(dt_groups))
#>           A1        A2 group2 group1
#> 1: 0.6312317 0.5596497      1      1
#> 2: 0.9343597 0.8214651      2      2
#> 3: 0.1394824 0.7866118      3      3
#> 4: 0.8566525 0.1973685      4      4
#> 5: 0.9658633 0.6671387      5      5
#> 6: 0.4725889 0.3767837      1      6
```

Now we see the `dt_groups` data table has A1, A2 as numeric columns, and
group1, group2 as group infomation.

``` r
data("dt_groups")
dataMojo::dt_group_by(dt_groups, 
            group_by_cols = c("group1", "group2"), 
            summarize_at = "A1", 
            operation = "mean")
#>     group1 group2 summary_col
#>  1:      1      1   0.4953336
#>  2:      2      2   0.4948892
#>  3:      3      3   0.5314195
#>  4:      4      4   0.4958035
#>  5:      5      5   0.4825304
#>  6:      6      1   0.5213521
#>  7:      7      2   0.5305957
#>  8:      8      3   0.4768201
#>  9:      9      4   0.4855223
#> 10:     10      5   0.5002411
```

Now we want to group by group1 and group2, then fetch the first within
each group, we can use `get_row_group_by()` function.

``` r
data("dt_groups")
dataMojo::get_row_group_by(dt_groups, 
                 group_by_cols = c("group1", "group2"), 
                 fetch_row = "first")
#>     group1 group2        A1        A2
#>  1:      1      1 0.6312317 0.5596497
#>  2:      2      2 0.9343597 0.8214651
#>  3:      3      3 0.1394824 0.7866118
#>  4:      4      4 0.8566525 0.1973685
#>  5:      5      5 0.9658633 0.6671387
#>  6:      6      1 0.4725889 0.3767837
#>  7:      7      2 0.3530244 0.6344632
#>  8:      8      3 0.2041025 0.7531322
#>  9:      9      4 0.8718080 0.6506606
#> 10:     10      5 0.3357608 0.9362194
```

or last row with same example.

``` r
data("dt_groups")
dataMojo::get_row_group_by(dt_groups, 
                 group_by_cols = c("group1", "group2"), 
                 fetch_row = "last")
#>     group1 group2         A1          A2
#>  1:      1      1 0.17294752 0.063375355
#>  2:      2      2 0.54620192 0.464936862
#>  3:      3      3 0.76486138 0.733507319
#>  4:      4      4 0.33303746 0.448011979
#>  5:      5      5 0.10455568 0.007968041
#>  6:      6      1 0.39483556 0.036755550
#>  7:      7      2 0.89792830 0.397020292
#>  8:      8      3 0.94427852 0.647780578
#>  9:      9      4 0.08840417 0.885425312
#> 10:     10      5 0.66508247 0.571804764
```

#### Comparison of dataMojo VS dplyr

``` r
set.seed(42)
test_dt <- data.table(
  A1 = runif(100000),
  B  = rep(1:1000,100),
  C  = rep(1:10,10000)
)

test_df <- data.frame(test_dt)
library(dplyr)
dataMojo_test <- function(){
  dataMojo::dt_group_by(test_dt, 
                       group_by_cols = c("B", "C"), 
                       summarize_at = "A1", 
                       operation = "mean")
}

dplyr_test <- function(){
  test_df %>% 
    dplyr::group_by(B, C) %>% 
    dplyr::summarise(A1= mean(A1))
}

library(microbenchmark)
library(ggplot2)
res_group <- microbenchmark(dataMojo_test(), dplyr_test(), times=100)
print(res_group)
#> Unit: milliseconds
#>             expr       min        lq      mean   median       uq      max neval
#>  dataMojo_test()  8.572514  8.938133  9.955206 10.23776 10.50295 14.84698   100
#>     dplyr_test() 16.799548 17.337491 18.640498 17.78099 18.70153 33.64926   100
ggplot2::autoplot(res_group)
```

<img src="man/figures/README-comp-1.png" width="100%" />

## Reshape `long to wide` or `wide to long`

Here is an example of reshaping a data table from wide to long.

``` r
data("dt_dates")
print(head(dt_dates))
#>    Start_Date   End_Date      Full_name First Name Last Name
#> 1: 2019-05-01 2019-06-01     Joe, Smith        Joe     Smith
#> 2: 2019-08-04 2019-08-09 Alex, Robinson       Alex  Robinson
#> 3: 2019-07-05 2019-08-14     David, Big      David       Big
#> 4: 2019-07-04 2019-07-05     Julia, Joe      Julia       Joe
#> 5: 2019-04-27 2019-05-10  Jessa, Oliver      Jessa    Oliver
dataMojo::reshape_longer(dt_dates, 
               keep_cols = "Full_name", 
               by_pattern = "Date", 
               label_cols = c("Date_Type"), 
               value_cols = "Exact_date", 
               fill_NA_with = NULL)
#>          Full_name  Date_Type Exact_date
#>  1:     Joe, Smith Start_Date 2019-05-01
#>  2: Alex, Robinson Start_Date 2019-08-04
#>  3:     David, Big Start_Date 2019-07-05
#>  4:     Julia, Joe Start_Date 2019-07-04
#>  5:  Jessa, Oliver Start_Date 2019-04-27
#>  6:     Joe, Smith   End_Date 2019-06-01
#>  7: Alex, Robinson   End_Date 2019-08-09
#>  8:     David, Big   End_Date 2019-08-14
#>  9:     Julia, Joe   End_Date 2019-07-05
#> 10:  Jessa, Oliver   End_Date 2019-05-10
```

Here is an example of reshaping a data table from long to wide.

``` r
data("dt_long")
print(head(dt_long))
#>         Full_name  Date_Type Exact_date
#> 1:     Joe, Smith Start_Date 2019-05-01
#> 2: Alex, Robinson Start_Date 2019-08-04
#> 3:     David, Big Start_Date 2019-07-05
#> 4:     Julia, Joe Start_Date 2019-07-04
#> 5:  Jessa, Oliver Start_Date 2019-04-27
#> 6:     Joe, Smith   End_Date 2019-06-01
dataMojo::reshape_wider(dt_long, 
              keep_cols = c("Full_name"), 
              col_lable = c("Date_Type"), 
              col_value = "Exact_date")
#>         Full_name Start_Date   End_Date
#> 1: Alex, Robinson 2019-08-04 2019-08-09
#> 2:     David, Big 2019-07-05 2019-08-14
#> 3:  Jessa, Oliver 2019-04-27 2019-05-10
#> 4:     Joe, Smith 2019-05-01 2019-06-01
#> 5:     Julia, Joe 2019-07-04 2019-07-05
```

## Advanced Topic: expand row based on pattern

`row_expand_pattern()` is to expand rows based on a desired column.

``` r
data("starwars_simple")
starwars_simple[]
#>                                                                                                                     films
#> 1:                        The Empire Strikes Back, Revenge of the Sith, Return of the Jedi, A New Hope, The Force Awakens
#> 2: The Empire Strikes Back, Attack of the Clones, The Phantom Menace, Revenge of the Sith, Return of the Jedi, A New Hope
#>              name height skin_color eye_color    gender
#> 1: Luke Skywalker    172       fair      blue masculine
#> 2:          C-3PO    167       gold    yellow masculine
row_expand_pattern(starwars_simple, "films", ", ", "film")[]
#>               name height skin_color eye_color    gender
#>  1: Luke Skywalker    172       fair      blue masculine
#>  2: Luke Skywalker    172       fair      blue masculine
#>  3: Luke Skywalker    172       fair      blue masculine
#>  4: Luke Skywalker    172       fair      blue masculine
#>  5: Luke Skywalker    172       fair      blue masculine
#>  6:          C-3PO    167       gold    yellow masculine
#>  7:          C-3PO    167       gold    yellow masculine
#>  8:          C-3PO    167       gold    yellow masculine
#>  9:          C-3PO    167       gold    yellow masculine
#> 10:          C-3PO    167       gold    yellow masculine
#> 11:          C-3PO    167       gold    yellow masculine
#>                        film
#>  1: The Empire Strikes Back
#>  2:     Revenge of the Sith
#>  3:      Return of the Jedi
#>  4:              A New Hope
#>  5:       The Force Awakens
#>  6: The Empire Strikes Back
#>  7:    Attack of the Clones
#>  8:      The Phantom Menace
#>  9:     Revenge of the Sith
#> 10:      Return of the Jedi
#> 11:              A New Hope
```

## Advanced Topic: expand row given start and end dates

`row_expand_dates()` is to expand rows to each date given start and end
dates.

``` r
dt_dates_simple <- data.table(
  Start_Date = as.Date(c("2020-02-03", "2020-03-01") ),
  End_Date = as.Date(c("2020-02-05", "2020-03-02") ),
  group = c("A", "B")
)
dt_dates_simple[]
#>    Start_Date   End_Date group
#> 1: 2020-02-03 2020-02-05     A
#> 2: 2020-03-01 2020-03-02     B
row_expand_dates(dt_dates_simple, "Start_Date", "End_Date", "Date")[]
#>    Start_Date   End_Date group       Date
#> 1: 2020-02-03 2020-02-05     A 2020-02-03
#> 2: 2020-02-03 2020-02-05     A 2020-02-04
#> 3: 2020-02-03 2020-02-05     A 2020-02-05
#> 4: 2020-03-01 2020-03-02     B 2020-03-01
#> 5: 2020-03-01 2020-03-02     B 2020-03-02
```
