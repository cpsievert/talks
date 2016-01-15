a <- commandArgs(trailingOnly = T)
d <- tryCatch(
  as.Date(a[1], format = "%Y%m%d"), 
  error = function(e) "first argument must be a date in form YYYYMMDD"
)
dir.create(a[1])
# default to ioslides
from <- if (length(a) == 1) "templates/ioslides" else sprintf("templates/%s", a[2])
t <- dir(from, full.names = T)
file.copy(t, a[1])

# fill in the date in the template
talk <- file.path(a[1], "index.Rmd")
txt <- readLines(talk)
txt[txt == 'date: ""'] <- sprintf('date: "%s"', d)
writeLines(txt, talk)
