##' Given histogram object of counts and bins (and maybe density) , determine the mode and return min of that bin as x_min
##'
##' @param h histogram object, e.g. from running [make_hist()] on a vector, or
##' [make_hist_for_binned_counts()] or
##' [make_hist_for_binned_counts_mlebin()] on a data.frame for MLEbins or MLEbin
##' method, respectively.
##' @return x_min to use to fit ISD, and to plot the histogram to show the full
##'   data and the mode.
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' sim_vec_binned_2 <- sim_vec_binned
##' sim_vec_binned_2[1, "bin_count"] <- 100  # lower count for first bin
##' hh <- make_hist_for_binned_counts_mlebin(sim_vec_binned)
##' x_min <- determine_xmin_based_on_hist(hh)
##' x_min
##'
##' # The above gets calculated automatically within:
##' res_binned_2 <- determine_xmin_and_fit_mlebin(sim_vec_binned_2)
##' plot(res_binned_2)
##' }
determine_xmin_based_on_hist <- function(h){
  stopifnot("h needs to be a histogram object" =
              class(h) == "histogram")

  max_ind <- ifelse(h$equidist,
                    which.max(h$counts),  # returns the first one if they are ties
                    which.max(h$density)) # for unequal bin widths

  # Give error (since fitting code breaks anyway) if end up with only one bin;
  #  in the testing I check that it still works with only two bins
  if(max_ind == length(h$counts)){
     stop("The maximum count is in the final bin, so a descending PLB is not appropriate and will not be fit.")
  }

  x_min <- h$breaks[max_ind]

  x_min
}
