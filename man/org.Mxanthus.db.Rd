\name{org.Mxanthus.db}
\alias{org.Mxanthus.db}
\title{The Data for org.Mxanthus.db}
\description{
  org.Mxanthus.db is an OrgDb object that stores the data from Annotation Hub that links
  each gene of the Genome with its corresponding GO terms and other biological identifiers.
}



\seealso{
  \itemize{
    \item \code{\link[AnnotationDbi]{AnnotationDb-class}} for use of
          the \code{select()} interface.
  }
}

\examples{
## Obtain the columns stored in org.Mxanthus.eg.db

columns(org.Mxanthus.db)

## This is aquery to obtain the SYMBOL and the GO terms related to the GID 2000

select(org.Mxanthus.db, keys="2000", columns=c("SYMBOL", "GO"))

}

\keyword{datasets}
