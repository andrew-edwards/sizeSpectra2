##' Do an aggregated plot of several PLB fits, each to a separate (but related)
##' group of individuals, and return aggregated plot
##'
##' Given a list of MLE results obtained from vectors of data (each component of
##' the list should have class `size_spectrum_numeric`), combine
##' the data and show an aggregated distribution, as well as the individual
##' fits. Return the x and y values of the aggregated plot. The calculations use
##' the ranges of the axes, which is why calculations and plotting is combined
##' here in the same function. For results from using the MLEbin and MLEbins methods use
##' [plot_aggregate_mlebin()] (it works for both types).
##'
##' The default is to plot logarithmic x and y axes; should presumably work with
##' some of the options of `style` in `plot.size_spectrum_mlebin()` and
##' `plot.size_spectrum_mlebins()`, but I have not tried them all.
##'
##' @param res_list list of results, with each component a list object of either
##' (it is hard to automate this):
##'   * class `size_spectrum_numeric` from applying [fit_size_spectrum()] to a
##' vector of individual body sizes; use `plot_aggregate()`
##'   * class `size_spectrum_mlebin` from using the MLEbin method for binned
##' data, or class `size_spectrum_mlebins` from using the MLEbins method; use
##' `plot_aggregate_mlebin()`
##' @param col_vec vector of colours to assign for each group, used for the
##'   individual data points for individual data, or borders of the rectangles
##' for binned data, and the fitted curve
##' @param col_vec vector of colours, one for each of the fits
##' @param col_agg colour for the aggregated fit
##' @param xlim_global two-component vector to specify the global `xlim`; if
##' `NULL` (the default) then calculated automatically
##' @param ylim_global as `ylim_global` for the global `ylim`
##' @param return_agg_x_y logical, whether to return the aggregated x and y for plotting
##' values of the aggregated fit
##' @param ... additional arguments to pass onto
##' `plot.size_spectrum.numeric(...)` or `plot.size_spectrum_mlebin()` or
##' `plot.size_spectrum_mlebins()` as appropriate.
##' @return if `return_agg_x_y` is `TRUE` then return a list with two objects, `x_plb_agg` and `y_plb_agg`, which are the
##'   fitted x and y values used to plot the aggregated size spectrum (which does not
##'   have a simple exponent). These can then be use for plotting multiple
##' strata in [plot_aggregate_fits()].
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' # See fit-aggregated.html vignette at
##' # https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-aggregated.html
##' # for a worked example
##' }
##'
plot_aggregate <- function(res_list,
                           col_vec = c("orange", "lightblue", "green",
                                       "darkblue", "darkgreen"),
                           col_agg = "magenta",
                           xlim_global = NULL,
                           ylim_global = NULL,
                           return_agg_x_y = TRUE,
                           ...){

  if(!("list" %in% class(res_list))){
    stop("res_list need to be a list of lists of MLE results.")
  }

  if(!("size_spectrum_numeric" %in% class(res_list[[1]]))){
    stop("res_list need to be a list of size_spectrum_numeric results.")
  }


  if(length(res_list) > length(col_vec)){
    stop("Need to add more colours to col_vec to have one for each results component in res_list.")
  }

  S <- length(res_list)

  # This is for size_spectrum_numeric:
  x_global <- numeric()
  for(s in 1:S){
    x_global <- c(x_global,
                  res_list[[s]]$x)
  }

  x_global <- sort(x_global,
                   decreasing = TRUE)

  if(is.null(xlim_global)){
    xlim_global <- range(x_global)
  }

  if(is.null(ylim_global)){
    ylim_global <- c(1, length(x_global))
  }

  # Extract required values
  b_vec <- numeric()
  n_vec <- numeric()
  xmin_vec <- numeric()
  xmax_vec <- numeric()
  for(s in 1:S){
    b_vec[s] <- res_list[[s]]$b_mle
    n_vec[s] <- length(res_list[[s]]$x)
    xmin_vec[s] <- res_list[[s]]$x_min
    xmax_vec[s] <- res_list[[s]]$x_max   }

  # Plot first one to automatically set up axes etc.
  plot(res_list[[1]],
       xlim = xlim_global,
       ylim = ylim_global,
       col = col_vec[1],
       fit_col = col_vec[1],
       legend_text_a = NA,
       legend_text_a_n = NA,
       ...)

  # Full data
  points(x_global,
         1:length(x_global))

  # x values at which to calculate PLB's and PLB_agg; may have to do each one
  # manually here
  # Doing evenly on a log scale since range is quite large for aggregated, and
  # x-axis is always logged
  x_plb_agg <- 10^seq(log10(xlim_global[1]),
                      log10(xlim_global[2]),
                      length = 1000)     # x values to plot PLB

  #  Need to insert value close to x_max to make log-log curve go down further;
  #   since log(1 - pPLB(x_max, ...)) = log(0) = -Inf   we need to force the asymptopte
  x_plb_agg_length <- length(x_plb_agg)

  x_plb_agg <- c(x_plb_agg[-x_plb_agg_length],
                 0.9999999999 * x_plb_agg[x_plb_agg_length],
                 x_plb_agg[x_plb_agg_length])

  # Add aggregated distribution first so that the right-most distribution shows up okay as
  # it overlays the aggregated one (and is thinner line).

  y_plb_agg = (1 - pPLB_agg(x = x_plb_agg,
                            b_vec = b_vec,
                            n_vec = n_vec,
                            xmin_vec = xmin_vec,
                            xmax_vec = xmax_vec)) * sum(n_vec)
  lines(x_plb_agg,
        y_plb_agg,
        col = col_agg,
        lwd = 4)

  # Now do remaining groups, just add them manually here
  for(s in 2:S){
    points(sort(res_list[[s]]$x,
                decreasing = TRUE),
           1:length(res_list[[s]]$x),
           col = col_vec[s])

    x_plb <- 10^seq(log10(xmin_vec[s]),
                    log10(xmax_vec[s]),
                    length = 1000)     # x values to plot PLB

    #  Need to insert value close to x_max to make log-log curve go down further;
    #   since log(1 - pPLB(x_max, ...)) = log(0) = -Inf   we need to force the asymptopte
    x_plb_length <- length(x_plb)

    x_plb <- c(x_plb[-x_plb_length],
               0.9999999999 * x_plb[x_plb_length],
               x_plb[x_plb_length])

    lines(x_plb,
          (1 - pPLB(x = x_plb,
                    b = b_vec[s],
                    x_min = xmin_vec[s],
                    x_max = xmax_vec[s])) * n_vec[s],
          col = col_vec[s])
  }

  if(return_agg_x_y){
    return(list(x_plb_agg = x_plb_agg,
                y_plb_agg = y_plb_agg))
  }

}
