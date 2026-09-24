---
id: gaiatec-nucleo-catalogo-evidencia-release-staging-2026-09-24
titulo: Evidência do release ágil e validação de staging
status: concluido-staging-sem-producao
tipo: evidencia-de-release
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Comercial GAIATEC Sistemas
data: 2026-09-24
---

# Evidência do release ágil — staging

## Identidade imutável

- SHA de controle, candidato e bytes promovidos: `31432783d77c5d90800dbf0e605f133f71e0aff1`.
- Perfil selecionado: `full-release` (a classificação mista/ambígua permanece fail-closed).
- CI independente: run `35953289141`, tentativa `1`, conclusão `success`.
- Bridge serial: run `35953810721`, tentativa `1`, conclusão `success`.
- Baseline verificado antes da mutação: `107da8ced5125de245c2f781aab053600ac7306e`.

## Gates e resultado

- `release-plan`, `quality`, `browser`, `database`, `hotfix-bundle-smoke` e `package-staging`: verdes no CI.
- O pacote unificado foi verificado antes de materializar o subpacote frontend; não houve rebuild entre CI e bridge.
- O bridge verificou CAS, fences, backend legado restaurado, limpeza de fixtures e estado de recuperação vazio.
- Healthz autenticável dos canários `ev2-g17-canary` e `ev2-g12-canary`: `ready`, `environment: staging`, release igual ao SHA acima.
- Duração observada do bridge: 540s; gargalo: prova de A isolado contra o backend de staging (54s). SLO de caminho feliz de 40–60min preservado; nenhum gate foi relaxado.
- Produção: não tocada.

## Núcleo de Catálogo

O contrato versionado e o planejamento das Fatias 1–4 estão publicados, com `catalog_v1` default-off. A lista nominal CAT-D009 continua `pendente-aprovacao`; nenhum item foi importado, nenhum SKU/preço/estoque foi criado e nenhum cutover é autorizado até owners, aprovadores e UAT estarem completos.

## Próximo gate humano

Nomear owner e aprovador de cada item da lista nominal, revisar a cobertura e registrar a aprovação literal correspondente. Até esse gate, manter o leitor legado e a flag desligada.
