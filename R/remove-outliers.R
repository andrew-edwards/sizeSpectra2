##' Remove outliers (large values with gaps from the subsequent remaining continuous values)
##' from MLEbins results object
##'
##' If there is a gap between roughly-continuous body sizes and a larger group,
##' then it is useful to test if removing the larger group affects the results.
##' Used for Sensitivity Example B in Quevedo et al. (2026), see p34 of Supp
##' Material B. The relevant code is [available here](https://github.com/andrew-edwards/sizeSpectraFit/tree/main/report/mediterranean/mediterranean-analysis-15)
##'
##' @param res One of:
##' * `size_spectrum_mlebins` object
##' * `determine_xmin_and_fit_mlebins` object
##' @param ... TODO
##' @param number numeric value for how many of the top measurements to remove;
##'   user should determine manually from a plot.
##' @return list containing two tibbles plus two numerics. Each tibble contains just the data values needed for
##' calculations, which are `species`, `bin_min`, `bin_max`, and
##' `bin_count`. `count_gte_bin_min` etc. will be recalculated in the new
##' analysis. They are:
##'  * `dat-keep` records that are being kept
##'  * `dat-removed` records that are removed
##' Numeric values are:
##'  * `bin_count_removed` sum of the counts in bins that have been removed
##'  * `bin_count_removed_prop` proportion of the counts in bins that have been
##' removed (total counts removed divided by total counts in original data set).
##'
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' # See example code at
##' # https://github.com/andrew-edwards/sizeSpectraFit/tree/main/report/mediterranean/mediterranean-analysis-15
##' }
remove_outliers <- function(res,
                            ...){
  UseMethod("remove_outliers")
}
