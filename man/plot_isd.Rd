% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot-isd.R
\name{plot_isd}
\alias{plot_isd}
\title{Single plot of individual size distribution of values and the MLE fit with
confidence intervals. TODO call this from plot.size_spectrum_numeric, this
currently copies that.}
\usage{
plot_isd(
  res,
  log = "xy",
  plot_conf_ints = TRUE,
  xlab = expression(paste("Values, ", italic(x))),
  ylab = expression(paste("Number of ", values >= x), sep = ""),
  mgp_val = c(1.6, 0.5, 0),
  tcl_small = -0.2,
  legend_text = expression(paste("b=", signif(res$b_mle, 3), sep = "")),
  legend_position = "topright",
  inset = c(0, 0),
  x_big_ticks = NULL,
  x_big_ticks_labels = NULL,
  x_small_ticks = NULL,
  x_small_ticks_by = NULL,
  x_small_ticks_labels = NULL,
  y_big_ticks = NULL,
  y_big_ticks_labels = NULL,
  y_small_ticks = NULL,
  y_small_ticks_by = NULL,
  y_small_ticks_labels = NULL,
  ...
)
}
\arguments{
\item{res}{size_spectrum_numeric object, as output from
\code{\link[=fit_size_spectrum.numeric]{fit_size_spectrum.numeric()}}, which gets called when applying
\code{\link[=fit_size_spectrum]{fit_size_spectrum()}} to a numeric vector}

\item{log}{Which axes to log, for \code{plot(..., log = log)}. So "xy" for
log-log axes, "x" for only x-axis logged.}

\item{plot_conf_ints}{logical whether to plot PLB fit for confidence
intervals or not}

\item{xlab, }{ylab x/y labels, explicitly given default values here which can
be modified as required.}

\item{mgp_val}{mgp values to use, as in \code{plot(..., mgp = mgp_vals)}; see \link{?par}.}

\item{tcl_small}{Length of small tickmarks; see \link{?axis}.}

\item{legend_text}{text to put in the corner, defaults to \verb{b = <value>}. Set to
\code{NA} to have none, and modify default if needed.}

\item{legend_position}{where to place legend, gets used as the first
argument in \code{\link[=legend]{legend()}}.}

\item{inset}{Inset distance for legend}

\item{x_big_ticks, }{y_big_ticks numeric vector of big tick marks on
x-axis/y-axis. If NULL then gets done automatically, so if that does not
look good then define explicitly here, plus \code{x_big_ticks_labels} and/or \code{y_big_ticks_labels}.}

\item{x_big_ticks_labels, }{y_big_ticks_labels numeric vector of big tick
marks to label on x-axis/y-axis. If NULL then gets done automatically, so
if that does not look good then define explicitly here}

\item{x_small_ticks, }{y_small_ticks  numeric vector of small tick marks on x-axis/y-axis. If
NULL then gets done automatically, so if that does not  look good then
define explicitly here.}

\item{x_small_ticks_by, }{y_small_ticks_by  numeric vector of increment to
use to generate small tick marks on x-axis/y-axis. Will conincide with the
big tick marks and extend beyond them. Can only define \code{x_small_ticks} or
\code{x_small_ticks_by} (same for \code{y_...}). Only relevant for linear axes. Set
to \code{NA} to force no small unlabelled tickmarks.}

\item{x_small_ticks_labels, }{y_small_ticks_labels numeric vector of big tick
marks to label on x-axis/y-axis. If NULL then gets done automatically, so
if that does not look good then define explicitly here}

\item{...}{Further arguments for \code{plot()}}
}
\value{
Single figure of ISD on log-log plot (or log-linear depending on the
options given), with values as points and PLB fit (and fits of confidence
limits) as solid (and dashed) lines.
}
\description{
Plot the results from a PLB fit to a vector of values, as in Figure 2h and 6b of
\href{http://onlinelibrary.wiley.com/doi/10.1111/2041-210X.12641/full}{1}. Also
shows PLB fits using the values of \code{b} at the ends of the confidence
intervals. Gets called from \code{\link[=plot_size_spectrum.numeric]{plot_size_spectrum.numeric()}}.
}
\examples{
\dontrun{
res_vec <- fit_size_spectrum(sim_vec)
plot(res_vec)
plot(res_vec, log = "x")
plot(res_vec, log = "")
plot(res_vec, x_small_ticks_labels = c(5, 50, 500), log = "x") # Tailor the
  labels for a particular figure
}
}
\author{
Andrew Edwards
}
