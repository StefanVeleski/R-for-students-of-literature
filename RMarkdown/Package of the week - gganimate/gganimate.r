library(gganimate)
library(gapminder)
library(gifski)

ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, colour = country)) +
  geom_point(alpha = 0.7, show.legend = FALSE) +
  scale_colour_manual(values = country_colors) +
  scale_size(range = c(2, 12)) +
  scale_x_log10() +
  facet_wrap(~continent) +
  # What follows is specific for the gganimate package
  labs(title = 'Year: {frame_time}', x = 'GDP per capita', y = 'life expectancy') +
  transition_time(year) +
  ease_aes('linear')

anim_save("GDP.gif", animation = last_animation(), path = "C:/Users/Stefan/OneDrive - MUNI/Github/R-for-students-of-literature")