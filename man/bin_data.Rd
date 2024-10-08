% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bin-data.R, R/bin-data.data.frame.R,
%   R/bin-data.numeric.R
\name{bin_data}
\alias{bin_data}
\alias{bin_data.data.frame}
\alias{bin_data.numeric}
\title{Construct bins that either double in size or are of equal width, and encompass
the data}
\usage{
bin_data(dat, ...)

\method{bin_data}{data.frame}(dat, bin_width = NULL, bin_breaks = NULL, start_integer = TRUE)

\method{bin_data}{numeric}(dat = NULL, ...)
}
\arguments{
\item{dat}{numeric vector of individual values (e.g. body masses) OR a
data.frame with first column \code{x} being the measured values
(e.g. body masses or lengths), and second column \code{counts} being the counts of the
number of individuals for that value. The \code{counts} column can have
non-integer values. The corresponding function \code{bin_data.numeric()} or
\code{bin_data.data.frame()} then gets used.}

\item{...}{arguments to pass onto \code{bin_data.data.frame()}}

\item{bin_width}{type of bins to use:
\itemize{
\item \code{"2k"} will result in \code{bin_breaks} that:
\itemize{
\item with \code{start_integer=TRUE} are powers of 2, i.e. ..., 0.25, 0.5, 1, 2, 4, 8, 16,....
\item with \code{start_integer=FALSE} are bins that double in size and  start with
\code{min(x)}; not yet implemented, since have to think about what the width of
the first bin should be.
}
\item numeric value (call it \code{a}) will result in bin_breaks are separated by \code{a} and span the
data, that:
\itemize{
\item with \code{start_integer=TRUE} start from \code{z = floor(min(x))} and are then
\verb{z, z+a, z+2a, z+3a, ....}   (if \code{z = 0} then power-law cannot be fit
so then need to use \code{start_integer=FALSE})
\item with \code{start_integer=FALSE} start from \code{z = min(x)} and are then
\verb{z, z+a, z+2a, z+3a, ....}
}
\item exactly one of \code{bin_width} or \code{bin_breaks} must be specified.
}}

\item{bin_breaks}{pre-defined bin breaks as a vector. Exactly one of  \code{bin_width}
or \code{bin_breaks} must be specified.}

\item{start_integer}{TRUE or FALSE, whether to start the bin breaks at an integer
power of 2 (for method \code{"2k"}) or an integer. See \code{bin_width} above.
\code{start_integer} is ignored if \code{bin_breaks} is specified.}
}
\value{
list containing:
\itemize{
\item bin_for_each_x: tibble with a row for each \code{counts_df$x} value, with columns:
\itemize{
\item \code{x}: original \code{x} or \code{counts_df$x} values (depending on the input)
\item \code{bin_mid}, \code{bin_min}, \code{bin_max}, \code{bin_width}: midpoint, minimum,
maximum, and width, respectively, of the bin within
which the \code{x} value falls.  If bin_for_each_x has \verb{>=10^6} rows then it isn't
saved.
}
\item bin_vals: tibble with a row for each new bin and columns:
\itemize{
\item \code{bin_mid}, \code{bin_min}, \code{bin_max}, \code{bin_width}: midpoint, minimum,
maximum, and width, respectively, of the bin
\item \code{bin_count}: total count of numbers of individuals in that bin
\item \code{bin_count_norm}: normalised bin count, \code{bin_count / bin_width}
\item \code{bin_sum}: sum of numbers of individuals * x values in that bin
(appropriate if \code{x} represents biomass, but not length)
\item \code{bin_sum_norm}: \code{bin_sum / bin_width}
\item \code{log10....} - \code{log10()} of some of the above quantities
}
}
}
\description{
Takes either a \code{numeric} vector of values (e.g. body masses) or a \code{data.frame}
of counts of values, and bins the values or counts into bins. In particular
needed for
MLEbin method (TODO function is ??) and the goodness-of-fit tests.
The counts can take non-integer values, which can occur when standardising field
measurements.
}
\details{
Constructs bins that start from \code{floor(min(x))} or \code{min(x)} and either double
in size or are of equal width, and encompass the data. User must specify
either \code{bin_width} or
\code{bin_breaks}.

Bins are defined intervals \verb{[w_j, w_\{j+1\})}, which means values
\code{x} in the interval satisfy \verb{w_j <= x < w_\{j+1\}}, i.e. closed on the left
and open on the right.  The exception being for
the highest bin \verb{[w_\{J-1\}, w_J]} which includes both bin breaks; see p11 of
Appendix of MEE paper \link{1} for more details. Functions are adapted from
\code{\link[sizeSpectra:binData]{sizeSpectra::binData()}}.
}
\examples{
\dontrun{
x <- c(1:5, 3:7, 7, 7, 7)
bin_data(x, bin_width = 2)

bin_data(sim_vec, bin_width = "2k")

counts_df <- tibble::tibble(x = as.numeric(1:50), counts = rep(c(0.19, 27.05, 9, 3.1, 0.001), 10))
bin_data(counts_df, bin_width = 6)
}
}
\author{
Andrew Edwards
}
