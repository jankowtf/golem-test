options(shiny.port = as.numeric(Sys.getenv("PORT")), shiny.host='0.0.0.0', shiny.fullstacktrace = TRUE)
golem.test::run_app()
