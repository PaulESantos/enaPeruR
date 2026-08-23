test_that("importar CSV y seleccionar columnas funciona", {
  archivo <- tempfile(fileext = ".csv")
  write.csv(data.frame(a = 1:2, b = 3:4), archivo, row.names = FALSE)
  salida <- ena_importar(archivo, "a")
  expect_named(salida, "a")
  expect_equal(salida$a, 1:2)
})

test_that("la descarga exige el dominio del INEI", {
  expect_error(ena_descargar("https://example.org/datos.zip"))
})
