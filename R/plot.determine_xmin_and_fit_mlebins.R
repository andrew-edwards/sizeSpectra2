##' Plot results from determining x_min by mode method and then fitting use
##' MLEbin or MLEbins method
##' @inheritParams plot.size_spectrum_numeric
##' @inheritParams plot_isd_binned
##' @inheritParams plot.determine_xmin_and_fit
##'
##' @return figure in current device
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' See fit-data-mlebins.html vignette at
##' https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-data-mlebins.html
##' for MLEbins example
##' }
plot.determine_xmin_and_fit_mlebins <- function(x,
                                                xlim_hist = NULL,
                                                par_mai = c(0.4, 0.5, 0.05, 0.3),
                                                par_cex = 0.7,
                                                seg_col = "green",
                                                main_hist = "",
                                                ...){
  res <- x

  par_orig <- par(no.readonly = TRUE)
  on.exit(par(par_orig))

  # Going to use this same function for MLEbin output, so just need to extract
  # the desired components that explicitly have MLEbins here, to generalise it:
  if("determine_xmin_and_fit_mlebins" %in% class(res)){
    res_fit <- res$mlebins_fit
  }

  if("determine_xmin_and_fit_mlebin" %in% class(res)){
    res_fit <- res$mlebin_fit
  }

  # Global xlim, might want to add functionality at some point
  #xlim_global <- c(min(unlist(lapply(res, '[[',
  #                                   "x_min"))[years_indices]),
  #                 max(unlist(lapply(res, '[[',
  #                                 "x_max"))[years_indices]))

  par(mfrow = c(3,1))

  # Want it red for the bin with x_min in it (though not all values in the bin
  # will get fitted) and all those above. So for all bins with max bin break > x_min
  col_hist <- ifelse(res$h$breaks[-1] <= res_fit$x_min,  # take out first
                                        # breakpoint since bars correspond to
                                        # mids; but need <= because if x_min is
                                        # a bin break we don't want the bin
                                        # below to be read (that's a little convoluted)
                     "grey",
                     "red")

  border_col = "black"

  # If too fine then don't have black borders: could generalise, this was hake specific:
  #if(res$h$bin_width < 0.1){
  #  border_col = col_hist
  #}

  # arguments <- list(...)
  # if (!"seg_col" %in% names(arguments)) {
  #  seg_col <- "green"    # the default in plot.size_spectrum_mlebins(); just
                          # can't use that automatically, see below.
  #}

  if(is.null(xlim_hist)){
    dots_parser(utils::getS3method("plot",
                                   "histogram"),
                x = res$h,
                # xlim = xlim_global,
                col = col_hist,
                border = border_col,
                main = main_hist,
                ...)} else {
    dots_parser(utils::getS3method("plot",
                                   "histogram"),
                x = res$h,
                # xlim = xlim_global,
                col = col_hist,
                border = border_col,
                xlim = xlim_hist,
                main = main_hist,
                ...)
  }

  par(mai = par_mai,
      cex = par_cex)

  dots_parser(plot.size_spectrum_mlebin,
              # This should be really be
              # plot.size_spectrum_mlebins (which is almost
              # plot.size_spectrum_mlebin() anyway) but the
              # dots_parser doesn't pass on style because formals(FUN) I think
              # does not detect the arguments for the
              # subsequent function plot...mlebin(), and hence ignores the
              #  style = "linear_y_axis" argument given here (and things like xlab).
              # Since plot..mlebins() basically calls
              # plot...mlebin() with seg_col = "green", can circumvent the
              # ...mlebins() call here and add seg_col as an explicit
              # option.
              x = res_fit,
              style = "linear_y_axis",
              seg_col = seg_col,
              ...)

  dots_parser(plot.size_spectrum_mlebin,
              x = res_fit,
              style = "log_y_axis",
              seg_col = seg_col,
              ...)
}
