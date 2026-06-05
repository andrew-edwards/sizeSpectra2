##' Plot results from determining x_min by mode method and then fitting use MLE hake spectra results
##'
##'
##' @param x list of one of the following classes:
##'   * `determine_xmin_and_fit` as output from `determine_xmin_and_fit()`
##'   * `determine_xmin_for_mlebin_and_fit` as output from `determine_xmin_for_mlebin_and_fit()`
##' * `determine_xmin_for_mlebins_and_fit` as output from `determine_xmin_for_mlebins_and_fit()`
##' @param xlim_hist numeric vector of two values representing `xlim` for
##' histogram plot on a linear axis; default is the full range
##'   of breaks (which might be too large for a clear figure, especially given
##'   the linear axis).
##' @param main_hist title for histogram; useful if doing strata
##' @param ... arguments to passed onto `hist()` or plotting functions
##' based on `class(res)`; see `?plot.size_spectrum_numeric`.
##' @return figure in current device
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' See fit-data-mlebins.html vignette at
##' https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-data-mlebins.html
##' for MLEbins example
##' }
plot.determine_xmin_and_fit <- function(x,
                                        xlim_hist = NULL,
                                        main_hist = "",
                                        ...){
  res <- x

  # Global xlim, might want to add functionality at some point
  #xlim_global <- c(min(unlist(lapply(res, '[[',
  #                                   "x_min"))[years_indices]),
  #                 max(unlist(lapply(res, '[[',
  #                                 "x_max"))[years_indices]))

  par_orig <- par(no.readonly = TRUE)
  on.exit(par(par_orig))

  par(mfrow = c(2,1))

  col_hist <- ifelse(res$h$mids < res$mle_fit$x_min,
                     "grey",
                     "red")

  border_col = "black"

  # If too fine then don't have black borders:  could generalise, this was hake specific
  #if(res$h$bin_width < 0.1){
  #  border_col = col_hist
  #}

  if(is.null(xlim_hist)){
    plot(res$h,
         # xlim = xlim_global,
         col = col_hist,
         border = border_col,
         main = main_hist,
         ...)} else {
    plot(res$h,
         # xlim = xlim_global,
         col = col_hist,
         border = border_col,
         xlim = xlim_hist,
         main = main_hist,
         ...)
 }

  plot(res$mle_fit)
}
