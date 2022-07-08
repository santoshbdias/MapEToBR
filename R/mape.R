##############################
# 'mape': Mean Absolute Percentage Error #
##############################
# 'obs'   : numeric 'data.frame', 'matrix' or 'vector' with observed values
# 'sim'   : numeric 'data.frame', 'matrix' or 'vector' with simulated values
# 'Result': Mean Absolute Error between 'sim' and 'obs', in the same units of 'sim' and 'obs'

mape <-function(sim, obs, ...) UseMethod("mape")

mape.default <- function (sim, obs, na.rm=TRUE, ...){

  if ( is.na(match(class(sim), c("integer", "numeric", "ts", "zoo"))) |
       is.na(match(class(obs), c("integer", "numeric", "ts", "zoo")))
  ) stop("Invalid argument type: 'sim' & 'obs' have to be of class: c('integer', 'numeric', 'ts', 'zoo')")

  if ( length(obs) != length(sim) )
    stop("Invalid argument: 'sim' & 'obs' doesn't have the same length !")

  mape <- mean( abs((obs - sim)/obs), na.rm = TRUE)

  return(mape)
}


mape.matrix <- function (sim, obs, na.rm=TRUE, ...){

  # Checking that 'sim' and 'obs' have the same dimensions
  if ( all.equal(dim(sim), dim(obs)) != TRUE )
    stop( paste("Invalid argument: dim(sim) != dim(obs) ( [",
                paste(dim(sim), collapse=" "), "] != [",
                paste(dim(obs), collapse=" "), "] )", sep="") )

  mape <- colMeans( abs((obs - sim)/obs), na.rm= na.rm)

  return(mape)

}


mape.data.frame <- function (sim, obs, na.rm=TRUE,...){

  sim <- as.matrix(sim)
  obs <- as.matrix(obs)

  mape.matrix(sim, obs, na.rm=na.rm, ...)

}




mape.zoo <- function(sim, obs, na.rm=TRUE, ...){

  sim <- zoo::coredata(sim)
  if (is.zoo(obs)) obs <- zoo::coredata(obs)

  if (is.matrix(sim) | is.data.frame(sim)) {
    mape.matrix(sim, obs, na.rm=na.rm, ...)
  } else NextMethod(sim, obs, na.rm=na.rm, ...)

}
