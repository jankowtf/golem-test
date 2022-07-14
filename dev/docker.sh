docker build -t golem-test .

docker run -d --rm --name golem-test -e PORT=5000 -p 5001:5000 golem-test

open http://localhost:5001

# --- GCP ---
docker tag rocker/shiny:4.0.0 eu.gcr.io/dbt-def/shiny:4.0.0
