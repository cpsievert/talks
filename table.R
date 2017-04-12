library(dplyr)
library(tibble)
library(DT)

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
d <- bind_rows(lapply(talks, get_yaml))

# add links to talks in title column
links <- sprintf("http://cpsievert.github.io/talks/%s", talks)
d$title <- sprintf('<a href="%s">%s</a>', links, d$title)

# other talks that are located elsewhere
dalt <- tibble(
  title = "<a href='https://bit.ly/plotcon17-webinar'> News and updates surrounding plotly for R </a>",
  venue = "The internet",
  type = "webinar",
  recording = "TBA",
  date = "20170412"
)

d <- bind_rows(d, dalt)

d %>%
  mutate(date = as.Date(date, format = "%Y%m%d")) %>%
  arrange(desc(date)) %>%
  datatable(escape = F, options = list(pageLength = 50)) %>%
  saveWidget(file = "index.html")

