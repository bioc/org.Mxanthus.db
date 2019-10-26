org.MxanthusORGANISM <- "Myxococcus xanthus DK 1622"

loadOrgMxanthusDb <- local({
    ah75133 <- NULL
    function(value) {
        stopifnot(missing(value))
        if (is.null(ah75133)) {
            ah <- AnnotationHub::AnnotationHub()
            ah75133 <<- ah[["AH75133"]]
        }
        ah75133
    }
})

.onLoad <- function(libname, pkgname)
{
    ns <- asNamespace(pkgname)
    makeActiveBinding("org.Mxanthus.db", loadOrgMxanthusDb , env=ns)
    namespaceExport(ns, "org.Mxanthus.db")
}
