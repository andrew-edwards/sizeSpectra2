# Test MLEbin related fitting and plotting (better than doing them separately,
# to have all on one place).

test_that("MLEbin fitting and plotting works and matches original results", {

  # For MLEbin, from the fit-data.html vignette:
  res_mlebin <- fit_size_spectrum(sim_vec_binned)

  sim_vec_binned_misnamed <- sim_vec_binned
  names(sim_vec_binned_misnamed) <- c("bish_bash", "bin_max", "bin_count")
  expect_error(fit_size_spectrum(sim_vec_binned_misnamed))

  expect_equal(res_mlebin$b_mle,
               -2.03502861)

  expect_equal(fit_size_spectrum(sim_vec_binned,
                                 x_min = 1.5)$b_mle,
               -1.98307875)

  expect_equal(fit_size_spectrum(sim_vec_binned,
                                 x_max = 200,
                                 b_start = -1)$b_mle,
               -2.02285708)

  expect_error(fit_size_spectrum(sim_vec_binned,
                                 x_min = 20,
                                 x_max = 15))

  sim_vec_binned_2 <- sim_vec_binned    # test error for x_min = min(bin_min)
  sim_vec_binned_2[1,"bin_min"] <- 0
  expect_error(fit_size_spectrum(sim_vec_binned_2))
  expect_error(fit_size_spectrum(sim_vec_binned_2,
                                 x_min = 0))    # different error to previous

  expect_error(fit_size_spectrum(sim_vec_binned,
                                 strata = "hello"))
  expect_invisible(plot(res_mlebin))
  expect_invisible(plot(res_mlebin,
                        style = "both_y_axes",
                        rect_border_col = "red",
                        show_fit_on_top = FALSE))
  expect_invisible(plot(res_mlebin,
                        style = "biomass"))
  expect_invisible(plot(res_mlebin,
                        style = "biomass_and_log"))


  # Zero count in first bin, this currently passes but should fail if I fix the
  # function (see TODO's in it).
  sim_vec_binned_zero <- sim_vec_binned
  sim_vec_binned_zero[1, "bin_count"] <- 0
  expect_error(fit_size_spectrum(sim_vec_binned_zero))



  # MLEbin determine x_min:
  sim_vec_binned_2 <- sim_vec_binned
  sim_vec_binned_2[1, "bin_count"] <- 100  # lower count for first bin

  res_binned_2 <- determine_xmin_and_fit_mlebin(sim_vec_binned_2)

  expect_equal(res_binned_2$mlebin_fit$b_mle,
               -1.98307875)

  expect_invisible(plot(res_binned_2))

  expect_error(determine_xmin_and_fit_mlebin(sim_vec_binned[-4, ]))

  # TODO need some outlier detection here?

  expect_equal(make_hist(1:10)$breaks[10],
               10)

  expect_equal(make_hist(c(10.6, 10.8, 14),
                         bin_width = 0.5)$breaks[1],
               10.5)

  # Check what happens when only one bin gets fit
  sim_vec_binned_3 <- sim_vec_binned
  sim_vec_binned_3[9, "bin_count"] <- 1000000  # big count for last bin (gets normalised)

  expect_error(determine_xmin_and_fit_mlebin(sim_vec_binned_3))

  # And it should still run if end up with only two bins
  sim_vec_binned_4 <- sim_vec_binned
  sim_vec_binned_4[8:9, "bin_count"] <- c(100000,
                                          100000) # big count for penultimate
                                          # and final bin (gets normalised)

  res_binned_4 <- determine_xmin_and_fit_mlebin(sim_vec_binned_4)
  expect_equal(res_binned_4$mlebin_fit$b_mle,
               -0.999995327)             # -1, since

  # And plotting still works, even for only two bins
  expect_invisible(plot(res_binned_4))
})
