##' Fit a size spectrum to data using maximum likelihood
##'
##' The function automatically uses the appropriate method depending on the data
##' class. For a simple `numeric` vector, the MLE method will be used. For a
##' `data.frame` with the appropriate columns (see below) the MLEbin method will
##' be used. To use the MLEbins method for species-specific bins, please use
##' [fit_size_spectrum_mlebins()]. See appropriate vignettes.
##'
##' @param dat One of:
##' * `numeric` vector of values (such as individual body masses or lengths), which uses
##'   the MLE method (via the function [fit_size_spectrum.numeric()];
##' * `data.frame` of count data for the MLEbin method, where each row represents a
##' bin. At a minimum this has to include the columns:
##'   * `bin_min`
##'   * `bin_max`
##'   * `bin_count`.
##' The values `bin_min` and `bin_max` in each row correspond to the min and max
##' bounds of that bin, with `bin_count` being the count of individuals in that bin.
##' @param x_min minimum value of data to fit the PLB distribution to. If `NULL`
##'   (the default) then it is set to the minimum value of the data (if `dat` is
##'   `numeric`), else to the minimum bin break of the lowest bin. If not `NULL`
##'   then the fitting is restricted to values greater than or equal to
##'   `x_min`; for the MLEbin method this is the first full bin equal to or above `x_min`
##'   (i.e. first bin with `bin_min >= x_min`). Similarly for `x_max` (fitting
##'   is restricted to including the largest bin for which `bin_max <= x_max`).
##' @param x_max maximum value of data to fit the PLB distribution to. If `NULL`
##'   (the default) then it is set to the maximum value of the data (if `dat` is
##'   `numeric`), else to the maximum bin break of the highest bin
##'    If not `NULL` then the fitting is restricted to values below or equal to
##'   `x_max`; for the MLEbin method this includes the highest bin for which
##'   `bin_max <= x_max`.
##' @param b_vec vector of values for the confidence interval calculation, to be
##'   used as the `vec` argument of `calc_mle_conf()`
##' @param b_vec_inc increment value for the confidence interval calculation, to be
##'   used as the `vec_inc` argument of `calc_mle_conf()`
##' @param b_start for the MLEbin method, the starting estimate for numerical
##'   search for the MLE, since there is no analytical value.
##' @return
##' * If `dat` is numeric then returns a list object of class
##'   `size_spectrum_numeric` (such that we can plot it
##'   with [plot.size_spectrum_numeric()], with objects
##'   * `b_mle` maximum likelihood estimate of $b$
##'   * `b_conf` vector giving 95% confidence interval for $b$
##'   * `x` vector of original values of `dat`
##'   * `x_min` the `x_min` value used for the fitting
##'   * `x_max` the `x_max` value used for the fitting
##'   * `method` to describe the fitting method used, in this case `MLE`
##' * If `dat` is a data.frame then returns a list object of class
##'   `size_spectrum_mlebin` with same objects as above, except for
##'   * `data` but instead of `x` it is the original `data.frame`, arranged by
##' the increasing values of `bin_min`, and also has the columns
##'     * `count_gte_bin_min` total count of values in bins for which `bin_min`
##' \eqn{\geq} the value of `bin_min` for this row
##'     * `low_count` total count of values in bins for which `bin_min`
##' \eqn{\geq} the value of `bin_max` for this row, so the lowest possible count of
##' values above this bin
##'     * `high_count` total count of values in bins for which `bin_max`
##' \eqn{\geq} the value of `bin_min` for this row, so the highest possible count of
##' values above this bin; for non-overlapping bins will be the same as
##' `count_gte_bin_min` (but is needed for plotting).
##' Note that if `x_min` and/or `x_max`
##' are prescribed such that some data are not included in the fit (e.g. `x_min`
##' is greater than the `bin_max` of the smallest bin), then they are omitted in `data`.
##'
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' res_vec <- fit_size_spectrum(sim_vec)
##' plot(res_vec)
##'
##' x_binned <- bin_data(res_vec$x, bin_width = "2k")`
##' res_mlebin <- fit_size_spectrum(x_binned)
##' plot(res_mlebin)
##' # See the vignettes for further details and refinements.
##' }
fit_size_spectrum <- function(dat,
                             ...){
  UseMethod("fit_size_spectrum")
}
