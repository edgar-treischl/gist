#' The gist addin
#'
#' @description The `gist_addin()` creates a shiny app
#' to manage your gists. Pick a gist, press the copy or the insert
#' button and the code will be insert.
#' Furthermore you can create and delete gists as well.
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
    shinyjs::useShinyjs(),
    shinyjs::extendShinyjs(text = "shinyjs.refresh_page = function() { location.reload(); }", functions = "refresh_page"),
    miniUI::gadgetTitleBar("Gist App"),
    miniUI::miniTabstripPanel(
      miniUI::miniTabPanel("Get", icon = icon("sliders"),
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
      ),
      miniUI::miniTabPanel("Create", icon = icon("area-chart"),
                           miniUI::miniContentPanel(
                             textInput("caption", "Name", ""),
                             textInput("description", "Description", ""),
                             textInput("code", "Code", ""),
                             miniUI::miniButtonBlock(
                               actionButton("push", "Push gist", class = "btn-success"),
                               actionButton("restart", "Restart", class = "btn-edgar")
                             )
                           )
      ),
      miniUI::miniTabPanel("Delete", icon = icon("upload"),
                           miniUI::miniContentPanel(
                             tableOutput('table'),
                             textInput("id", "Insert Gist ID to DELETE the file:", "")
                           ),
                           miniUI::miniButtonBlock(
                             actionButton("push2", "Delete gist", class = "btn-error"),
                             actionButton("restart2", "Restart", class = "btn-edgar")
                           )
      )
    )
  )

  server <- function(input, output, session) {


    get_gistnames <- reactive({

      x <- gistfiles(arrange = FALSE)

      x <- x |> dplyr::select(file) |> dplyr::arrange(file)
      file <- x$file

    })

    #create des functions
    get_des <- reactive({
      req(input$package_names)

      #print("Sorry, no description available.")
      x <- get_gist(input$package_names,
                    description = TRUE,
                    raw = TRUE)
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

    output$table <- renderTable(gistfiles(arrange = FALSE))

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

    observeEvent(input$push, {
      req(input$caption, input$description, input$code)
      x <- create_gist(name = input$caption,
                       code = input$code,
                       description = input$description)

      if (x == "TRUE") {
        shiny::showNotification("Pushed to GitHub",
                                duration = 3,
                                closeButton = TRUE,
                                type = "message")
      }

    })

    observeEvent(input$push2, {
      req(input$id)

      x <- delete_gist(id = input$id)

      if (x == "TRUE") {
        shiny::showNotification("Deleted",
                                duration = 3,
                                closeButton = TRUE,
                                type = "message")
      }

    })

    observeEvent(input$restart, {
      shinyjs::js$refresh_page()
    })

    observeEvent(input$restart2, {
      shinyjs::js$refresh_page()
    })


    observeEvent(input$done, {
      stopApp(TRUE)
    })
  }

  viewer <- paneViewer(300)
  runGadget(shinyApp(ui, server), viewer = paneViewer())

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
#     miniUI::gadgetTitleBar("Gist"),
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
#     get_gistnames <- reactive({
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
#
#     #make checkboxes for listed gists
#     output$package_names <- renderUI({
#
#       included_packages <- get_gistnames()
#
#       radioButtons(
#         inputId = "package_names",
#         label = NULL,
#         choices = included_packages
#       )
#
#     })
#
#     #print a tooltip/description of a gits
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






