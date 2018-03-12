decodeWord <- function(index) {
  word <- if (index >= 3) { 
    reverse_word_index[[as.character(index - 3)]]
  }
  
  if (!is.null(word)) {
    word 
  } else {
    '?'
  }
}