# Leer una descarga ENA

Leer una descarga ENA

## Usage

``` r
ena_leer(ruta, combinar = FALSE, ...)
```

## Arguments

- ruta:

  Directorio o archivo. Si es un directorio, lee el unico archivo de
  datos encontrado o todos cuando `combinar` es verdadero.

- combinar:

  Si es `TRUE`, apila los archivos detectados sin armonizar variables,
  codigos ni factores de expansion.

- ...:

  Argumentos para
  [`ena_importar()`](https://paulesantos.github.io/enaPeruR/reference/ena_importar.md).

## Value

Un `data.frame` o una lista de ellos.
