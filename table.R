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
    "<a href='http://bit.ly/plotcon17-talk' target='_blank'> Practical tools for exploratory visualization</a>",
    "<a href='https://slides.cpsievert.me/web-graphics/murdoch/' target='_blank'> Dynamic Interactive Web Graphics for Data Analysis</a>",
    "<a href='https://slides.cpsievert.me/web-graphics/wehi' target='_blank'> Interactive and Dynamic Web-Based Statistical Graphics</a>",
    "<a href='https://slides.cpsievert.me/pitchrx/jsm15' target='_blank'> Acquiring, Visualizing, and Modeling MLB Umpire Strike/Ball Decisions with PITCHf/x Data</a>",
    "<a href='https://slides.cpsievert.me/web-graphics/jsm15' target='_blank'> Recent Advances in Interactive Graphics for Data Analysis</a>",
    "<a href='https://slides.cpsievert.me/web-scraping/20150612' target='_blank'> Web Scraping in R</a>",
    "<a href='https://slides.cpsievert.me/markdown/' target='_blank'> Dynamic documents with R, knitr & Markdown</a>",
    "<a href='https://slides.cpsievert.me/ldavis' target='_blank'> LDAVis: A Method for Visualizing and Interpreting Topics</a>",
    "<a href='https://slides.cpsievert.me/lda/0926' target='_blank'> An interactive visualization platform for interpreting topic models</a>",
    "<a href='https://slides.cpsievert.me/pitchrx/jsm/' target='_blank'> pitchRx: Tools for Collecting and Analyzing MLB PITCHf/x Data</a>",
    "Play for Pay: the Effects of 'Walk Year' Performance on MLB Free Agent Contracts",
    "A Mathematical Perspective of Voting",
    "An Application of Auction Theory to the MLB Free Agent Market"
  ),
  venue = c(
    "Plotcon 2017",
    "Murdoch Childrens Research Institute",
    "Walter and Eliza Hall Institute for Medical Research",
    "Joint Statistical Meetings",
    "Joint Statistical Meetings",
    "Great Plain R Users Group",
    "ISU Graphics Working Group",
    "Joint Statistical Meetings",
    "ISU Graphics Working Group",
    "Joint Statistical Meetings",
    "Scholarship Day Saint Joseph",
    "Pi Mu Epsilon’s National Conference at MathFest",
    "Mathematical Association of America’s MathFest"
  ),
  type = c(
    "invited",
    "invited",
    "invited",
    "invited",
    "invited",
    "invited",
    "selected",
    "selected",
    "selected",
    "selected",
    "selected",
    "selected",
    "selected"
  ),
  recording = c(
    "<a href='https://www.youtube.com/watch?v=mZd9eWt7moE' target='_blank'>here</a>",
    "none",
    "none",
    "none",
    "none",
    "none",
    "none",
    "none",
    "<a href='https://www.dropbox.com/s/datl8sshpp859sh/LDAviz.mov' target='_blank'> here</a>",
    "none",
    "none",
    "none",
    "none"
  ),
  date = c(
    "20170502",
    "20151201",
    "20150901",
    "20150801",
    "20150801",
    "20150601",
    "20131101",
    "20140801",
    "20130801",
    "20130801",
    "20100401",
    "20090801",
    "20080801"
  )
)

d <- bind_rows(dauto, dalt)

d %>%
  mutate(date = as.Date(date, format = "%Y%m%d")) %>%
  arrange(desc(date)) %>%
  select(date, title, venue, type, recording) %>%
  datatable(escape = F, options = list(pageLength = 50), rownames = FALSE) %>%
  saveWidget(file = "index.html")

