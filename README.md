# Stochastic Population Forecasts for Finland 2026-2050

Jonas Schöley [![ORCID](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0002-3340-8518) ·
Ricarda Duerst [![ORCID](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0009-0003-0525-8756) ·
Julia Hellstrand [![ORCID](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0003-2308-0691) ·
Mikko Myrskylä [![ORCID](https://info.orcid.org/wp-content/uploads/2019/11/orcid_16x16.png)](https://orcid.org/0000-0003-4995-027X)

Stochastic population projections based on the assumption of slowing fertility postponement.

# Repository guidelines

Place downloaded or otherwise acquired data in `dat/`. Don't use `dat/` for derived data. Use `out/` for any persistent output of your scripts, e.g. plots, derived data, tables. Use `tmp/` for disposable output.

Place scripts in `src` within the respective domain folder, fertility, mortality, migration, or population. Place code which is relevant for all domains in `src/_global_objects.R`.

This repository uses renv for package management. Declare package dependencies explicitly in `_install_dependencies.R`.

Constants which are reused across scripts go into `cfg/config.yaml`.
