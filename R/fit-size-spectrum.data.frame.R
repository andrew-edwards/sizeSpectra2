##' @rdname fit_size_spectrum
##' @export
fit_size_spectrum.data.frame <- function(dat,
                                         strata = NULL,
                                         ...){
  # See Issue #10. Still think it would be a nice feature, just have to
  # highlight in the vignette and help. If you had a strata or year column then
  # you would not want to fit all the data together anyway, presumably.
  if(!is.null(strata)){
    # Individual measurements, x, for a strata, do MLE for each strata
    # separately and then combine results.
    stop("strata option not written yet; issue #10. Email Andy if you want it")
    #res <- fit_size_spectrum_mle_strata(dat,
    #                                    strata = strata,
    #                                    ...)
  } else {
    res <- fit_size_spectrum_mlebin(dat,
                                    ...)
  }
  return(res)
}
