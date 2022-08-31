library(testthat)
library(here)
library(data.table)
library(dataMojo)
library(magrittr)

testthat::test_that(
  "test pivot_percent_at function works properly", {
    test_dt <- data.table::data.table(
      Question = c(rep(1, 3), rep(2, 3), rep(3, 3)),
      Gender = c(rep("F", 4), rep("M", 5))
    )
    test_dt %>% dataMojo::pivot_percent_at(question_col = "Question", aggregated_by_cols = "Gender") %>%
      dplyr::pull(Question.rate2value2) %>%
      testthat::expect_equal( c(25, 40) )

  }
)


testthat::test_that(
  "test pivot_percent_at_multi function works properly", {
    test_dt <- data.table(
      Question1 = c(rep(1, 3), rep(2, 3), rep(3, 3)),
      Question2 = c(rep(1, 2), rep(2, 2), rep(3, 5)),
      Gender = c(rep("F", 4), rep("M", 5))
    )
    test_dt %>% dataMojo::pivot_percent_at_multi(question_col = c("Question1","Question2") , aggregated_by_cols = "Gender") %>%
      dplyr::pull(Question2.rate2value2) %>%
      testthat::expect_equal( c(50, 0) )


  }
)

testthat::test_that(
  "test row_percent_convert function works properly", {
    test_df <- data.frame(
      Group = c("A", "B", "C"),
      Female = c(2,3,5),
      Male = c(10,11, 13)
    )
    test_df %>% dataMojo::row_percent_convert(cols_rowsum = c("Female", "Male")) %>%
      dplyr::mutate(Female = round(Female, 2)) %>%
      dplyr::pull(Female) %>%
      testthat::expect_equal( c(0.17, 0.21, 0.28) )
  }
)
