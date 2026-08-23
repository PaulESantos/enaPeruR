test_that("el ejemplo Cusco tiene estructura documentada y no identificadores directos", {
  data("ena_cusco_2024", package = "enaPeruR", envir = environment())
  expect_equal(nrow(ena_cusco_2024), 250L)
  expect_true(all(c("departamento", "edad", "factor_productor") %in% names(ena_cusco_2024)))
  expect_true(all(ena_cusco_2024$departamento == "CUSCO"))
  expect_false(any(c("ID_PROD", "NSEGM", "CCPP", "CCDI", "UA") %in% names(ena_cusco_2024)))
})
