## R CMD check results

Este paquete fue preparado para R >= 4.2.0 y debe verificarse localmente antes del envío:

```r
devtools::document()
devtools::test()
devtools::check(cran = TRUE, manual = TRUE)
```

No se incluyen microdatos del INEI. Las viñetas no descargan archivos ni requieren credenciales.

## Notas para CRAN

* `enaPeruR` es una herramienta de acceso y análisis; no replica ni redistribuye datos.
* El mantenedor debe sustituir el correo de ejemplo de `DESCRIPTION` antes de enviar a CRAN.
