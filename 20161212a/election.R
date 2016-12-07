# modified from http://rpubs.com/dgrtwo/county-results
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(readxl)

# download area and population info from Census
download.file("http://www2.census.gov/prod2/statcomp/usac/excel/LND01.xls", "LND01.xls")
download.file("http://www2.census.gov/prod2/statcomp/usac/excel/POP01.xls", "POP01.xls")

# according to metadata, this is Land Area in 2010 and resident population in 2010
us_county_area <- read_excel("LND01.xls") %>%
  transmute(CountyCode = as.character(as.integer(STCOU)),
            Area = LND110210D)

us_county_population <- read_excel("POP01.xls") %>%
  transmute(CountyCode = as.character(as.integer(STCOU)),
            Population = POP010210D)

election_url <- "https://raw.githubusercontent.com/Prooffreader/election_2016_data/master/data/presidential_general_election_2016_by_county.csv"
county_data <- read_csv(election_url) %>%
  group_by(CountyCode = as.character(fips)) %>%
  mutate(TotalVotes = sum(votes)) %>%
  ungroup() %>%
  mutate(name = str_replace(name, ".\\. ", "")) %>%
  filter(name %in% c("Trump", "Clinton", "Johnson", "Stein")) %>%
  transmute(County = str_replace(geo_name, " County", ""),
            State = state,
            CountyCode = as.character(fips),
            Candidate = name,
            Percent = vote_pct / 100,
            TotalVotes) %>%
  spread(Candidate, Percent, fill = 0) %>%
  inner_join(us_county_population, by = "CountyCode") %>%
  inner_join(us_county_area, by = "CountyCode") %>%
  mutate(
    County = tolower(County),
    State = tolower(State),
    ID = paste(County, State, sep = "<br />")
  )


library(plotly)
library(crosstalk)
library(htmltools)

d1 <- county_data %>%
  select(ID, Clinton:Trump, TotalVotes, Population, Area) %>%
  gather(variable, value, -ID, -Population, -TotalVotes, -Area) %>%
  mutate(variable = factor(variable, levels = c("Trump", "Clinton", "Johnson", "Stein")))

sd1 <- SharedData$new(d1, ~ID, group = "A")

p1 <- ggplot(d1, aes(x = log(Population / Area), y = value)) + 
  geom_smooth(method = "lm") + 
  geom_point(aes(text = ID, color = TotalVotes / Population), 
             alpha = 0.2, data = sd1) + 
  facet_wrap(~variable, scales = "free") + 
  labs(x = NULL, y = NULL) +
  theme_bw() +
  theme(axis.text = element_text(size = 16),
        strip.text = element_text(size = 16),
        legend.position = "none")

gg1 <- ggplotly(p1, tooltip = "text", dynamicTicks = T, 
                height = 800, width = 900) %>%
  add_annotations("log(Population / Area)", font = list(size = 20),
                  x = 0.51, y = -0.07, ax = 10, ay = -50,
                  xref = "paper", yref = "paper", showarrow = FALSE) %>%
  layout(dragmode = "zoom", margin = list(l = 55, b = 50))

# htmlwidgets::saveWidget(gg1, "votes.html")

d2 <- map_data('county') %>%
  mutate(ID = paste(subregion, region, sep = "<br />")) %>% 
  left_join(county_data)

# vars to show in the tooltip
vars <- c("subregion", "Trump", "Clinton", "Johnson", "Stein", "TotalVotes", "Population")
tmp <- Map(function(x, y) paste0(x, ": ", y), vars, d2[vars])
paster <- function(x, y) paste(x, y, sep = "<br />")
d2$txt <- Reduce(paster, tmp)

sd2 <- SharedData$new(d2, ~ID, group = "A")

p2 <- ggplot(sd2, aes(x = long, y = lat, group = group, text = txt)) + 
  geom_polygon(aes(fill = TotalVotes / Population)) + 
  coord_map() + labs(x = NULL, y = NULL) +
  ggthemes::theme_map()

gg2 <- ggplotly(
  p2, tooltip = c("text", "fill"), dynamicTicks = T, height = 400, 
  width = 400 * with(d2, diff(range(long)) / diff(range(lat)))
) %>% layout(dragmode = "zoom")

# htmlwidgets::saveWidget(gg2, "20161212a/map.html")

#browsable(tagList(gg1, gg2))
html <- tags$div(
  style = "display: flex; flex-wrap: wrap",
  tags$div(gg1, style = "width: 50%"),
  tags$div(gg2, style = "width: 50%")
)

res <- html_print(html)

# TODO: can this be done in a standalone fashion?
file.copy(
  dir(dirname(res), full.names = TRUE), 
  "20161212a/election", overwrite = T, recursive = T
)
