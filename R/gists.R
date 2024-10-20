#' List All Gist Files
#'
#' @description The function `gistFiles()` returns all Gist files
#'  from a given Git Hub account.
#' @param arrange To arrange the files alphabetically, set to TRUE.
#' @return Data frame with file names and id.
#' @export
#'

gistFiles <- function(arrange = TRUE) {
  key <- try(keyring::key_get(service = "github_api"), silent = TRUE)
  test <- exists("key")

  if (test == FALSE) {
    cli::cli_abort("Create a Git Hub Token and store it as a key named github_api with keyring::key_set() function.")
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

  df <- data.frame(answer, ids) |>
    dplyr::rename("file" = answer, "id" = ids)

  if (arrange == TRUE) {
    df <- df |> dplyr::arrange(file)
  }

  return(df)

}



#' Get a Gist
#'
#' @description The function `gist_get()` copies a Gist from Git Hub.
#' @param filename The file name of a gist file.
#' @param raw Get raw text string or copy it to clipboard.
#' @param description If TRUE, the function returns the description of the Gist.
#' @return Message if successful.
#' @export
#'

gist_get <- function(filename,
                     description = FALSE,
                     raw = FALSE) {

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

  x <- gistFiles(arrange = FALSE)
  x$n <- 1:length(x$file)

  filename <- paste0(filename)

  scrapednr <- x |>
    dplyr::filter(file == filename) |>
    dplyr::pull(n)

  if (length(scrapednr) == 0) {
    cli::cli_abort("File not available.")
  }

  files_json <- resp_json[[scrapednr]]$files
  gist_url <- files_json[[1]][[4]]

  #gist_url <- raw_link(n = scrapednr)

  response <- httr::GET(gist_url)

  txt <- httr::content(response, as = "text")

  if (description == TRUE )  {
    des <- resp_json[[scrapednr]]$description
    return(des)
  }

  #return(txt)
  if (raw == TRUE) {
    return(txt)
  } else {
    cli::cli_alert_success("Copied {filename} from your GitHub account.")
    clipr::write_clip(txt)
  }

}

utils::globalVariables(c("n"))


#' Create a Gist
#'
#' @description The function `gist_create()` creates a new Gist file.
#' @param name The name of the file.
#' @param code The code as character.
#' @param description The description of the code as character.
#' @return Message if successful.
#' @export
#'

gist_create = function (name, code, description) {
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

  x <- gistFiles(arrange = FALSE)

  if (name %in% x$file) {
    usethis::ui_done("Insert {name}")
    return("TRUE")
  }


}


#' Delete a Gist
#'
#' @description Be careful: The function `gist_delete()` deletes a Gist file.
#' @param id The id of the Gist file (from gistFiles).
#' @return Message if file was successfully deleted.
#' @export
#'

gist_delete = function (id) {
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

