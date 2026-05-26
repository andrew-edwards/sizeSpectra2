##' Plot a binned ISD plots similar to MEPS Figure 7 from MLEbins method.
##'
##' See `?plot.size_spectrum_mlebin`.
##' @inheritParams plot.size_spectrum_numeric
##' @inheritParams plot_isd_binned
##' @param res_mlebins size_spectrum_mlebins object resulting from running
##'   `fit_size_spectrum()` to use the MLEbins method;
##'   see the [fit-data-mlebins.html vignette](https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-data-mlebins.html).
##' @return one- or two-panel plot of the ISD with data in binned form like in
##'   Fig. 7, 7a or 7b (depending on settings) of MEPS paper, with overlapping bins; returns nothing.
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' # See the fit-data-mlebins.html vignette for a worked example:
##' # https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-data-mlebins.html
##' }
plot.size_spectrum_mlebins <- function(res_mlebins,
                                       seg_col = "green",
                                       ...
                                       ){
  plot.size_spectrum_mlebin(res_mlebin = res_mlebins,
                            seg_col = seg_col,
                            ...)
  # want to have mlebins in class, hence need
  # this separate function.
}
