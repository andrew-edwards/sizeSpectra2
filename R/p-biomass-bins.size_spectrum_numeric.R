##' @rdname p_biomass_bins
##' @export
p_biomass_bins.size_spectrum_numeric <- function(res_mle   # result from MLE method
                                                 ){


  # Need to create bins manually
  data <- bin_data(res_mle$x,
                   bin_width = "2k")$bin_vals

  n <- res_mle$n
  x_min <- res_mle$x_min
  x_max <- res_mle$x_max

  # There is no uncertainty in the biomass in each bin, because we know the
  # individual body masses. So setting low_biomass and high_biomass to be bin_sum_norm
  res <- dplyr::mutate(data,
                       low_biomass = bin_sum,
                       high_biomass = bin_sum,
                       low_biomass_norm = bin_sum_norm,
                       high_biomass_norm = bin_sum_norm,
                       mle_biomass =
                         p_biomass(x = data$bin_max,
                                   b = res_mle$b_mle,
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n) -
                         p_biomass(x = data$bin_min,
                                   b = res_mle$b_mle,
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n),
                       mle_conf_1_biomass =
                         p_biomass(x = data$bin_max,
                                   b = res_mle$b_conf[1],
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n) -
                         p_biomass(x = data$bin_min,
                                   b = res_mle$b_conf[1],
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n),
                       mle_conf_2_biomass =
                         p_biomass(x = data$bin_max,
                                   b = res_mle$b_conf[2],
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n) -
                         p_biomass(x = data$bin_min,
                                   b = res_mle$b_conf[2],
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n),
                       mle_biomass_norm = mle_biomass / bin_width,
                       mle_conf_1_biomass_norm = mle_conf_1_biomass / bin_width,
                       mle_conf_2_biomass_norm = mle_conf_2_biomass / bin_width)
return(res)
}
