## basic example to begin populating a DB with loot from R
# not for big table
#library(dplyr)
#load("massivetable.Rdata")
#x <- x %.% mutate(year = as.integer(substr(filename, 2, 5)), jday = as.integer(substr(filename, 6, 8)))
#my_db <- src_postgres()
#d <- copy_to(my_db, x, temporary = FALSE, indexes = list(c("year", "jday"), "bin_num"))

## this works, need to improve
library(dplyr)
load("massivetable.Rdata")
x <- x %>% mutate(year = as.integer(substr(filename, 2, 5)), jday = as.integer(substr(filename, 6, 8)))
my_db <- src_postgres()
con <- dbConnect(PostgreSQL())

chunk <- 100000
cnt <- seq(1, chunk)
d <- copy_to(my_db, x[cnt, ], "oc_db")

 ##dbWriteTable(my_db, as.data.frame(x[cnt, ]), "oc_db")
cnt <- cnt + chunk

while(TRUE) {
   dbWriteTable(con, "oc_db", as.data.frame(x[cnt, ]), append = TRUE)
   cnt <- cnt + chunk
   cnt <- cnt[cnt <= nrow(x)]
   if (length(cnt) == 0) break; 
}
my_db <- src_postgres()
d <- tbl(my_db, "oc_db")
##xi <- db_create_index(my_db, "oc_db", list(c("year", "jday"), "bin_num"), name = NULL, ...)

CREATE INDEX Year_day_bin ON oc_db (year, jday, bin_num);
