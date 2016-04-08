library(dplyr)
library(tidyr)
library(reshape2)
library(ggplot2)
library(coefplot)

head(economics)

ggplot(data=economics) + geom_point(aes(x=date, y=pop))
ggplot(data=economics) + geom_point(aes(x=date, y=psavert))
ggplot(data=economics) + geom_point(aes(x=date, y=pce))

GGally::ggpairs(economics[,c(2:6)])

GGally::ggpairs(economics[,c(1,2)])
GGally::ggpairs(economics[,c(1,3)])
GGally::ggpairs(economics[,c(1,4)])
GGally::ggpairs(economics[,c(1,5)])
GGally::ggpairs(economics[,c(1,6)])

econCor <- economics[, c(2, 4:6)] %>% cor
econCorMelt <- econCor %>% melt(varnames=c("x", "y"),value.name="Correlation")

econCorMeltHigh <- econCorMelt %>% filter(x != y & Correlation>0.65)
