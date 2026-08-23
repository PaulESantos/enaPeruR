# Estimar proporciones ponderadas

Calcula frecuencias muestrales, poblacion expandida y proporciones
ponderadas para una variable categorica. Puede aplicarse a una base
multianual ya armonizada; no calcula varianza de diseno ni inferencia.

## Usage

``` r
ena_estimar_proporcion(datos, variable, pesos, por = NULL, porcentaje = FALSE)
```

## Arguments

- datos:

  Un `data.frame` o un objeto de
  [`ena_diseno()`](https://paulesantos.github.io/enaPeruR/reference/ena_diseno.md).

- variable:

  Variable numerica.

- pesos:

  Variable de ponderacion si `datos` no es `ena_diseno`.

- por:

  Vector opcional de dominios.

- porcentaje:

  Si es `TRUE`, expresa la proporcion en porcentaje.

## Value

Un `data.frame` ordenado por dominio y categoria.
