---
id: gaiatec-nucleo-catalogo-matriz-rastreabilidade-2026-09-24
titulo: Matriz de rastreabilidade e gates do Núcleo de Catálogo
status: ativo-implementacao
tipo: matriz-de-rastreabilidade
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging-e-local
responsavel: Comercial GAIATEC Sistemas
data_criacao: 2026-09-24
ultima_revisao: 2026-09-28
fonte_canonica: gaiatec-documentacao
decisoes: CAT-D001-CAT-D010
---

# Matriz de rastreabilidade e gates do Núcleo de Catálogo

Este documento transforma CAT-D001–CAT-D010 em unidades verificáveis para as Fatias 1–4. Não
autoriza migration remota, carga de legado, ativação global de flag, cutover ou produção. O catálogo
novo começa vazio, sem fonte mista e sem SKU, conforme CAT-D002 e CAT-D009.

## Regra de seleção de perfil

| Perfil          | Mudança permitida                                   | Gates obrigatórios                                                                       | Artefato/rollback                                       |
| --------------- | --------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `frontend-only` | telas, copy, acessibilidade, flag sem contrato novo | check, unit, build, browser real em staging                                              | pacote frontend selado; desligar flag                   |
| `edge-only`     | contrato/Edge sem schema novo                       | check, unit, contrato API, Auth/RLS de staging, browser real                             | bundle Edge único; restaurar versão anterior            |
| `database-auth` | migration, RLS, auditoria, Auth/AAL2                | manifesto de migration, pgTAP, advisors, RLS negativo/positivo, rollback local e staging | migration imutável; compensação/rollback testado        |
| `full-release`  | combinação de áreas ou ambiguidade                  | todos os gates acima, artefato único e canário completo                                  | pacote único por SHA; rollback de leitura, Edge e banco |

Qualquer mudança que atravesse mais de uma área, altere contrato de publicação, classificação,
relações, RLS/Auth ou tenha classificação incerta seleciona `full-release`. Nenhum perfil menor pode
ser escolhido para reduzir gates.

## Mudança → decisão → gate → evidência

| Fatia                      | Entrega verificável                                                              | Decisões                             | Gates de entrada                                          | Gates de saída e evidência                                                                     | Rollback                                                |
| -------------------------- | -------------------------------------------------------------------------------- | ------------------------------------ | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| F1 — fundação              | entidades, revisão otimista, taxonomia principal, papéis e RLS                   | D001, D004, D005                     | contrato versionado, owner de taxonomia, flag default-off | migração local/staging, pgTAP concorrência/RLS, API 409, auditoria sem PII, Chrome autenticado | desativar flag; migration compensatória aprovada        |
| F2 — revisão/publicação    | Rascunho/Pronto/Publicado, snapshot público e CTA de orçamento                   | D003, D007                           | F1 verde, outbox/cache definido, sem Offer/preço/estoque  | testes de transição inválida, snapshot isolado, JSON-LD sem Offer, smoke Edge/Chrome           | leitor volta ao snapshot anterior; não apagar histórico |
| F3 — kits e relações       | tipos de relação, quantidades/unidades, herança e exclusões                      | D005, D006                           | F1 e F2 verdes, vocabulário de unidades aprovado          | pgTAP de ciclo/autorrelação/duplicata, projeção bidirecional, rollback de revisão              | nova revisão compensatória; sem exclusão física         |
| F4 — termos e cutover prep | páginas Tecnologia/Indústria/Aplicação opt-in, lista nominal e gate de cobertura | D008, D009; D010 explicitamente fora | F1–F3 verdes, UAT e owners nomeados                       | Chrome real, noindex/SEO, sitemap opt-in, lista 100% revisada, rollback ensaiado               | manter site antigo e flag off                           |

## Checkpoints e imutabilidade

Cada tentativa registra `sha`, perfil, digest do artefato, deployment ID, snapshot do ambiente,
resultado de cada gate, owner e timestamp. Retry só reutiliza um gate independente ainda válido;
mudança de SHA, bytes, schema, estado remoto ou ambiente invalida os dependentes. O desafio de
Chrome é emitido somente após os gates automáticos e watcher estarem prontos.

## Métricas de planejamento

Registrar duração por etapa (preflight, validações paralelas, mutação serial, pós-deploy somente
leitura, Chrome e evidência). O SLO de caminho feliz é 40–60 minutos; qualquer extrapolação deve
identificar o gargalo e nunca relaxar segurança. O primeiro cutover permanece bloqueado enquanto a
lista nominal não tiver 100% de cadastro, revisão e aprovação.

## Checkpoint vigente da integração — 28 de setembro de 2026

O SHA `486fa5c40baeafe7212914591499245ddef4a5a6` reúne a implementação funcional das Fatias
1–4. CI `36512509486` integralmente verde, 1.351 testes Vitest, 2.110 pgTAP e runtime das 34
funções com dois builds independentes idênticos. Os IDs/digests e tempos estão no
[registro da integração](registro-integracao-fatias-1-a-4-2026-09-28.md).

Esse checkpoint é de código/local/CI isolado: não possui deployment ID nem homologação do backend
hospedado. `CAT-001`–`CAT-010` ficam `ready-for-gate`; `CAT-011`/`CAT-012` permanecem bloqueados
nos gates nominais e operacionais. Nenhum campo de evidência pode ser preenchido como `passed`
por analogia com testes automatizados. Nenhuma fatia está declarada `done`.

## Evidência histórica da Fatia 3 — CAT-D008/CAT-D009

- Implementação local/staging no CMS canônico: commit `037695887f370a8d10cad663ff89562940c7c3dd`.
- Migration selada: `0109_catalog_fatia_3_relations.sql`, SHA-256
  `921e9cfcf4a6947a656a17768ac04fbc67db851e39099d50abc9ed5a9178084d`.
- A migration materializa tipos de relação, unidades controladas, quantidade positiva para composição,
  herança Variante→Modelo→Produto, exclusão local, auditoria append-only e RLS; rejeita
  autorrelação, ciclo, duplicata, relação simétrica não canônica e kit aninhado.
- CI terminal verde: run `36446140298`, database pgTAP `48/48`, quality, browser, smoke de runtime,
  pacote de staging e métricas concluídos com sucesso.
- Nenhum produto, SKU, relação, carga, publicação, deploy ou cutover foi executado; `ev2.catalog_v1`
  permanece default-off. O rollback aprovado para esta fase é uma nova revisão compensatória, sem
  exclusão física.

## Evidência da Fatia 4 — CAT-010/CAT-011/CAT-012

- Implementação local/staging no CMS canônico: commit `e37eb1b729e680f2c9a346b0088593e63aa3e138`.
- Contratos editoriais adicionados para Tecnologia, Indústria e Aplicação: payload público sanitizado,
  `noindex` fail-closed, aprovação/UAT server-owned, cobertura nominal de 100% e leitor legado para
  rollback. Nenhum campo comercial, SKU, preço, estoque ou disponibilidade é exposto.
- CI terminal verde: run `36449157247`; release-plan, quality, browser Playwright, database,
  hotfix-bundle-smoke, pacote de staging e pipeline-metrics concluídos com sucesso.
- Gate E2E de homologação fechado no commit `8389c5da7b4d3a4736d31f1ef89bdec9f35155d9`:
  `tests/e2e/catalog-editorial-fatia4.spec.ts` passou em desktop e mobile Chromium (4/4),
  provando que capability desligada ou malformada mantém `noindex` e não requisita o termo.
- CI terminal do gate E2E: run `36471368672`, todas as lanes verdes.
- Envelope de evidência UAT adicionado no commit `db6388e65441ab44f0e1ce67adbc4f9bc2e075d9`:
  registra SHA, ambiente, cobertura, rollback e status do navegador sem PII; só aceita `passed`
  para Google Chrome autenticado contra staging com evidência nominal, e nunca autoriza publicação,
  carga ou cutover.
- CI terminal do envelope UAT: run `36480366876`, todas as lanes verdes; suíte unitária final
  `211` arquivos/`1322` testes aprovados.
- A lane de browser validou o pacote local de staging; a homologação manual em Chrome real
  autenticado e backend de staging ainda é gate pendente para promover os itens a `done`.
- `ev2.catalog_v1` permanece default-off. Nenhuma migration nova, carga, publicação, deploy,
  promoção ou cutover foi executado. CAT-D010 continua `deferred`.
- Rollback ensaiável: desligar a flag e selecionar o leitor legado, sem cópia entre fontes; qualquer
  correção futura exige novo SHA e revalidação dos gates dependentes.
