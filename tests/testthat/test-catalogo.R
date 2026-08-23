test_that("el catálogo reconoce la ruptura metodológica", {
  expect_equal(ena_marco(2022)$marco, "IV CENAGRO 2012")
  expect_equal(ena_marco(2023)$marco, "MMM MIDAGRI")
  expect_false(ena_catalogo(2020)$disponible)
  expect_error(ena_catalogo(2013))
})
