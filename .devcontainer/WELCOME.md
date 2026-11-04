# Welcome

This codespace runs the software a [ready-made Nectar server](https://mdsumner.github.io/nectar/guide/09-ready-made-server.html)
gets: R with `sf`, `terra`, `gdalraster`, `vapour` and `sds` on a current GDAL, and Python with GDAL.

There are three ways in. Use whichever you know.

1. **JupyterLab**, which should have opened in a new browser tab, at a notebook that reads some bathymetry. If it
   didn't open (a pop-up blocker, say), open the **Ports** tab at the bottom of this window and click the globe icon
   beside **JupyterLab (RStudio inside)**.
2. **RStudio**: in JupyterLab, choose **File > New Launcher**, then **RStudio**.
3. **R here in VS Code**: open a terminal (**Terminal > New Terminal**) and type `R`. Or open a `.R` file and send
   lines to R with **Ctrl+Enter**.

Try this, in any of them:

```r
library(terra)
r <- rast(sds::gebco())
plot(crop(r, ext(147, 148, -43, -42)))
```

This codespace is temporary. It stops when idle, and is deleted after a few weeks unused, with anything saved in it.
For what to do next, see [Try it now](https://mdsumner.github.io/nectar/guide/11-try-it-now.html).
