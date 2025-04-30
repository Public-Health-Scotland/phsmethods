# see `help(run_script, package = 'touchstone')` on how to run this
# interactively

# installs branches to benchmark
touchstone::branch_install(c("master", "master"))

# benchmark
touchstone::benchmark_run(
  expr_before_benchmark = {
    library(phsmethods)
    ages = 20L
  },
  single_age_groups = create_age_groups(x = ages),
  branches = c("master", "master")
)

touchstone::benchmark_run(
  expr_before_benchmark = {
    library(phsmethods)
    ages = rep(1L:120L, 10L)
  },
  single_age_groups = create_age_groups(x = ages),
  branches = c("master", "master")
)

# create artefacts used downstream in the GitHub Action
touchstone::benchmark_analyze()
