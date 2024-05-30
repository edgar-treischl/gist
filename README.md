
<!-- README.md is generated from README.Rmd. Please edit that file -->

# gist

<!-- badges: start -->
<!-- badges: end -->

The gist package provides a set of functions to work with the GitHub
Gist API. It allows you to create, read, update and delete gists.
Moreover, it provides a shiny app to interact with gists. The app will
be installed as an addin and can be accessed via the RStudio addin menu.

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
