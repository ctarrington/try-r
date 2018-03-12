# assumes unique numbers on right
lookup <- list('apple' = 5, 'pear' = 4, 'pie' = 3)

reverse <- names(lookup)
names(reverse) <- lookup

lookup$apple
lookup['apple']

reverse['5']
reverse[['5']]
reverse[[as.character(5)]]

