if(!exists(".rslEnv")) .rslEnv <- new.env(parent=emptyenv())
#'@title Default settings for rsl
#'
#'@description Sets the default settings for the "run" argument of rsl. You can
#'also choose if this default argument overides manually imputed arguments for "run".
#'
#'@param run_default boolean value: the default setting to be used for "run" argument in rsl function. see rsl documentation for details.
#'@param override hidden argument for rsl function. If true, rsl will use run_default and d_default regardless of input
#'values for its "run" and "d" arguments.
#'@param d the default argument to be used for "d" in runfast
#'
#'@return does not return anything
#'
#'@export
set_rsl_default <- function(run_default = TRUE, override_default = FALSE, d_default = NULL ) {

  #if(!exists("rslEnv2")) rslEnv2 <- new.env(parent=emptyenv())

  assign(x = "run_default", value = run_default, envir = .rslEnv)
  assign(x = "override_default", value = override_default, envir = .rslEnv)
  assign(x = "d_default", value = d_default, envir = .rslEnv)

}
