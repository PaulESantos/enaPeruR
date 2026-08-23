# Estimar una media ponderada

Calcula la media descriptiva ponderada, opcionalmente por dominios.
Puede aplicarse a una base multianual ya armonizada. No calcula error
estandar, coeficiente de variacion ni intervalos de confianza.

## Usage

``` r
ena_estimar_media(datos, variable, pesos, por = NULL)
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

## Value

Un `data.frame` con tamano muestral, suma de pesos y media.
