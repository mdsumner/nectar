## basic example to begin populating a DB with loot from R
library(dplyr)
load("massivetable.Rdata")
x <- x %.% mutate(year = as.integer(substr(filename, 2, 5)), jday = as.integer(substr(filename, 6, 8)))
my_db <- src_postgres()
d <- copy_to(my_db, x, temporary = FALSE, indexes = list(c("year", "jday"), "bin_num"))

