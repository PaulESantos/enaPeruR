# Validar una base ENA antes del analisis

Revisa nombres duplicados, observaciones, pesos y estratos. Los pesos
deben ser numericos, finitos y estrictamente positivos. La funcion no
modifica los datos y devuelve un informe que puede guardarse junto al
analisis.

## Usage

``` r
ena_validar(
  datos,
  pesos = NULL,
  estratos = NULL,
  conglomerados = NULL,
  estricto = FALSE
)
```

## Arguments

- datos:

  Base de datos a evaluar.

- pesos:

  Nombre opcional de la variable de ponderacion.

- estratos:

  Nombre opcional de la variable de estratificacion.

- conglomerados:

  Nombre opcional de la variable de conglomerado.

- estricto:

  Si es `TRUE`, convierte advertencias de calidad en errores.

## Value

Una lista con `valido`, `problemas` y `n`.
