# Genera el conjunto didáctico incluido en data/ena_cusco_2024.rda.
# Fuente: INEI, ENA 2024, módulo 1911 (características del productor/a).
# Se excluyen identificadores de productor, segmento, provincia y distrito.

url <- "https://proyectos.inei.gob.pe/iinei/srienaho/descarga/CSV/973-Modulo1911.zip"
library(data.table)
archivo_zip <- tempfile(fileext = ".zip")
directorio <- tempfile("ena_2024_")
dir.create(directorio)
utils::download.file(url, archivo_zip, mode = "wb", quiet = TRUE)
utils::unzip(archivo_zip, exdir = directorio)

archivo_csv <- list.files(directorio, pattern = "19_CAP1100\\.csv$", recursive = TRUE, full.names = TRUE)
stopifnot(length(archivo_csv) == 1L)
ena_2024 <- data.table::fread(archivo_csv, encoding = "UTF-8")

columnas <- c(
  "ANIO", "NOMBREDD", "REGION", "FACTOR_PRODUCTOR", "CODIGO",
  "P142_1", "P142_2", "P142_3", "P1100", "P1102", "P1103", "P1104_A",
  "P1104_B", "P1112", "P1105", "P1106", "P1107", "P1107B", "P1108_1",
  "P1108_2", "P1108_3", "P1108_4", "P1108_5", "P1108_6", "P1109", "OMICAP1100"
)

# Muestra fija, no diseñada para inferencia: solo para ejemplos reproducibles.
set.seed(2024)
ena_cusco_2024 <- ena_2024[CCDD == 8L, ..columnas]
ena_cusco_2024 <- ena_cusco_2024[sample(.N, size = min(250L, .N))]
data.table::setnames(ena_cusco_2024, c("NOMBREDD", "FACTOR_PRODUCTOR", "P1104_A"),
                     c("departamento", "factor_productor", "edad"))
ena_cusco_2024 <- as.data.frame(ena_cusco_2024)

save(ena_cusco_2024, file = "data/ena_cusco_2024.rda", compress = "xz", version = 2)
