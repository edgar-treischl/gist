#' Explore GitHub Gist files
#'
#' @description The function `copycat_gistfiles()` returns a list with GitHub Gists.
#' @return Data frame with file names.
#' @export
#'

gistfiles <- function() {
  key <- try(keyring::key_get(service = "github_api"), silent = TRUE)
  test <- exists("key")

  if (test == FALSE) {
    cli::cli_abort("Create a Github Token and store it as a key named github_api with keyring::key_set() function.")
  }

  authoriz <- paste0("Bearer ", keyring::key_get("github_api"))


  req <- httr2::request("https://api.github.com/gists") |>
    httr2::req_headers("Accept" = "application/vnd.github+json",
                       "Authorization" = authoriz,
                       "X-GitHub-Api-Version" = "2022-11-28")


  resp <- httr2::req_perform(req)



  resp_json <- resp |> httr2::resp_body_json()

  answer <- c()
  ids <- c()

  for (i in 1:length(resp_json)) {

    file <- resp_json[[i]]$files
    filename <- file[[1]][1]
    filename <- as.character(filename)
    id <- resp_json[[i]]$id
    id <- id[[1]][1]
    answer <- append(answer, filename)
    ids <- append(ids, id)
  }

  df <- data.frame(answer, ids) |> dplyr::rename("file" = answer,
                                                 "id" = ids)
  return(df)

}



#' Copy Github Gist files
#'
#' @description The function `get_gist()` copies GitHub Gists.
#' @param filename The file name from one of your GitHub account (see gistfiles)
#' @param description The file name from one of your GitHub account (see gistfiles)
#' @return Message if successful.
#' @export
#'

get_gist <- function(filename, description = FALSE) {

  key <- try(keyring::key_get(service = "github_api"), silent = TRUE)
  test <- exists("key")

  if (test == FALSE) {
    cli::cli_abort("Create a Github Token and store it as a key named github_api with keyring::key_set() function.")
  }

  authoriz <- paste0("Bearer ", keyring::key_get("github_api"))


  req <- httr2::request("https://api.github.com/gists") |>
    httr2::req_headers("Accept" = "application/vnd.github+json",
                       "Authorization" = authoriz,
                       "X-GitHub-Api-Version" = "2022-11-28")


  resp <- httr2::req_perform(req)



  resp_json <- resp |> httr2::resp_body_json()

  x <- gistfiles()
  x$n <- 1:length(x$file)

  filename <- paste0(filename)

  scrapednr <- x |>
    dplyr::filter(file == filename) |>
    dplyr::pull(n)

  if (length(scrapednr) == 0) {
    cli::cli_abort("File not available.")
  }

  files_json <- resp_json[[scrapednr]]$files
  gist_url <-files_json[[1]][[4]]

  #gist_url <- raw_link(n = scrapednr)

  response <- httr::GET(gist_url)

  txt <- httr::content(response, as = "text")

  if (description == TRUE )  {
    des <- resp_json[[scrapednr]]$description
    return(des)
  }

  return(txt)
  #clipr::write_clip(txt)
  #cli::cli_alert_success("Copied {filename} from your GitHub account.")

}

utils::globalVariables(c("n"))


#' Create Github Gist files
#'
#' @description The function `copycat_gists.create()` creates GitHub Gists.
#' @param name The name of the Gist file.
#' @param code String with the code of the Gist.
#' @param description Code description.
#' @return Message if successful.
#' @export
#'

create_gist = function (name, code, description) {
  #name <- "snippets_usethis.R"
  #code <-  "usethis::edit_rstudio_snippets()"

  authoriz <- paste0("Bearer ", keyring::key_get("github_api"))
  name_file <- name

  # mylist_works <- list(
  #   description = "des",
  #   files = list("test2.R" = list(content = "usethis::edit_rstudio_snippets()")),
  #   public = TRUE
  # )

  #code_list <-list(content = code)

  mylist <- list(
    description = description,
    files = list(name = list(content = code)),
    public = TRUE
  )

  names(mylist$files)
  names(mylist$files) <- name


  req <- httr2::request("https://api.github.com/gists") |>
    #httr2::req_url_path("/post")|>
    httr2::req_headers("Accept" = "application/vnd.github+json",
                       "Authorization" = authoriz,
                       "X-GitHub-Api-Version" = "2022-11-28") |>
    httr2::req_body_json(mylist)

  resp <- httr2::req_perform(req)

  x <- gistfiles()

  if (name %in% x$file) {
    return("TRUE")
    usethis::ui_done("Insert {name}")
  }


}


#' Delete Github Gist files
#'
#' @description The function `copycat_gists.del()` deletes GitHub Gists.
#' @param id The id of the Gist file (see copycat_gistfiles).
#' @return Message if successful.
#' @export
#'

delete_gist = function (id) {
  authoriz <- paste0("Bearer ", keyring::key_get("github_api"))

  gitid <- id
  gurl <- "https://api.github.com/gists/"

  del_url <- paste0(gurl, gitid)

  req <- httr2::request(del_url) |>
    httr2::req_headers("Accept" = "application/vnd.github+json",
                       "Authorization" = authoriz,
                       "X-GitHub-Api-Version" = "2022-11-28") |>
    httr2::req_method("DELETE")


  resp <- httr2::req_perform(req)

  if (resp$status_code == 204) {
    usethis::ui_done("Deleted id: {id}")
    return("TRUE")
  }else {
    cli::cli_abort("Argh, something went wrong.")
    return("FALSE")
  }

}


utils::globalVariables(c("n"))

