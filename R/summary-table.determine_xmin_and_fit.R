##' @rdname summary_mle_table
##' @export
summary_mle_table.determine_xmin_and_fit <- function(obj,
                                                     dig = 2){
  # stopifnot("intervals_density" %in% class(int_dens))

#  obj_mle <- obj$mle_fit

  # Just does one row here, for multiple fits could make the row a function. Or
  # put all results into one tibble.
  ## cat("| Exponent $$b$$| Confidence interval | $$x_{min}$$ | $$x_{max}$$ | \n",
  ##     "| :-------| ----------:| -----:| -----:| \n",
  ##     "| ", f(obj_mle$b_mle, dig) , "| (",
  ##     f(obj_mle$b_conf[1], dig), ",",
  ##     f(obj_mle$b_conf[2], dig), ") | ",
  ##     f(obj_mle$x_min, dig), " | ",
  ##     f(obj_mle$x_max, dig), "| \n")
}
