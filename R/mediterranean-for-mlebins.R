##' Extract and format the required Mediterranean data for MLEbins analysis, for
##'  a given strata and group
##'
##' This is specific for the Mediterranean data set, but can
##'   easily be adapted/generalised for others. It amalgamates rows that are
##' identical (counts of the same length of the same species measured in the same strata).
##' @param dat tibble of data already with certain columns, namely must include
##'  `strata`, `group`, `species`, `length_bin_min`, `bin_count`, `weight_bin_min`, `weight_bin_max`
##'
##' @param group_name `character` the group(s) to analyse (can be a vector of
##' group names), if not specified then use all
##' @param strata_name `character` the strata to analyse (can be a vector of
##' strata names), if not specified then use all
##' @param minimum_length,maximum_length remove fish shorter/longer than this, in the units of
##' `length_bin_min` (which may be different to the original `length`
##' one). Note: this was originally based on
##' `length` column which used a different example and does not need to be in
##' `dat`, but I just switched it to `length_bin_min` column which is
##' more correct; may change some older results if rerunning anything; broke a
##' test making me realise the change in units. 22/5/26.
##' @return tibble with columns `species`, `bin_min`, `bin_max`, `bin_count`, to
##' go into [determine_xmin_and_fit_mlebins()], or maybe just
##' [fit_size_spectrum_mlebins()], including the `species` column, to use the
##' MLEbins method
##' @export
##' @author Andrew Edwards
##' @examples
##' \dontrun{
##' dat <- dplyr::filter(mediterranean_data,
##'                      group == "Cephalopoda",
##'                      strata == "fg")
##'
##' dat_with_breaks <- calc_bin_breaks(dat,
##'                                   bin_width = 1) %>%
##' dplyr::rename(bin_count = number)
##' dat_joined <-
##'   length_bins_to_body_mass_bins(dat_with_breaks,
##'                                 mediterranean_length_weight_coefficients,
##'                                 length_data_unit = "mm")
##' dat_joined
##' dat_needed <- mediterranean_for_mlebins(dat_joined) %>%
##'   dplyr::filter(bin_min < 20)
##' dat_needed
##' res <- determine_xmin_and_fit_mlebins(dat_needed)
##' }
mediterranean_for_mlebins <- function(dat,
                                      group_name = NULL,
                                      strata_name = NULL,
                                      minimum_length = NULL,
                                      maximum_length = NULL){
  if(is.null(group_name)){
    group_name <- unique(dat$group)
  }

  if(is.null(strata_name)){
    strata_name <- unique(dat$strata)
  }

  temp <- dplyr::filter(dat,
                        group %in% group_name,
                        strata %in% strata_name)

  if(!is.null(minimum_length)){
    temp <- dplyr::filter(temp,
                          length_bin_min >= minimum_length)  # was length, may
    # change some old results? Did break a test, since need to tweak units also
  }

  temp <- dplyr::select(temp,
                        species,
                        bin_count,
                        bin_min = weight_bin_min,
                        bin_max = weight_bin_max)

  res <- dplyr::summarise(dplyr::group_by(temp,
                                          species,
                                          bin_min,
                                          bin_max),    # need to retain, not needed
                                                       # for grouping
                          bin_count = sum(bin_count)) %>%
    dplyr::ungroup()

  return(res)
}
