# Copyright (C) 201 Jelmer Ypma. All Rights Reserved.
# This code is published under the L-GPL.
#
# File:   test-derivative-checker.R
# Author: Jelmer Ypma
# Date:   24 July 2010
#
# Example showing results of the derivative checker.
#
# Changelog:
#   27/10/2013: Changed example to use unit testing framework testthat.
#   12/12/2019: Corrected warnings and using updated testtthat framework (Avraham Adler)
test_that("Test derivative checker.", {
    # Define objective function.
    f <- function(x, a) {
      sum((x - a )^2)
    }

    # Define gradient function without errors.
    f_grad <- function(x, a) {
      2 * (x - a)
    }

    # Generated a using:
    # > set.seed(3141)
    # > a = runif(10)
    a <- c(0.754995959345251, 0.964991861954331, 0.0414307734463364, 0.42781219445169,  0.6517094373703,
           0.838369226781651, 0.774285392835736, 0.531992698321119,  0.768715722020715, 0.785174649208784)
    res <- suppressMessages(check.derivatives(
      .x = 1:10,
      func = f,
      func_grad = f_grad,
      check_derivatives_print = 'none',
      a = a
    ))
    expect_equal(sum(res$flag_derivative_warning), 0)

    # Define gradient function with 1 error.
    f_grad <- function(x, a) {
      2 * (x - a) + c(0, .1, rep(0, 8))
    }

    res <- suppressMessages(check.derivatives(
      .x = 1:10,
      func = f,
      func_grad = f_grad,
      check_derivatives_print = 'none',
      a = a
    ))
    expect_equal(sum(res$flag_derivative_warning), 1)

    # Define objective function.
    g <- function(x, a) {
      c(sum(x - a), sum((x - a)^2))
    }

    # Define gradient function with 2 errors.
    g_grad <- function(x, a) {
      rbind(rep(1, length(x)) + c(0, .01, rep(0, 8)), 2 * (x - a) + c(0, .1, rep(0, 8)))
    }

    res <- suppressMessages(check.derivatives(
      .x = 1:10,
      func = g,
      func_grad = g_grad,
      check_derivatives_print = 'none',
      a = a
    ))
    expect_equal(sum(res$flag_derivative_warning), 2)
})
