
# shape2kml

<!-- badges: start -->
[![CRAN status](https://www.r-pkg.org/badges/version/shape2kml)](https://CRAN.R-project.org/package=shape2kml)
[![Lifecycle: stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

The **shape2kml** package serves a importnat purpose: converting (multi)polygon data into a KML format that is compatible with DJI drones. While **KML** or **KMZ** files exported from popular GIS Software like ArcGIS (ESRI), QGIS (QGIS Development TEam), or R (R Core Team) may not be directly compatible with DJI drones, this package bridges that gap.

When preparing flight plans for small Unmanned Aerial Vehicles (sUAVs), manually digitizing polygons using Google Earth Pro (GEP) to ensure compatibility with DJI's pilot app can be tedious. This function streamlines the process, making it significantly more efficient.

The **shape2kml** can process any polygon data readable by the sf package, providing flexibility in data sources. However, at this time, only following file types are tested and are supported; they are types include feature classes (ESRI), shapefiles (ESRI), GeoJSON (OGC), and KML (Google). Users can seamlessly convert spatial data from various formats into DJI-compatible KML files, empowering smoother flight planning and execution for drone operations. 

## Installation

You can install the development version of **shape2kml** from [GitHub](https://github.com/):

``` r
remotes::install_github('suvedimukti/shape2kml')
```

## Example

The package has three different data types

``` r
library(shape2kml)
file_pattern <- "\\.shp$|\\.geoson$|\\.kml$"
files        <- list.files(path = './inst/testdata/', pattern = file_pattern, full.names = FALSE)
print(files)
```

