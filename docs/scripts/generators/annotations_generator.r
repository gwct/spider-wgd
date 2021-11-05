############################################################
# For turtles web, 07.21
# This generates the file "annotations.html"
############################################################


cat("Rendering annotations.rmd/html\n")
Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc/")
library(rmarkdown)
library(here)
#setwd(here("scripts", "generators"))
print(getwd())
output_dir = "../.."
render("../markdown/annotations.rmd", output_dir = output_dir, params = list(output_dir = output_dir), quiet = TRUE)