#FROM rocker/r-ver:4.1.2
FROM ghcr.io/rappster/golem-test_deps:deps

# --- Meta ---
LABEL dockerfile_version="v0.3"
EXPOSE 3838
ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true
ENV APP_DIR=/home/shiny/project

# NEW
ENV RENV_PATHS_CACHE=/home/shiny/renv/cache

# system libraries of general use
# --- Install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    git-core \
    libcurl4-openssl-dev \
    libgit2-dev \
    libicu-dev \
    libpng-dev \
    libpq-dev \
    libssl-dev \
    libxml2-dev \
    cmake \
    make \
    pandoc \
    pandoc-citeproc \
    python

# --- Update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# --- Copy all files and folders into docker and set the working dir
#WORKDIR /build
WORKDIR $APP_DIR
COPY . .

# --- Install local package
# |---> 0. Handle repository stuff
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)"\
    >> /usr/local/lib/R/etc/Rprofile.site

# ---|---> 1. Install local package
RUN echo ls -lf /home/shiny/renv/cache
RUN Rscript -e "renv::install('.')"

# --- Run shiny app
CMD ["Rscript", "docker_run_app.R"]
