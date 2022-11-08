test_that("single character argument passes check for character", {
  args <- list(arg1 = "test")
  expect_equal(make_inheritance_checks(args, target_classes = "character"), NULL)
})

test_that("two character argument passes check for character", {
  args <- list(arg1 = "test", arg2 = "test2")
  expect_equal(make_inheritance_checks(args, target_classes = "character"), NULL)
})

test_that("single numeric argument passes check for numeric", {
  args <- list(arg1 = 0.5)
  expect_equal(make_inheritance_checks(args, target_classes = "numeric"), NULL)
})

test_that("two numeric argument passes check for numeric", {
  args <- list(arg1 = 1, arg2 = 0.5)
  expect_equal(make_inheritance_checks(args, target_classes = "numeric"), NULL)
})

test_that("single factor argument passes check for factor", {
  args <- list(arg1 = as.factor(c("a", "a", "b", "b")))
  expect_equal(make_inheritance_checks(args, target_classes = "factor"), NULL)
})

test_that("single factor argument passes check for factor", {
  args <- list(arg1 = as.factor(c("a", "a", "b", "b")))
  expect_equal(make_inheritance_checks(args, target_classes = "factor"), NULL)
})

test_that("make_inheritance_checks errors properly", {
  expect_error(make_inheritance_checks(list(arg1 = "1"), target_classes = "numeric"),
    regexp = "`arg1` has class <character>, but must be <numeric>\\.$"
  )

  expect_error(make_inheritance_checks(list(arg1 = 1), target_classes = "character"),
    regexp = "`arg1` has class <numeric>, but must be <character>\\.$"
  )

  expect_error(
    make_inheritance_checks(list(arg1 = "22.10.1888", arg2 = 22),
      target_classes = c("DATE", "POSIX")
    ),
    regexp = "`arg1` has class <character>, but must be any of <DATE/POSIX>\\.
`arg2` has class <numeric>, but must be any of <DATE/POSIX>\\.$"
  )

  expect_error(make_inheritance_checks("1", target_classes = "numeric"),
    regexp = "make_inheritance_checks failed: 'arguments' must be a list\\.$"
  )

  expect_error(
    make_inheritance_checks(list(arg1 = NULL),
      target_classes = "character",
      ignore_null = FALSE
    ),
    regexp = '`arg1` is "NULL" but must be <character>\\.$'
  )
})
