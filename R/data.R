#' Ejemplo ENA 2024: productores de Cusco
#'
#' Subconjunto reproducible de 250 registros de la Encuesta Nacional Agropecuaria (ENA)
#' 2024, modulo 1911: caracteristicas del productor/a agropecuario/a y su
#' familia. Procede del portal de Microdatos del INEI. Se retiraron los
#' identificadores de productor, segmento, unidad agropecuaria, provincia y
#' distrito. Esta destinado a ejemplos de codigo y no es una muestra disenada
#' para estimacion o difusion de indicadores.
#'
#' `edad` y `factor_productor` son variables listas para los ejemplos. Las
#' demas columnas `Pxxxx` son codigos sin recodificar del cuestionario; revise
#' el diccionario oficial del modulo antes de interpretarlas.
#'
#' @format Un `data.frame` de 250 filas y 26 columnas.
#' @source Instituto Nacional de Estadistica e Informatica (INEI), Encuesta
#'   Nacional Agropecuaria 2024, modulo 1911. URL de descarga:
#'   <https://proyectos.inei.gob.pe/iinei/srienaho/descarga/CSV/973-Modulo1911.zip>.
#' @examples
#' data(ena_cusco_2024)
#' ena_validar(ena_cusco_2024, pesos = "factor_productor")
#' ena_estimar_media(ena_cusco_2024, "edad", "factor_productor")
"ena_cusco_2024"
