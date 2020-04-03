import random


def simulate_game(make_switch=False, n_doors=3, seed=None):
    ''' 
    Simulate a game of Monty Hall
    For detailed information: https://en.wikipedia.org/wiki/Monty_Hall_problem
    Basically, there are several closed doors and behind only one of them is a prize.
    The player can choose one door at the start. 
    Next, the game master (Monty Hall) opens all the other doors, but one.
    Now, the player can stick to his/her initial choice or switch to the remaining closed door.
    If the prize is behind the player's final choice he/she wins.

    Keyword arguments:
    make_switch -- a boolean value whether the player switches after its initial choice and Monty Hall opening all other non-prize doors but one (default False)
    n_doors -- an integer value > 2, for the number of doors behind which one prize and (n-1) non-prizes (e.g., goats) are hidden (default 3)
    seed -- a seed to set (default None)
    '''

    # check the arguments
    if type(make_switch) is not bool:
        raise TypeError("`make_switch` must be boolean")
    if type(n_doors) is float:
        n_doors = int(n_doors)
        raise Warning("float value provided for `n_doors`: forced to integer value of", n_doors)
    if type(n_doors) is not int:
        raise TypeError("`n_doors` needs to be a positive integer > 2")
    if n_doors < 2:
        raise ValueError("`n_doors` needs to be a positive integer > 2")

    # if a seed was provided, set it
    if seed is not None:
        random.seed(seed)

    # sample one index for the door to hide the car behind
    prize_index = random.randint(0, n_doors - 1)

    # sample one index for the door initially chosen by the player
    choice_index = random.randint(0, n_doors - 1)

    # we can test for the current result
    current_result = prize_index == choice_index

    # now Monty Hall opens all doors the player did not choose, except for one door
    # next, he asks the player if he/she wants to make a switch
    if (make_switch):
        # if we do, we change to the one remaining door, which inverts our current choice
        # if we had already picked the prize door, the one remaining closed door has a nonprize
        # if we had not already picked the prize door, the one remaining closed door has the prize
        return not current_result
    else:
        # the player sticks with his/her original door,
        # which may or may not be the prize door
        return current_result
