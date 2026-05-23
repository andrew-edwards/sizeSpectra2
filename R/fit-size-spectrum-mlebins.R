##' Fit a size spectrum to data using the MLEbins method.
##'
##' The MLEbins method calculates the maximum likelihood estimate
##' of the size-spectrum exponent, $b$, when the data are collected as lengths and
##' we have species-specific length-weight coefficients. So individual body masses
##' are not available. Or, if you have binned body masses but the bins overlap,
##' then you also need to use MLEbins. The method is described in our MEPS
##' paper.
##'
##' @param dat `data.frame` of the data to be fit using MLEbins, where each row represents a
##' bin. At a minimum this has to include the columns:
##'   * `bin_min`
##'   * `bin_max`
##'   * `bin_count`.
##' The values `bin_min` and `bin_max` in each row correspond to the min and max
##' bounds of that bin, with `bin_count` being the count of individuals in that
##' bin. Note that `bin_count` can be non-integer, which, in particular, happens
##' when integer counts are scaled by effort. An extra column may well be
##' `species` identification, though this is not needed for the analysis (extra
##' columns are preserved in the output). The bin with the smallest `bin_min`
##' value and the bin with the largest `bin_max` value must both have non-zero
##' `bin_count` unless you explicitly specify `x_min` and/or `x_max` as appropriate.
##' @param x_min minimum value of data to fit the PLB distribution to. If `NULL`
##'   (the default) then it is set to the minimum bin break of the lowest
##' bin (which must have non-zero `bin_count` as mentioned above). If not `NULL`
##'   then the fitting is restricted to values greater than or equal to
##'   `x_min`, which for the MLEbins method is the first full bin equal to or above `x_min`
##'   (i.e. first bin with `bin_min >= x_min`). Similarly for `x_max` (fitting
##'   is restricted to including the largest bin for which `bin_max <= x_max`).
##' @param x_max maximum value of data to fit the PLB distribution to. If `NULL`
##'   (the default) then it is set to the maximum bin break of the highest bin
##' (which must have non-zero `bin_count` as mentioned above.)
##' @param b_vec vector of values for the confidence interval calculation, to be
##'   used as the `vec` argument of `calc_mle_conf()`
##' @param b_vec_inc increment value for the confidence interval calculation, to be
##'   used as the `vec_inc` argument of `calc_mle_conf()`
##' @param b_start for the MLEbins method, the starting estimate for numerical
##'   search for the MLE; since there is no analytical value that can be
##'   calculated. Change this if you run into numerical issues.
##'
##' @return `list` object of class `size_spectrum_mlebins`, such that we can
##' automatically plot it with [plot.size_spectrum_mlebins()], with objects
##'   * `b_mle` maximum likelihood estimate of $b$
##'   * `b_conf` vector giving 95% confidence interval for $b$
##'   * `data` the original `data.frame` `dat`, arranged by
##' the increasing values of `bin_min`, and also has the columns
##'     * `count_gte_bin_min` total count of values in bins for which `bin_min`
##' \eqn{\geq} the value of `bin_min` for this row
##'     * `low_count` total count of values in bins for which `bin_min`
##' \eqn{\geq} the value of `bin_max` for this row, so the lowest possible count of
##' values above this bin
##'     * `high_count` total count of values in bins for which `bin_max`
##' \eqn{\geq} the value of `bin_min` for this row, so the highest possible count of
##' values above this bin.
##' Note that if `x_min` and/or `x_max`
##' are prescribed such that some data are not included in the fit (e.g. `x_min`
##' is greater than the `bin_max` of the smallest bin), then they are omitted in `data`.
##'   * `x_min` the `x_min` value used for the fitting
##'   * `x_max` the `x_max` value used for the fitting
##'   * `n` the sum of the counts in the bins used for the fitting
##'   * `method` to describe the fitting method used, in this case `MLEbins`
##' @export
##' @examples
##' \dontrun{
##' # See the rendered vignette
##' # https://andrew-edwards.github.io/sizeSpectraFit/vignettes/fit-data-mlebins.html
##' # for a worked example.
##' }
##'
fit_size_spectrum_mlebins <- function(dat,
                                      x_min = NULL,
                                      x_max = NULL,
                                      b_start = -1.9,   # no analytical value
                                      b_vec = NULL,
                                      b_vec_inc = 0.00001){


  # Fitting MLEbins method. Need dat
  stopifnot("dat needs to include columns bin_min, bin_max, and bin_count to use the MLEbins method" = c("bin_min", "bin_max", "bin_count") %in% names(dat))

  df <- tibble::as_tibble(dat)     # df is tibble to be fitted, can get
                                   # restricted in next lines

  df <- dplyr::arrange(df,
                       bin_min)
                       # species,    # don't want to do that as it messes up
                       # plotting, and kind of don't care about specific species
                       # as have already dealt with the species-specific aspects

  if(!is.null(x_min)){
    df <- dplyr::filter(df,
                        bin_min >= x_min)
  } else {
    if(df[1, "bin_count"] == 0){
      # already arranged in order above; if 0 then do not want to use to calculate
      # x_min; have not fully thought about if the lowest is 0 but equal lowest
      # (has the same bin_min) is non-zero
      stop("Need to have a non-zero bin_count for the bin with the smallest bin_min when not specifying x_min; remove such a bin and rerun.")
    } else {
      x_min <- min(df$bin_min)
    }
  }

  if(!is.null(x_max)){
    df <- dplyr::filter(df,
                        bin_max <= x_max)
  } else {
    if(df[which.max(df$bin_max), "bin_count"] == 0){   # might error if multiple
      # but that's okay
      stop("Need to have a non-zero bin_count for the bin with the largest bin_max when not specifying x_max; remove such a bin and rerun.")
    } else {
    x_max <- max(df$bin_max)
    }
  }

  if(x_min <= 0 | x_min >= x_max){
    stop("Parameters x_min and/or x_max out of bounds in fit_size_spectrum_mlebins(), maybe called by fit_spectrum.data.frame(), for MLEbins method")
  }

  n <- sum(df$bin_count)

  mle_and_conf <- calc_mle_conf(this_neg_ll_fn = neg_ll_mlebins_method,
                                p = b_start,
                                vec = b_vec,
                                vec_inc = b_vec_inc,
                                x_min = x_min,
                                x_max = x_max,
                                data_for_mlebins = df,
                                # w = w,
                                # d = d,
                                # J = J,
                                n = n)

  # Need for plotting rectangles in ISD type plots, so calculate here to be able
  # to extract values and to simplify passing through functions.

  # count_gte_bin_min is, for a given bin, the total counts >= than that bin's minimum.

  # Can't do these in dplyr, but then cbind later:
  count_gte_bin_min <- rep(NA, length = nrow(df))
  low_count <- count_gte_bin_min
  high_count <- count_gte_bin_min

  for(iii in 1:length(count_gte_bin_min)){
    count_gte_bin_min[iii] <- sum( (df$bin_min >= df$bin_min[iii]) * df$bin_count)
    low_count[iii] <- sum( (df$bin_min >= df$bin_max[iii]) * df$bin_count)
    high_count[iii] <- sum( (df$bin_max > df$bin_min[iii]) * df$bin_count)
  }

  df$count_gte_bin_min <- count_gte_bin_min
  df$low_count <- low_count
  df$high_count <- high_count

  res <- list(b_mle = mle_and_conf$mle,
              b_conf = mle_and_conf$conf,
              data = df,
              x_min = x_min,
              x_max = x_max,
              n = n,
              method = "MLEbins")

  class(res) = c("size_spectrum_mlebins",
                 class(res))

  return(res)
}
