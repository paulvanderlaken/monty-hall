#' Simulate a game of Monty Hall
#' For detailed information: https://en.wikipedia.org/wiki/Monty_Hall_problem
#' Basically, there are several closed doors and behind only one of them is a prize.
#' The player can choose one door at the start. 
#' Next, the game master (Monty Hall) opens all the other doors, but one.
#' Now, the player can stick to his/her initial choice or switch to the remaining closed door.
#' If the prize is behind the player's final choice he/she wins.
#' 
#' @param make_switch A boolean value whether the player switches after its initial choice and Monty Hall opening all other non-prize doors but one. Defaults to `FALSE`
#' @param n_doors An integer value > 2, for the number of doors behind which one prize and (n-1) non-prizes (e.g., goats) are hidden. Defaults to `3L`
#' @param seed A seed to set. Defaults to `NULL`
#'
#' @return A boolean value indicating whether the player won the prize
#'
#' @examples 
#' simulate_game()
#' simulate_game(make_switch = TRUE)
#' simulate_game(make_switch = TRUE, n_doors = 5L, seed = 1)
simulate_game = function(make_switch = FALSE, n_doors = 3L, seed = NULL) {
  
  # check the arguments
  if (!is.logical(make_switch) | is.na(make_switch)) stop("`make_switch` needs to be TRUE or FALSE")
  if (is.double(n_doors)) {
    n_doors = as.integer(n_doors)
    warning(paste("double value provided for `n_doors`: forced to integer value of", n_doors))
  }
  if (!is.integer(n_doors) | n_doors < 2) stop("`n_doors` needs to be a positive integer > 2")
  
  # if a seed was provided, set it
  if (!is.null(seed)) set.seed(seed)
  
  # create a integer vector for the door indices
  doors = seq_len(n_doors)
  
  # create a boolean vector showing which doors are opened
  # all doors are closed at the start of the game
  isClosed = rep(TRUE, length = n_doors)
  
  # sample one index for the door to hide the car behind
  prize_index = sample(doors, size = 1)
  
  # sample one index for the door initially chosen by the player
  # this can be the same door as the prize door
  choice_index = sample(doors, size = 1)
  
  # now Monty Hall opens all doors the player did not choose
  # except for one door
  # if we have already picked the prize door, the one remaining closed door has a nonprize
  # if we have not picked the prize door, the one remaining closed door has the prize
  if (prize_index == choice_index) {
    # if we have the prize, Monty Hall can open all but two doors:
    #   ours, which we remove from the options to sample from and open
    #   and one goat-conceiling door, which we do not open
    isClosed[sample(doors[-prize_index], size = n_doors - 2)] = FALSE
  } else {
    # else, Monty Hall can also open all but two doors:
    #   ours
    #   and the prize-conceiling door
    isClosed[-c(prize_index, choice_index)] = FALSE
  }
  
  # now Monty Hall asks us whether we want to make a switch
  if (make_switch) {
    # if we decide to make a switch, we can pick the closed door that is not our door
    choice_index = doors[isClosed][doors[isClosed] != choice_index]
  }
  
  # we return a boolean value showing whether the player choice is the prize door
  return(choice_index == prize_index)
}


#' Simulate N games of Monty Hall
#' Calls the `simulate_game()` function `n` times and returns a boolean vector representing the games won
#' 
#' @param n An integer value for the number of times to call the `simulate_game()` function
#' @param seed A seed to set in the outer loop. Defaults to `NULL`
#' @param ... Any parameters to be passed to the `simulate_game()` function. 
#' No seed can be passed to the simulate_game function as that would result in `n` times the same result 
#'
#' @return A boolean vector indicating for each of the games whether the player won the prize
#'
#' @examples 
#' simulate_n_games(n = 100)
#' simulate_n_games(n = 500, make_switch = TRUE)
#' simulate_n_games(n = 1000, seed = 123, make_switch = TRUE, n_doors = 5L)
simulate_n_games = function(n, seed = NULL, make_switch = FALSE, ...) {
  # round the number of iterations to an integer value
  if (is.double(n)) {
    n = as.integer(n)
  }
  if (!is.integer(n) | n < 1) stop("`n_games` needs to be a positive integer > 1")
  # if a seed was provided, set it
  if (!is.null(seed)) set.seed(seed)
  return(vapply(rep(make_switch, n), simulate_game, logical(1), ...))
}