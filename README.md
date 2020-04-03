# Monty Hall
My attempt at simulating the Monty Hall game show problem in both R and Python.

Both R and Python scripts follow a functional approach. 

However, in R, I actually simulated the doors and Monty Hall closing them. In Python, I took a more direct approach by inverting the initial result on players switching. This way, the R version of the code is more flexible. For instance, in case someone wants to change the number of (wrong) doors Monty Hall opens.

I visualized the cumulative wins a player would have if he/she'd consecutively play against Monty Hall.

In R, I visualized these cumulative wins using `ggplot2`. For Python, I used `matplotlib`.

![50 games of Monty Hall simulated in R](https://github.com/paulvanderlaken/monty-hall/blob/master/output/monty-hall_50_r.png)

![50 games of Monty Hall simulated in Python](https://github.com/paulvanderlaken/monty-hall/blob/master/output/monty-hall_50_python.png)
