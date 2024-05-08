#' List types of data available in the package
#'
#' This function lists the types of data available in the package by examining
#' the file extensions of the test data files.
#'
#' @return A character vector listing the unique file extensions of the test data files.
#' @export
list_data_types <- function() {
  file_pattern <- "\\.shp$|\\.geojson$|\\.kml$"
  files <- list.files(path = system.file("testdata", package = "shape2kml"),
                      pattern = file_pattern,
                      full.names = FALSE)

  # Extract file extensions
  #file_types <- tools::file_ext(files)

  # Return unique file types
  unique(files)
}
