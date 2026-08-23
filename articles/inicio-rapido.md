# Inicio rápido con enaPeruR

`enaPeruR` facilita la organización y tabulación reproducible de
microdatos de la Encuesta Nacional Agropecuaria (ENA).

## Qué hace el paquete

El paquete descarga y lee archivos ENA, los apila, valida pesos y
produce tablas ponderadas descriptivas. El apilado conserva las columnas
disponibles y el origen de cada archivo; no armoniza cuestionarios,
códigos, factores de expansión ni cambios de cobertura. Consulte la guía
de comparabilidad antes de combinar años.

``` r

library(enaPeruR)
ena_catalogo(2022:2025)
#>   anio disponible           marco             componente
#> 1 2022       TRUE IV CENAGRO 2012 Unidades agropecuarias
#> 2 2023       TRUE     MMM MIDAGRI          Áreas y lista
#> 3 2024       TRUE     MMM MIDAGRI          Áreas y lista
#> 4 2025       TRUE     MMM MIDAGRI          Áreas y lista
#>   comparable_con_2014_2022
#> 1                     TRUE
#> 2                    FALSE
#> 3                    FALSE
#> 4                    FALSE
ena_marco(2023)
#> $anio
#> [1] 2023
#> 
#> $marco
#> [1] "MMM MIDAGRI"
#> 
#> $componente
#> [1] "Áreas y lista"
#> 
#> $disponible
#> [1] TRUE
#> 
#> $advertencia
#> [1] "Desde 2023 cambió el marco muestral; no trate la serie como homogénea sin armonización."
```

## Descargar, leer y preparar

El portal del INEI puede requerir registro. Copie la URL del archivo
autorizado desde el portal oficial y pásela a
[`ena_descargar()`](https://paulesantos.github.io/enaPeruR/reference/ena_descargar.md).
No guarde credenciales en scripts ni paquetes.

``` r

ruta <- ena_descargar("https://proyectos.inei.gob.pe/.../ENA_2025.zip", "datos")
datos <- ena_leer(ruta, combinar = TRUE)
```

## Datos incluidos y tabulación

El paquete trae una muestra real, fija y anonimizada de 250 productores
de Cusco. Se usa exclusivamente para mostrar la interfaz: no es una
muestra diseñada para estimar indicadores oficiales.

``` r

data("ena_cusco_2024", package = "enaPeruR", envir = environment())
if (!exists("ena_cusco_2024")) {
  candidatos <- c(
    file.path("data", "ena_cusco_2024.rda"),
    file.path("..", "data", "ena_cusco_2024.rda")
  )
  archivo_datos <- candidatos[file.exists(candidatos)][1L]
  if (is.na(archivo_datos)) stop("No se encontró data/ena_cusco_2024.rda.")
  load(archivo_datos, envir = environment())
}

ena_validar(ena_cusco_2024, pesos = "factor_productor")
#> $valido
#> [1] TRUE
#> 
#> $problemas
#> character(0)
#> 
#> $n
#> [1] 250
ena_estimar_media(ena_cusco_2024, "edad", "factor_productor")
#>   n_muestra suma_pesos    media
#> 1       249   36040.03 41.21918
ena_estimar_proporcion(ena_cusco_2024, "P1103", "factor_productor", porcentaje = TRUE)
#>   P1103 n_muestra poblacion proporcion
#> 1     1       121  16253.97    44.9024
#> 2     2       129  19944.47    55.0976
```

`P1103` conserva el código original del cuestionario. Consulte el
diccionario del módulo antes de asignar una interpretación sustantiva a
sus categorías.
