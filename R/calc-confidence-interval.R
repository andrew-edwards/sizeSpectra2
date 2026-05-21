##' Calculate confidence interval
##'
##' Gets called from [calc_mle_conf()].
##'
##' @param min_neg_ll_value the minimum negative log likelihood value at the MLE.
##' @inheritParams calc_mle_conf
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##'
##' }
calc_confidence_interval <- function(this_neg_ll_fn,
                                     min_neg_ll_value,
                                     vec,
                                     ...){

  # Negative log-likelihood at values of b_vec to test to obtain confidence
  #  interval. For the real movement data
  #  sets in Table 2 of Edwards (2011) the intervals were symmetric, so make a
  #  symmetric interval here.

  neg_ll_vals <- sapply(X = vec,
                        FUN = this_neg_ll_fn,
                        ...)

  crit_val <- min_neg_ll_value  + qchisq(0.95,1)/2
                      # 1 degree of freedom, Hilborn and Mangel (1997) p162.

  values_in_95 <- vec[neg_ll_vals < crit_val] # b values in 95% confidence interval
  conf = c(min(values_in_95),
           max(values_in_95))

  return(conf)
}
