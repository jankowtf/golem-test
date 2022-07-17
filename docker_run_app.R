options(shiny.port = as.numeric(Sys.getenv("PORT")), shiny.host='0.0.0.0', shiny.fullstacktrace = TRUE)
print(getwd())
print(as.data.frame(installed.packages()[,c(1,3)]))
golem.test::run_app()
