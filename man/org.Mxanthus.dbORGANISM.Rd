\name{org.Mxanthus.dbORGANISM}
\alias{org.Mxanthus.dbORGANISM}
\title{The Organism for org.Mxanthus.db}
\description{
  org.Mxanthus.dbORGANISM is an R object that contains a single item: a
  character string that names the organism for which org.Mxanthus.db was built.
}

\details{
  Although the package name is suggestive of the organism for which it
  was built, org.Mxanthus.dbORGANISM provides a simple way to programmatically
  extract the organism name.
}

\seealso{
  \itemize{
    \item \code{\link[AnnotationDbi]{AnnotationDb-class}} for use of
          the \code{select()} interface.
  }
}

\examples{
## select() interface:
## Objects in this package can be accessed using the select() interface
## from the AnnotationDbi package. See ?select for details.

## Bimap interface:
name <- org.Mxanthus.dbORGANISM
}

\keyword{datasets}

