# Usage:
# test_file("airquality.xls")
test_file <- function(file_name) {
  testthat::test_path("files", file_name)
}
