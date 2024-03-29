% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/chi_pad.R
\name{chi_pad}
\alias{chi_pad}
\title{Add a leading zero to nine-digit CHI numbers}
\usage{
chi_pad(x)
}
\arguments{
\item{x}{a CHI number or a vector of CHI numbers with \code{character} class.}
}
\value{
The original character vector with CHI numbers padded if applicable.
}
\description{
\code{chi_pad} takes a nine-digit CHI number with
\code{character} class and prefixes it with a zero. Any values provided
which are not a string comprised of nine numeric digits remain unchanged.
}
\details{
The Community Health Index (CHI) is a register of all patients in
NHS Scotland. A CHI number is a unique, ten-digit identifier assigned to
each patient on the index.

The first six digits of a CHI number are a patient's date of birth in
DD/MM/YY format. The first digit of a CHI number must, therefore, be 3 or
less. Depending on the source, CHI numbers are sometimes missing a leading
zero.

While a CHI number is made up exclusively of numeric digits, it cannot be
stored with \code{numeric} class in R. This is because leading zeros in
numeric values are silently dropped, a practice not exclusive to R. For this
reason, \code{chi_pad} accepts input values of \code{character} class
only, and returns values of the same class. It does not assess the validity
of a CHI number - please see \code{\link[=chi_check]{chi_check()}} for that.
}
\examples{
chi_pad(c("101011237", "101201234"))
}
