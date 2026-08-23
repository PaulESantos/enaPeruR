# enaPeruR

Herramientas reproducibles para los microdatos de la Encuesta Nacional Agropecuaria (ENA) del Perú, 2014--2025.

> **Comparabilidad:** la ENA 2014--2022 se basa en el marco del IV CENAGRO 2012. Desde 2023 usa el Marco Maestro Muestral de MIDAGRI (marco de áreas y de lista). No compare ambos periodos sin una decisión metodológica explícita.

## Instalación de desarrollo

```r
# remotes::install_local("D:/enaR")
```

## Flujo mínimo

```r
library(enaPeruR)

ena_catalogo()
ena_marco(2022)

# Una URL debe obtenerse del portal de Microdatos del INEI tras iniciar sesión.
# rutas <- ena_descargar(url = "https://.../archivo.zip", destino = "datos")
# datos <- ena_leer(rutas[1])

ena_validar(datos, pesos = "FACTOR", estratos = "ESTRATO")
ena_estimar_proporcion(datos, variable = "SEXO", pesos = "FACTOR")
```

La descarga no contiene ni redistribuye microdatos: respeta el acceso y el secreto estadístico del INEI. Consulte el portal oficial: <https://proyectos.inei.gob.pe/microdatos/>.
