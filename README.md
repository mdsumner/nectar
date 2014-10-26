nectar
======

Scripts to set up Nectar VMs. 



### Metadata

https://support.rc.nectar.org.au/docs/metadata-interface

Get your Customization script: 

```{r,eval=FALSE}
Rscript -e "writeLines(readLines('http://169.254.169.254/1.0//user-data/'))"
```

Get all other metdata

```{r,eval=FALSE}
Rscript -e "furl <- 'http://169.254.169.254/1.0//user-data';x <- readLines(furl); for (i in seq_along(x)) {tx <- readLines(file.path(furl, x[i]));writeLines(c(x[i], '\n', tx))}"
```


