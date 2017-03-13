a <- commandArgs(trailingOnly = T)
d <- tryCatch(
  as.Date(a[1], format = "%Y%m%d"), 
  error = function(e) "first argument must be a date in form YYYYMMDD"
)
dir.create(a[1])
# default to remarkjs
from <- if (length(a) == 1) "templates/remarkjs" else sprintf("templates/%s", a[2])
t <- dir(from, full.names = T)
file.copy(t, a[1], recursive = TRUE)

# fill in the date in the template
talk <- file.path(a[1], "index.Rmd")
txt <- readLines(talk)
txt[txt == 'date: ""'] <- sprintf('date: "%s <br /> <br /> This work is released under <a href=\'https://github.com/cpsievert/talks/blob/gh-pages/LICENSE\'>Creative Commons</a>"', d)
writeLines(txt, talk)
