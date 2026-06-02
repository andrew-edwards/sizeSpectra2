##' Calculate total and normalised biomass in each bin for a fitted distribution and given
##' bin breaks, with uncertainty if appropriate.
##'
##' For an object of class `size_spectrum_numeric`, from fitting a vector of
##' values using the MLE method, we create new bins and calculate the biomass
##' in each. The bins are defined as doubling in size (as per
##' the traditional size spectrum approach) using `bin_data(res$x, bin_width =
##' "2k")` in `p_biomass_bins.size_spectrum.numeric()`. We know all the individual body sizes, so there is
##' no uncertainty in the biomass within each bin, and we set `low_biomass =
##' `high_biomass` and `low_biomass_norm high_biomass_norm` in the output.
##'
##' For an object of class `size_spectrum_mlebin` where we have only binned
##' data, the range of possible biomass in a bin is \eqn{`bin_count` *
##' `bin_min`} to \eqn{`bin_count` * `bin_max`}. The existing bin breaks are used.
##'
##' Need MLEbins version (Issue #11).
##'
##' Output can then be used for plotting LBN biomass type plots; it is used
##' automatically in [plot_lbn_style()] which is called if `style = "biomass"`
##' in calls to plot results.
##'
##' @param bin_vals either a `numeric` vector of bin breaks, or a `data.frame` that
##'   contains columns `bin_min` and `bin_max` (and possibly more; e.g. the
##'   format of the `bin_vals` component output from [bin_data()].
##'   Either `p_biomass_bins.numeric()` or `p_biomass_bins.data.frame()` gets called
##'   appropriately.
##' @param res results list, of either class `size_spectrum_numeric` or
##'   `size_spectrum_mlebin`.
##' @return tibble if `res` is of class `size_spectrum_numeric` then it is the
##' `$bin_vals$ component of the output of `bin_data(res$x, bin_width = "2k")` with extra columns
##' added. If `res` is of class `size_spectrum_mlebin` then it is the `res$data`
##' tibble with a column `bin_width` added plus extra columns. The extra columns
##' for both cases are:
##'   * `low_biomass`: the lowest possible biomass in that bin based on the
##' possible individual body weights that individuals in that bin can have
##'   * `high_biomass`: the highest possible biomass in that bin; equals
##' `low-biomass` when `class(res) = size_spectrum_numeric`.
##'   * `low_biomass_norm`: `low_biomass / bin_width`
##'   * `high_biomass_norm`: `high_biomass / bin_width`
##'   * `mle_biomass`: the expected biomass in that bin using the MLE value of $b$
##'   * `mle_conf_1_biomass` the expected biomass in that bin using the lowest
##' value of the 95% confidence interval for $b$
##'   * `mle_conf_2_biomass` the expected biomass in that bin using the highest
##' value of the 95% confidence interval for $b$
##'   * `mle_biomass_norm`: `mle_biomass / bin_width`
##'   * `mle_conf_1_biomass_norm`: `mle_conf_1_biomass / bin_width`
##'   * `mle_conf_2_biomass_norm`: `mle_conf_2_biomass / bin_width`
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' res <- fit_size_spectrum(sim_vec)
##' p_biomass_bins(res)
##' plot(res, style = "biomass")
##'
##' res_mle <- fit_size_spectrum(sim_vec_binned)
##' p_biomass_bins(res_mle)
##' plot(res_mle, style = "biomass")
##' }
##'
p_biomass_bins <- function(res){
  UseMethod("p_biomass_bins")
}

