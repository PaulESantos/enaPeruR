test_that("las estimaciones ponderadas son correctas", {
  x <- data.frame(dominio = c("A", "A", "B", "B"), sexo = c("M", "F", "M", "F"), valor = c(1, 3, 2, 4), peso = c(1, 3, 2, 2))
  expect_true(ena_validar(x, "peso")$valido)
  expect_equal(ena_estimar_media(x, "valor", "peso")$media, 2.75)
  p <- ena_estimar_proporcion(x, "sexo", "peso", porcentaje = TRUE)
  expect_equal(p$proporcion[p$sexo == "F"], 62.5)
})

test_that("la validación detecta pesos inválidos", {
  x <- data.frame(valor = 1:2, peso = c(1, 0))
  expect_false(ena_validar(x, "peso")$valido)
  expect_error(ena_diseno(x, "peso"))
})
