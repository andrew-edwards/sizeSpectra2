##' Aggregated bounded power-law distributions across multiple samples
##'
##' For data that are collected using different sampling techniques but are
##' desired to be aggregated, the measured sizes can be fitted separately
##' for each sample, using likelihood. See the [fit-aggregated vignette](https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-aggregated.html). For each sample, $s = 1, 2, 3, ..., S$, we then have a
##' fitted fitted exponent $b_s$, and minima and maxima of that sample (based on
##' the data).
##'
##' Here we construct the resulting probability density function, [dPLB_agg()],
##' and cumulative distribution function, [pPLB_agg()], based on math worked out
##' in Appendix B of [Quevedo et
##' al. (2026)](https://www.sciencedirect.com/science/article/pii/S2351989426001769). [pPLB_agg()]
##' . Results then feed into
##' `plot_aggregate()] to generate the plot -- the resulting fitted aggregate
##' distribution is different to the simple approach of fitting one PLB to the
##' full data set (which is not appropriate when the samples have different
##' sampling protocols, or are not comparable for other reasons).
##'
##' I have not written `rPLB()` yet as it is a bit tricky (and is not really
##' needed for people fitting their data, but is useful for simulating and
##' understanding). If generating random numbers using
##' `rPLB_agg()` then probably should sample `sum(n_vec)` from the full
##' distribution; need to think about. Note for [rPLB()] we had this, which we don't
##' want here: number of random numbers to be generated (if `length(n) > 1` then
##' generate `length(n)` values).
##' @param x vector of values to compute the density and distribution functions.
##' @param n_vec vector of known (or assumed) sample size for each sample,
##' element `s` corresponds to sample `s`.
##' @param b_vec vector of exponents of the PLB distribution, one element for each sample
##' @param xmin_vec vector of minimum bounds of the distributions, each element
##'   is the assumed value for each sample, which will probably be defined (by
##'   the user) as the minimum body size of the data for each sample
##' @param xmax_vec as for `xmin_vec` but for maximum bounds
##' @return `dPLB_agg` returns a vector of probability density values
##' corresponding to `x`. `pPLB_agg` returns a vector of cumulative
##' distribution values P(X <= x) corresponding to `x`. `rPLB_agg` (when
##'   written) will return a vector (of length `sum(n_vec)`) of independent
##'   random draws from the full aggregated distribution.
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' # See
##' https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-aggregated.html
##' vignette for a worked example
##' x <- 1:1500
##' y <- dPLB_agg(x,
##'   b_vec = c(-1, -2, -3, -4),
##'   n_vec = c(6000, 6000, 1600, 2000),
##'   xmin_vec = c(0.3, 10, 100, 500),
##'   xmax_vec = c(80, 800, 1000, 1500))
##' # Can do same example arguments for pPLB_agg()
##' }
##'
dPLB_agg <- function(x,
                     b_vec,
                     n_vec,
                     xmin_vec,
                     xmax_vec){
  expect_equal(rep(length(b_vec),
                   3),
               c(length(n_vec),
                 length(xmin_vec),
                 length(xmax_vec)))

  y <- 0 * x     # so have zeros where x < x_min or x > x_max

  for(s in 1:length(b_vec)){
    y <- y + n_vec[s] * dPLB(x,
                             b = b_vec[s],
                             x_min = xmin_vec[s],
                             x_max = xmax_vec[s])
  }
  # dPLB returns 0's for outside of the range, so don't need explicit indicator functions
  y <- y / sum(n_vec)
  return(y)
}

##' @rdname dPLB_agg
##' @export
pPLB_agg <- function(x,
                     b_vec,
                     n_vec,
                     xmin_vec,
                     xmax_vec){
  expect_equal(rep(length(b_vec),
                   3),
               c(length(n_vec),
                 length(xmin_vec),
                 length(xmax_vec)))

  y <- 0 * x     # so have zeros where x < x_min

  for(s in 1:length(b_vec)){
    y <- y + n_vec[s] * pPLB(x,
                             b = b_vec[s],
                             x_min = xmin_vec[s],
                             x_max = xmax_vec[s])
  }
  # pPLB returns 0's and 1's for outside of the range, so don't need explicit indicator functions
  y <- y / sum(n_vec)
  return(y)
}
