docker build -t golem-test-sb .

docker run -d --name golem-test-sb -e PORT=3838 -p 3838:3838 golem-test-sb
docker run -d --name golem-test-sb -e PORT=3838 -p 3838:3838 ghcr.io/rappster/golem-test:staging

open http://localhost:3838

# --- GCP ---
docker tag rocker/shiny:4.0.0 eu.gcr.io/dbt-def/shiny:4.0.0
