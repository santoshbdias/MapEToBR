##############################
# 'mpe': Mean Percentage Error #
##############################
# 'obs'   : numeric 'data.frame', 'matrix' or 'vector' with observed values
# 'sim'   : numeric 'data.frame', 'matrix' or 'vector' with simulated values
# 'Result': Mean Absolute Error between 'sim' and 'obs', in the same units of 'sim' and 'obs'

mpe <-function(sim, obs, ...) UseMethod("mpe")

mpe.default <- function (sim, obs, na.rm=TRUE, ...){

  if ( is.na(match(class(sim), c("integer", "numeric", "ts", "zoo"))) |
       is.na(match(class(obs), c("integer", "numeric", "ts", "zoo")))
  ) stop("Invalid argument type: 'sim' & 'obs' have to be of class: c('integer', 'numeric', 'ts', 'zoo')")

  if ( length(obs) != length(sim) )
    stop("Invalid argument: 'sim' & 'obs' doesn't have the same length !")

  mpe <- mean(((obs - sim)/obs), na.rm = TRUE)

  return(mpe)
}


mpe.matrix <- function (sim, obs, na.rm=TRUE, ...){

  # Checking that 'sim' and 'obs' have the same dimensions
  if ( all.equal(dim(sim), dim(obs)) != TRUE )
    stop( paste("Invalid argument: dim(sim) != dim(obs) ( [",
                paste(dim(sim), collapse=" "), "] != [",
                paste(dim(obs), collapse=" "), "] )", sep="") )

  mpe <- colMeans(((obs - sim)/obs), na.rm= na.rm)

  return(mpe)

}


mpe.data.frame <- function (sim, obs, na.rm=TRUE,...){

  sim <- as.matrix(sim)
  obs <- as.matrix(obs)

  mpe.matrix(sim, obs, na.rm=na.rm, ...)

}




mpe.zoo <- function(sim, obs, na.rm=TRUE, ...){

  sim <- zoo::coredata(sim)
  if (is.zoo(obs)) obs <- zoo::coredata(obs)

  if (is.matrix(sim) | is.data.frame(sim)) {
    mpe.matrix(sim, obs, na.rm=na.rm, ...)
  } else NextMethod(sim, obs, na.rm=na.rm, ...)

}
