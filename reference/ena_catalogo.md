# Consultar la cobertura historica de ENA

Informa la cobertura conocida de la ENA y el marco muestral
correspondiente. Los anios 2020 y 2021 se marcan como no disponibles. El
catalogo orienta la preparacion de una serie; no certifica que las
variables o indicadores sean comparables entre anios.

## Usage

``` r
ena_catalogo(anios = 2014:2025)
```

## Arguments

- anios:

  Anios a consultar. Por defecto, todos los disponibles.

## Value

Un `data.frame` con anio, disponibilidad, marco y una indicacion de
comparabilidad con 2014–2022.
