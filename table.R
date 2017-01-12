f <- list.files()
# all talk directories have format 'YYYYMMDD'
talks <- f[grepl("[0-9]{8}", f)]

# get yaml front matter fields from a given talk
get_yaml <- function(talk, fields = c("title", "venue", "type", "recording")) {
  txt <- readLines(file.path(talk, "index.Rmd"))
  sep <- which(txt == "---")
  front <- txt[seq.int(sep[1] + 1, sep[2] - 1)]
  yml <- yaml::yaml.load(paste(front, collapse = "\n"))
  yml[names(yml) %in% fields]
}
d <- data.frame(do.call("rbind", lapply(talks, get_yaml)))

# add links to talks in title column
links <- sprintf("http://cpsievert.github.io/talks/%s", talks)
d$title <- sprintf('<a href="%s">%s</a>', links, d$title)

d$date <- as.Date(talks, format = "%Y%m%d")
d <- d[order(d$date, decreasing = TRUE), ]

library(DT)
dt <- datatable(d, escape = F, options = list(pageLength = 50))
saveWidget(dt, file = "index.html")
