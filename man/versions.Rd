\name{versions}
\alias{versions}
\title{Old Versions for the Dataset stored in AnnotationHub}

\description{An environment in which the AnnotationHub code of the different versions of the database is stored in each entry. At the moment only support the old version 1.0.0}

\examples{

ah = suppressMessages(AnnotationHub::AnnotationHub())
old_version = ah[[versions[["1.0.0"]], verbose=FALSE]]

}

\keyword{datasets}
