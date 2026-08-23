#' Combinar bases ENA de manera segura
#'
#' Agrega una columna de origen antes de apilar tablas con columnas distintas.
#'
#' @param datos Lista de `data.frame` o varios `data.frame`.
#' @param id_origen Nombre de la columna que identifica la fuente.
#' @return Un `data.frame` combinado.
#' @export
ena_combinar <- function(datos, id_origen = "origen") {
  if (!is.list(datos) || inherits(datos, "data.frame")) datos <- list(datos)
  if (!length(datos) || !all(vapply(datos, inherits, logical(1), what = "data.frame"))) {
    rlang::abort("`datos` debe ser una lista no vac\u00eda de data.frames.")
  }
  nombres <- names(datos)
  if (is.null(nombres) || any(!nzchar(nombres))) nombres <- as.character(seq_along(datos))
  datos <- Map(function(x, nombre) { x[[id_origen]] <- nombre; x }, datos, nombres)
  data.table::rbindlist(datos, fill = TRUE, use.names = TRUE)
}

#' Validar una base ENA antes del analisis
#'
#' Revisa nombres duplicados, observaciones, pesos y estratos. Los pesos deben
#' ser numericos, finitos y estrictamente positivos. La funcion no modifica los
#' datos y devuelve un informe que puede guardarse junto al analisis.
#'
#' @param datos Base de datos a evaluar.
#' @param pesos Nombre opcional de la variable de ponderacion.
#' @param estratos Nombre opcional de la variable de estratificacion.
#' @param conglomerados Nombre opcional de la variable de conglomerado.
#' @param estricto Si es `TRUE`, convierte advertencias de calidad en errores.
#' @return Una lista con `valido`, `problemas` y `n`.
#' @export
ena_validar <- function(datos, pesos = NULL, estratos = NULL, conglomerados = NULL, estricto = FALSE) {
  if (!inherits(datos, "data.frame")) rlang::abort("`datos` debe ser un data.frame.")
  problemas <- character()
  if (!nrow(datos)) problemas <- c(problemas, "La base no tiene observaciones.")
  if (anyDuplicated(names(datos))) problemas <- c(problemas, "Hay nombres de columnas duplicados.")
  for (variable in c(pesos, estratos, conglomerados)) {
    if (!is.null(variable) && (!is.character(variable) || length(variable) != 1L || !variable %in% names(datos))) {
      problemas <- c(problemas, sprintf("No existe la variable requerida: %s.", variable))
    }
  }
  if (!is.null(pesos) && pesos %in% names(datos)) {
    p <- datos[[pesos]]
    if (!is.numeric(p) || any(!is.finite(p), na.rm = TRUE) || any(p <= 0, na.rm = TRUE)) {
      problemas <- c(problemas, "Los pesos deben ser num\u00e9ricos, finitos y positivos.")
    }
    if (all(is.na(p))) problemas <- c(problemas, "Todos los pesos son ausentes.")
  }
  salida <- list(valido = !length(problemas), problemas = problemas, n = nrow(datos))
  if (estricto && length(problemas)) rlang::abort(paste(problemas, collapse = " "))
  salida
}

#' Construir especificacion de diseno muestral ENA
#'
#' Esta funcion verifica y estandariza los nombres necesarios para analisis
#' ponderados. No estima varianzas complejas: para inferencia con errores
#' estandar se deben verificar las variables de diseno del anio y usar un
#' paquete especializado conforme a la ficha tecnica correspondiente.
#'
#' @param datos Base ENA.
#' @param pesos Variable de ponderacion.
#' @param estratos Variable de estrato, si existe.
#' @param conglomerados Variable de conglomerado, si existe.
#' @return Un objeto de clase `ena_diseno`.
#' @export
ena_diseno <- function(datos, pesos, estratos = NULL, conglomerados = NULL) {
  ena_validar(datos, pesos, estratos, conglomerados, estricto = TRUE)
  structure(list(datos = datos, pesos = pesos, estratos = estratos, conglomerados = conglomerados), class = "ena_diseno")
}

.ena_datos_pesos <- function(datos, pesos) {
  if (inherits(datos, "ena_diseno")) {
    if (missing(pesos)) pesos <- datos$pesos
    datos <- datos$datos
  }
  if (missing(pesos) || is.null(pesos)) rlang::abort("Indique `pesos` o use `ena_diseno()`.")
  ena_validar(datos, pesos, estricto = TRUE)
  list(datos = datos, pesos = pesos)
}

#' Estimar una media ponderada
#'
#' Calcula la media descriptiva ponderada, opcionalmente por dominios. El
#' resultado no incluye error estandar porque este depende del diseno muestral
#' especifico de cada anio ENA.
#'
#' @param datos Un `data.frame` o un objeto de [ena_diseno()].
#' @param variable Variable numerica.
#' @param pesos Variable de ponderacion si `datos` no es `ena_diseno`.
#' @param por Vector opcional de dominios.
#' @return Un `data.frame` con tamano muestral, suma de pesos y media.
#' @export
ena_estimar_media <- function(datos, variable, pesos, por = NULL) {
  x <- .ena_datos_pesos(datos, pesos)
  if (!variable %in% names(x$datos) || !is.numeric(x$datos[[variable]])) rlang::abort("`variable` debe ser una columna num\u00e9rica.")
  if (!is.null(por) && !all(por %in% names(x$datos))) rlang::abort("Alg\u00fan dominio de `por` no existe.")
  dt <- data.table::as.data.table(x$datos)
  dt[, `:=`(.ena_valor = as.numeric(.SD[[1L]]), .ena_peso = as.numeric(.SD[[2L]])), .SDcols = c(variable, x$pesos)]
  dt <- dt[is.finite(.ena_valor) & is.finite(.ena_peso)]
  resultado <- dt[, list(n_muestra = .N, suma_pesos = sum(.ena_peso), media = stats::weighted.mean(.ena_valor, .ena_peso)), by = por]
  as.data.frame(resultado)
}

#' Estimar proporciones ponderadas
#'
#' Calcula frecuencias muestrales, poblacion expandida y proporciones
#' ponderadas para una variable categorica.
#'
#' @inheritParams ena_estimar_media
#' @param porcentaje Si es `TRUE`, expresa la proporcion en porcentaje.
#' @return Un `data.frame` ordenado por dominio y categoria.
#' @export
ena_estimar_proporcion <- function(datos, variable, pesos, por = NULL, porcentaje = FALSE) {
  x <- .ena_datos_pesos(datos, pesos)
  if (!variable %in% names(x$datos)) rlang::abort("`variable` no existe.")
  if (!is.null(por) && !all(por %in% names(x$datos))) rlang::abort("Alg\u00fan dominio de `por` no existe.")
  dt <- data.table::as.data.table(x$datos)
  dt[, `:=`(.ena_categoria = as.character(.SD[[1L]]), .ena_peso = as.numeric(.SD[[2L]])), .SDcols = c(variable, x$pesos)]
  dt <- dt[!is.na(.ena_categoria) & is.finite(.ena_peso)]
  grupos <- c(por, ".ena_categoria")
  salida <- dt[, list(n_muestra = .N, poblacion = sum(.ena_peso)), by = grupos]
  if (is.null(por) || !length(por)) {
    total_global <- sum(dt$.ena_peso)
    salida[, total := total_global]
  } else {
    totales <- dt[, list(total = sum(.ena_peso)), by = por]
    salida <- merge(salida, totales, by = por, all.x = TRUE, sort = FALSE)
  }
  salida[, proporcion := poblacion / total * if (porcentaje) 100 else 1]
  salida[, total := NULL]
  data.table::setnames(salida, ".ena_categoria", variable)
  as.data.frame(salida)
}
