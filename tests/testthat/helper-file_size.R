if (!dir.exists(file.path(tempdir(), "test-file_size"))) {
  dir.create(file.path(tempdir(), "test-file_size"))
} else {
  stop("A folder named test-file_size already exists in the temporary ",
       "directory. Please delete this folder before attempting to build this ",
       "package or run its tests.")
}

data("airquality")
data("mtcars")
