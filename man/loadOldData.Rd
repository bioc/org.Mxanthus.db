\name{loadOldData}
\alias{loadOldData}
\title{The loadOldData(v) function}

\description{This is a function that generates a OrgDv object that stores old versions stored in AnnotationHub}
\usage{loadOldData(v)}

\arguments{
  \item{v}{This value must be a character. It must be the two first numbers of the package version that uses the database that the user want to download. For example: "1.0"}
}

\value{An OrgDb object}

\examples{

old_version = loadOldData("1.0.0")

}

\keyword{datasets}