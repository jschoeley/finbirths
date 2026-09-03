# Install required packages to local renv repository

# define date stamped repository
repo <- c(
  PPM = "https://packagemanager.posit.co/cran/2026-09-01"
)
options(repos = repo)

# define packages to install from cran-like repositories
cran <- c(
  "qs2",
  "yaml",
  "dplyr",
  "tidyr",
  "readr",
  "ggplot2",
  "svglite",
  "pxweb"
)

# define packages to install from github
github <- c(
  pfs = "jschoeley/pfs@a14c6b2dcd0877cd606ea0aef69c62c013d88fab"
)

all_package_names <-
  c(cran, names(github))

# initialize renv without restarting this R session
if (!file.exists("renv/activate.R")) {
  renv::init(
    bare = TRUE,
    repos = repo,
    restart = FALSE
  )
}

# needed for V8 on Linux
Sys.setenv(DOWNLOAD_STATIC_LIBV8 = "1")

# install cran packages
renv::install(
  cran,
  dependencies = "strong",
  repos = repo,
  prompt = FALSE
)

# Install GitHub packages
renv::install(
  unname(github),
  dependencies = "strong",
  prompt = FALSE
)

# make a record of installed packages
renv::snapshot(
  packages = all_package_names,
  repos = repo,
  prompt = FALSE
)
