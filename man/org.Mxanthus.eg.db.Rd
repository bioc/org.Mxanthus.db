\name{org.Mxanthus.eg.db}
\alias{org.Mxanthus.eg.db}
\title{The Data for org.Mxanthus.eg.db}
\description{
  org.Mxanthus.eg.db is an OrgDb object that stores the data from Annotation Hub that links
  each gene of the Genome with its corresponding GO terms.
}



\seealso{
  \itemize{
    \item \code{\link[AnnotationDbi]{AnnotationDb-class}} for use of
          the \code{select()} interface.
  }
}

\examples{
## Obtain the columns stored in org.Mxanthus.eg.db

columns(org.Mxanthus.eg.db)

## This is aquery to obtain the SYMBOL and the GO terms related to the GID 2000

select(org.Mxanthus.eg.db, keys="2000", columns=c("SYMBOL", "GO"))

}

\keyword{datasets}
