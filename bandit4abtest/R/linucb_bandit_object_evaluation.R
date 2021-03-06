#'LinucbBanditObjectEvaluation
#'
#'Run a \code{\link{LINUCB}} using visitor_reward and dt values.
#'Control data.
#'Stop if something is wrong.
#'After execution of linucb_bandit, calculates the cumulative regret
#'associated with the choices made.
#'Review the cumulative regret according iterations and an linucb_bandit object.
#'See also \code{\link{LINUCB}}, \code{\link{CumulativeRegret}}
#'Require \code{\link{tic}} and \code{\link{toc}} from \code{\link{tictoc}} library
#'
#'@param dt Dataframe of integer or numeric values
#'@param visitor_reward Dataframe of integer or numeric values
#'@param alpha numerical value (optional)
#'@param K Integer value (optional)
#'
#'@return
#' \itemize{ List of element:
#'  \item linucb_bandit_alloc: linucb bandit object ,
#'  \item cum_reg_linucb_bandit_alloc: List numeric.
#'  }
#'
#'@examples
#'size.tot = 1000
#'set.seed(4649)                          # this makes the example exactly reproducible
#'x1 = runif(size.tot, min=0, max=10)          # you have 4, largely uncorrelated predictors
#'x2 = runif(size.tot, min=0, max=10)
#'x3 = runif(size.tot, min=0, max=10)
#'x4 = runif(size.tot, min=0, max=10)
#'dt = cbind(x1,x2,x3,x4)
#'#arm reward
#'arm_1 <-  as.vector(c(-1,9,-8,4))
#'K1 = 1/(1+exp(- crossprod(t(dt),arm_1))) # inverse logit transform of linear predictor
#'K1 = vapply(K1, function(x) rbinom(1, 1, x), as.integer(1L))
#'arm_2 <-  as.vector(c(-1,2,1,0))
#'K2 = 1/(1+exp(- crossprod(t(dt),arm_2))) # inverse logit transform of linear predictor
#'K2 = vapply(K2, function(x) rbinom(1, 1, x), as.integer(1L))
#'arm_3 <-  as.vector(c(-1,-5,1,10))
#'K3 = 1/(1+exp(- crossprod(t(dt),arm_3)))
#'K3 = vapply(K3, function(x) rbinom(1, 1, x), as.integer(1L))
#'visitor_reward <-  data.frame(K1,K2,K3)
#'dt <- as.data.frame(dt)
#'LinucbBanditObjectEvaluation(dt,visitor_reward)
#'LinucbBanditObjectEvaluation(dt,visitor_reward,average = TRUE,IsRewardAreBoolean = TRUE)
#'@export
#linucb_bandit object evaluation
LinucbBanditObjectEvaluation <- function(dt, visitor_reward, alpha=1, K=ncol(visitor_reward),average = FALSE,IsRewardAreBoolean = FALSE,dt.reward = dt ,explanatory_variable=colnames(dt.reward)) {
  linucb_bandit_alloc <- LINUCB(dt=dt, visitor_reward=visitor_reward, alpha=alpha, K=K)

  if(average == FALSE) cum_reg_linucb_bandit_alloc <- cumulativeRegret(linucb_bandit_alloc$choice, visitor_reward)
  if(average == TRUE) cum_reg_linucb_bandit_alloc <- cumulativeRegretAverage(linucb_bandit_alloc$choice,
                                                                                visitor_reward = visitor_reward,
                                                                                dt=dt.reward,
                                                                                IsRewardAreBoolean=IsRewardAreBoolean,
                                                                                explanatory_variable=explanatory_variable)


  return (list('linucb_bandit_alloc'=linucb_bandit_alloc ,'cum_reg_linucb_bandit_alloc'=cum_reg_linucb_bandit_alloc))
}
