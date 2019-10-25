org.Mxanthus.egORGANISM <- "Myxococcus xanthus DK 1622"


getData <- function(){
  
  ah <- AnnotationHub::AnnotationHub()
  return(query(ah, c("Myxococcus xanthus DK 1622", "org.Mxanthus.eg.db"))[[1]])
  
}

.onLoad <- function(libname, pkgname){
  
  
  makeActiveBinding("org.Mxanthus.db", getData , .GlobalEnv)
  
}
