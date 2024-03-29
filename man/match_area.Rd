% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/match_area.R
\name{match_area}
\alias{match_area}
\title{Translate geography codes into area names}
\usage{
match_area(x)
}
\arguments{
\item{x}{A geography code or vector of geography codes.}
}
\value{
Each geography code within Scotland is unique, and consequently
\code{match_area} returns a single area name for each input value.
Any input value without a corresponding value in the
\code{\link[=area_lookup]{area_lookup()}} dataset will return an NA output value.
}
\description{
\code{match_area} takes a geography code or vector of geography
codes. It matches the input to the corresponding value in the
\code{\link[=area_lookup]{area_lookup()}} dataset and returns the corresponding area name.
}
\details{
\code{match_area} relies predominantly on the standard 9 digit
geography codes. The only exceptions are:
\itemize{
\item RA2701: No Fixed Abode
\item RA2702: Rest of UK (Outside Scotland)
\item RA2703: Outside the UK
\item RA2704: Unknown Residency
}

\code{match_area} caters for both current and previous versions of geography
codes (e.g 2014 and 2019 Health Boards).

It can account for geography codes pertaining to Health Boards, Council
Areas, Health and Social Care Partnerships, Intermediate Zones, Data Zones
(2001 and 2011), Electoral Wards, Scottish Parliamentary Constituencies,
UK Parliamentary Constituencies, Travel to work areas, National Parks,
Community Health Partnerships, Localities (S19), Settlements (S20) and
Scotland.

\code{match_area} returns a non-NA value only when an exact match is present
between the input value and the corresponding variable in the
\code{\link[=area_lookup]{area_lookup()}} dataset. These exact matches are sensitive to both
case and spacing. It is advised to inspect \code{\link[=area_lookup]{area_lookup()}} in the
case of unexpected results, as these may be explained by subtle differences
in transcription between the input value and the corresponding value in the
lookup dataset.
}
\examples{
match_area("S20000010")

library(dplyr)
df <- tibble(code = c("S02000656", "S02001042", "S08000020", "S12000013"))
df \%>\% mutate(name = match_area(code))

}
