##' Simulated vector of 1000 simulated values from a power-law distribution
##'
##' As used for Figures 1 and 2 of [Edwards et al. (2017)](http://onlinelibrary.wiley.com/doi/10.1111/2041-210X.12641/full),
##' used as a default set of values. Paramaters are `b = -2`, `x_min = 1`, x_max = 1000`, and the seed was
##' set to 42, obviously.
##'
##' `sim_vec` is the raw 1000 values.
##'
##' `sim_vec_binned` takes those values and bins them with bin widths that
##' double in size (using `bin_data(sim_vec, bin_width = "2k"`) and just keeps
##' the columns `bin_min`, `bin_max`, `bin_count` as you would have for real
##' binned data.
##'
##' @format `sim_vec` is numeric, `sim_vec_binned` is a tibble
##' @examples
##' \dontrun{
##' head(sim_vec)
##' sim_vec_binned
##' }
##' @author Andrew Edwards
##' @source Generated from `data-raw/sim_vec.R` and `data-raw/sim_vec_binned.R`
"sim_vec"

##' @rdname sim_vec
"sim_vec_binned"

##' Length data from experimental trawl surveys conducted in the Northwestern
##' Mediterranean Sea
##'
##' The full data used for the size-spectrum analyses in
##' [Quevedo et
##' al. (2026)](https://www.sciencedirect.com/science/article/pii/S2351989426001769).
##' Consists of a tibble with columns:
##'   * `strata`: (baseline, ntr: the no-take reserve four years after its
##' implementation, or fg:the fishing grounds four years after the reserve's
##' implementation)
##'   * `group`: species group
##'   * `species`: species scientific name
##'   * `length`: length (mm) of the individuals of that strata and species in
##' that row
##'   * `number` of individuals of that strata-species-length combination, per
##' km2 of trawling.
##'
##' So each row gives the number of individuals of a given length of a given
##' species in the given strata. Note that the resolution of the lenght
##' measurements varied between species groups; see page 2 of Supplementary
##' Material B of [Quevedo et al. (2026)](https://www.sciencedirect.com/science/article/pii/S2351989426001769).
##'
##' Values of `number` can be non-integer because they
##' are standardised by the area trawled in each tow; the MLEbins method can
##' explicitly deal with this.
##'
##' Data were collected as part of the research projects RESNEP and
##' BITER by the Instituto de Ciencias del Mar (ICM-CSIC), Spain; data courtesy
##' of
##' Juliana Quevedo, Joan B. Company, Nixon Bahamon, and Jordi Ribera Altimir,
##' as
##' used in
##' [Quevedo et
##' al. (2026)](https://www.sciencedirect.com/science/article/pii/S2351989426001769).
##'
##' Data originally processed by Juliana Quevedo and then wrangled by Andrew
##' Edwards and Juliana Quevedo, including details such as excluding lengths <12 mm
##' as such organisms are assumed to not be well sampled by the nets, and
##' excluding Echinidermata and Tunicata groups due to very low numbers of
##' organisms caught.
##'
##' @format tibble
##' @examples
##' \dontrun{
##' mediterranean_data
##' }
##' @author Andrew Edwards using data supplied by Juliana Quevedo
##' @source Generated from `data-raw/mediterranean-data/mediterranean-data.Rmd`
"mediterranean_data"

##' Species-specific length-weight coefficients for the Mediterranean data
##'
##' A tibble of species-specific length-weight coefficients for the
##' species in the Mediterranean data (`mediterranean_data`), with columns:
##'  * `species` - name of the species, matching those in `mediterranean_data`
##'  * `alpha`, `beta` - length-weight coefficients for the given species.
##'
##' The coefficients are for the equation \eqn{w_s = \alpha_s l^{\beta_s}}
##' relating weights (\eqn{w_s}, g) to lengths (\eqn{l}, mm) for each species
##' $s$ via the species-specific coefficients \eqn{\alpha_s} and \eqn{\beta_s}
##' (we drop the \eqn{s} subscript in the tibble column name).
##' See `fit-data-mlebins` vignette for template code that can be used for other
##' applications. In particular, the data and coefficients are used to give
##' body-mass bins in the call to [length_bins_to_body_mass_bins()].
##'
##' For your own applications always triple check the units for the
##' coefficients.
##'
##' Values obtained by Juliana Quevedo from Institut Català de Recerca per a la
##' Governança del Mar data at www.icatmar.cat (accessed 1st October 2024).
##'
##' @format tibble
##' @examples
##' \dontrun{
##' mediterranean_length_weight_coefficients
##' }
##' @author Andrew Edwards using data supplied by Juliana Quevedo
##' @source Generated from `data-raw/mediterranean-data/mediterranean-data.Rmd`
"mediterranean_length_weight_coefficients"

##' Mediterranean binned body mass counts for just small Cephalopda in the fishing grounds strata
##'
##' The small Cephalopoda in the fishing grounds strata of the Mediterranean
##' data, with the values already converted to body-mass bins using the
##' species-specific length-weight coefficients. Saved in package to
##' use for vignettes and testing, to save having to keep recalculating. Columns
##' of the tibble (where each row is a species-bin combination) are:
##'   * `species`: species scientific name
##'   * `bin_min`: minimum body mass (g) for that species and bin
##'   * `bin_max`: maximum body mass (g) for that species and bin
##'   * `bin_count`: count of individuals of that species in that body-mass bin
##'
##' Tibble can then be used for the MLEbins method.
##'
##' @format tibble
##' @examples
##' \dontrun{
##' data_cephsmall_fg
##' # From data-raw/mediterranean-data/mediterranean-results.R, it was created
##' #   from the other full data and length-weight coefficients using:
##'
##' dat_filtered <- dplyr::filter(mediterranean_data,
##'                               group == "Cephalopoda",
##'                               strata == "fg")
##'
##' dat_with_breaks <- calc_bin_breaks(dat_filtered,
##'                                    bin_width = 1) %>%
##'                    dplyr::rename(bin_count = number)
##'
##' dat_joined <-
##'   length_bins_to_body_mass_bins(dat_with_breaks,
##'                                 mediterranean_length_weight_coefficients,
##'                                 length_data_unit = "mm")
##'
##' data_cephsmall_fg <- mediterranean_for_mlebins(dat_joined) %>%
##'                        dplyr::filter(bin_min < 20) %>%
##'                        dplyr::arrange(bin_min)
##' data_cephsmall_fg
##' # To then analyse:
##' res_cephsmall_fg <- determine_xmin_and_fit_mlebins(data_cephsmall_fg)
##' }
##' @author Andrew Edwards
##' @source Generated from `data-raw/mediterranean-data/mediterranean-results.R`
"data_cephsmall_fg"

##' Results from fitting size spectrum to the Mediterranean body mass counts for just small Cephalopda in the fishing grounds strata
##'
##' Applying
##' `res_cephsmall_fg <- determine_xmin_and_fit_mlebins(data_cephsmall_fg)`,
##' which takes a few minutes to run. See `?data_cephsmall_fg` for details of
##' the data.
##'
##' @format `determine_xmin_and_fit_mlebins` class of object, also a "list"; see
##' [determine_xmin_and_fit_mlebins()] for details.
##' @examples
##' \dontrun{
##' res_cephsmall_fg
##' plot(res_cephsmall_fg)
##' }
##' @author Andrew Edwards
##' @source Generated from `data-raw/mediterranean-data/mediterranean-results.R`
"res_cephsmall_fg"

##' Results of the fits as shown in Table B.1, to use as the example code to
##' plot Figure B.20 of [Quevedo et al. (2026)](https://www.sciencedirect.com/science/article/pii/S2351989426001769).
##'
##' @format tibble
##' @examples
##' \dontrun{
##' quevedo_table_b1
##' knitr::kable(quevedo_table_b1,
##'              digits = 2)       # As shown in Table B.1 (2 decimal places)
##' plot_multiple_exponents(quevedo_table_b1,         # Plot Figure B.20
##'                         shade_first = TRUE)
##' }
##' @author Andrew Edwards
##' @source Generated from `data-raw/mediterranean-results.R`.
"quevedo_table_b1"


