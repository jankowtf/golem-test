#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
    # Your application server logic
    # ### USER AUTH ##########

    res_auth <- shinymanager::secure_server(
        check_credentials = shinymanager::check_credentials(credentials)
    )

    output$auth_output <- renderPrint({
        reactiveValuesToList(res_auth)
    })
}
