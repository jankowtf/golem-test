# --- Local ---
docker build -t golem-test .
docker buildx build --platform linux/amd64 -t golem-test .

# Run container based on image built locally
docker run -d --name golem-test -e PORT=3838 -p 3838:3838 golem-test
# Run container based on image built via GitHub actions
docker run -d --name golem-test-sb -e PORT=3838 -p 3838:3838 ghcr.io/rappster/golem-test:staging

# Open shiny app
open http://localhost:3838

# --- Heroku ---
# Login to container registry
heroku container:login

# Build the image and push to container registry
heroku container:push -a golem-test web

# Release the image to your app
heroku container:release -a golem-test web

# Open website
heroku open

# [WIP] --- GCP --- 
docker tag rocker/shiny:4.0.0 eu.gcr.io/dbt-def/shiny:4.0.0
