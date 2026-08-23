# Construir especificacion de diseno muestral ENA

Esta funcion reune la base y los nombres de sus variables de diseno para
las funciones descriptivas de `enaPeruR`. No construye un objeto de
muestreo ni estima varianzas complejas. Para inferencia, errores
estandar, CV o intervalos de confianza, verifique el diseno de cada anio
y use una herramienta de encuestas complejas conforme a su ficha
tecnica.

## Usage

``` r
ena_diseno(datos, pesos, estratos = NULL, conglomerados = NULL)
```

## Arguments

- datos:

  Base ENA.

- pesos:

  Variable de ponderacion.

- estratos:

  Variable de estrato, si existe.

- conglomerados:

  Variable de conglomerado, si existe.

## Value

Un objeto de clase `ena_diseno`.
