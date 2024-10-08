% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/calc-confidence-interval.R
\name{calc_confidence_interval}
\alias{calc_confidence_interval}
\title{Calculate confidence interval}
\usage{
calc_confidence_interval(this_neg_ll_fn, min_neg_ll_value, vec, ...)
}
\arguments{
\item{min_ll}{list output from \code{\link[=nlm]{nlm()}}.}
}
\description{
Gets called from \code{\link[=fit_size_spectrum.numeric]{fit_size_spectrum.numeric()}}. TODO may need to be explicit
about the help. Might be simpler as fitting function gets more complex.
}
\examples{
\dontrun{

}
}
\author{
Andrew Edwards
}
