Sys.setenv("R_TESTS" = "")

library(testthat)
library(phsmethods)

test_check("phsmethods")
