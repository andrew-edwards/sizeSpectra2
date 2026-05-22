##' Convert a vector of body sizes into a histogram list object and create 0 counts for missing bins.
##'
##' Can then use `plot()` which calls `plot.histogram()`. Without the 0 counts for missing bins
##' `plot.histogram()` does not plot counts because bins appear to have unequal widths.
##'
##' @param x numeric vector of values.
##' @param bin_width numeric bin width for the data set.
##' @param bin_start numeric value for the first bin to start at; if `NULL` then
##'   set to the next multiple of `bin_width` below `min(x)`. If `bin_width = 1` then this will
##'   be the integer below `min(x)` (i.e. `min(x) %/% 1`). If,
##'   say, `min(x) = 10.6` and `bin_width = 0.5` then `bin_start = 10.5`.
##' @param x_name character to use for the histogram x-axis when plotted
##' (`xname` component of a histogram list); if `NULL` (the default) then
##' `Body length (x), mm` is used.
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
##' x <- 1:10
##' make_hist(x)
##' }
make_hist <- function(x,
                      bin_width = 1,
                      bin_start = NULL,
                      x_name = NULL){
  if(is.null(bin_start)){
    bin_start <- min(x) - min(x) %% bin_width
  }

  if(is.null(x_name)){
    x_name = "Body length (x), mm"
  }

  breaks <- seq(from = bin_start,
                to = max(x) + bin_width,
                by = bin_width)
  # Given seq generates values up to the sequence value below `to`, this should
  #  ensure final bin has max(x) in it. But if max(x) is exactly a bin break,
  #  need to remove the top 0 count, since bins are ( , ]. Doing below.
  h <- hist(x,
            breaks = breaks,
            plot = FALSE)
  h$xname <- x_name

  n <- length(h$counts)

  # Remove top count if 0 (see above)
  if(h$counts[n] == 0){
    h$breaks <- h$breaks[-(n+1)]
    h$counts <- h$counts[-n]
    h$density <- h$density[-n]
    h$mids <- h$mids[-n]
  }

  h
}
