##' Calculate negative log-likelihood of a vector of values for the bounded power-law
##'   distribution
##'
##' Calculate the negative log-likelihood of the parameters `b`, `x_min` and
##'   `x_max` given data `x` for the PLB model. Returns the negative
##'   log-likelihood. Will be called by `nlm()` or similar. `x_min` and `x_max`
##'   are just estimated as the min and max of the data, not numerically using likelihood.
##' @param b value of `b` for which to calculate the negative log-likelihood
##' @param x vector of values of data (e.g. masses of individual fish)
##' @param n `length(x)`, have as an input to avoid repeatedly calculating it when
##'   function is called multiple times in an optimization routine
##' @param x_min minimum value of `x` to avoid repeatedly calculating
##' @param x_max maximum value of `x` to avoid repeatedly calculating
##' @param sum_log_x `sum(log(x))` to avoid repeatedly calculating
##' @return numeric negative log-likelihood of the parameters given the data
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' # Gives the negative likelihood value for the PLB distribution for the
##' # simulated vector of data at the value of b = -3:
##' neg_ll_mle_method(b = -3,
##'                   x = sim_vec,
##'                   n = length(sim_vec),
##'                   x_min = min(sim_vec),
##'                   x_max = max(sim_vec),
##'                   sum_log_x = sum(log(sim_vec)))
##' # Those last four would be calculated outside the repeated calls to the
##' # function, but are shown here for the example; e.g. see
##' # fit_size_spectrum_numeric() code.
##' }
neg_ll_mle_method = function(b,
                             x,
                             n,
                             x_min,
                             x_max,
                             sum_log_x){
  if(x_min <= 0 | x_min >= x_max) stop("Parameters out of bounds in neg_ll_mle_method()")
  if(b != -1){
    neg_ll = -n * log( ( b + 1) / (x_max^(b + 1) - x_min^(b + 1)) ) -
      b * sum_log_x
  } else {
    neg_ll = n * log( log(x_max) - log(x_min) ) + sum_log_x
  }
  return(neg_ll)
}
