#' Consultar la cobertura historica de ENA
#'
#' Informa la cobertura conocida de la ENA y el marco muestral correspondiente.
#' Los anios 2020 y 2021 se marcan como no disponibles. El catalogo orienta la
#' preparacion de una serie; no certifica que las variables o indicadores sean
#' comparables entre anios.
#'
#' @param anios Anios a consultar. Por defecto, todos los disponibles.
#' @return Un `data.frame` con anio, disponibilidad, marco y una indicacion de
#'   comparabilidad con 2014--2022.
#' @export
ena_catalogo <- function(anios = 2014:2025) {
  anios <- as.integer(anios)
  if (anyNA(anios) || any(!anios %in% 2014:2025)) {
    rlang::abort("`anios` debe estar entre 2014 y 2025.")
  }
  data.frame(
    anio = anios,
    disponible = !(anios %in% c(2020, 2021)),
    marco = ifelse(anios <= 2022, "IV CENAGRO 2012", "MMM MIDAGRI"),
    componente = ifelse(anios <= 2022, "Unidades agropecuarias", "\u00c1reas y lista"),
    comparable_con_2014_2022 = anios <= 2022,
    stringsAsFactors = FALSE
  )
}

#' Consultar el marco muestral de un anio ENA
#'
#' Use esta funcion antes de apilar anios. El resultado es una advertencia
#' metodologica, no una transformacion ni una prueba de comparabilidad.
#'
#' @param anio Anio de referencia entre 2014 y 2025.
#' @return Una lista con metadatos del marco, incluido un aviso de
#'   comparabilidad cuando corresponde.
#' @export
ena_marco <- function(anio) {
  fila <- ena_catalogo(anio)
  list(
    anio = fila$anio,
    marco = fila$marco,
    componente = fila$componente,
    disponible = fila$disponible,
    advertencia = if (anio >= 2023) {
      "Desde 2023 cambi\u00f3 el marco muestral; no trate la serie como homog\u00e9nea sin armonizaci\u00f3n."
    } else {
      "Comparable dentro de 2014-2022, sujeto a cambios de cuestionario y cobertura."
    }
  )
}
