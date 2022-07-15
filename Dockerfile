FROM rocker/r-ver:4.1.2

ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true

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
    make \
    pandoc \
    pandoc-citeproc \
    python

# --- Update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# --- Copy all files and folders into docker and set the working dir
RUN mkdir /build
ADD . /build
WORKDIR /build

EXPOSE 3838

# --- Install golem package & run shiny app
# |---> 0. Handle repository stuff
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)"\
    >> /usr/local/lib/R/etc/Rprofile.site
# |---> 1. Install {remotes}
RUN install2.r --error --skipinstalled --deps TRUE remotes
#RUN install2.r --error --deps TRUE remotes
# |---> 2. Install golem package
RUN Rscript -e "remotes::install_local(upgrade='never')"
CMD Rscript docker_run_app.R
