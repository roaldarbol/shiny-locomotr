library(ggplot2)
library(showtext)
library(hexSticker)
library(magick)

p <- magick::image_read('shiny-locomotr/www/dansk-atletik.jpeg')
# q <- magick::image_read('bears-analytics/www/logo.png')
# p <- image_write(p, format='png')

## Loading Google fonts (http://www.google.com/fonts)
font_add_google("Press Start 2P", "nerd")
## Automatically use showtext to render text for future devices
showtext_auto()

## use the ggplot2 example
t1 <- sticker(p, 
             package="ANALYTICS",
             p_family = "nerd",
             p_color = '#99B9E0',
             p_x = 1.05,
             p_y = 0.6,
             p_size=2.3,
             s_x=1,
             s_y=1.15,
             s_width=2.2,
             s_height=2.2,
             h_fill = '#475CC7', #3C3783
             h_color = 'Black', ##1E1960
             # url ='Analytics',
             # u_x = 1.07,
             # u_y = 0.16,
             # u_family = "nerd",
             # u_size = 2,
             # u_color = 'White',
             filename="locomotr.png",
             white_around_sticker = FALSE,
             dpi = 1000
             )

plot(t1)

