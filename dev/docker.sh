docker build -t golem-test-sb .

docker run -d --name golem-test-sb -e PORT=5000 -p 5002:5000 golem-test

open http://localhost:5002

# --- GCP ---
docker tag rocker/shiny:4.0.0 eu.gcr.io/dbt-def/shiny:4.0.0
