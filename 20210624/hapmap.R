# install.packages("plotly")
library(plotly)
library(htmlwidgets)

# grab some data from manhattanly
download.file("https://github.com/sahirbhatnagar/manhattanly/raw/master/data/HapMap.rda", "HapMap.rda")
load("HapMap.rda")
str(HapMap)

vline <- function(x = 1) {
  list(
    type = "line",
    x1 = x, x0 = x, xref = "x", 
    y0 = 0, y1 = 1, yref = "paper",
    line = list(dash = "dash")
  )
}

hline <- function(y = 4) {
  list(
    type = "line", 
    y0 = y, y1 = y, yref = "y",
    x1 = 0, x0 = 1, xref = "paper",
    line = list(dash = "dash")
  )
}


p <- HapMap %>%
  mutate(P2 = -log10(P)) %>%
  plot_ly(
    x = ~EFFECTSIZE, y = ~ P2, text = ~SNP, hoverinfo = "text",
    customdata = ~paste0("https://www.ncbi.nlm.nih.gov/snp/?term=", SNP)
  ) %>%
  add_markers(color = I("black"), alpha = 0.1) %>%
  # add annotations for the upper-right quadrant
  add_fun(
    function(plot) {
      plot %>% 
        filter(EFFECTSIZE > 1 & P2 > 2) %>% 
        add_markers(color = I("red")) %>%
        add_annotations(text = ~SNP)
    }
  ) %>%
  # add annotations for the upper-left quadrant
  add_fun(
    function(plot) {
      plot %>% 
        filter(EFFECTSIZE < -1 & P2 > 2) %>%
        add_markers(color = I("blue")) %>%
        add_annotations(text = ~SNP)
    }
  ) %>%
  toWebGL() %>% # webgl renders many points much more efficiently!
  layout(
    title = "<a href='https://www.ncbi.nlm.nih.gov/snp'>Query</a> significant <a href='https://en.wikipedia.org/wiki/Single-nucleotide_polymorphism'>single nucleotide polymorphisms</a> via a <a href='https://en.wikipedia.org/wiki/Volcano_plot_(statistics)'>volcano plot</a>",
    showlegend = FALSE,
    font = list(size = 15),
    shapes = list(
      vline(-1),
      vline(1),
      hline(2)
    ),
    margin = list(t = 100),
    annotations = list(
      text = "The <a href='hapmap.R'>R code</a> uses <a href='https://www.rdocumentation.org/packages/manhattanly/versions/0.2.0/topics/HapMap'>HapMap</a> from the <b>manhattanly</b> package (Bhatnagar 2016)",
      x = 0.5,
      y = 1,
      #xshift = 10,
      yshift = 15,
      xref = "paper",
      yref = "paper",
      xanchor = "center",
      yanchor = "bottom",
      showarrow = FALSE
    ),
    xaxis = list(
      title = "Effect size",
      zeroline = FALSE
    ),
    yaxis = list(
      title = "-log(p-value)",
      zeroline = FALSE
    )
  ) %>%
  onRender("function(el, x) {
           el.on('plotly_click', function(d) {
           var pt = d.points[0];
           var url = pt.data.customdata[pt.pointNumber];
           window.open(url);
           });
           }") %>%
  config(displayModeBar = FALSE)

#unlink("HapMap.rda")
saveWidget(p, file = "hapmap.html", selfcontained = FALSE, libdir = "index_files")

