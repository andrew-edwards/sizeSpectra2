##' Biomass cumulative distribution function from MEE equations A.4 and A.8
##'
##' Total biomass between `x_min` and `x`, assuming a bounded power-law
##' distribution of body masses between `x_min` and `x_max` and a given value of
##' exponent `b`, and a total of `n` individuals.
##'
##' Given by MEE equations A.4 and A.8. Can then be called by [p_biomass_bins()]
##' to give total biomass (and normalised biomass) in each bin.
##'
##' @param x vector of values for which to calculate the total biomass between
##' `x_min` and the value
##' @param b estimated exponent of the PLB distribution
##' @param x_min minimum bound of the distribution, `x_min > 0`
##' @param x_max maximum bound for bounded distribution, `x_max > x_min`
##' @param n number of individuals (or total counts)
##' @return return vector of total biomass between `x_min` and each value of `x`
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' p_biomass(x = c(1, 5, 10, 20, 50, 100),
##'           b = -2,
##'           x_min = 1,
##'           x_max = 100,
##'           n = 1000)
##' }
p_biomass <- function(x,
                      b,
                      x_min,
                      x_max,
                      n){

  if(x_min <= 0 | x_min >= x_max | n <= 0){
    stop("Parameters out of bounds in p_biomass")
  }

  # return the biomass distribution at each value, but have to tweak any <x_min
  #  and > x_max.

  if(b != -1){
    C <- (b+1) / ( x_max^(b+1) - x_min^(b+1) )
  } else {
    C <- 1/ ( log(x_max) - log(x_min) )
  }

  if(b != -2){
    biomass <- n * C * (x^(b+2) - x_min^(b+2)) / (b + 2)
    biomass_for_xmax <- n * C * (x_max^(b+2) - x_min^(b+2)) / (b + 2)  # might not
                                        # be one of x
  } else {
    biomass <- n * C * (log(x) - log(x_min))
    biomass_for_xmax <- n * C * (log(x_max) - log(x_min))
  }

  biomass[x < x_min] <- 0         # so have zeros where x < x_min
  biomass[x > x_max] <- biomass_for_xmax

  return(biomass)
}
