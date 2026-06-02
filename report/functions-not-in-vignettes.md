# Functions not referenced in any vignette (done on 2nd June 2026)

N = not needed (users aren't really meant to use)
D = done


## Utility/helper functions
N `add_minor_tickmarks`
D `add_ticks`
N `add_ticks_to_one_axis`
N `dots_parser`
D `calc_confidence_interval`
D `calc_mle_conf`  

## Binning/histogram
N `bin_data.data.frame` *(S3 method)*
N `bin_data.numeric` *(S3 method)*
D `make_hist` 
D `make_hist_for_binned_counts`
D `make_hist_for_binned_counts_mlebin`

## Fitting (mlebins)
D `fit_size_spectrum_mlebins`
D `fit_size_spectrum.data.frame` *(S3 method)*
D `fit_size_spectrum.numeric` *(S3 method)*
N `neg_ll_mle_method`
N `neg_ll_mlebin_method`
N `neg_ll_mlebins_method`

## Outlier detection/removal
D `detect_outliers`
D `detect_outliers.determine_xmin_and_fit_mlebins`
D `detect_outliers.remove_outliers_mlebins`
D `detect_outliers.size_spectrum_mlebins`
D `remove_outliers.determine_xmin_and_fit_mlebins`
D `remove_outliers.size_spectrum_mlebins`

## Biomass
D `p_biomass`
D `p_biomass_bins`
D `p_biomass_bins.size_spectrum_mlebin`
D `p_biomass_bins.size_spectrum_numeric`

## PLB distribution functions
D `dPLB`
D `dPLB_agg`
D `pPLB`
D `pPLB_agg`
D `qPLB`

## Plotting
D `plot.determine_xmin_and_fit_mlebins`
D `plot_lbn_fitted`
D `plot_lbn_style`
D `plot_multiple_exponents`

## Summary/print
D `print.size_spectrum_numeric`
N `summary_mle_table`
N `summary_mle_table.determine_xmin_and_fit`
