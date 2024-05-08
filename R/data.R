#' GeoJSON Dataset
#'
#' This dataset contains spatial data in GeoJSON format.
#'
#' @format A data frame with 11 observations and 6 variables:
#' \describe{
#'   \item{\code{FID}}{Feature ID.}
#'   \item{\code{Shape_Leng}}{Length of the shape.}
#'   \item{\code{Shape_Area}}{Area of the shape.}
#'   \item{\code{tile_id}}{Tile ID for naming.}
#'   \item{\code{descr}}{Description field.}
#'   \item{\code{geometry}}{Geometry column.}
#' }
#' @source Test data provided with the package.
#' @export
gj_data <- sf::st_read(system.file("testdata", "test_gjson_polygon.geojson", package = "shape2kml"))

#' KML Dataset
#'
#' This dataset contains spatial data in KML format.
#'
#' @format A data frame with 11 observations and 3 variables:
#' \describe{
#'   \item{\code{Name}}{Name of the feature.}
#'   \item{\code{Description}}{Description of the feature.}
#'   \item{\code{geometry}}{Geometry column.}
#' }
#' @source Test data comes with the packages.
#' @export
km_data <- sf::st_read(system.file("testdata", "test_kml_polygon.kml", package = "shape2kml"))

#' Shapefile Dataset
#'
#' This dataset contains spatial data in Shapefile format.
#'
#' @format A data frame with 11 observations and 5 variables:
#' \describe{
#'   \item{\code{Shape_Leng}}{Length of the shape.}
#'   \item{\code{Shape_Area}}{Area of the shape.}
#'   \item{\code{tile_id}}{Tile ID for naming.}
#'   \item{\code{descr}}{Description field.}
#'   \item{\code{geometry}}{Geometry column.}
#' }
#' @source Test Shapefile data
#' @export
sh_data <- sf::st_read(system.file("testdata", "test_fish_polygon.shp", package = "shape2kml"))
