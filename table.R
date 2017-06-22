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
dauto <- talks %>%
  lapply(get_yaml) %>%
  bind_rows() %>%
  mutate(date = talks) %>%
  mutate(title = sprintf(
    '<a href="%s" target="_blank">%s</a>', sprintf("http://cpsievert.github.io/talks/%s", date), title
  ))

# other talks that are located elsewhere
dalt <- tibble(
  title = c(
    "<a href='http://bit.ly/plotcon17-talk' target='_blank'> Practical tools for exploratory visualization</a>"
  ),
  venue = c(
    "Plotcon 2017"
  ),
  type = c(
    "invited talk"
  ),
  recording = c(
    "<a href='https://www.youtube.com/watch?v=mZd9eWt7moE' target='_blank'>here</a>"
  ),
  date = c(
    "20170502"
  )
)

d <- bind_rows(dauto, dalt)

d %>%
  mutate(date = as.Date(date, format = "%Y%m%d")) %>%
  arrange(desc(date)) %>%
  select(date, title, venue, type, recording) %>%
  datatable(escape = F, options = list(pageLength = 50)) %>%
  saveWidget(file = "index.html")

