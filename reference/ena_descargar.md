# Descargar un archivo ENA desde una URL autorizada

Comprueba que la URL pertenezca al dominio del INEI, descarga el archivo
y, opcionalmente, lo descomprime. El acceso al portal puede requerir
registro; por ello la URL se solicita explicitamente y nunca se
incorporan credenciales.

## Usage

``` r
ena_descargar(
  url,
  destino = getwd(),
  descomprimir = TRUE,
  sobrescribir = FALSE
)
```

## Arguments

- url:

  URL HTTPS del archivo descargable en `proyectos.inei.gob.pe`.

- destino:

  Directorio de destino.

- descomprimir:

  Si es `TRUE`, extrae archivos ZIP.

- sobrescribir:

  Si es `TRUE`, permite sustituir un archivo existente.

## Value

La ruta del archivo descargado o del directorio extraido.
