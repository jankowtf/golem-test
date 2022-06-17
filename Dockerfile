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

# --- Install golem package & run shiny app
# |---> Old approach (prior to 2022-05-05):
# |---> 0. Handle repository stuff
#RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
# |---> 1. Install {renv}
# |---> 2. Restore dependencies from renv.lock
# |---> 3. Install golem package
#RUN Rscript -e "renv::consent(provided = TRUE);renv::restore();renv::install("remotes");remotes::install_local(upgrade='never')"
# |---> 4. Run shiny app
#CMD R -e "options(shiny.fullstacktrace = TRUE);options('shiny.port'=$PORT, shiny.host='0.0.0.0');golem.test::run_app()"

# |---> Approach 2022-06-14 13:30: trying to make some more sense of everything
#RUN Rscript -e "install.packages('remotes');remotes::install_local(upgrade='never')"
##CMD ["R", "-e", "options(shiny.fullstacktrace = TRUE);options('shiny.port'=$PORT, shiny.host='0.0.0.0');golem.test::run_app()"]
#CMD R -e "options(shiny.fullstacktrace = TRUE);options('shiny.port'=$PORT, shiny.host='0.0.0.0');golem.test::run_app()"

# |---> Approach 2022-06-17 09:30: without using {renv}
# |---> 0. Handle repository stuff
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl', Ncpus = 4)"\
    >> /usr/local/lib/R/etc/Rprofile.site
# |---> 1. Install {remotes}
#RUN install2.r --error --skipinstalled --deps TRUE remotes
RUN install2.r --error --deps TRUE remotes
# |---> 2. Install golem package
RUN Rscript -e "renv::deactivate();remotes::install_local(upgrade='never')"
# |---> 3. Run shiny app
CMD R -e "options(shiny.port = ${PORT}, shiny.host='0.0.0.0', shiny.fullstacktrace = TRUE);golem.test::run_app()"
#CMD ["R", "-e", "options(shiny.port = '${PORT}', shiny.host='0.0.0.0', shiny.fullstacktrace = TRUE);golem.test::run_app()"]
