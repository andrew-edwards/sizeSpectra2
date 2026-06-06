##' Plot a single binned ISD plot, as called from `plot.size_spectrum_mlebin()`
##' and `plot.size_spectrum_mlebins()`,
##' or used directly from `plot.size_spectrum_numeric()` to make an LBN-style
##' plot of individual values and MLE plot.
##'
##' The rectangles in the plot show the bins of body size (x-axis) and the
##' resulting uncertainty in the counts \eqn{$\geq$} values in the bin -- see
##' [Edwards et
##' al. (2020)](https://www.int-res.com/abstracts/meps/v636/p19-33/)) for
##' details.
##'
##' @inheritParams plot.size_spectrum_numeric
##' @inheritParams plot_isd
##' @param res_mlebin object of class `size_spectrum_mlebin` object, as output from
##'   [fit_size_spectrum.data.frame()]
##' @param x_plb,y_plb vectors of values with `y_plb` corresponding to the MLE fit of the PLB
##'   distribution at each value of `x_PLB`
##' @param plot_conf_ints logical whether to plot confidence intervals or not
##' @param xlab,ylab x/y labels, explicitly given default values here which can
##'   be modified as required; the usual argument to `plot()`
##' @param tcl_small passed on as the `tcl` argument to [axis()] for tick
##' direction and length for small tickmarks
##' @param seg_col colour to use for the segments (top line of each box; green
##'   in Fig. 7 of MEPS paper); default in `plot.size_spectrum_mlebin()` is NULL
##'   which gets converted to `black` in that function.
##' @param rect_shading_col colour to use for the shading of the boxes
##' @param rect_border_col colour to use for the borders of the boxes; can be
##' `NA` to omit (see `border` arg of [rect()]).
##' @param legend_text_second_row_multiplier numeric multiplier of the second
##'   row of legend text to space it out, especially for smaller panel plots.
##' @param show_fit_on_top logical, whether to plot the fitted PLB curve on top of the
##'   data or underneath. Usually on top (the default) is fine, but sometimes
##'   having it underneath is better.
##' @return single panel plot of the ISD with data in binned form like in
##'   Fig. 7a or 7b of MEPS paper, but with nonoverlapping bins; returns nothing.
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' # Is called by `plot.size_spectrum_mlebin()`,
##' # `plot.size_spectrum_mlebins()`, and
##' # `plot.size_spectrum_numeric()` to make an LBN-style plot; see vignettes
##' # and help for those functions for examples.
##' }
plot_isd_binned <- function(res_mlebin,
                            log,
                            xlim,
                            ylim,
                            x_plb,
                            y_plb,
                            y_plb_conf_min,
                            y_plb_conf_max,
                            plot_conf_ints = TRUE,
                            xlab = expression(paste("Values, ", italic(x))),
                            ylab = expression( paste("Total ", counts >= x),
                                              sep=""),  # Figure out how to do
                                                # it as optional but feed through.
                            mgp_val = c(1.6, 0.5, 0),
                            tcl_small = -0.2,
                            inset_label = c(0, 0),
                            inset_text = c(0, 0.04),
                            legend_label = NULL,
                            legend_text = NULL,
                            legend_text_n = NULL,
                            legend_text_second_row_multiplier = 2,
                            legend_position = "topright",
                            x_big_ticks = NULL,
                            x_big_ticks_labels = NULL,
                            x_small_ticks = NULL,
                            x_small_ticks_by = NULL,
                            x_small_ticks_labels = NULL,
                            y_big_ticks = NULL,
                            y_big_ticks_labels = NULL,
                            y_small_ticks = NULL,
                            y_small_ticks_by = NULL,
                            y_small_ticks_labels = NULL,
                            seg_col = "green",   # want these parsed along if
                                        # they're changed by users in original
                                        # call - useArgs or something?
                                        # Seems automatic; these next
                                        # two seem to work with
                                        # plot(res_mlebin_list[[1]],
                                        # rect_border_col = "yellow") from
                                        # aggregated vignette
                            rect_shading_col = "grey",
                            rect_border_col = "black",
                            fit_col = "red",
                            fit_lwd = 2,
                            conf_lty = 2,
                            show_fit_on_top = TRUE
                            ){
  # Not sure if needed, see plot_isd() also and plot_lbn_style.
  stopifnot("Cannot define both x_small_ticks and x_small_ticks_by" =
              !(!is.null(x_small_ticks) & !is.null(x_small_ticks_by)))
  stopifnot("Cannot define both y_small_ticks and y_small_ticks_by" =
              !(!is.null(y_small_ticks) & !is.null(y_small_ticks_by)))

# mgp maybe need - see above commented option
# From ISD_bin_plot to adapt here, this is for linear y-axis, then have to tweak
  # to have the log option also:

  dat <- res_mlebin$data %>%
    dplyr::arrange(desc(bin_min))
                                  # Should overlay rectangles like in MEPS
                                  # Fig. 7, and not matter for
                                  # non-overlapping. check.


  # y-axis not logged
  plot.default(dat$bin_min,      #    nothing plotted anyway as type = "n"
               dat$count_gte_bin_min,
               log = log,
               xlab = xlab,
               ylab = ylab,
               xlim = xlim,
               ylim = ylim,
               type = "n",
               axes = FALSE,
               mgp = mgp_val)

  # Add tickmarks and labels, replacing what was in ISD_bin_plot with this
  add_ticks(
    log = log,
    tcl_small = tcl_small,
    mgp_val = mgp_val,
    x_big_ticks = x_big_ticks,
    x_big_ticks_labels = x_big_ticks_labels,
    x_small_ticks = x_small_ticks,
    x_small_ticks_by = x_small_ticks_by,
    x_small_ticks_labels = x_small_ticks_labels,
    y_big_ticks = y_big_ticks,
    y_big_ticks_labels = y_big_ticks_labels,
    y_small_ticks = y_small_ticks,
    y_small_ticks_by = y_small_ticks_by,
    y_small_ticks_labels = y_small_ticks_labels)


  if(!show_fit_on_top){                              # Plot fit first, under data
    lines(x_plb, y_plb, col = fit_col, lwd = fit_lwd)
    if(plot_conf_ints){
      lines(x_plb, y_plb_conf_min, col = fit_col, lty = conf_lty)
      lines(x_plb, y_plb_conf_max, col = fit_col, lty = conf_lty)
    }
  }


  rect(xleft = dat$bin_min,
       ybottom = dat$low_count,
       xright = dat$bin_max,
       ytop = dat$high_count,
       col = rect_shading_col,
       border = rect_border_col)
  segments(x0 = dat$bin_min,
           y0 = dat$count_gte_bin_min,
           x1 = dat$bin_max,
           y1 = dat$count_gte_bin_min,
           col = seg_col)

  if(log == "xy"){
    # Need to manually draw the rectangle with low_count = 0 since it doesn't
    #  get plotted on log-log plot
    extra_rect <- dplyr::filter(dat,
                                low_count == 0)
    # if(nrow(extra.rect) > 1) stop("Check rows of extra rect.")
    rect(xleft = extra_rect$bin_min,
         ybottom = rep(0.01 * ylim[1],
                       nrow(extra_rect)),
         xright = extra_rect$bin_max,
         ytop = extra_rect$high_count,
         col = rect_shading_col,
         border = rect_border_col)

  segments(x0 = dat$bin_min,
           y0 = dat$count_gte_bin_min,
           x1 = dat$bin_max,
           y1 = dat$count_gte_bin_min,
           col = seg_col)
  }

  if(show_fit_on_top){
    lines(x_plb, y_plb, col = fit_col, lwd = fit_lwd)   # Plot line last so can see it
    if(plot_conf_ints){
      lines(x_plb, y_plb_conf_min, col = fit_col, lty = conf_lty)
      lines(x_plb, y_plb_conf_max, col = fit_col, lty = conf_lty)
    }
  }

  # Had a note to fix legend maybe, but seems okay
  if(!is.null(legend_label)){
    legend("topright",
           legend_label,
           bty = "n",
           inset = inset_label)
  }

  #  if(!is.na(year)){  # would need if keep strata/year in there
  #    legend("topright",
  #           legend = year,
  #           bty = "n",
  #           inset = inset_year)
  #  }

  if(!is.null(legend_text)){
  legend("topright",
         legend = legend_text,
         bty = "n",
         inset = inset_text)
  }


  # Add n
  if(!is.null(legend_text_n)){
  legend("topright",
         legend = legend_text_n,
         bty = "n",
         inset = legend_text_second_row_multiplier * inset_text)
  }

  box()     # to redraw axes over any boxes

  invisible()
}
