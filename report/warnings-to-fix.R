Warnings from running check() on 4/6/26.

1. checking dependencies in R code ... WARNING
  '::' or ':::' import not declared from: 'tibble'
  Unexported object imported by a ':::' call: 'graphics:::plot.histogram'
    See the note in ?`:::` about the use of this operator.
    Including base/recommended package(s):
    'graphics'

2. checking S3 generic/method consistency ... WARNING
  fit_size_spectrum:
    function(dat, ...)
  fit_size_spectrum.numeric:
    function(dat, x_min, x_max, b_vec, b_vec_inc, b_start)

  detect_outliers:
    function(res, ...)
  detect_outliers.remove_outliers_mlebins:
    function(res)

  detect_outliers:
    function(res, ...)
  detect_outliers.determine_xmin_and_fit_mlebins:
    function(res)

  detect_outliers:
    function(res, ...)
  detect_outliers.size_spectrum_mlebins:
    function(res)

  bin_data:
    function(dat, ...)
  bin_data.data.frame:
    function(dat, bin_width, bin_breaks, start_integer, truncate_top_bin)

  remove_outliers:
    function(dat, ...)
  remove_outliers.determine_xmin_and_fit_mlebins:
    function(res, ...)

  remove_outliers:
    function(dat, ...)
  remove_outliers.size_spectrum_mlebins:
    function(res, number)

  p_biomass_bins:
    function(res)
  p_biomass_bins.size_spectrum_numeric:
    function(res_mle)

  p_biomass_bins:
    function(res)
  p_biomass_bins.size_spectrum_mlebin:
    function(res_mlebin)

  print:
    function(x, ...)
  print.size_spectrum_numeric:
    function(res, ...)

  plot:
    function(x, ...)
  plot.determine_xmin_and_fit:
    function(res, xlim_hist, main_hist, ...)

  plot:
    function(x, ...)
  plot.size_spectrum_mlebins:
    function(res_mlebins, seg_col, ...)

  plot:
    function(x, ...)
  plot.size_spectrum_numeric:
    function(res, style, xlim, ylim, x_plb, y_scaling, mle_round,
             inset_label, xlab, legend_label_a, legend_label_b,
             legend_label_single, legend_text_a, legend_text_a_n,
             legend_text_b, legend_text_b_n, par_mai, par_cex, ...)

  plot:
    function(x, ...)
  plot.determine_xmin_and_fit_mlebin:
    function(res, seg_col, main_hist, ...)

  plot:
    function(x, ...)
  plot.size_spectrum_mlebin:
    function(res_mlebin, style, xlim, ylim, x_plb, inset_label, xlab,
             y_scaling, mle_round, legend_label_a, legend_label_b,
             legend_label_single, legend_text_a, legend_text_a_n,
             legend_text_b, legend_text_b_n, par_mai, par_cex, seg_col,
             ...)

  plot:
    function(x, ...)
  plot.determine_xmin_and_fit_mlebins:
    function(res, xlim_hist, par_mai, par_cex, seg_col, main_hist, ...)
  See section 'Generic functions and methods' in the 'Writing R
  Extensions' manual.

3. checking for missing documentation entries ... WARNING
  Undocumented code objects:
    'data_cephsmall_fg' 'mediterranean_data'
    'mediterranean_length_weight_coefficients' 'res_cephsmall_fg'
    'sim_vec_binned'
  Undocumented data sets:
    'dataBinForLike' 'data_cephsmall_fg' 'mediterranean_data'
    'mediterranean_length_weight_coefficients' 'res_cephsmall_fg'
    'sim_vec_binned'
  All user-level objects in a package should have documentation entries.
  See chapter 'Writing R documentation files' in the 'Writing R
  Extensions' manual.

4. checking Rd \usage sections ... WARNING
  Undocumented arguments in Rd file 'add_ticks.Rd'
    'log' 'tcl_small' 'mgp_val' 'x_big_ticks' 'x_big_ticks_labels'
    'x_small_ticks' 'x_small_ticks_by' 'x_small_ticks_labels'
    'y_big_ticks' 'y_big_ticks_labels' 'y_small_ticks' 'y_small_ticks_by'
    'y_small_ticks_labels'

  Undocumented arguments in Rd file 'add_ticks_to_one_axis.Rd'
    'tcl_small' 'mgp_val' 'big_ticks_labels' 'small_ticks'
    'small_ticks_by' 'small_ticks_labels' 'small_ticks_per_big'

  Undocumented arguments in Rd file 'detect_outliers.Rd'
    '...'

  Undocumented arguments in Rd file 'determine_xmin_and_fit.Rd'
    'bin_width' 'bin_start'

  Undocumented arguments in Rd file 'determine_xmin_and_fit_mlebin.Rd'
    'x_min' '...'

  Undocumented arguments in Rd file 'determine_xmin_and_fit_mlebins.Rd'
    'bin_width' 'bin_start' 'x_min' '...'

  Undocumented arguments in Rd file 'fit_size_spectrum.Rd'
    '...' 'strata'

  Undocumented arguments in Rd file 'mediterranean_for_mlebins.Rd'
    'maximum_length'

  Undocumented arguments in Rd file 'neg_ll_mlebin_method.Rd'
    'n'

  Undocumented arguments in Rd file 'p_biomass_bins.Rd'
    'res_mlebin' 'res_mle'
  Documented arguments not in \usage in Rd file 'p_biomass_bins.Rd':
    'bin_vals'

  Undocumented arguments in Rd file 'plot.size_spectrum_mlebin.Rd'
    'xlim' 'ylim' 'inset_label' 'mle_round' 'legend_text_b_n'

  Undocumented arguments in Rd file 'plot.size_spectrum_numeric.Rd'
    'xlim' 'ylim' 'x_plb' 'mle_round' 'inset_label' 'legend_text_b_n'
    'par_mai' 'par_cex'

  Undocumented arguments in Rd file 'plot_aggregate_fits.Rd'
    'ylim' 'xlab'

  Undocumented arguments in Rd file 'plot_aggregate_mlebin.Rd'
    'y_scaling'

  Undocumented arguments in Rd file 'plot_isd.Rd'
    'xlim' 'ylim' 'x_plb' 'y_plb' 'y_plb_conf_min' 'y_plb_conf_max'
    'ylab' 'inset_label' 'inset_text' 'legend_label' 'legend_text_n'
    'legend_text_second_row_multiplier' 'y_big_ticks'
    'y_big_ticks_labels' 'y_small_ticks' 'y_small_ticks_by'
    'y_small_ticks_labels' 'fit_col' 'fit_lwd' 'conf_lty'
  Documented arguments not in \usage in Rd file 'plot_isd.Rd':
    'inset'

  Undocumented arguments in Rd file 'plot_isd_binned.Rd'
    'log' 'xlim' 'ylim' 'y_plb_conf_max' 'mgp_val' 'inset_label'
    'inset_text' 'legend_label' 'legend_text' 'legend_text_n'
    'legend_position' 'x_big_ticks' 'x_big_ticks_labels' 'x_small_ticks'
    'x_small_ticks_by' 'x_small_ticks_labels' 'y_big_ticks'
    'y_big_ticks_labels' 'y_small_ticks' 'y_small_ticks_by'
    'y_small_ticks_labels'
  Documented arguments not in \usage in Rd file 'plot_isd_binned.Rd':
    'par_mai' 'par_cex' 'LBN_style'

  Undocumented arguments in Rd file 'plot_lbn_fitted.Rd'
    'rect_border'

  Undocumented arguments in Rd file 'plot_lbn_style.Rd'
    'xlim' 'ylim' 'mgp_val' 'inset_label' 'inset_text' 'legend_label'
    'legend_text' 'legend_text_n' 'legend_position' 'x_big_ticks'
    'x_big_ticks_labels' 'x_small_ticks' 'x_small_ticks_by'
    'x_small_ticks_labels' 'y_big_ticks' 'y_big_ticks_labels'
    'y_small_ticks' 'y_small_ticks_by' 'y_small_ticks_labels' 'y_scaling'
    'rect_col'

  Undocumented arguments in Rd file 'plot_multiple_exponents.Rd'
    'ylim'

  Undocumented arguments in Rd file 'remove_outliers.Rd'
    'dat' '...'

  Undocumented arguments in Rd file 'summary_mle_table.Rd'
    '...' 'res'

  Functions with \usage entries need to have the appropriate \alias
  entries, and all their arguments documented.
  The \usage entries must correspond to syntactically valid R code.
  See chapter 'Writing R documentation files' in the 'Writing R
  Extensions' manual.

5. checking for unstated dependencies in 'tests' ... WARNING
  '::' or ':::' import not declared from: 'tibble'

Okay, asked ghcp to fix number 4. Going through and checking/fixing them, leaving the
TODOs (37 across 18 files) for now. Doing in commit that creates this file.
