#'transform_categorial_to_binary
#'
#'transform categorial columns into binary
#'
#'@param dt Dataframe of integer or numeric values
#'@param listCategorial list of categorial columns
#'@param listInteger list of numerical columns
#'
#'@return A dataframe with numerical value
#'@examples

#'@export
#transform_categorial_to_binary
transform_categorial_to_binary <- function(listCategorial=0 , listInteger=0,dt){             #have to precice column data

  ######### Transformation
  vect_to_matrix_transform  <- function(vec) {
    vec <- as.character(vec)
    model.matrix(~vec-1)
  }

   dt<- as.data.frame(dt)

  if( listCategorial==0 ) return(dt)

  if( listInteger==0 ){
    if(length(listCategorial)==1) return(vect_to_matrix_transform(dt[,listCategorial]))  ###A changer
    return(cbind(model.matrix(~ . + 0, data=dt[,listCategorial] ,
                              contrasts.arg = lapply(dt[,listCategorial] , contrasts, contrasts=FALSE))))

  }

  return(cbind(dt[,listInteger],model.matrix(~ . + 0, data=dt[,listCategorial] ,
                                             contrasts.arg = lapply(dt[,listCategorial] , contrasts, contrasts=FALSE))))
}



