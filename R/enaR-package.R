#' enaPeruR: microdatos de la Encuesta Nacional Agropecuaria
#'
#' Infraestructura reproducible para trabajar con los microdatos ENA del INEI.
#' La cobertura incluida es 2014--2025. Antes de unir periodos, consulte
#' [ena_marco()] y documente el tratamiento de la ruptura metodologica de 2023.
#'
#' @import data.table
#' @keywords internal
"_PACKAGE"

utils::globalVariables(c(".ena_categoria", ".ena_peso", ".ena_valor", "poblacion", "proporcion", "total"))
