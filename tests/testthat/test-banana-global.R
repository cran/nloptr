# Copyright (C) 2011 Jelmer Ypma. All Rights Reserved.
# This code is published under the L-GPL.
#
# File:   test-banana-global.R
# Author: Jelmer Ypma
# Date:   8 August 2011
#
# Example showing how to solve the Rosenbrock Banana function
# using a global optimization algorithm.
#
# Changelog:
#   27/10/2013: Changed example to use unit testing framework testthat.
#   12/12/2019: Corrected warnings and using updated testtthat framework (Avraham Adler)

test_that("Test Rosenbrock Banana optimization with global optimizer NLOPT_GD_MLSL.", {
  ## Rosenbrock Banana objective function
  eval_f <- function(x) {
    return(100 * (x[2] - x[1] * x[1]) ^ 2 + (1 - x[1]) ^ 2)
  }

  eval_grad_f <- function(x) {
    return(c(-400 * x[1] * (x[2] - x[1] * x[1]) - 2 * (1 - x[1]),
             200 * (x[2] - x[1] * x[1])))
  }

  # initial values
  x0 <- c(-1.2, 1)

  # lower and upper bounds
  lb <- c(-3, -3)
  ub <- c(3,  3)

  # Define optimizer options.
  local_opts <- list("algorithm" = "NLOPT_LD_LBFGS",
                     "xtol_rel"  = 1e-4)

  opts <- list("algorithm"   = "NLOPT_GD_MLSL",
               "maxeval"    = 10000,
               "population" = 4,
               "local_opts" = local_opts )

  # Solve Rosenbrock Banana function.
  res <- nloptr(
    x0          = x0,
    lb          = lb,
    ub          = ub,
    eval_f      = eval_f,
    eval_grad_f = eval_grad_f,
    opts        = opts)

  # Check results.
  expect_equal(res$objective, 0.0)
  expect_equal(res$solution, c(1.0, 1.0))
}
)

test_that("Test Rosenbrock Banana optimization with global optimizer NLOPT_GN_ISRES.", {
  ## Rosenbrock Banana objective function
  eval_f <- function(x) {
    return(100 * (x[2] - x[1] * x[1]) ^ 2 + (1 - x[1]) ^ 2)
  }

  eval_grad_f <- function(x) {
    return(c(-400 * x[1] * (x[2] - x[1] * x[1]) - 2 * (1 - x[1]),
             200 * (x[2] - x[1] * x[1])))
  }

  # initial values
  x0 <- c(-1.2, 1)

  # lower and upper bounds
  lb <- c(-3, -3)
  ub <- c(3,  3)

  # Define optimizer options.
  # For unit testing we want to set the random seed for replicability.
  opts <- list("algorithm"   = "NLOPT_GN_ISRES",
               "maxeval"     = 10000,
               "population"  = 100,
               "ranseed"     = 2718)

  # Solve Rosenbrock Banana function.
  res <- nloptr(
    x0     = x0,
    lb     = lb,
    ub     = ub,
    eval_f = eval_f,
    opts   = opts)

  # Check results.
  expect_equal(res$objective, 0.0, tolerance=1e-4)
  expect_equal(res$solution, c(1.0, 1.0), tolerance=1e-2)
}
)

test_that("Test Rosenbrock Banana optimization with global optimizer NLOPT_GN_CRS2_LM with random seed defined.", {
  ## Rosenbrock Banana objective function
  eval_f <- function(x) {
    return(100 * (x[2] - x[1] * x[1]) ^ 2 + (1 - x[1]) ^ 2)
  }

  eval_grad_f <- function(x) {
    return(c(-400 * x[1] * (x[2] - x[1] * x[1]) - 2 * (1 - x[1]),
             200 * (x[2] - x[1] * x[1])))
  }

  # initial values
  x0 <- c(-1.2, 1)

  # lower and upper bounds
  lb <- c(-3, -3)
  ub <- c(3,  3)

  # Define optimizer options.
  # For unit testing we want to set the random seed for replicability.
  opts <- list("algorithm"   = "NLOPT_GN_CRS2_LM",
               "maxeval"     = 10000,
               "population"  = 100,
               "ranseed"     = 2718)

  # Solve Rosenbrock Banana function.
  res1 <- nloptr(
    x0     = x0,
    lb     = lb,
    ub     = ub,
    eval_f = eval_f,
    opts   = opts)

  # Define optimizer options.
  # this optimization uses a different seed for the
  # random number generator and gives a different result
  opts <- list("algorithm"   = "NLOPT_GN_CRS2_LM",
               "maxeval"     = 10000,
               "population"  = 100,
               "ranseed"     = 3141)

  # Solve Rosenbrock Banana function.
  res2 <- nloptr(
    x0     = x0,
    lb     = lb,
    ub     = ub,
    eval_f = eval_f,
    opts   = opts)

  # Define optimizer options.
  # this optimization uses the same seed for the random
  # number generator and gives the same results as res2
  opts <- list("algorithm"   = "NLOPT_GN_CRS2_LM",
               "maxeval"     = 10000,
               "population"  = 100,
               "ranseed"     = 3141)

  # Solve Rosenbrock Banana function.
  res3 <- nloptr(
    x0     = x0,
    lb     = lb,
    ub     = ub,
    eval_f = eval_f,
    opts   = opts)

  # Check results.
  expect_equal(res1$objective, 0.0, tolerance = 1e-4)
  expect_equal(res1$solution, c(1.0, 1.0), tolerance = 1e-2)

  expect_equal(res2$objective, 0.0, tolerance = 1e-4)
  expect_equal(res2$solution, c(1.0, 1.0), tolerance = 1e-2)

  expect_equal(res3$objective, 0.0, tolerance = 1e-4)
  expect_equal(res3$solution, c(1.0, 1.0), tolerance = 1e-2)

  # Expect that the results are different for res1 and res2.
  expect_false(res1$objective == res2$objective)
  expect_false(all(res1$solution  == res2$solution))

  # Expect that the results are identical for res2 and res3.
  expect_identical(res2$objective, res3$objective)
  expect_identical(res2$solution, res3$solution)
}
)

