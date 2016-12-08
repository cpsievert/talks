library(tourr)
library(plotly)

set.seed(100)

d <- county_data %>%
  select(Clinton:Trump)#, TotalVotes, Population, Area)
mat <- rescale(as.matrix(d))
tour <- new_tour(mat, grand_tour(), NULL)

tour_dat <- function(step_size) {
  step <- tour(step_size)
  proj <- center(mat %*% step$proj)
  data.frame(x = proj[,1], y = proj[,2], 
             ID = county_data$ID)
}

proj_dat <- function(step_size) {
  step <- tour(step_size)
  data.frame(
    x = step$proj[,1], y = step$proj[,2], measure = colnames(mat)
  )
}

steps <- c(0, rep(1/15, 500))
stepz <- cumsum(steps)

# tidy version of tour data
tour_dats <- lapply(steps, tour_dat)
tour_datz <- Map(function(x, y) cbind(x, step = y), tour_dats, stepz)
tour_dat <- dplyr::bind_rows(tour_datz)

# tidy version of tour projection data
proj_dats <- lapply(steps, proj_dat)
proj_datz <- Map(function(x, y) cbind(x, step = y), proj_dats, stepz)
proj_dat <- dplyr::bind_rows(proj_datz)


ax <- list(
  title = "",
  range = c(-1, 1),
  zeroline = FALSE,
  showgrid = FALSE,
  showticklabels = FALSE
)

# for nicely formatted slider labels
options(digits = 2)

pts <- tour_dat %>%
  plot_ly(x = ~x, y = ~y, frame = ~step, color = I("black"), showlegend = FALSE) %>%
  add_trace(type = "pointcloud", mode = "markers", text = ~ID, hoverinfo = "text") %>%
  layout(xaxis = ax, yaxis = ax)

axes <- proj_dat %>%
  plot_ly(x = ~x, y = ~y, frame = ~step, color = I("black")) %>%
  add_segments(xend = 0, yend = 0, color = ~measure) %>%
  # https://github.com/plotly/plotly.js/issues/130
  #add_trace(type = "scattergl", mode = "text", text = ~measure) %>%
  toWebGL() %>%
  layout(xaxis = ax, yaxis = ax)
  
  
subplot(pts, axes) %>%
  animation_opts(33, 33)
