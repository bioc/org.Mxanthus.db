org.MxanthusORGANISM <- "Myxococcus xanthus DK 1622"


getData <- function(){
  
  ah <- AnnotationHub::AnnotationHub()
  return(query(ah, c("Myxococcus xanthus DK 1622", "org.Mxanthus.db"))[[1]])
  
}

.onLoad <- function(libname, pkgname){
  
  
  makeActiveBinding("org.Mxanthus.db", getData , .GlobalEnv)
  
}
