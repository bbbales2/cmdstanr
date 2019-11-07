# Setup -------------------------------------------------------------------
NOT_CRAN <-
  identical(Sys.getenv("NOT_CRAN"), "true") ||
  identical(Sys.getenv("TRAVIS"), "true")

if (NOT_CRAN) {
  set_cmdstan_path("/home/bbales2/cmdstan-warmup")
  stan_program <- test_path("resources", "stan", "kilpisjarvi.stan")
  mod <- cmdstan_model(stan_file = stan_program, compile = TRUE)

  data_file <- test_path("resources", "data", "kilpisjarvi.dat")
}

expect_sample_output <- function(object) {
  testthat::expect_output(object, "Gradient evaluation took")
}

test_that("sample() method works with warmup arguments", {
  skip_on_cran()

  expect_sample_output(fit <- mod$sample(data = data_file,
                                         num_chains = 1,
                                         experimental = 1,
                                         metric = "dense_e",
                                         which_adaptation = 0))
  expect_is(fit, "CmdStanMCMC")
})
