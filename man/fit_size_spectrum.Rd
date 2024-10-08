% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fit-size-spectrum-mlebin.R,
%   R/fit-size-spectrum.R, R/fit-size-spectrum.data.frame.R,
%   R/fit-size-spectrum.numeric.R
\name{fit_size_spectrum.mlebin}
\alias{fit_size_spectrum.mlebin}
\alias{fit_size_spectrum}
\alias{fit_size_spectrum.data.frame}
\alias{fit_size_spectrum.numeric}
\title{Fit a size spectrum to data using maximum likelihood}
\usage{
\method{fit_size_spectrum}{mlebin}(
  dat,
  x_min = NULL,
  x_max = NULL,
  b_start = -1.9,
  b_vec = NULL,
  b_vec_inc = 1e-05
)

fit_size_spectrum(dat, ...)

\method{fit_size_spectrum}{data.frame}(dat, strata = NULL, ...)

\method{fit_size_spectrum}{numeric}(
  dat,
  x_min = NULL,
  x_max = NULL,
  b_vec = NULL,
  b_vec_inc = 1e-05
)
}
\arguments{
\item{dat}{One of:
\itemize{
\item \code{numeric} vector of values (such as individual body masses of lengths), which uses
the MLE method (via the function \code{\link[=fit_size_spectrum.numeric]{fit_size_spectrum.numeric()}};
\item \code{data.frame} that can be either
\itemize{
\item individual measurements for a strata
(such as a year), for which column names are given by \code{strata} (default
is \code{year}, user can specify) and \code{x} for the measurements. More column
names can be in the data.frame but will not be used. In this case the MLE
method \code{fit_size_spectrum.numeric()} will be applied separately to each
year. TODO - need the functions OR
\item count data for MLEbin method. At a minimum this has to include the columns:
\itemize{
\item \code{bin_min}
\item \code{bin_max}
\item \code{bin_count}
}
}
}

TODO}

\item{x_min}{minimum value of data to fit the PLB distribution to. If \code{NULL}
(the default) then it is set to the minimum value of the data (if \code{dat} is
\code{numeric}), else to the minimum bin break of the lowest bin or ??TODO any
other options? If not NULL then the fitting is restricted to value above
\code{x_min} (and for the MLEbin method this has to be at one of the bin
breaks). TODO check the MLEbinfunction when finished. TODO Mention species-specific}

\item{x_max}{maximum value of data to fit the PLB distribution to. If \code{NULL}
(the default) then it is set to the maximum value of the data (if \code{dat} is
\code{numeric}), else to the maximum bin break of the highest bin or ??TODOany
other options? If not NULL then the fitting is restricted to values below
\code{x_max} (and for the MLEbin method this has to be at one of the bin
breaks). Mention species-specific...}
}
\value{
\itemize{
\item If \code{dat} is numeric then returns a list object of class
\code{size_spectrum_numeric} (such that we can plot it
with \code{\link[=plot.size_spectrum_numeric]{plot.size_spectrum_numeric()}}, with objects:
\itemize{
\item TODOintervals: one-row tibble with columns:
\itemize{
\item median: median of the data
\item eti_lower: lower end of the ETI
\item eti_upper: upper end of the ETI
\item hdi_lower: lower end of the HDI
\item hdi_upper: upper end of the HDI
\item width_eti: width of the ETI
\item width_hdi: width of the HDI
\item width_diff: difference in widths, how much smaller (more certain) the
HDI is than the ETI
\item i_eti_lower: index for which \code{eti_lower} is between
\code{dens$x[i_eti_lower]} and \code{dens$x[i_eti_lower + 1]}
\item y_eti_lower: linearly interpolated value based on \code{i_eti_lower}
corresponding to the density at \code{eti_lower}
\item i_eti_upper, y_eti_upper: similar to \code{...lower} but for \code{upper}
\item i_hdi_lower: index for which \code{dens$x[i_hdi_lower] = hdi_lower}. The
theoretical true value of the lower bound of HDI will lie between
\code{dens$x[i_hdi_lower - 1]} and \code{dens$x[i_hdi_lower]}, but the high \code{n} used
should make this range small enough
\item y_hdi_lower: the density at \code{dens$y[i_hdi_lower]} corresponding to \code{hdi_lower}
\item i_hdi_upper: index for which \code{dens$x[i_hdi_upper] = hdi_upper}. The
theoretical true value of the upper bound of HDI will lie between
\code{dens$x[i_hdi_upper]} and \code{dens$x[i_hdi_upper + 1]} (note the asymmetry to
\code{i_hdi_lower}), but the high \code{n} used should make this range small enough
\item y_hdi_upper: the density at \code{dens$y[i_hdi_upper]} corresponding to \code{hdi_upper}
\item hdi_height: the height of the pdf returned from \code{HDInterval::hdi()},
corresponding to either \code{y_hdi_lower} or \code{y_hdi_upper} (depending on which
is the first \code{dens$x} value to push the integrated sum of the sorted
cumulative \code{dens$y} values over \code{credibility}; see
\code{HDInterval::hdi.density()}. Is \code{NA} if \code{density = FALSE}.
\item warning: logical, if \code{TRUE} then a warning was produced during the
\code{HDInterval::hdi()} calculation. If no warning printed then this warning
was "The HDI is discontinuous but allowSplit = FALSE; the result is a
valid CrI but not HDI.", else the new warning "New type of warning in
create_intervals()." is printed and needs investigating. See
\code{plot.intervals_density()} with \code{show_discontinuity = TRUE} to plot the
discontinuities in the HDI.
\item allow_hdi_zero: logical of \code{allow_hdi_zero} used
}
}
\item If \code{dat} is a data frame then return a list object of class
\code{intervals_density_list} with:
\itemize{
\item element \verb{[[i]]} corresponding to column \code{i} of the \code{dat_mcmc}. Each
\verb{[[i]]} element is itself a list of the form described above (since the
intervals are calculated for each column in turn), plus also the
\verb{$name} element which is the name of column \code{i} of \code{dat_mcmc}.
\item intervals_all_years tibble of all the intervals, with the first column,
\code{quantity}, corresponding to each column of \code{dat_mcmc}, such that row \code{i}
corresponds to column \code{i} of \code{dat_mcmc}. \code{quantity} is numeric if no
column names of \code{dat_mcmc} contain non-digits (e.g. represents years).
}
}
}
\description{
The function automatically uses the method...
For tibble, need \code{strata} if the data are different
}
\examples{
\dontrun{
fit_size_spectrum(sim_vec)

# See the vignettes for further details and refinements.
# Create intervals from the vector MCMC samples for hake recruitment in 2021:
res_vec <- create_intervals(rec_2021)
res_vec
plot(res_vec)    # Plot the default density plot showing the HDI

# Create intervals from the data frame of MCMC samples for hake recruitment,
#  with each column representing a year:
res_df <- create_intervals(dplyr::select(hake_recruitment_mcmc, -"Virgin"))
res_df
plot(res_df)     # Plot the time series of calculated intervals
}
}
\author{
Andrew Edwards
}
