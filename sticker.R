library(ggplot2)
library(showtext)
library(hexSticker)
library(magick)

p <- magick::image_read('bears-analytics/www/bear-logo.jpg')
q <- magick::image_read('bears-analytics/www/logo.png')
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
             p_y = 0.5,
             p_size=2.3,
             s_x=1,
             s_y=1.1,
             s_width=3,
             s_height=3,
             h_fill = '#2C3E92', #3C3783
             h_color = 'Black', ##1E1960
             # url ='Analytics',
             # u_x = 1.07,
             # u_y = 0.16,
             # u_family = "nerd",
             # u_size = 2,
             # u_color = 'White',
             filename="Bears Analytics.png",
             white_around_sticker = TRUE,
             dpi = 1000
             )

t2 <- sticker(q, 
             package="BEARS\nANALYTICS",
             p_family = "nerd",
             p_color = '#99B9E0',
             p_x = 1.05,
             p_y = 0.46,
             p_size=2.3,
             s_x=1,
             s_y=1.17,
             s_width=1.5,
             s_height=1.5,
             h_fill = '#2C3E92', #3C3783
             h_color = 'Black', ##1E1960
             # url ='Analytics',
             # u_x = 1.07,
             # u_y = 0.16,
             # u_family = "nerd",
             # u_size = 2,
             # u_color = 'White',
             filename="Bears Analytics 2.png",
             dpi = 1000
)

t3 <- sticker(q, 
              package="",
              p_family = "nerd",
              p_color = '#99B9E0',
              p_x = 1.05,
              p_y = 0.5,
              p_size=2.3,
              s_x=0.97,
              s_y=1.03,
              s_width=1.5,
              s_height=1.5,
              h_fill = '#2C3E92', #3C3783
              h_color = 'Black', ##1E1960
              url ='    BEARS\nANALYTICS',
              u_x = 1.13,
              u_y = 0.26,
              u_family = "nerd",
              u_size = 2,
              u_color = '#99B9E0',
              filename="Bears Analytics 3.png",
              dpi = 1000
)

plot(t1)
plot(t2)
plot(t3)

