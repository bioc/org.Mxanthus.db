\name{org.Mxanthus.eg.db}
\alias{org.Mxanthus.eg.db}
\alias{org.Mxanthus.eg}
\title{Bioconductor annotation data package}
\description{

  Welcome to the org.Mxanthus.eg.db annotation Package.  This is an
  organism specific package. The purpose is to provide detailed
  information about the species abbreviated in the second part of the
  package name org.Mxanthus.eg.db. This package is updated biannually.

  To learn more about this package, users are encouraged to learn about
  the select, columns, keys and keytypes methods.  These are described
  in a walkthrough on the bioconductor website as well as in the manual
  pages and vignettes in the AnnotationDbi package.
}
\keyword{datasets}

ah = AnnotationHub()
query(ah, c("Myxococcus xanthus DK 1622", "org.Mxanthus.eg.db"))[[1]]

