############################################################
# For spiders web, 11.21
# This generates the file "alignments.html"
############################################################


cat("Rendering alignments.rmd/html\n")
Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc/")
library(rmarkdown)
library(here)
setwd(here("docs", "scripts", "generators"))
print(getwd())
output_dir = "../.."
render("../markdown/alignments.rmd", output_dir = output_dir, params = list(output_dir = output_dir), quiet = TRUE)