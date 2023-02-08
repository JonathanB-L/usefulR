#'@title Multiple diagnostics for a lm/glm or gam from mgcv package
#'
#'@description Generates multiple diagnostics of a lm/glm/gam object from other base functions.
#'Prints the summary, residual plots, a QQ plots, the acf of the residuals and a plot the model fit over the raw data.
#'The dependent variable for the fitted values plot can be specified as one of the predictors used in the glm, or any vector
#'or data frame column of correct length.
#'
#'@param glmobject a lm, glm or gam{mgcv} object.
#'@param xcoord The independent variable that will be used to plot against the fitted values.
#'Can be a vector of same length as dependent variable or an integer between 1 and the number of predictors used in the model.
#'The default value is the first predictor used in the formula of the glm.
#'@param xlab Specify the x label for plotting the fitted values. Default is "x" or the column name if xcoord comes from a dataframe.
#'Note: use data\[,x\] format to keep column name accessible to this function, not data$name or data\[\[x\]\].
#'@param ylab Specify ylabel manually. Default is the name response variable in the glm
#'@param main Title of fitted values plot as a character or string. Default is no title..
#'
#'@return does not return anything.
#'
#'@export
#'
#'@importFrom mgcv plot.gam
summarise_glm <- function(glmobject, xcoord = 1, xlab = "x", ylab, main = ""){

  num.predictors <- length(glmobject$model) - 1
  xvals = NULL
  xlabel = "x"
  ylabel = ""
  plot.title = "GLM fit over data"
  isvector = FALSE # need to specify plot arguments different if a vector is used

  #INTEGER
  if (is.numeric(xcoord) && length(xcoord) == 1){
    if ( xcoord > num.predictors || xcoord < 1) {
      stop("xcoord must be between 1 and the number of predictors")

    } else { # assign values for plotting
      xlabel = names(glmobject$model[xcoord + 1])
      xvals = glmobject$model[xcoord + 1]
    }

    #NUMERIC VECTOR
  } else if (is.numeric(xcoord)){
    if ( length(xcoord) != length(glmobject$fitted.values) ){
      stop("xcoord is not of same length as the fitted values")
    } else {# assign values for plotting
      xvals = xcoord
      isvector = TRUE
    }

    #LIST
  } else if (is.list(xcoord)){ # Assuming data[,x] was used
    if ( nrow(xcoord) == length(glmobject$fitted.values) ) {
      if(ncol(xcoord) != 1) {
        stop("xcoord has more than one column")
      } else { # assign values for plotting
        if(is.null(colnames(xcoord))) xlabel = colnames(xcoord)
        xvals = xcoord
        xlabel = names(xcoord)
      }
    } else {
      stop("xcoord is not of same length as the fitted values")
    }
    #CHARACTER
  } else if ( is.character(xcoord) ){
    check.name <- which(names(glmobject$model[2:(num.predictors + 1)]) == xcoord)
    if (length(check.name) == 0L) stop("xcoord name does not match any of the predictors")

    xlabel = names(glmobject$model[check.name + 1])
    xvals = glmobject$model[check.name + 1]
  } else {
    stop("xcoord must be an integer, vector, or string")
  }

  if(!missing(xlab) && is.character(xlab)) xlabel = xlab
  if(!is.character(xlab)) warning("xlab is not a string, argument ignored")

  if(!missing(ylab) && is.character(ylab)) {
    ylabel = ylab
  } else {
    ylabel = names(glmobject$model[1])
  }
  if(!missing(ylab) && !is.character(ylab)) warning("ylab is not a string, argument ignored")

  if(!missing(main) && is.character(main)){
    plot.title = main
  } else {
    plot.title = ""
  }
  if(!is.character(main)) warning("title is not a string, argument ignored")

  #Summary
  print(summary(glmobject))

  #basic diagnostic plots
  par(mfrow = c(2,2))

  if ("gam" %in% class(glmobject)){
    mgcv::gam.check(glmobject)
    mgcv::plot.gam(glmobject, residuals = T, scheme = 1)
    #message("gam detected")
  } else {
    plot(glmobject)
  }
  #autocorrelation of residuals
  par(mfrow = c(1,1))
  acf(glmobject$residuals)

  #plot of fitted values over data
  if(!isvector) xvals = xvals[[1]]

  plot(x = xvals, y = glmobject$model[[1]] , type = "p", pch = 20, xlab = xlabel, ylab = ylabel, main = plot.title) # plot data
  lines(x = xvals, y = glmobject$fitted.values, col = "blue", lwd = 2) # add fitted values
}
