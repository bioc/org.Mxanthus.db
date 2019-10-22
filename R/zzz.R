org.Mxanthus.egORGANISM <- "Myxococcus xanthus DK 1622"


getData <- function(){
    ah <- AnnotationHub::AnnotationHub()
    query(ah, c("Myxococcus xanthus DK 1622", "org.Mxanthus.eg.db"))[[1]]
}
