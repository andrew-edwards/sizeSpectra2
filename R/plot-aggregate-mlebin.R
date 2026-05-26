##' Do an aggregated MLEbin or MLEbins plot of several PLB fits, each to a separate (but related)
##' group of individuals; returns the fitted values.
##'
##' Given a list of MLEbin or MLEbins results, combine
##' the data and show an aggregated distribution, as well as the individual fits.

##' Users may need to play with the colour settings to get an instructive
##' plot; it is hard to automate all of them, see the arguments available.
##'
##' This creates the first plot using `plot.size_spectrum_mlebin()` or
##' `plot.size_spectrum_mlebins()`, depending on `class(res_list[[1]]). It then
##' makes the subsequent rectangles and lines here.
##'
##' @inheritParams plot_aggregate
##' @param rect_shading_equal_col_vec logical, if TRUE then shade in the
##' rectangles with the colour for that group, else if FALSE stick with grey. Will depend
##' how the figure looks (sometimes you cannot see the fitted curve if the
##' rectangles are large and the curve blends in); hard to fully automate.
##' @param rect_border_equal_col_vec logical, if TRUE then colour the borders of the
##' rectangles with the colour for that group, else stick with black. Will depend
##' how the figure looks; hard to fully automate.
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' # See fit-aggregated.html vignette at
##' # https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-aggregated.html
##' # for a worked example
##' }
##'
plot_aggregate_mlebin <- function(res_list,
                                  col_vec = c("orange", "lightblue", "green",
                                              "darkblue", "darkgreen"),
                                  col_agg = "magenta",
                                  rect_shading_equal_col_vec = FALSE,
                                  rect_border_equal_col_vec = TRUE,
                                  xlim_global = NULL,
                                  ylim_global = NULL,
                                  y_scaling = 0.25,
                                  return_agg_x_y = TRUE,
                                  ...){

  # Basing this on plot_aggregate() for size_spectrum_numeric results and using
  # code from plot.size_spectrum_mlebin(). Also moving in calculations that were
  # in aggregate_mlebins(). Hard to make the plotting functions
  # general enough to do this, so just copying the relevant bits here.

  if(!("list" %in% class(res_list))){
    stop("res_list need to be a list of lists of MLE results.")
  }

  if(length(res_list) > length(col_vec)){
    stop("Need to add more colours to col_vec to have one for each results component in res_list.")
  }

  if(!("size_spectrum_mlebin" %in% class(res_list[[1]]) |
       "size_spectrum_mlebins" %in% class(res_list[[1]]))){
    stop("res_list need to be a list of size_spectrum_mlebin or size_spectrum_mlebins results.")
  }

  S <- length(res_list)                     # Number of species groups
  group_names <- names(res_list)

  # Aggregate all the data together to plot
  aggregated_data_temp <- tibble::tibble()

  for(i in 1:S){
#    res <- res_list[[i]]
    # Just want the mlebins_fit object, keeping it intact it is class
    # size_spectrum_mlebins and the plotting works automatically.

    aggregated_data_temp <- rbind(aggregated_data_temp,
                                  res_list[[i]]$data)
  }

  # Next aggregate matching bin_min and bin_max (might not be any, as would
  # require two species in different groups to have same bin_min and bin_max),
  # but need to recalculate anyway since count_gte_bin_min etc. will be different
  # for aggregated data set compared to values in each group (these get ignored
  # once we do the summarise, so no need to filter out).

  aggregated_data <- dplyr::summarise(dplyr::group_by(aggregated_data_temp,
                                                      bin_min,
                                                      bin_max),
                                      bin_count = sum(bin_count)) %>%
    dplyr::ungroup() %>%
    dplyr::arrange(bin_min)

  # Can't do in dplyr, same approach as in fit_size_spectrum_mlebins(); maybe
  # create a function
  count_gte_bin_min <- rep(NA,
                           length = nrow(aggregated_data))
  low_count <- count_gte_bin_min
  high_count <- count_gte_bin_min

  for(iii in 1:length(count_gte_bin_min)){
    count_gte_bin_min[iii] <- sum( (aggregated_data$bin_min >= aggregated_data$bin_min[iii]) * aggregated_data$bin_count)
    low_count[iii] <- sum( (aggregated_data$bin_min >= aggregated_data$bin_max[iii]) * aggregated_data$bin_count)
    high_count[iii] <- sum( (aggregated_data$bin_max > aggregated_data$bin_min[iii]) * aggregated_data$bin_count)
  }

  aggregated_data$count_gte_bin_min <- count_gte_bin_min
  aggregated_data$low_count <- low_count
  aggregated_data$high_count <- high_count

  if(is.null(ylim_global)){
    ylim_global <- c(y_scaling * min(aggregated_data$count_gte_bin_min),
                     max(aggregated_data$high_count))
  }

  # Extract required values (need as vectors to create the aggregate fit)
  b_vec <- numeric()
  n_vec <- numeric()
  xmin_vec <- numeric()
  xmax_vec <- numeric()
  for(s in 1:S){
    b_vec[s] <- res_list[[s]]$b_mle
    n_vec[s] <- max(res_list[[s]]$data$high_count)
    xmin_vec[s] <- res_list[[s]]$x_min
    xmax_vec[s] <- res_list[[s]]$x_max  }

  # x_min and x_max for fitting
  xmin_agg <- min(xmin_vec)
  xmax_agg <- max(xmax_vec)


  # xlim for plotting
  if(is.null(xlim_global)){
    xlim_global <- c(xmin_agg,
                     xmax_agg)
  }

  if(rect_shading_equal_col_vec){
    rect_shading_col_vec <- col_vec
    agg_shading_col <- col_agg
  } else {
    rect_shading_col_vec <- rep("grey", length(col_vec))
    agg_shading_col <- "grey"
  }

  if(rect_border_equal_col_vec){
    rect_border_col_vec <- col_vec
    agg_border_col <- col_agg
  } else {
    rect_border_col_vec <- rep("black", length(col_vec))
    agg_border_col <- "black"
  }

  seg_col_vec = rect_border_col_vec
                           # May want different for MLEbins if want green still in
                           # there, bit doubtful though as would get too busy I
                           # expect, and didn't for Med paper.

  # Plot first one to automatically set up axes etc.
  plot(res_list[[1]],    # Call depends on class of res_list[[1]]
       xlim = xlim_global,
       ylim = ylim_global,
       # col = col_vec[1],
       fit_col = col_vec[1],
       legend_text_a = NA,
       legend_text_a_n = NA,
       seg_col = seg_col_vec[1],
       rect_shading_col = rect_shading_col_vec[1],
       rect_border_col = rect_border_col_vec[1],
       ...
       )

  # Full aggregated data, taking from plot_isd_binned():
    rect(xleft = aggregated_data$bin_min,
       ybottom = aggregated_data$low_count,
       xright = aggregated_data$bin_max,
       ytop = aggregated_data$high_count,
       col = agg_shading_col,
       border = agg_border_col)

  segments(x0 = aggregated_data$bin_min,
           y0 = aggregated_data$count_gte_bin_min,
           x1 = aggregated_data$bin_max,
           y1 = aggregated_data$count_gte_bin_min,
           col = agg_border_col)

  # if(log == "xy")    # Not including any other option yet, or at least haven't
  # fully tested them all

  # Need to manually draw the rectangle with low_count = 0 since it doesn't
  #  get plotted on log-log plot
  extra_rect <- dplyr::filter(aggregated_data,
                              low_count == 0)
  # if(nrow(extra.rect) > 1) stop("Check rows of extra rect.")

  rect(xleft = extra_rect$bin_min,
       ybottom = rep(0.01 * ylim_global[1],
                     nrow(extra_rect)),
       xright = extra_rect$bin_max,
       ytop = extra_rect$high_count,
       col = agg_shading_col,
       border = agg_border_col)

  segments(x0 = aggregated_data$bin_min,
           y0 = aggregated_data$count_gte_bin_min,
           x1 = aggregated_data$bin_max,
           y1 = aggregated_data$count_gte_bin_min,
           col = agg_border_col)
  # }

  # x values at which to calculate PLB's and PLB_agg; have to do each one
  # manually here.
  # Doing evenly on a log scale since range is quite large for aggregated, and
  # x-axis is always logged
  x_plb_agg <- 10^seq(log10(xmin_agg),
                      log10(xmax_agg),
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
  # Above can give negative value due to rounding, so change any negative value
  #  to a small value. Pretty sure it's just numerical errors close to 0; just
  #  set to the minimum one.

  y_plb_agg[y_plb_agg < 0] <-  min(y_plb_agg[y_plb_agg > 0]) * 0.01

  lines(x_plb_agg,
        y_plb_agg,
        col = col_agg,
        lwd = 4)

  # Now do remaining groups, just add them manually here
  for(s in 2:S){
    this_group_data <- res_list[[s]]$data

    rect(xleft = this_group_data$bin_min,
         ybottom = this_group_data$low_count,
         xright = this_group_data$bin_max,
         ytop = this_group_data$high_count,
         col = rect_shading_col_vec[s],
         border = rect_border_col_vec[s])
    segments(x0 = this_group_data$bin_min,
             y0 = this_group_data$count_gte_bin_min,
             x1 = this_group_data$bin_max,
             y1 = this_group_data$count_gte_bin_min,
             col = seg_col_vec[s])

  # if(log == "xy")    # Not including any other option yet,

  # Need to manually draw the rectangle with low_count = 0 since it doesn't
  #  get plotted on log-log plot
    extra_rect <- dplyr::filter(this_group_data,
                                low_count == 0)
    # if(nrow(extra.rect) > 1) stop("Check rows of extra rect.")
    rect(xleft = extra_rect$bin_min,
         ybottom = rep(0.01 * ylim_global[1],
                       nrow(extra_rect)),
         xright = extra_rect$bin_max,
         ytop = extra_rect$high_count,
         col = rect_shading_col_vec[s],
         border = rect_border_col_vec[s])

    segments(x0 = this_group_data$bin_min,
             y0 = this_group_data$count_gte_bin_min,
             x1 = this_group_data$bin_max,
             y1 = this_group_data$count_gte_bin_min,
             col = seg_col_vec[s])

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
