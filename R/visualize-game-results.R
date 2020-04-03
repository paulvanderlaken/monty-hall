
source('R/simulate-game.R')

# install.packages('ggplot2')
library(ggplot2)

# set the seed here
# do not set the `seed` parameter in `simulate_game()`,
# as this will make the function return `n_games` times the same results
seed = 1

# pick number of games you want to simulate
n_games = 1000

# simulate the games and store the boolean results
results_without_switching = simulate_n_games(n = n_games, seed = seed, make_switch = FALSE)
results_with_switching = simulate_n_games(n = n_games, seed = seed, make_switch = TRUE)

# store the cumulative wins in a dataframe
results = data.frame(
  game = seq_len(n_games),
  cumulative_wins_without_switching = cumsum(results_without_switching),
  cumulative_wins_with_switching = cumsum(results_with_switching)
)

# function that turns values into nice percentages
format_percentage = function(values) {
  return(paste0(formatC(mean(values) * 100, digits = 1, format = 'f'), '%'))
}

# generate a title based on the results of the simulations
title = paste(
  paste0('Switching doors wins you ', sum(results_with_switching), ' of ', n_games, ' games (', format_percentage(mean(results_with_switching)), ')'),
  paste0('as opposed to only ', sum(results_without_switching), ' games (', format_percentage(mean(results_without_switching)), ') when not switching)'),
  sep = '\n'
)

# set some basic plotting parameters
linesize = 1 # size of the plotted lines
x_breaks = y_breaks = seq(from = 0, to = n_games, length.out = 10 + 1) # breaks of the axes
y_limits = c(0, n_games) # limits of the y axis - makes y limits match x limits
w = 8 # width for saving plot
h = 5 # height for saving plot
palette = setNames(c('blue', 'red'), nm = c('switching', 'without switching')) # make a named color scheme

# make a line plot of the cumulative wins with and without switching
ggplot(data = results) +
  geom_line(aes(x = game, y = cumulative_wins_with_switching, col = names(palette[1])), size = linesize) +
  geom_line(aes(x = game, y = cumulative_wins_without_switching, col = names(palette[2])), size = linesize) +
  scale_x_continuous(breaks = x_breaks) +
  scale_y_continuous(breaks = y_breaks, limits = y_limits) +
  scale_color_manual(values = palette) +
  theme_minimal() +
  theme(legend.position = c(1, 1), legend.justification = c(1, 1), legend.background = element_rect(fill = 'white', color = 'transparent')) +
  labs(x = 'Number of games played') +
  labs(y = 'Cumulative number of games won') +
  labs(col = NULL) +
  labs(caption = 'paulvanderlaken.com') +
  labs(title = title)

# save the plot in the output folder
# create the output folder if it does not exist yet
if (!file.exists('output')) dir.create('output', showWarnings = FALSE)
ggsave(paste0('output/monty-hall_', n_games, '_r.png'), width = w, height = h)
