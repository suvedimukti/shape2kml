#' @title Convert Polygon(s) to KML
#' @description The function transform geospatial data in ESRI shapefile, geojson and keyhold markup languages
#' files into DJI Pilot2 app accepted kml format.
#'
#' @param input_dir Path to the input file. The function is tested for ESRI shapefile, GeoJson, and google's keyhole Markup Language (KML) files
#' @param output_dir Path to the directory where the KML files will be saved.
#' @param name_field Field name containing names for each polygon.It takes base file name and row number of each polygon.
#' @param desc_field Field name containing descriptions for each polygon.
#' @param recursive Logical indicating whether to recursively search for files in sub-directories.
#' @return NULL
#' @export
#'
convert_polygon2_kml <- function(input_dir, output_dir = NULL, name_field, desc_field, recursive = FALSE) {
  # check required packages
  req_packages <- c("sf", "XML")
  pack_tobe_installed <- req_packages[!(req_packages %in% utils::installed.packages()[,"Package"])]
  if(length(pack_tobe_installed)) utils::install.packages(pack_tobe_installed)
  lapply(req_packages, function(x) library(x, character.only = TRUE))

  # check if input directory exist or not
  if (!file.exists(input_dir)) {
    stop("Input directory does not exist, please check")
  }
  # create output directory default "Output_kml", when output directory is not provided
  #
  create_output_directory <- function(input_dir, output_dir = NULL) {
    input_dir <- gsub("/$", "", input_dir)
    if (is.null(output_dir) || output_dir == "") {
      output_dir <- file.path(input_dir, "Output_kml")
    } else {
      if (!grepl("/$", output_dir)) {
        output_dir <- paste0(output_dir, "/")
      }
      output_dir <- paste0(output_dir, "Output_kml")
    }
    if (!file.exists(output_dir)) {
      dir.create(output_dir)
    }
    return(output_dir)
  }

  # check if provided field and description info are available in the data
  # I used the term field as in Arcgis columns are referred to as field, and rows as records
  #
  if (!is.character(name_field) || !is.character(desc_field)) {
    stop("Name field and description field must be character strings.")
  }

  # Function to read shapefile and convert to KML
  read_shapefile_convert_to_kml <- function(file, name_field, desc_field, output_dir) {
    # Error handling for reading shapefile
    input_file <- tryCatch(sf::st_read(file), error = function(e) {
      cat("Error reading file:", file, "\n")
      return(NULL)
    })

    if (is.null(input_file)) {
      return()
    }

    file_basename <- basename(tools::file_path_sans_ext(file))

    geom_type <- sf::st_geometry_type(input_file)
    if (!all(geom_type %in% c("POLYGON", "MULTIPOLYGON"))) {
      cat("Skipping file", file_basename, ": Only polygon files are supported as of now!\n")
      return()
    }

    if (!(name_field %in% colnames(input_file))) {
      name_field <- NULL
    }
    if (!(desc_field %in% colnames(input_file))) {
      desc_field <- NULL
    }

    crs <- sf::st_crs(input_file)
    # converting crs to wgs84, as dji accept coordinate in wgs84
    if (!is.na(crs) && crs$epsg != 4326) {
      input_file <- sf::st_transform(input_file, 4326)
    }

    for (i in seq_len(nrow(input_file))) {
      cat(sprintf("Converting polygon %d to KML\n", i))
      geom <- sf::st_geometry(input_file[i, ])
      ext <- sf::st_coordinates(sf::st_cast(geom, "MULTILINESTRING"))
      num_cols <- ncol(ext)

      if (num_cols > 2) {
        coordinates <- paste(ext[, 1], ext[, 2], ext[,3], sep = ",")
      } else {
        coordinates <- paste(ext[, 1], ext[, 2],  sep = ",")
      }
      # This portion is hard coded for better indentation
      # feel free to improve on this.
      #------------------------------------------------------#
      kml_content <- paste(
        "    <Document id=\"", i, "\">\n",
        "        <Placemark id=\"", i, "\">\n",
        "            <name>", ifelse(is.null(name_field), i, input_file[i, name_field]), "</name>\n",
        "            <description>", ifelse(is.null(desc_field), "", input_file[i, desc_field]), "</description>\n",
        "            <Polygon id=\"", i, "\">\n",
        "                <outerBoundaryIs>\n",
        "                    <LinearRing id=\"", i, "\">\n",
        "                        <coordinates>", paste(coordinates, collapse = " "), "</coordinates>\n",
        "                    </LinearRing>\n",
        "                </outerBoundaryIs>\n",
        "            </Polygon>\n",
        "        </Placemark>\n",
        "    </Document>\n",
        "</kml>\n"
      )

      if (grepl("/$", output_dir)) {
        kml_file <- paste0(output_dir, file_basename, "_", ifelse(is.null(name_field), i, input_file[i, name_field]), ".kml")
      } else {
        kml_file <- file.path(output_dir, paste0(file_basename, "_", ifelse(is.null(name_field), i, input_file[i, name_field]), ".kml"))
      }

      kml_content_lines <- strsplit(paste0(
        "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
        "<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\">","\n",
        kml_content
      ), "\n")[[1]]

      writeLines(kml_content_lines, kml_file)
    }

    cat("File", file_basename, "converted to KML.\n")
  }

  # define filetype pattern
  file_pattern <- "\\.shp$|\\.geojson$|\\.kml$"

  files <- list.files(input_dir, pattern = file_pattern, recursive = recursive, full.names = TRUE)

  if (length(files) == 0) {
    cat("No shapefiles found in the specified directory.\n")
    return()
  }

  output_dir <- create_output_directory(input_dir, output_dir)

  cat("The following files were found in the input directory:\n")
  cat(files, "\n\n")

  # Now,read, extract, transform and export
  cat("Transforming file geometries to KML...\n\n")
  for (file in files) {
    read_shapefile_convert_to_kml(file, name_field, desc_field, output_dir)
  }

  cat("Request completed, please check output\n")
}
