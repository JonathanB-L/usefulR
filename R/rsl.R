#'rsl: run, save, load
#'
#'Wrapper to handle executing a method and saving or loading the output all in one instance.
#'Gives two options when running a function:
#'1. Run the function and save the result as a .rda file in the specified directory
#'2. Look into the specified directory and load the object instead of running the function
#'
#'@param func Method to be run
#'@param run Boolean value. If TRUE, run the method in func, return the result, and save the result in directory d as obj_name.rda.
#'If FALSE, load obj_name.rda from directory d and return it.
#'@param obj_name Name to assign to the output of func and of the .rda object that will be saved in the directory d.
#'@param d directory to where obj_name.rda will be saved and loaded from.
#'
#'
#'@return returns the output of whatever is chosen for func
rsl <- function(func, run = TRUE, obj_name, d) {

  if(missing(func)) stop("func argument is missing")
  if(missing(obj_name)) stop("obj_name argument is missing")

  override = FALSE
  if (exists(x = "override_default", envir = .rslEnv)){
    override <- get("override_default", envir = .rslEnv)
    run_default <- get("run_default", envir = .rslEnv)
    d_default <- get("d_default", envir = .rslEnv)
  }

  if (override == TRUE){

    run <- run_default

    if (is.null(d_default)) {
      if(!missing(d)) {
        warning(paste0("d has no default argument set with set_runfast_default, using d = ",d))
      } else {
        stop("d has no default argument set with set_runfast_default, and no value to use in thi method either")
      }
    } else {
      d <- d_default
    }

  } else { # Run using the imput arguments, override == FALSE
    if(missing(d)) {
      if(!exists("d_default")) {
        stop("d argument is missing with no default")
      } else {
        if (is.null(d_default)) stop("d argument is missing with no default")
        d <- d_default
      }
    }
  }# end else

  if (run == TRUE) {
    assign(x = obj_name, value = eval(func), envir = .GlobalEnv)
    save(list = obj_name, file = paste0(d,"/",obj_name,".rda"))
  } else {
    load(file = paste0(d,"/",obj_name,".rda"), envir = .GlobalEnv)
    #out <- get(obj_name, envir = .GlobalEnv)
    #out
  }


}# end runfast
