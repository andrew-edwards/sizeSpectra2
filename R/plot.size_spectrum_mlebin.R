##' Plot binned ISD plots similar to MEPS Figure 7 (but with nonoverlapping
##' bins).
##'
##' Plots one- or two-panel plot of the ISD with data in binned form like in
##'   Fig. 7a or 7b (depending on settings) of MEPS paper, but with
##'   nonoverlapping bins. See `log_y_axis` to specify exact plot(s).
##'
##' Also directly called from `plot.size_spectrum_mlebins()` with no
##' extra arugments for MLEbins method.
##'
##' @inheritParams plot.size_spectrum_numeric
##' @inheritParams plot_isd_binned
##' @param x size_spectrum_mlebin object resulting from running
##'   `fit_size_spectrum()` on a `data.frame` of binned data (such that the function
##'   `fit_size_spectrum_mlebin()` is used); see the [fit-data.html vignette](https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-data.html).
##' @return one- or two-panel plot of the ISD with data in binned form like in
##'   Fig. 7, 7a or 7b (depending on settings) of MEPS paper, but with nonoverlapping bins; returns nothing.
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' res_binned <- fit_size_spectrum(sim_vec_binned)
##' plot(res_binned)
##' }
plot.size_spectrum_mlebin <- function(x,
                                      style = "log_y_axis",
                                      xlim = c(min(x$data$bin_min),
                                               max(x$data$bin_max)),
                                      ylim = NA,
                                      x_plb = NA,
                                      inset_label = c(0, -0.02),
                                      xlab = expression(paste("Body mass, ",
                                                               italic(x), "(g)")),

                                      y_scaling = 0.75,
                                      mle_round = 2,
                                      legend_label_a = "(a)",
                                      legend_label_b = "(b)",
                                      legend_label_single = NULL,
                                      legend_text_a = paste0("b=",
                                                           round(x$b_mle,
                                                                  mle_round)),
                                      legend_text_a_n = paste0("n=",
                                                               round(sum(x$data$bin_count))),
                                      legend_text_b = NULL,
                                      legend_text_b_n = NULL,
                                      par_mai = c(0.4, 0.5, 0.05, 0.3),
                                      par_cex = 0.7,   # only for two panel
                                         # plots, use par() as usual for single plots
                                      seg_col = NULL,         # but gets set to
                                                              # black if not overridden
                                      ...
                                      ){
  res_mlebin <- x
  # Parts of this are included in plot_aggregate_mlebin() so if change things
  #  here may need to check that and change there also.
  stopifnot("style must be log_y_axis, linear_y_axis, both_y_axes, biomass, or biomass_and_log" =
              style %in% c("log_y_axis", "linear_y_axis", "both_y_axes",
                           "biomass", "biomass_and_log"))
  par_orig <- par(no.readonly = TRUE)

  # if seg_col is not defined (so remains NULL) but rect_border_col is, then set the former to the
  # latter, but it won't do this for mlebins because we set seg_col = "green" there
  if(is.null(seg_col)){
    if(hasArg(rect_border_col)){
      seg_col <- eval.parent(match.call()[["rect_border_col"]])
    } else {
      seg_col <- "black"           # rect() defaults to black anyway, as
    }                              # used for the rectangles, so no need to
                                   # define border col
  }                                # Else just stick with user-defined seg_col

  # Work out calculations needed for both types of plot and then pass them on to
  # plot_isd_binned():

  dat <- res_mlebin$data
  n <- res_mlebin$n

  x_min <- res_mlebin$x_min

  x_max <- res_mlebin$x_max

  # x values to plot PLB if not provided; need high resolution for both plots.
  if(is.na(x_plb)){
    x_plb <- exp(seq(log(x_min),
                     log(x_max),
                     length = 10000))

    #  Need to insert value close to x_max to make log-log curve go down further;
    #   since log(1 - pplb(x_max, ...)) = log(0) = -Inf   we need to force the asymptopte
    x_plb_length <- length(x_plb)
    x_plb <- c(x_plb[-x_plb_length],
               0.9999999999 * x_plb[x_plb_length],
               x_plb[x_plb_length])
  }

  y_plb = (1 - pPLB(x = x_plb,
                    b = res_mlebin$b_mle,
                    x_min = min(x_plb),
                    x_max = max(x_plb))) * n
  # To add curves for the limits of the 95% confidence interval of b:
  y_plb_conf_min = (1 - pPLB(x = x_plb,
                             b = res_mlebin$b_conf[1],
                             x_min = min(x_plb),
                             x_max = max(x_plb))) * n
  y_plb_conf_max = (1 - pPLB(x = x_plb,
                             b = res_mlebin$b_conf[2],
                             x_min = min(x_plb),
                             x_max = max(x_plb))) * n


  if(all(is.na(ylim))){
    ylim <- c(y_scaling * min(dat$count_gte_bin_min),
              max(dat$high_count))
  }

    if(style %in% c("linear_y_axis", "log_y_axis")){
    log_axes <- ifelse(style == "log_y_axis",
                       "xy",
                       "x")

    plot_isd_binned(res_mlebin = res_mlebin,
                    log = log_axes,
                    xlim = xlim,
                    ylim = ylim,
                    x_plb = x_plb,
                    y_plb = y_plb,
                    y_plb_conf_min = y_plb_conf_min,
                    y_plb_conf_max = y_plb_conf_max,
                    xlab = xlab,
                    legend_label = legend_label_single,
                    legend_text = legend_text_a,
                    legend_text_n = legend_text_a_n,
                    seg_col = seg_col,
                    ...)
  }

  if(style == "both_y_axes"){
    par(mfrow = c(2,1),
        mai = par_mai,
        cex = par_cex)
    plot_isd_binned(res_mlebin = res_mlebin,
                    log = "x",
                    xlim = xlim,
                    ylim = ylim,
                    x_plb = x_plb,
                    y_plb = y_plb,
                    y_plb_conf_min = y_plb_conf_min,
                    y_plb_conf_max = y_plb_conf_max,
                    xlab = xlab,
                    legend_label = legend_label_a,
                    legend_text = legend_text_a,
                    legend_text_n = legend_text_a_n,
                    seg_col = seg_col,
                    ...)  # ADD in more options maybe, see plot_isd_binned; figure out
                          # useArgs() thing. Copy to next ones

    plot_isd_binned(res_mlebin = res_mlebin,
                    log = "xy",
                    xlim = xlim,
                    ylim = ylim,
                    x_plb = x_plb,
                    y_plb = y_plb,
                    y_plb_conf_min = y_plb_conf_min,
                    y_plb_conf_max = y_plb_conf_max,
                    xlab = xlab,
                    legend_label = legend_label_b,
                    legend_text = legend_text_b,
                    legend_text_n = legend_text_b_n,
                    seg_col = seg_col,
                    ...)
  }

  if(style == "biomass"){
    # Think this should just be the one plot
    plot_lbn_style(res_mlebin,
                   x_plb = x_plb,
                   xlab = xlab,
                   inset_label = inset_label,
                   legend_label = legend_label_single,
                   legend_text = legend_text_a,
                   legend_text_n = legend_text_a_n,
                   ...)
  }

  if(style == "biomass_and_log"){
    par(mfrow = c(2,1),
        mai = par_mai,
        cex = par_cex)

    plot_lbn_style(res_mlebin,
                   x_plb = x_plb,
                   xlab = xlab,
                   inset_label = inset_label,
                   legend_label = legend_label_a,
                   legend_text = legend_text_a,
                   legend_text_n = legend_text_a_n,
                   ...)

    plot_isd_binned(res_mlebin = res_mlebin,
                    log = "xy",
                    xlim = xlim,
                    ylim = ylim,
                    x_plb = x_plb,
                    y_plb = y_plb,
                    y_plb_conf_min = y_plb_conf_min,
                    y_plb_conf_max = y_plb_conf_max,
                    xlab = xlab,
                    legend_label = legend_label_b,
                    legend_text = legend_text_b,
                    legend_text_n = legend_text_b_n,
                    seg_col = seg_col,
                    ...)
  }
  # par(par_orig)      # Leave as was found, but  commenting as think messes
                       #  up plot.determine_xmin_and_fit_mlebins.R
  invisible()
}
