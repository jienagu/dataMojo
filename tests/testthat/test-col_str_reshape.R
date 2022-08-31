library(testthat)
library(here)
library(data.table)
library(dataMojo)

testthat::test_that(
  "test str_split_col function works properly", {
    data("dt_dates")
    dataMojo::str_split_col(dt_dates,
                            by_col = "Full_name",
                            by_pattern = ", ",
                            match_to_names = c("First Name", "Last Name")) %>%
      dplyr::pull(`First Name`) %>%
      testthat::expect_equal( c("Joe",   "Alex",  "David", "Julia", "Jessa") )

  }
)

testthat::test_that(
  "test str_split_col function works properly", {
    data("dt_dates")
    dataMojo::str_split_col(dt_dates,
                            by_col = "Full_name",
                            by_pattern = ", ") %>%
      dplyr::pull(`First Name`) %>%
      testthat::expect_equal( c("Joe",   "Alex",  "David", "Julia", "Jessa") )

  }
)

testthat::test_that(
  "test str_split_col function works properly", {
    data("dt_dates")
    expect_error(dataMojo::str_split_col(dt_dates,
                            by_col = "Start_Date",
                            by_pattern = "-",
                            match_to_names = c("year", "month", "day")),
                 "Hmm... Note that your by_col is a Date foramt, please convert to character and try again!")


  }
)

testthat::test_that(
  "test select_cols function works properly", {
    data("dt_dates")
    dt_dates <- setDT(dt_dates)
    dataMojo::select_cols(dt_dates, c("Start_Date", "Full_name")) %>%
      colnames() %>%
      testthat::expect_equal( c("Start_Date", "Full_name") )

  }
)

testthat::test_that(
  "test fill_NA_with function works properly", {
    data("dt_missing")
    dataMojo::fill_NA_with(dt_missing,
                           fill_cols = c("Full_name"),
                           fill_value = "pending") %>%
      dplyr::pull(Full_name) %>%
      testthat::expect_equal( c("pending",
                                "pending",
                                "David, Big",
                                "Julia, Joe",
                                "Jessa, Oliver") )

  }
)

testthat::test_that(
  "test fill_NA_with function works properly", {
    data("dt_missing")
    dataMojo::fill_NA_with(dt_missing[,"Full_name"],
                           fill_cols = "All",
                           fill_value = "pending") %>%
      dplyr::pull(Full_name) %>%
      testthat::expect_equal( c("pending",
                                "pending",
                                "David, Big",
                                "Julia, Joe",
                                "Jessa, Oliver") )

  }
)

testthat::test_that(
  "test reshape_longer function works properly", {
    data("dt_dates")
    dataMojo::reshape_longer(dt_dates,
                             keep_cols = "Full_name",
                             by_pattern = "Date",
                             label_cols = c("Date_Type"),
                             value_cols = "Exact_date",
                             fill_NA_with = NULL) %>%
      dplyr::pull(Exact_date) %>%
      testthat::expect_equal( as.Date(c("2019-05-01",
                                "2019-08-04",
                                "2019-07-05",
                                "2019-07-04",
                                "2019-04-27",
                                "2019-06-01",
                                "2019-08-09",
                                "2019-08-14",
                                "2019-07-05",
                                "2019-05-10") ) )

  }
)

testthat::test_that(
  "test reshape_longer function works properly", {
    data("dt_dates")
    dt_dates$Start_Date[1] <- NA
    dataMojo::reshape_longer(dt_dates,
                             keep_cols = "Full_name",
                             by_pattern = "Date",
                             label_cols = c("Date_Type"),
                             value_cols = "Exact_date",
                             fill_NA_with = as.Date("2020-01-01")) %>%
      dplyr::pull(Exact_date) %>%
      testthat::expect_equal( as.Date(c("2020-01-01",
                                        "2019-08-04",
                                        "2019-07-05",
                                        "2019-07-04",
                                        "2019-04-27",
                                        "2019-06-01",
                                        "2019-08-09",
                                        "2019-08-14",
                                        "2019-07-05",
                                        "2019-05-10") ) )

  }
)


testthat::test_that(
  "test reshape_wider function works properly", {
    data("dt_long")
    dataMojo::reshape_wider(dt_long,
                            keep_cols = c("Full_name"),
                            col_lable = c("Date_Type"),
                            col_value = "Exact_date") %>%
      dplyr::pull(Start_Date) %>%
      testthat::expect_equal( as.Date(c("2019-08-04",
                                        "2019-07-05",
                                        "2019-04-27",
                                        "2019-05-01",
                                        "2019-07-04") ) )

  }
)


testthat::test_that(
  "test filter_all function works properly", {
    data("dt_values")
    dataMojo::filter_all(dt_values, operator = "l", .2)%>%
      dplyr::pull(A1) %>%
      testthat::expect_equal(c(0.05785895,
                               0.01923819,
                               0.05195276,
                               0.05032699,
                               0.05952578,
                               0.18180095,
                               0.10973857) )

  }
)

testthat::test_that(
  "test filter_all function works properly", {
    data("dt_values")
    dataMojo::filter_all(dt_values, operator = "g", .2)%>%
      dplyr::pull(A1)  %>% mean() %>%
      testthat::expect_equal(c(0.5951317) )

  }
)

testthat::test_that(
  "test filter_all function works properly", {
    data("dt_values")
    expect_error(dataMojo::filter_all(dt_values, operator = "greater", .2),
                 "operator should be one of l, g.
         l means less than, g means greater than!")

  }
)




testthat::test_that(
  "test filter_any function works properly", {
    data("dt_values")
    dataMojo::filter_any(dt_values, operator = "l", .1)%>%
      dplyr::pull(A1) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.37) )

  }
)

testthat::test_that(
  "test filter_any function works properly", {
    data("dt_values")
    dataMojo::filter_any(dt_values, operator = "g", .1)%>%
      dplyr::pull(A1) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.49) )

  }
)

testthat::test_that(
  "test filter_any function works properly", {
    data("dt_values")
    expect_error(dataMojo::filter_any(dt_values, operator = "greater", .1),
                 "operator should be one of l, g.
         l means less than, g means greater than!")

  }
)

testthat::test_that(
  "test filter_any_at function works properly", {
    data("dt_values")
    dataMojo::filter_any_at(dt_values, operator = "l", .1, c("A1", "A2"))%>%
      dplyr::pull(A1) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.3) )

  }
)

testthat::test_that(
  "test filter_any_at function works properly", {
    data("dt_values")
    dataMojo::filter_any_at(dt_values, operator = "g", .1, c("A1", "A2"))%>%
      dplyr::pull(A1) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.5) )

  }
)

testthat::test_that(
  "test filter_any function works properly", {
    data("dt_values")
    expect_error(dataMojo::filter_any_at(dt_values, operator = "greater", .1, c("A1", "A2")),
                 "operator should be one of l, or g.
         l means less than, g means greater than!")

  }
)

testthat::test_that(
  "test filter_all_at function works properly", {
    data("dt_values")
    dataMojo::filter_all_at(dt_values, operator = "l", .1, c("A1", "A2")) %>%
      dplyr::pull(A1) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.04) )

  }
)

testthat::test_that(
  "test filter_all_at function works properly", {
    data("dt_values")
    dataMojo::filter_all_at(dt_values, operator = "g", .1, c("A1", "A2")) %>%
      dplyr::pull(A1) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.54) )

  }
)

testthat::test_that(
  "test filter_all_at function works properly", {
    data("dt_values")
    expect_error(dataMojo::filter_all_at(dt_values, operator = "greater", .1, c("A1", "A2")),
                 "operator should be one of l, or g.
         l means less than, g means greater than!")

  }
)

testthat::test_that(
  "test dt_group_by function works properly", {
    data("dt_groups")
    dataMojo::dt_group_by(dt_groups,
                          group_by_cols = c("group1", "group2"),
                          summarize_at = "A1",
                          operation = "mean") %>%
      dplyr::pull(summary_col) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.5) )

  }
)

testthat::test_that(
  "test dt_group_by function works properly", {
    data("dt_groups")
    dataMojo::dt_group_by(dt_groups,
                          group_by_cols = c("group1", "group2"),
                          summarize_at = "A1",
                          operation = "sum") %>%
      dplyr::pull(summary_col) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(50.15) )

  }
)

testthat::test_that(
  "test dt_group_by function works properly", {
    data("dt_groups")
    dataMojo::dt_group_by(dt_groups,
                          group_by_cols = c("group1", "group2"),
                          summarize_at = "A1",
                          operation = "median") %>%
      dplyr::pull(summary_col) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.51) )

  }
)

testthat::test_that(
  "test dt_group_by function works properly", {
    data("dt_groups")
    dataMojo::dt_group_by(dt_groups,
                          group_by_cols = c("group1", "group2"),
                          summarize_at = "A1",
                          operation = "max") %>%
      dplyr::pull(summary_col) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.99) )

  }
)


testthat::test_that(
  "test dt_group_by function works properly", {
    data("dt_groups")
    dataMojo::dt_group_by(dt_groups,
                          group_by_cols = c("group1", "group2"),
                          summarize_at = "A1",
                          operation = "min") %>%
      dplyr::pull(summary_col) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.01) )

  }
)

testthat::test_that(
  "test dt_group_by function works properly", {
    data("dt_groups")
    expect_error(dataMojo::dt_group_by(dt_groups,
                          group_by_cols = c("group1", "group2"),
                          summarize_at = "A1",
                          operation = "m"),
                 "Hmm... operation should be one of sum, mean, median, max and min!")

  }
)


testthat::test_that(
  "test get_row_group_by function works properly", {
    data("dt_groups")
    dataMojo::get_row_group_by(dt_groups,
                               group_by_cols = c("group1", "group2"),
                               fetch_row = "first") %>%
      dplyr::pull(A1) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.58) )

  }
)

testthat::test_that(
  "test get_row_group_by function works properly", {
    data("dt_groups")
    dataMojo::get_row_group_by(dt_groups,
                               group_by_cols = c("group1", "group2"),
                               fetch_row = "last") %>%
      dplyr::pull(A1) %>% mean() %>% round(2) %>%
      testthat::expect_equal(c(0.49) )

  }
)

testthat::test_that(
  "test get_row_group_by function works properly", {
    data("dt_groups")
    expect_error(dataMojo::get_row_group_by(dt_groups,
                               group_by_cols = c("group1", "group2"),
                               fetch_row = "random"),
                 "Hmm... fetch_row should be either first or last!")

  }
)

testthat::test_that(
  "test row_expand_pattern function works properly", {
    data("starwars_simple")
    row_expand_pattern(starwars_simple, "films", ", ", "film")[] %>%
      dplyr::pull(film) %>%
      testthat::expect_equal(c("The Empire Strikes Back",
                               "Revenge of the Sith",
                               "Return of the Jedi",
                                "A New Hope",
                               "The Force Awakens",
                               "The Empire Strikes Back",
                                "Attack of the Clones",
                               "The Phantom Menace",
                               "Revenge of the Sith",
                               "Return of the Jedi",
                               "A New Hope") )

  }
)


testthat::test_that(
  "test row_expand_dates  function works properly", {
    dt_dates_simple <- data.table(
      Start_Date = as.Date(c("2020-02-03", "2020-03-01") ),
      End_Date = as.Date(c("2020-02-05", "2020-03-02") ),
      group = c("A", "B")
    )
    row_expand_dates(dt_dates_simple, "Start_Date", "End_Date", "Date")[] %>%
      dplyr::pull(Date) %>%
      testthat::expect_equal(as.Date(c("2020-02-03",
                               "2020-02-04",
                               "2020-02-05",
                               "2020-03-01",
                               "2020-03-02"))  )

  }
)
