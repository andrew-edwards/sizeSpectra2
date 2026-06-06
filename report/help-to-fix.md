# New @param entries added — descriptions needed

Each entry below was added as `@param <arg> TODO` in the corresponding R file.
Replace `TODO` with a proper description.

Andy removing them as I do them. It got a bit overzealous.
---

## R/plot-isd.R

```
@param inset_label
@param inset_text
@param legend_label
@param legend_text_n
@param legend_text_second_row_multiplier
@param fit_col
@param fit_lwd
@param conf_lty
```

*Note: many other functions inherit these via `@inheritParams plot_isd`, so writing
them here documents them everywhere.*

---

## R/add-ticks-to-one-axis.R

```
@param big_ticks
@param big_ticks_labels
@param small_ticks
@param small_ticks_by
@param small_ticks_labels
@param small_ticks_per_big
```

---

## R/plot.size_spectrum_numeric.R

```
@param xlim
@param ylim
@param x_plb
@param mle_round
@param par_mai
@param par_cex
```

*Note: `xlim`, `ylim`, `x_plb` are inherited from `plot_isd` — only `mle_round`,
`par_mai`, `par_cex` truly need new descriptions here.*

---

## R/plot-lbn-style.R

```
@param y_scaling
@param rect_col
```

---

## R/detect-outliers.R

```
@param ...
```

---

## R/determine-xmin-and-fit-mlebin.R

```
@param x_min
@param ...
```

---

## R/determine-xmin-and-fit-mlebins.R

```
@param x_min
@param ...
```

---

## R/fit-size-spectrum.R

```
@param ...
@param strata
```

---

## R/mediterranean-for-mlebins.R

```
@param maximum_length
```

---

## R/neg-ll-mlebin-method.R

```
@param n
```

---

## R/p-biomass-bins.size_spectrum_numeric.R

```
@param res (renamed from res_mle; inherited from p_biomass_bins generic)
```

---

## R/p-biomass-bins.size_spectrum_mlebin.R

```
@param res (inherited from p_biomass_bins generic)
```

---

## R/plot-aggregate-fits.R

```
@param xlab
```

---

## R/plot-aggregate-mlebin.R

```
@param y_scaling
```

---

## R/plot-lbn-fitted.R

```
@param rect_border
```

---

## R/remove-outliers.R

```
~~@param dat~~ (removed — generic now uses `res`)
@param ...
```

---

## R/summary-mle-table.R

```
@param ...
```

---

## R/summary-table.determine_xmin_and_fit.R

```
@param res
```
