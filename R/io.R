#' Descargar un archivo ENA desde una URL autorizada
#'
#' Comprueba que la URL pertenezca al dominio del INEI, descarga el archivo y,
#' opcionalmente, lo descomprime. El acceso al portal puede requerir registro;
#' por ello la URL se solicita explicitamente y nunca se incorporan credenciales.
#'
#' @param url URL HTTPS del archivo descargable en `proyectos.inei.gob.pe`.
#' @param destino Directorio de destino.
#' @param descomprimir Si es `TRUE`, extrae archivos ZIP.
#' @param sobrescribir Si es `TRUE`, permite sustituir un archivo existente.
#' @return La ruta del archivo descargado o del directorio extraido.
#' @export
ena_descargar <- function(url, destino = getwd(), descomprimir = TRUE, sobrescribir = FALSE) {
  if (!is.character(url) || length(url) != 1L || is.na(url) || !grepl("^https://proyectos\\.inei\\.gob\\.pe/", url)) {
    rlang::abort("`url` debe ser una URL HTTPS de proyectos.inei.gob.pe.")
  }
  dir.create(destino, recursive = TRUE, showWarnings = FALSE)
  archivo <- file.path(destino, basename(utils::URLdecode(url)))
  if (file.exists(archivo) && !sobrescribir) rlang::abort("El archivo ya existe; use `sobrescribir = TRUE`.")
  utils::download.file(url, archivo, mode = "wb", quiet = TRUE)
  if (!file.exists(archivo) || file.info(archivo)$size == 0) rlang::abort("La descarga no produjo un archivo v\u00e1lido.")
  if (descomprimir && identical(tolower(tools::file_ext(archivo)), "zip")) {
    salida <- file.path(destino, tools::file_path_sans_ext(basename(archivo)))
    dir.create(salida, recursive = TRUE, showWarnings = FALSE)
    utils::unzip(archivo, exdir = salida)
    return(normalizePath(salida, winslash = "/", mustWork = TRUE))
  }
  normalizePath(archivo, winslash = "/", mustWork = TRUE)
}

#' Encontrar archivos de datos ENA
#'
#' @param ruta Archivo o directorio de una descarga ENA.
#' @param recursivo Buscar en subdirectorios.
#' @return Un vector nombrado de rutas por extension.
#' @export
ena_archivos <- function(ruta, recursivo = TRUE) {
  if (!file.exists(ruta)) rlang::abort("`ruta` no existe.")
  if (!dir.exists(ruta)) return(normalizePath(ruta, winslash = "/", mustWork = TRUE))
  archivos <- list.files(ruta, pattern = "\\.(sav|dta|csv|rds)$", ignore.case = TRUE, full.names = TRUE, recursive = recursivo)
  if (!length(archivos)) rlang::abort("No se encontraron archivos .sav, .dta, .csv o .rds.")
  stats::setNames(normalizePath(archivos, winslash = "/", mustWork = TRUE), tolower(tools::file_ext(archivos)))
}

#' Importar un archivo ENA
#'
#' Lee SPSS, Stata, CSV o RDS y conserva etiquetas de `haven` cuando el formato
#' las provee. No recodifica ni estandariza nombres de variables entre anios.
#'
#' @param archivo Ruta a un archivo `.sav`, `.dta`, `.csv` o `.rds`.
#' @param columnas Nombres opcionales de columnas a conservar tras la lectura.
#' @return Un `data.frame`.
#' @export
ena_importar <- function(archivo, columnas = NULL) {
  if (!file.exists(archivo) || dir.exists(archivo)) rlang::abort("`archivo` debe ser un archivo existente.")
  extension <- tolower(tools::file_ext(archivo))
  datos <- switch(extension,
    sav = haven::read_sav(archivo), dta = haven::read_dta(archivo),
    csv = utils::read.csv(archivo, check.names = FALSE), rds = readRDS(archivo),
    rlang::abort("Formato no admitido: use .sav, .dta, .csv o .rds.")
  )
  if (!is.null(columnas)) {
    faltan <- setdiff(columnas, names(datos))
    if (length(faltan)) rlang::abort(paste0("Columnas ausentes: ", paste(faltan, collapse = ", "), "."))
    datos <- datos[, columnas, drop = FALSE]
  }
  as.data.frame(datos)
}

#' Leer una descarga ENA
#'
#' @param ruta Directorio o archivo. Si es un directorio, lee el unico archivo
#'   de datos encontrado o todos cuando `combinar` es verdadero.
#' @param combinar Si es `TRUE`, apila los archivos detectados sin armonizar
#'   variables, codigos ni factores de expansion.
#' @param ... Argumentos para [ena_importar()].
#' @return Un `data.frame` o una lista de ellos.
#' @export
ena_leer <- function(ruta, combinar = FALSE, ...) {
  archivos <- ena_archivos(ruta)
  datos <- lapply(unname(archivos), ena_importar, ...)
  if (length(datos) == 1L && !combinar) return(datos[[1L]])
  if (combinar) return(ena_combinar(datos, id_origen = "archivo"))
  stats::setNames(datos, basename(archivos))
}
