context("model-sample-metric")

if (not_on_cran()) {
  set_cmdstan_path()
  mod <- cmdstan_model(stan_file = beroulli_example_file())
  data_list <- bernoulli_example_data()
}

test_that("sample() method works with provided inv_metrics", {
  skip_on_cran()

  inv_metric_vector <- array(1, dim = c(1))
  inv_metric_matrix <- matrix(1, nrow = 1, ncol = 1)

  inv_metric_vector_json <- test_path("resources", "metric", "bernoulli.inv_metric.diag_e.json")
  inv_metric_matrix_json <- test_path("resources", "metric", "bernoulli.inv_metric.dense_e.json")

  inv_metric_vector_r <- test_path("resources", "metric", "bernoulli.inv_metric.diag_e.data.R")
  inv_metric_matrix_r <- test_path("resources", "metric", "bernoulli.inv_metric.dense_e.data.R")

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 1,
                                           metric = "diag_e",
                                           inv_metric = inv_metric_vector))

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 1,
                                           metric = "dense_e",
                                           inv_metric = inv_metric_matrix))

  expect_sample_output(fit_json <- mod$sample(data = data_list,
                                              num_chains = 1,
                                              metric = "diag_e",
                                              metric_file = inv_metric_vector_json))

  expect_sample_output(fit_json <- mod$sample(data = data_list,
                                              num_chains = 1,
                                              metric = "dense_e",
                                              metric_file = inv_metric_matrix_json))

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 1,
                                           metric = "diag_e",
                                           metric_file = inv_metric_vector_r))

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 3,
                                           num_cores = 2,
                                           metric = "dense_e",
                                           metric_file = inv_metric_matrix_r))
})


test_that("sample() method works with lists of inv_metrics", {
  skip_on_cran()

  inv_metric_vector <- array(1, dim = c(1))
  inv_metric_vector_json <- test_path("resources", "metric", "bernoulli.inv_metric.diag_e.json")

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 1,
                                           metric = "diag_e",
                                           inv_metric = list(inv_metric_vector)))

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 2,
                                           metric = "diag_e",
                                           inv_metric = list(inv_metric_vector, inv_metric_vector)))

  expect_error(fit_r <- mod$sample(data = data_list,
                                   num_chains = 3,
                                   num_cores = 2,
                                   metric = "diag_e",
                                   inv_metric = list(inv_metric_vector, inv_metric_vector)),
               "2 metric\\(s\\) provided. Must provide 1 or 3 metric\\(s\\) for 3 chain\\(s\\)")

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 1,
                                           metric = "diag_e",
                                           metric_file = list(inv_metric_vector_json)))

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 2,
                                           metric = "diag_e",
                                           metric_file = list(inv_metric_vector_json, inv_metric_vector_json)))

  expect_sample_output(fit_r <- mod$sample(data = data_list,
                                           num_chains = 2,
                                           metric = "diag_e",
                                           metric_file = c(inv_metric_vector_json, inv_metric_vector_json)))

  expect_error(fit_r <- mod$sample(data = data_list,
                                   num_chains = 3,
                                   num_cores = 2,
                                   metric = "diag_e",
                                   metric_file = c(inv_metric_vector_json, inv_metric_vector_json)),
               "2 metric\\(s\\) provided. Must provide 1 or 3 metric\\(s\\) for 3 chain\\(s\\)")
})

test_that("sample() method fails if metric_file and inv_metric both provided", {
  skip_on_cran()

  inv_metric_vector <- array(1, dim = c(1))
  inv_metric_vector_json <- test_path("resources", "metric", "bernoulli.inv_metric.diag_e.json")

  expect_error(mod$sample(data = data_file_r,
                          num_chains = 1,
                          metric = "diag_e",
                          inv_metric = inv_metric_vector,
                          metric_file = inv_metric_vector_json),
               "Only one of inv_metric and metric_file can be specified")
})
