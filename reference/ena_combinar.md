# Combinar bases ENA de manera segura

Agrega una columna de origen antes de apilar tablas con columnas
distintas. Es util para preparar varios modulos o anios, pero no
armoniza cuestionarios, nombres de variables, categorias o ponderadores.
Realice y documente esa armonizacion antes de estimar una serie
historica.

## Usage

``` r
ena_combinar(datos, id_origen = "origen")
```

## Arguments

- datos:

  Lista de `data.frame` o varios `data.frame`.

- id_origen:

  Nombre de la columna que identifica la fuente.

## Value

Un `data.frame` combinado.
