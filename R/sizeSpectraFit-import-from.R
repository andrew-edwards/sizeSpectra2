#' sizeSpectraFit package importFrom requirements
#'
#' Copied from pacea-import-from.R and then editing based on results of check().
#' pacea one was in turn from:
#' Adapting from https://github.com/pbs-assess/gfiphc/blob/master/R/gfiphc.R
#' (see that if get issues with column names within dplyr functions for what to
#'  add). And from
#' https://github.com/andrew-edwards/sizeSpectra/blob/master/R/sizeSpectra.R for
#' some tibble related stuff.
#' And from the 'Consider adding' output from check(vignettes = FALSE), adding
#' here to then go into NAMESPACE. May have a few more here than we really need.
#'
#' @name sizeSpectraFit_import_from
## usethis namespace: start
#' @importFrom dplyr mutate summarise select group_by n arrange ungroup
#' @importFrom dplyr inner_join left_join right_join anti_join full_join
#' @importFrom dplyr semi_join row_number
#' @importFrom dplyr bind_rows case_when pull contains tibble rename as_tibble
#' @importFrom dplyr %>%
#' @importFrom tibble add_column as_tibble tibble
#' @importFrom methods hasArg
#' @importFrom stats nlm qchisq runif
#' @importFrom graphics abline axis box hist legend lines par plot.default points rect segments
#' @importFrom utils head
## usethis namespace: end
NULL

#' sizeSpectraFit: a streamlined R package for fitting size spectra to ecological data
#' @name sizeSpectraFit
#' @keywords internal
"_PACKAGE"
NULL

# As for sizeSpectra and gfiphc repos (both a few years old now), need these to avoid warnings related to dplyr
# commands (e.g. referring to the column names withing dplyr::filter()).
# Copied from the warning given by check() (that puts them alphabetical, then
# had some more to add at the end), not adding the ones now mentioned above
if (getRversion() >= "2.15.1") utils::globalVariables(c("."))
if (getRversion() >= "2.15.1") {
  utils::globalVariables(c(
    "alpha",
    "bin_count",
    "bin_count_norm",
    "bin_max",
    "bin_mid",
    "bin_min",
    "bin_sum",
    "bin_sum_norm",
    "bin_width",
    "counts",
    "desc",
    "expect_equal",
    "gap",
    "group",
    "high_biomass",
    "length_bin_max",
    "length_bin_min",
    "low_biomass",
    "low_count",
    "mle_biomass",
    "mle_conf_1_biomass",
    "mle_conf_2_biomass",
    "new_bin_max",
    "new_bin_min",
    "rect_border_col",
    "species",
    "strata",
    "weight_bin_max",
    "weight_bin_min"
  ))
}
