# Importar un archivo ENA

Lee SPSS, Stata, CSV o RDS y conserva etiquetas de `haven` cuando el
formato las provee. No recodifica ni estandariza nombres de variables
entre anios.

## Usage

``` r
ena_importar(archivo, columnas = NULL)
```

## Arguments

- archivo:

  Ruta a un archivo `.sav`, `.dta`, `.csv` o `.rds`.

- columnas:

  Nombres opcionales de columnas a conservar tras la lectura.

## Value

Un `data.frame`.
