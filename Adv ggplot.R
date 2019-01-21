#ggplot 2 
library(ggplot2)
install.packages("Hmisc")
require(Hmisc) # for summary statistics component

#draw standard deviation 
mean_sdl(dataframe, multi = 1) # one sd above and beyond

ggplot(iris, aes(x = Species, y = Sepal.Length)) +
  stat_summary(fun.y = mean, geom = "point") +
  stat_summary(fun.data = mean_sdl, fun.args = list(mult = 1),
               geom = "errorbar", width = 0.1)

