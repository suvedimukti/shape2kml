
<!-- README.md is generated from README.Rmd. Please edit that file -->

# shape2kml

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/shape2kml)](https://CRAN.R-project.org/package=shape2kml)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

# Geospatial Polygons to DJI compatible KML (shape2kml)

The **shape2kml** package serves a important purpose: converting
(multi)polygon data into a KML format that is compatible with DJI
drones. While **KML** or **KMZ** files exported from popular GIS
Software like ArcGIS (ESRI), QGIS (QGIS Development Team), or R (R Core
Team) may not be directly compatible with DJI drones, this package
bridges that gap.

When preparing flight plans for small Unmanned Aerial Vehicles (sUAVs),
manually digitizing polygons using Google Earth Pro (GEP) to ensure
compatibility with DJI’s pilot app can be tedious. This function
streamlines the process, making it significantly more efficient.

The **shape2kml** can process any polygon data readable by the sf
package, providing flexibility in data sources. However, at this time,
only following file types are tested and are supported; they are types
include feature classes (ESRI), shapefiles (ESRI), GeoJSON (OGC), and
KML (Google). Users can seamlessly convert spatial data from various
formats into DJI-compatible KML files, empowering smoother flight
planning and execution for drone operations. \## Installation

You can install the development version of shape2kml from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("suvedimukti/shape2kml")
```

## Load required packages

The package has three different data types

``` r
library(shape2kml)
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.3.1; sf_use_s2() is TRUE
```

## List data types: shape2kml package

``` r
# Once the package is installed, we can use system.file to locate the 
# data ".inst/testdata" that come with the package

sys_dat_path <- system.file("testdata", package = "shape2kml")

# list shape file (there is only one shapefile)
test_shp <- list.files(sys_dat_path, pattern = "\\.shp$", full.names = TRUE)

## list all data types
all_data <- list.files(sys_dat_path, full.names = FALSE)
```

## Read and plot example data

``` r
shp_dat = sf::st_read(test_shp)
#> Reading layer `test_fish_polygon' from data source 
#>   `C:\Users\suved\AppData\Local\R\win-library\4.4\shape2kml\testdata\test_fish_polygon.shp' 
#>   using driver `ESRI Shapefile'
#> Simple feature collection with 11 features and 4 fields
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 835122.6 ymin: 3760618 xmax: 835322.6 ymax: 3760768
#> Projected CRS: NAD83 / UTM zone 16N

#Plot
library(ggplot2)
gp<- ggplot2::ggplot()+
  ggplot2::geom_sf(data = shp_dat)
gp
```

<img src="man/figures/README-plot data-1.png" width="100%" />

## Convert data to DJI compatible kml file

``` r
# lets convert all data types that can be read by `sf::st_read`
shape2kml::convert_polygon2_kml(input_dir = test_shp,output_dir = "",name_field = "tile_id",desc_field = "",recursive = FALSE)
#> The following files were found in the input directory:
#> C:/Users/suved/AppData/Local/R/win-library/4.4/shape2kml/testdata/test_fish_polygon.shp 
#> 
#> Transforming file geometries to KML...
#> 
#> Reading layer `test_fish_polygon' from data source 
#>   `C:\Users\suved\AppData\Local\R\win-library\4.4\shape2kml\testdata\test_fish_polygon.shp' 
#>   using driver `ESRI Shapefile'
#> Simple feature collection with 11 features and 4 fields
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 835122.6 ymin: 3760618 xmax: 835322.6 ymax: 3760768
#> Projected CRS: NAD83 / UTM zone 16N
#> Converting polygon 1 to KML
#> Converting polygon 2 to KML
#> Converting polygon 3 to KML
#> Converting polygon 4 to KML
#> Converting polygon 5 to KML
#> Converting polygon 6 to KML
#> Converting polygon 7 to KML
#> Converting polygon 8 to KML
#> Converting polygon 9 to KML
#> Converting polygon 10 to KML
#> Converting polygon 11 to KML
#> File test_fish_polygon converted to KML.
#> Request completed, please check output
```
