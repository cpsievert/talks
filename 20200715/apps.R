load_all("../bslib"); load_all("../shiny"); load_all("../DT")

shinyOptions(bslib = TRUE)

bs_theme_new()
bs_theme_add(rules = "label { font-weight: 700} ")
bs_theme_preview(with_themer = FALSE)

bs_theme_new(bootswatch = "flatly") 
bs_theme_add(rules = "label { font-weight: 700} ")
bs_theme_preview(with_themer = FALSE)

bs_theme_new(bootswatch = "darkly") 
bs_theme_add(rules = "label { font-weight: 700} ")
bs_theme_preview(with_themer = FALSE)

bs_theme_new(bootswatch = "superhero")
#bs_theme_new()
bs_theme_base_colors("#2B3E51", "white")
bs_theme_accent_colors("#DF6919")
bs_theme_add(rules = "label { font-weight: 700} ")
bs_theme_preview(with_themer = FALSE)

load_all("../bslib"); load_all("../shiny"); load_all("../DT")
shinyOptions(bslib = TRUE)
bs_theme_new()
bs_theme_base_colors(bg = "#002B36", fg = "#EEE8D5")
bs_theme_accent_colors(primary = "#2AA198")
bs_theme_fonts("Fira Code")
thematic::thematic_shiny()
bs_theme_preview(with_themer = FALSE)


bs_theme_new(bootswatch = "sketchy")
#bs_theme_base_colors(bg = "#002B36", fg = "#EEE8D5")
#bs_theme_accent_colors(primary = "#2AA198")
bs_theme_add(rules = "label { font-weight: 700} ")
bs_theme_preview(with_themer = FALSE)




bs_theme_new(); bs_theme_preview()
