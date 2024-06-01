
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gist

<!-- badges: start -->

[![R-CMD-check](https://github.com/edgar-treischl/gist/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edgar-treischl/gist/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The gist package provides a set of functions to work with [GitHub
Gist](https://gist.github.com/). It allows you to copy, create, and
delete gists via the GitHub API. Moreover, it provides an RStudio
addin - a shiny app - to interact with your gists.

## Installation

You can install the development version of gist like so:

``` r
devtools::install_github("edgar-treischl/gist")
```

In order to retrieve data, you need to provide a GitHub API token
(`github_api`) with the `keyring` package. Use the `key_set()` function
to store the token:

``` r
#Save GitHub API token as github_api
keyring::key_set(service = "github_api")
```

## Example

Go to the addin menu or use the following code to open the gist app. The
app shows a list with your gist files and a preview of the code. Pick
your gist and copy or insert the code. Furthermore, the app has tabs to
create and delete gists as well.

``` r
#Run gist_addin()
gist::gist_addin()
```

<img src="man/figures/gistapp.png" style="width:70.0%" />

If you want to interact via R, you can use the following functions:

``` r
#gistfiles lists all files and returns names and ids
gist::gistfiles() |> 
  head()
#>                  file                               id
#> 1       DBI_connect.R 102ea02b27520c8735fe034965bbaaaf
#> 2           RSQLite.R aba7bea4c37aa3788d32820c5b5e8894
#> 3             clear.R 27a596e3c9cf3b533936e771a01d840f
#> 4 cli_progress_step.R c0a0c0485afd7b0b48101e86a5dd1b3c
#> 5        dotwhisker.R 725f9b302453c9456e6dcc546760a0d4
#> 6          get_spss.R 491c63ec730fe156d8c3139ac21d978b
```

The package includes a get, create, and delete function. The following
code shows how to get a gist:

``` r
#gistfiles lists all files and returns names and ids
gist::get_gist(filename = "DBI_connect.R")

#> ✔ Copied DBI_connect.R from your GitHub account.
```
