# Functions without executable examples (done them all, 4/6/26).

Functions in `R/` that have no executable R code in their `\examples` section.
This includes functions whose `\dontrun{}` or `\donttest{}` block is empty or
contains only comments / prose text.

Functions whose `\dontrun{}` contains real R code (even if wrapped in `\dontrun{}`
and therefore not run by `R CMD check`) are **not** listed here.

---

## Empty `\dontrun{}` or `\donttest{}` block

| Function | File | Notes |
|---|---|---|
D  | `add_minor_tickmarks()` | `add-minor-tickmarks.r` | `\dontrun{}` is empty |
D  | `calc_confidence_interval()` | `calc-confidence-interval.R` | `\dontrun{}` is empty |
D | `plot_isd_binned()` | `plot-isd-binned.R` | `\dontrun{}` is empty |
D | `plot_lbn_style()` | `plot-lbn-style.R` | `\donttest{}` is empty |

---

## `\dontrun{}` contains only comments or prose (no R code)

D These are all fine, as they point to something else (vignettes mainly). Awesome. 

| Function | File | Notes |
|---|---|---|
| `fit_size_spectrum_mlebins()` | `fit-size-spectrum-mlebins.R` | Only `# comment` lines pointing to vignette |
| `plot_aggregate()` | `plot-aggregate.R` | Only `# comment` lines pointing to vignette |
| `plot_aggregate_fits()` | `plot-aggregate-fits.R` | Only `# comment` lines pointing to vignette |
| `plot_aggregate_mlebin()` | `plot-aggregate-mlebin.R` | Only `# comment` lines pointing to vignette |
| `plot.determine_xmin_and_fit()` | `plot.determine_xmin_and_fit.R` | Only unquoted prose pointing to vignette |
| `plot.determine_xmin_and_fit_mlebins()` | `plot.determine_xmin_and_fit_mlebins.R` | Only unquoted prose pointing to vignette |
| `plot.size_spectrum_mlebins()` | `plot.size_spectrum_mlebins.R` | Only `# comment` lines pointing to vignette |
| `remove_outliers()` | `remove-outliers.R` | Only `# comment` lines pointing to example code |

---

## No `@examples` section at all

| Function | File |
|---|---|
D | `add_ticks_to_one_axis()` | `add-ticks-to-one-axis.R` |
D | `calc_mle_conf()` | `calc-mle-conf.R` |
D | `neg_ll_mle_method()` | `neg-ll-mle-method.R` |
D | `neg_ll_mlebin_method()` | `neg-ll-mlebin-method.R` |
D | `neg_ll_mlebins_method()` | `neg-ll-mlebins-method.R` |
