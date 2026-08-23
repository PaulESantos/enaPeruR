# Comparabilidad ENA 2014--2025

## Qué puede analizarse con enaPeruR

Las funciones de lectura y
[`ena_combinar()`](https://paulesantos.github.io/enaPeruR/reference/ena_combinar.md)
permiten construir una base que contiene varios años, módulos o
archivos.
[`ena_estimar_media()`](https://paulesantos.github.io/enaPeruR/reference/ena_estimar_media.md)
y
[`ena_estimar_proporcion()`](https://paulesantos.github.io/enaPeruR/reference/ena_estimar_proporcion.md)
pueden resumir esa base por una variable de año o dominio, siempre que
el usuario haya creado variables armonizadas y escogido el factor de
expansión apropiado.

El paquete no decide qué variables son equivalentes, no recodifica
categorías históricas, no ajusta factores de expansión y no calcula
varianzas de muestreo. Por tanto, una salida multianual es descriptiva y
solo representa una serie analítica después de una armonización
documentada.

## Ruptura metodológica

La ENA no debe analizarse como una serie automáticamente homogénea.
Entre 2014 y 2022 empleó el marco derivado del IV CENAGRO 2012. Desde
2023 emplea el Marco Maestro Muestral de MIDAGRI, que incorpora un marco
de áreas para productores individuales y un marco de lista para empresas
y grandes productores. Los años 2020 y 2021 no están disponibles en el
catálogo incluido.

Antes de comparar indicadores:

1.  Defina la población objetivo y el componente (áreas/lista) de cada
    año.
2.  Compare cuestionarios, periodos de referencia y reglas de edición.
3.  Revise la ficha técnica y las variables de ponderación del año.
4.  Documente toda armonización y presente la ruptura de 2023 cuando sea
    relevante.

## Esquema de trabajo recomendado

``` r

# Cada elemento debe provenir del mismo módulo o de módulos previamente armonizados.
archivos <- ena_leer("datos/ena", combinar = FALSE)
serie <- ena_combinar(archivos, id_origen = "archivo_origen")

# Cree y documente anio_analisis, indicador_armonizado y factor_armonizado.
ena_validar(serie, pesos = "factor_armonizado")
ena_estimar_proporcion(
  serie,
  variable = "indicador_armonizado",
  pesos = "factor_armonizado",
  por = "anio_analisis",
  porcentaje = TRUE
)
```

Para inferencia por diseño complejo, incorpore las variables de estrato
y conglomerado descritas en la ficha técnica de cada año a un flujo de
análisis especializado.

``` r

library(enaPeruR)
ena_catalogo()
```

    ##    anio disponible           marco             componente
    ## 1  2014       TRUE IV CENAGRO 2012 Unidades agropecuarias
    ## 2  2015       TRUE IV CENAGRO 2012 Unidades agropecuarias
    ## 3  2016       TRUE IV CENAGRO 2012 Unidades agropecuarias
    ## 4  2017       TRUE IV CENAGRO 2012 Unidades agropecuarias
    ## 5  2018       TRUE IV CENAGRO 2012 Unidades agropecuarias
    ## 6  2019       TRUE IV CENAGRO 2012 Unidades agropecuarias
    ## 7  2020      FALSE IV CENAGRO 2012 Unidades agropecuarias
    ## 8  2021      FALSE IV CENAGRO 2012 Unidades agropecuarias
    ## 9  2022       TRUE IV CENAGRO 2012 Unidades agropecuarias
    ## 10 2023       TRUE     MMM MIDAGRI          Áreas y lista
    ## 11 2024       TRUE     MMM MIDAGRI          Áreas y lista
    ## 12 2025       TRUE     MMM MIDAGRI          Áreas y lista
    ##    comparable_con_2014_2022
    ## 1                      TRUE
    ## 2                      TRUE
    ## 3                      TRUE
    ## 4                      TRUE
    ## 5                      TRUE
    ## 6                      TRUE
    ## 7                      TRUE
    ## 8                      TRUE
    ## 9                      TRUE
    ## 10                    FALSE
    ## 11                    FALSE
    ## 12                    FALSE
