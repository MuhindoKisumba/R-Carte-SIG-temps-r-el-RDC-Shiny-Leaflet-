FROM rocker/shiny

RUN R -e "install.packages(c('leaflet','DBI','RPostgres','dplyr'))"

COPY app.R /srv/shiny-server/

EXPOSE 3838
