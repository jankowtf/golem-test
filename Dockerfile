FROM rocker/r-ver:4.1.2
ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS=true
# system libraries of general use
# install debian packages
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
# update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean
# copy all files and folders into docker and set the working dir
RUN mkdir /build
ADD . /build
WORKDIR /build

# install renv & restore packages
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
#RUN Rscript -e 'install.packages("remotes");install.packages("renv");renv::consent(provided = TRUE);renv::restore()'
RUN Rscript -e 'renv::consent(provided = TRUE);renv::restore()'
CMD R -e "renv::install('remotes');remotes::install_local(upgrade='never');options(shiny.fullstacktrace = TRUE);options('shiny.port'=$PORT,shiny.host='0.0.0.0');golem.test::run_app()"
#CMD R -e "remotes::install_local(upgrade='never');options(shiny.fullstacktrace = TRUE);options('shiny.port'=$PORT,shiny.host='0.0.0.0');golem.test::run_app()"
