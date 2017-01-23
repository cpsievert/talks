# first, make sure your existing R libraries are up-to-date
update.packages(ask = FALSE)

# function to install a package if it isn't already installed
required <- function(pkg) {
  if (system.file(package = pkg) == "") {
    install.packages(pkg, repos = c(CRAN = "https://cran.rstudio.com/"))
  }
}

required("devtools")

# most importantly, get development version of plotly from GitHub 
# (many examples won't be possible with CRAN version) 
devtools::install_github("ropensci/plotly")

# other packages we'll use
required("GGally")
required("crosstalk")
required("gapminder")
required("dendextend")
required("leaflet")
required("shiny")
required("rmarkdown")
