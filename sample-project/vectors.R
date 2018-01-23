library(tidyverse)


oneToTen <- 1:10
thousands <- 1:9 * 1000

oneToSix <- 1:6
oneOrHundred <- c(1,100)

# functions like vectors
thing <- oneToSix * oneOrHundred
c(2,2.00000000001,2.1) %>% near(2)
c(1,NA) %>% is.finite()

tenToThousand <- 1:100 *10
tenToThousand[3:5]
tenToThousand[66]
tenToThousand[c(2,3,8)]
tenToThousand[tenToThousand %% 3 == 0]

x <- c(-5,-4,-1,NA,0,1,4,5)
x[x <= 1]
