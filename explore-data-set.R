library(dplyr)
library(tidyr)
library(reshape2)
library(ggplot2)
library(coefplot)
library(scales)

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

econCor <- economics[, c(2:6)] %>% cor
econCorMelt <- econCor %>% melt(varnames=c("x", "y"),value.name="Correlation") 
candidates <- econCorMelt %>% filter(x != y & abs(Correlation) > 0.6) %>% arrange(Correlation)

ggplot(econCorMelt, aes(x=x, y=y)) + 
  geom_tile(aes(fill=Correlation, label=Correlation)) +
  geom_text(label = round(econCorMelt$Correlation, 2)) +
  scale_fill_gradient2(low=muted("red"), 
                       mid="white", 
                       high="steelblue",
                       guide=guide_colorbar(ticks=FALSE, barheight=10),
                       limits=c(-1, 1)
                       ) +
  theme_minimal() +
  labs(x=NULL, y=NULL)