##' Plot individual size distribution (ISD) of values and the MLE fit with
##' confidence intervals
##'
##' Plots one- or two-panel plot of the ISD and data, with maximum likelihood
##' fits shown, as calculated using the MLE method. Two-panel plot is either
##' the ISD style (individual points and fitted distribution) with (a) linear
##' y-axis and (b) logarithimc y-axis (so like Fig 7 of MEPS paper but for
##' unbinned data), or, only for when
##' the data represent body masses, (a) the normalised biomass on log-log
##' axes with fitted estimates and (b) same as (b) above, essentially the
##' recommended Fig. 6 of the MEE paper, but improved by showing bins in the top
##' panel rather than points.
##'
##' Single plots are the ISD style with either logarithmic or linear y-axis. See
##' the `style` argument.
##'
##' Legends are automatically set, but can be tailored with the
##'   arguments defined below.
##'
##' @inheritParams plot_isd
##' @param x `size_spectrum_numeric` object, as output from
##'   [fit_size_spectrum.numeric()], which gets called when applying
##'   [fit_size_spectrum()] to a numeric vector. Has to be called `x` to match
##'   the `base::plot(x)` function else gives warnings.
##' @param style character either:
##'   * `"log_y_axis"` - single ISD plot with logarithmic y axis (Fig. 6b of MEE paper)
##'   * `"linear_y_axis"` - for single ISD plot with linear y axis
##'   * `"both_y_axes"` - both the above plots as a two-panel plot
##'   * `"biomass_and_isd"` - to use only if the data represent a vector of body masses. Does two-panel
##'   plot, essentially the recommended Fig. 6 of MEE paper where the top panel
##'   is bins of normalized biomass (but improved here by showing bins in the top
##'   panel rather than points) and the `"log_y_axis"` plot described above.
##'   Note that the x-axis is always logarithmic.
##'   Legends are automatically set, but can be tailored with the arguments
##'   defined below.
##'   * `"biomass"` or `"biomass_and_log"` - from using the MLEbin method,
##'   whether to plot just a normalised biomass plot or a normalised biomass plot
##'   plus the binned data and fit of the PLB.
##' @param x_plb vector of values to use to plot the fitted PLB curve; if NA then
##'   automatically calculated (sometimes need to manually extend it to hit the
##'   x-axis, but tricky to automate that on a log-scale)
##' @param y_scaling numeric scaling of y-minimum of y-axis. Axis can't go to zero on
##'   log-log plot, but goes to the proportion `y_scaling` (<1)
##'   of the minimum value of counts greater than the highest `bin_min` value. Do
##'   such that can see the right-most or point bin in all plots.
##' @param xlab x label, explicitly given default value here which can
##'   be modified as required; the usual argument to `plot()`
##' @param legend_label_a character label (default `"(a)"`) to use for panel (a)
##' for a two-panel plot
##' @param legend_label_b character label to use for panel (b) for two-panel plot
##' @param legend_label_single character label to use for the only panel for a one-panel plot
##' @param legend_text_a text to include in the legend for panel
##'   (a) for two-panel plot( the `b = -1.58` in Fig. 7a
##'   of MEPS paper) or the only panel for a one-panel plot.
##' @param legend_text_b text to include in the legend for panel
##'   b for two-panel plot (`log_y_axis = "both"`); ignored for one-panel plot
##' @param legend_text_a_n,legend_text_b_n as for `legend_text_a` and
##'   `legend_text_b` but for another row of information, default being `n =
##'   <sample size>` as in Fig. 7a of MEPS paper.
##' @param ... Further arguments for `plot_isd()` and then `plot()`, except
##'   cannot have `log` as that gets overridden.
##' @param mle_round number of decimal places to round the MLE estimate of `b`
##' to; passed on as `digits` argument to [round()]
##' @param par_mai vector of values to use for `par(mai)`
##' @param par_cex numeric value to use for `par(cex)` (font size)
##' @return One- or two-panel plot of raw data and PLB distribution (and fits of
##'   confidence limits) as solid (and dashed) fitted using MLE method; returns
##'   nothing.
##'
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' res_vec <- fit_size_spectrum(sim_vec)
##' plot(res_vec)
##' plot(res_vec, log = "x")
##' plot(res_vec, log = "")
##' plot(res_vec, x_small_ticks_labels = c(5, 50, 500), log = "x") # Tailor the
##'   labels for a particular figure
##' }
plot.size_spectrum_numeric <- function(x,
                                       style = "log_y_axis",
                                       xlim = c(x$x_min,
                                                x$x_max),
                                       ylim = NULL,
                                       x_plb = NULL,
                                       y_scaling = 0.75,
                                       mle_round = 2,
                                       inset_label = c(0, -0.02),
                                       xlab = expression(paste("Body mass, ",
                                                               italic(x), "(g)")),
                                       legend_label_a = "(a)",
                                       legend_label_b = "(b)",
                                       legend_label_single = NULL, # for just one
                                       # panel
                                       legend_text_a = paste0("b=",
                                                              round(x$b_mle,
                                                                    mle_round)),
                                       legend_text_a_n = paste0("n=",
                                                                round(length(x$x))),
                                       legend_text_b = NULL,
                                       legend_text_b_n = NULL,
                                       par_mai = c(0.4, 0.5, 0.05, 0.3),
                                       par_cex = 0.7,   # only for two panel
                                         # plots, use par() as usual for single plots
                                       ...){
  res <- x

  stopifnot("style must be log_y_axis, linear_y_axis, both_y_axes, biomass, or biomass_and_isd" =
              style %in% c("log_y_axis", "linear_y_axis", "both_y_axes",
                           "biomass", "biomass_and_isd"))
  args <- list(...)
  if ("log" %in% names(args)) {
    stop("Cannot specify argument `log`, since it gets overridden within plot.size_spectrum_numeric().")
  }

  # par_orig <- par(no.readonly = TRUE)

  # Work out calculations needed for both types of plot and then pass them on to
  # plot_isd() (and plot_isd_binned() for `both`).:

  # These default arguments reference `x` (the size_spectrum_numeric list), so
  # they must be evaluated before x is reassigned to the numeric vector below.
  force(xlim)
  force(legend_text_a)
  force(legend_text_a_n)

  x <- res$x                # I originally had 'res' as the main argument, but
                            # had to change it to x as that's what plot.default() has. So not ideal
                            # notation, but is behind the scenes, though
                            # requires the above force fudge.

  x_min <- res$x_min
  x_max <- res$x_max
  n <- res$n

  # x values to plot PLB if not provided; need high resolution for both plots.
  if(is.null(x_plb)){
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
                    b = res$b_mle,
                    x_min = min(x_plb),
                    x_max = max(x_plb))) * n
  # To add curves for the limits of the 95% confidence interval of b:
  y_plb_conf_min = (1 - pPLB(x = x_plb,
                             b = res$b_conf[1],
                             x_min = min(x_plb),
                             x_max = max(x_plb))) * n
  y_plb_conf_max = (1 - pPLB(x = x_plb,
                             b = res$b_conf[2],
                             x_min = min(x_plb),
                             x_max = max(x_plb))) * n

  if(is.null(ylim)){
    ylim <- c(y_scaling,
              length(x))
  }

  if(style %in% c("linear_y_axis", "log_y_axis")){
    log_axes <- ifelse(style == "log_y_axis",
                       "xy",
                       "x")

    plot_isd(res = res,
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
             ...)
  }

  if(style == "both_y_axes"){

    par(mfrow = c(2,1),
        mai = par_mai,
        cex = par_cex)

    plot_isd(res = res,
             log = "x",
             xlim = xlim,
             ylim = ylim,
             x_plb = x_plb,
             y_plb = y_plb,
             y_plb_conf_min = y_plb_conf_min,
             y_plb_conf_max = y_plb_conf_max,
             xlab = xlab,
             inset_label = inset_label,
             legend_label = legend_label_a,
             legend_text = legend_text_a,
             legend_text_n = legend_text_a_n,
             ...)

    plot_isd(res = res,
             log = "xy",
             xlim = xlim,
             ylim = ylim,
             x_plb = x_plb,
             y_plb = y_plb,
             y_plb_conf_min = y_plb_conf_min,
             y_plb_conf_max = y_plb_conf_max,
             xlab = xlab,
             inset_label = inset_label,
             legend_label = legend_label_b,
             legend_text = legend_text_b,
             legend_text_n = legend_text_b_n,
             ...)

  }

  if(style == "biomass"){

    plot_lbn_style(res,
                   x_plb = x_plb,
                   xlab = xlab,
                   inset_label = inset_label,
                   legend_label = legend_label_single,
                   legend_text = legend_text_a,
                   legend_text_n = legend_text_a_n,
                   ...)
  }

  if(style == "biomass_and_isd"){
    par(mfrow = c(2,1),
        mai = par_mai,
        cex = par_cex)

    plot_lbn_style(res,
                   x_plb = x_plb,
                   xlab = xlab,
                   inset_label = inset_label,
                   legend_label = legend_label_a,
                   legend_text = legend_text_a,
                   legend_text_n = legend_text_a_n,
                   ...)

## Now using plot_lbn_style() above, but might want to add some of these in
##                     log = "x",  # maybe not, since always doing log-log?
##                     ...)  # ADD in more options maybe, see plot_isd_binned; figure out

    plot_isd(res = res,
             log = "xy",
             xlim = xlim,
             ylim = ylim,
             x_plb = x_plb,
             y_plb = y_plb,
             y_plb_conf_min = y_plb_conf_min,
             y_plb_conf_max = y_plb_conf_max,
             xlab = xlab,
             inset_label = inset_label,
             legend_label = legend_label_b,
             legend_text = legend_text_b,
             legend_text_n = legend_text_b_n,
             ...)
  }

  # par(par_orig)      # Leave as was found, but messes up (starts again) if have said par(mfrow
                     # = c(4,1), so think best to not do.

  invisible()
}
