if(requireNamespace('spelling', quietly = TRUE) && l10n_info()[["UTF-8"]])
  spelling::spell_check_test(vignettes = TRUE, error = FALSE,
                             skip_on_cran = TRUE)
