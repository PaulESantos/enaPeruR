#' enaPeruR: microdatos de la Encuesta Nacional Agropecuaria
#'
#' Infraestructura reproducible para descargar, leer, validar, apilar y tabular
#' microdatos ENA del INEI. La cobertura incluida es 2014--2025. El paquete
#' facilita la preparacion de bases multianuales, pero no armoniza cuestionarios,
#' codigos, factores de expansion o cambios de cobertura. Antes de comparar
#' periodos, consulte [ena_catalogo()] y [ena_marco()] y documente el tratamiento
#' de la ruptura metodologica de 2023.
#'
#' @import data.table
#' @keywords internal
"_PACKAGE"

utils::globalVariables(c(".ena_categoria", ".ena_peso", ".ena_valor", "poblacion", "proporcion", "total"))
