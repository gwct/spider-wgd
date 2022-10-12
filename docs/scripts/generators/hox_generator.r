############################################################
# For spiders web, 11.21
# This generates the file "hox.html"
############################################################


cat("Rendering hox.rmd/html\n")
Sys.setenv(RSTUDIO_PANDOC="C:/Program Files/RStudio/bin/pandoc/")
library(rmarkdown)
library(here)
here()
#setwd(here("docs", "scripts", "generators"))
setwd(here())
print(getwd())
#output_dir = "../.."
output_dir = here("docs")
render(here("docs", "scripts", "markdown", "hox.rmd"), output_dir = output_dir, params = list(output_dir = output_dir), quiet = TRUE)