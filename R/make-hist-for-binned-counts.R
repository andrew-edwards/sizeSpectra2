##' Take a tibble with `bin_min`, `bin_max`, and `bin_count` and assign counts
##' to new equal bins based on `bin_min`, summing the original counts (which can
##' be non-integer).
##'
##' Called from
##' [determine_xmin_and_fit_mlebins()] to determine x_min for MLEbins
##' method.
##' Counts for an original bin are assigned to the new bin for which the
##' original `bin_min` falls into.
##' Gives values as a histogram list object and creates 0 counts for missing bins.
##' Can then use `plot()` which calls `plot.histogram()`. Without the 0 counts for missing bins
##' `plot.histogram()` does not plot counts because bins appear to have unequal widths.
##'
##' @param dat tibble of data in the format required for fitting
##'   using MLEbins methods; i.e. at a minimum has to include the columns:
##'     * `bin_min`
##'     * `bin_max`
##'     * `bin_count`.
##' @param bin_width numeric bin width to fit a histogram to help determine x_min
##' @param bin_start numeric value for the first bin to start at; if `NULL` then
##'   is set to the highest multiple of `bin_width` value below
##' `min(dat$bin_min)`.
##' @param x_name character to use for the histogram x-axis when plotted
##' (`xname` component of a histogram list); if `NULL` (the default) then
##' `Total counts in each bin` is used.
##' @return a histogram list object with components (see `?hist`):
##'  - `breaks`
##'  - `mids`
##'  - `counts`
##'  - `xname`
##'  - `equidist` TRUE since have equal bin widths
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' hh <- make_hist_for_binned_counts(sim_vec_binned)
##' hh
##' plot(hh)
##' }
make_hist_for_binned_counts <- function(dat,
                                        bin_width = 1,
                                        bin_start = NULL,
                                        x_name = NULL){

  if(is.null(bin_start)){
    bin_start <- min(dat$bin_min) -
      min(dat$bin_min) %% bin_width
  }

  if(is.null(x_name)){
    x_name = "Total counts in each bin"
  }

  # Vector of histogram bin breaks that we want to ascribe data to:
  hist_breaks <- seq(from = bin_start,
                     to = max(dat$bin_min) + bin_width,
                     by = bin_width)
  hist_bin_min <- hist_breaks[-length(hist_breaks)]

  # Work out the hist_break for each data bin_min, naming the factors using the
  # left-end of each hist_breaks bin. Vector in the order of the data
  dat_in_which_hist_bin <- cut(x = dat$bin_min,
                               breaks = hist_breaks,
                               # labels = hist_bin_min,
                               right = FALSE,
                               include.lowest = TRUE)

  # as.numeric on the levels messes up. Using this from ?cut to make them
  #  correct bin minima
  dat_in_which_hist_bin <- as.numeric( sub("\\[(.+),.*", "\\1",
                                           dat_in_which_hist_bin))

  dat_ascribed_to_hist_bins <- tibble::add_column(dat,
                                                  hist_bin_min =
                                                    dat_in_which_hist_bin)


  hist_bin_totals <- dplyr::summarise(dplyr::group_by(dat_ascribed_to_hist_bins,
                                                      hist_bin_min),
                                      total_count = sum(bin_count)) %>%
    dplyr::mutate(hist_bin_min = as.numeric(hist_bin_min))

  # For histogram plotting need values in all hist bins, so create tibble to join
  hist_bin_all_bins <- tibble::tibble(hist_bin_min = hist_bin_min) %>%
    dplyr::left_join(hist_bin_totals,
                     by = "hist_bin_min") %>%
    tidyr::replace_na(list(total_count = 0))

  # May need to think about this for MLEbin, do some tests. Keep all this
  # thinking in case we find an edge case for MLEbins; see -mlebin.R also.
  # From sizeSpectra::fitting() to do with LBNbiom method.
  # Don't think need this, but might for MLEbin  if the function needs
  # adapting. Think it was almost like a resonance effect.
  #                      eps = 0.0000001){

  # Check the bin widths are compatible with (i.e. multiples of) bin_width
  # Problem is due to floating point resolution, the remainder might be
  # 0.9999*bin_width. So can't just look at the absolute remainder.

  #   bin_diffs_remainder <- diff(counts_per_bin$binMid) %% bin_width

  # That gives some just above 0, and some just below bin_width
  # (if bin_width = 1 don't think this happens).

  #  bin_diffs_remainder_not_zero <- which(bin_diffs_remainder > eps &
  #                                        bin_diffs_remainder < bin_width - eps)

  #  if(length(bin_diffs_remainder_not_zero) != 0){
  #    stop("Need counts_per_bin$binMid to all be multiples of bin_width")
  #  }

  #  all_bins <- tibble::tibble(binMid = seq(min(counts_per_bin$binMid),
  #                                          max(counts_per_bin$binMid),
  #                                          bin_width))

  # It does not matter if first or final bins have zero counts (latter
  # should probably not happen anyway given how bins are constructed, though
  # might do in edge cases). This is just for determining x_min, not actually fitting.

  hist_res_list <- list(breaks = hist_breaks,
                   mids = hist_bin_min + bin_width/2,
                   counts = hist_bin_all_bins$total_count,
                   xname = x_name,
                   equidist = TRUE)

  class(hist_res_list) <- "histogram"

  hist_res_list
}
