
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gist

<!-- badges: start -->
<!-- badges: end -->

The gist package provides a set of functions to work with the GitHub
Gist. It allows you to create, read, update and delete gists via the
GitHub API. Moreover, it provides R Studio adding - a shiny app - to
interact with gists.

## Installation

You can install the development version of gist like so:

``` r
devtools::install_github("edgar-treischl/gist")
```

In order to retrieve data, you need to provide a GitHub API token
(`github_api`) with the `keyring` package. Use the `key_set()` function
code to save the token:

``` r
#Save GitHub API token as github_api
keyring::key_set(service = "github_api")
```

## Example

Go to the addin menu or use the following code to open the gist app:

``` r
#Run gist_addin()
gist::gist_addin()
```

<img src="man/figures/gistapp.png" style="width:70.0%" />

If you want to interact via CLI, you can use the following functions:

``` r
#gistfiles lists all files and returns names and ids
gist::gistfiles()
#>                   file                               id
#> 1        DBI_connect.R 102ea02b27520c8735fe034965bbaaaf
#> 2            RSQLite.R aba7bea4c37aa3788d32820c5b5e8894
#> 3              clear.R 27a596e3c9cf3b533936e771a01d840f
#> 4  cli_progress_step.R c0a0c0485afd7b0b48101e86a5dd1b3c
#> 5         dotwhisker.R 725f9b302453c9456e6dcc546760a0d4
#> 6           get_spss.R 491c63ec730fe156d8c3139ac21d978b
#> 7           gitcreds.R e00be278d451534ccac1862ac96987e2
#> 8       github_setup.R 8982bf396011c3694b39756873fd1476
#> 9              lintr.R f4168506926cf63c9ab48aaa823d62aa
#> 10             log4r.R 7717aa217f4f3eda06ab0b2b224cb52f
#> 11          mclapply.R 49f8a5396325c0a6827740b7b49e23be
#> 12    package_create.R c579aaeecd3eaa4cdd019c04ef49d133
#> 13    pandoc_convert.R b37e188d61bb08efa9aa8a53d0133f95
#> 14             sqldf.R 076dd0c4b87e6c0e721f03a275a58082
```

To work with your files, the package includes get, create, and delete
functions. The following code shows how to get a gist:

``` r
#gistfiles lists all files and returns names and ids
gist::get_gist("DBI_connect.R")
#> ✔ Copied DBI_connect.R from your GitHub account.
```
