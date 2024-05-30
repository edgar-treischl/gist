#' Manage code snippets via the copycat addin
#'
#' @description The `copycat_addin()` creates a shiny gadget
#' to work with the Copycat or your data for Copycat. Pick an R package
#' and a function within the gadget. Press the insert
#' button and the code will be insert into the current document at the
#' location of the cursor. The `copycat_addin()` is inspired by parsnip addin,
#' which inserts model specifications.
#'
#' @import shiny
#' @export
#'


gist_addin <- function() {

  ui <- miniUI::miniPage(
    tags$head(
      tags$style(HTML("
      .gadget-title{
        color: black;
        font-size: larger;
        font-weight: bold;
      }
      .btn-edgar {
        background-color: #0077b6;
        border: none;
        color: white;
        opacity: 0.6;
        transition: 0.3s;
        font-size: medium;
      }
      .btn-edgar:hover {
        opacity: 1;
        background-color: #0077b6;
      }
      .btn-success {
        background-color: #f4511e;
        border: none;
        color: white;
        opacity: 0.6;
        transition: 0.3s;
        font-size: medium;
      }
      .btn-success:hover {
        opacity: 1;
        background-color: #f4511e;
      }"))
    ),
    miniUI::gadgetTitleBar("Gist"),
    miniUI::miniContentPanel(
      h4("Pick a Gist:"),
      fillRow(
        fillCol(
          uiOutput("package_names")
        ),
        miniUI::miniContentPanel(
          h4(uiOutput("tooltip")),
          br(),
          verbatimTextOutput("preview"),
        )
      )
    ),
    miniUI::miniButtonBlock(
      actionButton("write", "Insert code", class = "btn-success"),
      actionButton("copy", "Copy code", class = "btn-edgar")
    )
  )

  server <- function(input, output, session) {



    #create list with functions
    get_gistnames <- reactive({

      x <- gistfiles()

      x <- x |> dplyr::select(file) |> dplyr::arrange(file)
      file <- x$file

    })


    #create des functions
    get_des <- reactive({
      req(input$package_names)

      #print("Sorry, no description available.")
      x <- get_gist(input$package_names, description = TRUE)
      print(x)

    })

    #make checkboxes for listed gists
    output$package_names <- renderUI({

      included_packages <- get_gistnames()

      radioButtons(
        inputId = "package_names",
        label = NULL,
        choices = included_packages
      )

    })

    #print a tooltip/description of a gits
    output$tooltip <- renderUI({
      get_des()

    })

    #fetch code
    create_code <- reactive({

      #paste0(txt0,"\n", txt, sep = "\n\n")
      req(input$package_names)
      get_gist(input$package_names, description = FALSE)

    })

    #print preview
    output$preview <- renderText({
      create_code()
    })

    #write code
    observeEvent(input$write, {
      txt <- create_code()
      rstudioapi::insertText(txt)
    })

    #copy code
    observeEvent(input$copy, {
      txt <- create_code()
      clipr::write_clip(txt)
    })

    #DONE
    observeEvent(input$done, {
      stopApp()
    })

  }

  viewer <- paneViewer(300)
  runGadget(ui, server, viewer = viewer)

}





utils::globalVariables(c("package"))

#OLD ONE####################
# gist_addin <- function() {
#
#   ui <- miniUI::miniPage(
#     tags$head(
#       tags$style(HTML("
#       .gadget-title{
#         color: black;
#         font-size: larger;
#         font-weight: bold;
#       }
#       .btn-edgar {
#         background-color: #0077b6;
#         border: none;
#         color: white;
#         opacity: 0.6;
#         transition: 0.3s;
#         font-size: medium;
#       }
#       .btn-edgar:hover {
#         opacity: 1;
#         background-color: #0077b6;
#       }
#       .btn-success {
#         background-color: #f4511e;
#         border: none;
#         color: white;
#         opacity: 0.6;
#         transition: 0.3s;
#         font-size: medium;
#       }
#       .btn-success:hover {
#         opacity: 1;
#         background-color: #f4511e;
#       }"))
#     ),
#     miniUI::gadgetTitleBar("GistR"),
#     miniUI::miniContentPanel(
#       h4("Pick a Gist:"),
#       fillRow(
#         fillCol(
#           uiOutput("package_names")
#         ),
#         miniUI::miniContentPanel(
#           h4(uiOutput("tooltip")),
#           br(),
#           verbatimTextOutput("preview"),
#         )
#       )
#     ),
#     miniUI::miniButtonBlock(
#       actionButton("write", "Insert code", class = "btn-success"),
#       actionButton("copy", "Copy code", class = "btn-edgar")
#     )
#   )
#
#   server <- function(input, output, session) {
#
#
#
#     #create list with functions
#     get_packages <- reactive({
#
#       x <- gistfiles()
#
#       x <- x |> dplyr::select(file) |> dplyr::arrange(file)
#       file <- x$file
#
#     })
#
#
#     #create des functions
#     get_des <- reactive({
#       req(input$package_names)
#
#       #print("Sorry, no description available.")
#       x <- get_gist(input$package_names, description = TRUE)
#       print(x)
#
#     })
#     #make checkbox for package choices
#
#     # output$package_choices <- renderUI({
#     #
#     #   choices <- get_fun()
#     #
#     #   radioButtons(
#     #     inputId = "fun_name",
#     #     label = NULL,
#     #     choices = choices
#     #   )
#     #
#     # })
#
#     #make checkboxes for listed packages
#     output$package_names <- renderUI({
#
#       included_packages <- get_packages()
#
#       radioButtons(
#         inputId = "package_names",
#         label = NULL,
#         choices = included_packages
#       )
#
#     })
#
#     #print a tooltip/description of a function
#     output$tooltip <- renderUI({
#       get_des()
#
#     })
#
#     #fetch code
#     create_code <- reactive({
#
#       #paste0(txt0,"\n", txt, sep = "\n\n")
#       req(input$package_names)
#       get_gist(input$package_names, description = FALSE)
#
#     })
#
#     #print preview
#     output$preview <- renderText({
#       create_code()
#     })
#
#     #write code
#     observeEvent(input$write, {
#       txt <- create_code()
#       rstudioapi::insertText(txt)
#     })
#
#     #copy code
#     observeEvent(input$copy, {
#       txt <- create_code()
#       clipr::write_clip(txt)
#     })
#
#     #DONE
#     observeEvent(input$done, {
#       stopApp()
#     })
#
#   }
#
#   viewer <- paneViewer(300)
#   runGadget(ui, server, viewer = viewer)
#
# }




