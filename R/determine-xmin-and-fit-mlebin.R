##' Given data for MLEbin calculation, determine a common binning and use that
##' to calculate `x_min` and then fit using MLEbin.
##'
##' @param dat tibble of data in the format required for fitting
##'   using MLEbin method; see [fit_size_spectrum()].
##' @param x_min minimum value of data to fit the PLB distribution to. If `NULL`
##'   (the default) then it is determined by the histogram method (see Quevedo
##' et al. 2026), by binning the data using the bins in the data in
##' [make_hist_for_binned_counts()], determining the mode in
##' [determine_xmin_based_on_hist()], and setting `x_min` to be the `bin_min` of
##' the modal bin. If not `NULL`
##'   then the fitting is restricted to values greater than or equal to
##'   `x_min`, which for the MLEbin method is the first full bin equal to or above `x_min`
##'   (i.e. first bin with `bin_min >= x_min`).
##' @param ... arguments passed onto [fit_size_spectrum_mlebin()]
##' @return object of class `determine_xmin_and_fit_mlebin`, such that
##' [plot.determine_xmin_and_fit_mlebin()] gets used for plotting; a list containing
##' two list objects
##' * `mlebin_fit` object of class `size_spectrum_mlebin` from using MLEbin
##' method; see [fit_size_spectrum()]
##' * `h` histogram object, as used to determine `x_min`
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' sim_vec_binned_2 <- sim_vec_binned
##' sim_vec_binned_2[1, "bin_count"] <- 100  # lower count for first bin
##' res_binned_2 <- determine_xmin_and_fit_mlebin(sim_vec_binned_2)
##' plot(res_binned_2)
##'
##' # An example showing the code still works even if you end up with
##' #  only two bins (though you should not really do such an analysis on real data):
##' sim_vec_binned_4 <- sim_vec_binned
##' sim_vec_binned_4[8:9, "bin_count"] <- c(100000,
##'                                         100000)
##'       # big counts for penultimate and final bin (that will get normalised),
##'       #  such that x_min gets set to only have the two final bins
##'
##' res_binned_4 <- determine_xmin_and_fit_mlebin(sim_vec_binned_4)
##' res_binned_4$mlebin_fit$b_mle     # is essentially -1, (question for
##'                                   #  audience: why?)
##' # And plotting still works, even for only two bins
##' plot(res_binned_4)
##' }
determine_xmin_and_fit_mlebin <- function(dat,
                                           x_min = NULL,
                                           ...){

  stopifnot("dat needs to include columns bin_min, bin_max, and bin_count to use the MLEbin method"
  = c("bin_min", "bin_max", "bin_count") %in% names(dat))

  if(!all(dat$bin_min[-1] == dat$bin_max[-nrow(dat)])){
    stop("The data.frame `dat` needs to have consecutive bins; you may need to add some zero counts for any intermediate bins. Given there are many choices of binning, it is hard for sizeSpectraFit to automatically fill in intermediate bins with counts of zero.")
  }

  hh <- make_hist_for_binned_counts_mlebin(dat)

  if(is.null(x_min)){
    x_min <- determine_xmin_based_on_hist(hh)

    # This will automatically be an original bin break, so no need to make it
    # anything slightly higher like for MLE or MLEbins

  }

  # Not determining x_max separately here so no need to mention it, it gets
  #  passed on in ...

  mlebin_fit <- fit_size_spectrum_mlebin(dat,
                                         x_min = x_min,
                                         ...)

  res <- list(mlebin_fit = mlebin_fit,
              h = hh)

  class(res) <- c("determine_xmin_and_fit_mlebin",
                  class(res))
  return(res)
}
