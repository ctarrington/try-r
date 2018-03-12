install.packages('tidyverse')
install.packages('sparklyr')
install.packages('tensorflow')
install.packages('tfestimators')
install.packages('keras')

install.packages('nycflights13')
install.packages('Lahman')

library(sparklyr)
spark_available_versions()
spark_install(version = '2.2.1')

library(keras)
install_keras()

OR

library(tensorflow)
install_tensorflow()
