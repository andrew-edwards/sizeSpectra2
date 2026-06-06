##' Given data for MLEbins calculation, with species-specific weight bins,
##' determine a common binning and use that to calculate `x_min` and then fit
##' using MLEbins.
##'
##' See
##' [fit-data-mlebins vignette](https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-data-mlebins.html)
##' for explanation.
##'
##' @param dat_for_mlebins tibble of data in the format required for fitting
##'   using MLEbins method; see [fit_size_spectrum_mlebins()].
##' @inheritParams make_hist
##' @param x_min minimum value of data to fit the PLB distribution to. If `NULL`
##'   (the default) then it is determined by the histogram method (see Quevedo
##' et al. 2026), by binning the data (based on each `bin_min`) in
##' [make_hist_for_binned_counts()], determining the mode in
##' [determine_xmin_based_on_hist()], and setting `x_min` to be the minimum
##' `bin_min` that is above the minimum of that modal bin. If not `NULL`
##'   then the fitting is restricted to values greater than or equal to
##'   `x_min`, which for the MLEbins method is the first full bin equal to or above `x_min`
##'   (i.e. first bin with `bin_min >= x_min`).
##' @param ... arguments passed onto [fit_size_spectrum_mlebins()]
##' @return list of class `determine_xmin_and_fit_mlebins` for plotting, containing
##' * `mlebins_fit` object of class `size_spectrum_mlebins` from using MLEbins
##' method; see [fit_size_spectrum_mlebins()]
##' * `h` histogram object, as used to determine `x_min`
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' # See fit-data-mlebins vignette, rendered at
##' #  https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-data-mlebins.html
##' }
determine_xmin_and_fit_mlebins <- function(dat_for_mlebins,
                                           bin_width = 1,
                                           bin_start = 0,
                                           x_min = NULL,
                                           ...){

  # Need to be pragmatic, since have overlapping bins. Since assuming a power
  # law, kind of expect counts to be shifted to the low end of the bin. Use this
  # though to just create simple histograms of counts based on bin_min values.

  # Can't just treat the bin_min values as components of a single vector
  hh <- make_hist_for_binned_counts(dat_for_mlebins,
                                    bin_width = bin_width,
                                    bin_start = bin_start)

  if(is.null(x_min)){
    x_min_based_on_hist <- determine_xmin_based_on_hist(hh)

    # Now set x_min to be the minimum value that is above x_min_based_on_hist,
    #  because the latter is based on histograms bin breaks (which are somewhat
    #  arbitrary, though likely integers). This will also work for the case
    #  where x_min_based_on_hist comes out as 0.
    x_min = min(dplyr::filter(dat_for_mlebins,
                              bin_min >= x_min_based_on_hist)$bin_min)
  }

  # Not determining x_max separately here so no need to mention it, it gets
  #  passed on in ...

  mlebins_fit <- fit_size_spectrum_mlebins(dat_for_mlebins,
                                           x_min = x_min,
                                           ...)

  res <- list(mlebins_fit = mlebins_fit,
              h = hh)

  class(res) <- c("determine_xmin_and_fit_mlebins",
                  class(res))
  return(res)
}
