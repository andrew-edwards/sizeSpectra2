##' @rdname p_biomass_bins
##' @param res TODO
##' @export
p_biomass_bins.size_spectrum_mlebin <- function(res){
  res_mlebin <- res

  data <- res_mlebin$data %>%
    dplyr::mutate(bin_width = bin_max - bin_min)   # might already exist
  n <- res_mlebin$n
  x_min <- res_mlebin$x_min
  x_max <- res_mlebin$x_max

  # for binned data, the range of possible biomass in a bin is the count in bin
  #  * bin_min to count * bin_max.
  res <- dplyr::mutate(data,
                       low_biomass = bin_min * bin_count,
                       high_biomass = bin_max * bin_count,
                       low_biomass_norm = low_biomass / bin_width,
                       high_biomass_norm = high_biomass / bin_width,
                       mle_biomass =
                         p_biomass(x = res_mlebin$data$bin_max,
                                   b = res_mlebin$b_mle,
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n) -
                         p_biomass(x = res_mlebin$data$bin_min,
                                   b = res_mlebin$b_mle,
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n),
                       mle_conf_1_biomass =
                         p_biomass(x = res_mlebin$data$bin_max,
                                   b = res_mlebin$b_conf[1],
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n) -
                         p_biomass(x = res_mlebin$data$bin_min,
                                   b = res_mlebin$b_conf[1],
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n),
                       mle_conf_2_biomass =
                         p_biomass(x = res_mlebin$data$bin_max,
                                   b = res_mlebin$b_conf[2],
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n) -
                         p_biomass(x = res_mlebin$data$bin_min,
                                   b = res_mlebin$b_conf[2],
                                   x_min = x_min,
                                   x_max = x_max,
                                   n = n),
                       mle_biomass_norm = mle_biomass / bin_width,
                       mle_conf_1_biomass_norm = mle_conf_1_biomass / bin_width,
                       mle_conf_2_biomass_norm = mle_conf_2_biomass / bin_width)
  return(res)
}
