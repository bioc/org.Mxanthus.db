\name{loadOrgMxanthusDb}
\alias{loadOrgMxanthusDb}
\title{The loadOrgMxanthusDb(value) function}
\description{This is a function that generates the object org.Mxanthus.db (an OrgDb object) when the package is loaded}
\usage{loadOrgMxanthusDb(value)}

\arguments{
  \item{value}{This value must be NULL}
}

\value{An OrgDb objecto called org.Mxanthus.db}

\examples{

function (value) 
{
    stopifnot(missing(value))
    if (is.null(ah75133)) {
        ah <- AnnotationHub::AnnotationHub()
        ah75133 <<- ah[["AH75133"]]
    }
    ah75133
  }
}

\keyword{datasets}

