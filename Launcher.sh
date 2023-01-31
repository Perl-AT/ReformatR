#!/bin/bash

cd ~/Desktop/ReformatR-1.1

/usr/local/bin/R --vanilla --no-echo -e 'library(methods); shiny::runApp("ReformatR.R", launch.browser = TRUE)' &

sleep 600

kill $!