library(dplyr)
library(tidyr)
library(plotly)
library(crosstalk)
library(htmltools)

# 1st preference votes for candidates for the House for each electorate
aec13 <- as.data.frame(eechidna::aec2013_fp_electorate)

# TODO: fix this?
aec13$PartyNm <- ifelse(
  aec13$PartyAb %in% "LNP", "Liberal National Party of Queensland", aec13$PartyNm
)

# parties that won at least one electorate
relevantParties <- aec13 %>% 
  group_by(PartyAb) %>% 
  summarise(n = sum(ifelse(Elected == "Y", 1, 0))) %>% 
  filter(n > 0)

# filter out "irrelevant" parties
d <- semi_join(aec13, relevantParties)

# count number of electorates won
wins <- d %>%
  group_by(PartyAb, PartyNm) %>%
  summarise(nseats = sum(ifelse(Elected == "Y", 1, 0))) %>%
  arrange(nseats)

# attach list-column of the electorates won
d2 <- filter(d, Elected == "Y")
wins$Electorate <- split(d2$Electorate, d2$PartyAb)

sdBars <- SharedData$new(wins, ~Electorate, group = "A")

barChart <- sdBars %>%
  plot_ly(y = ~factor(PartyAb, levels = PartyAb), x = ~nseats) %>%
  add_bars(text = ~PartyNm, hoverinfo = "text+x", color = I("black")) %>%
  layout(
    xaxis = list(title = "Number of electorates"),
    yaxis = list(title = ""),
    barmode = "overlay"
  ) %>%
  config(collaborate = F, cloud = F, displaylogo = F) %>%
  highlight("plotly_click", persistent = TRUE, dynamic = TRUE)

dat <- eechidna::nat_data_cart %>%
  rename(Electorate = ELECT_DIV) %>%
  SharedData$new(~Electorate, group = "A")

ggMap <- ggplot() +
  geom_polygon(data = eechidna::nat_map,
               aes(x = long, y = lat, group = group),
               fill = "grey90", colour = "white") +
  geom_point(data = dat, alpha = 0.5,
             aes(x, y, text = Electorate)) +
  ggthemes::theme_map() +
  theme(legend.position = "none")

mapRatio <- with(eechidna::nat_map, diff(range(long)) / diff(range(lat)))
map <- ggMap %>% 
  ggplotly(tooltip = "text", height = 400, width = 400 * mapRatio) %>% 
  style(hoverinfo = "none", traces = 1) %>%
  highlight(persistent = TRUE)

html <- tags$div(
  style = "display: flex; flex-wrap: wrap",
  tags$div(barChart, style = "width: 30%"),
  tags$div(map, style = "width: 50%")
)

# opens in an interactive session
res <- html_print(html)

file.copy(
  dir(dirname(res), full.names = TRUE), 
  "20161212a/eechidna", 
  overwrite = T, recursive = T
)
