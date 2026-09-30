---
id: gaiatec-nucleo-catalogo-backlog-fatias-1-a-4-2026-09-24
titulo: Backlog executável das Fatias 1–4 do Núcleo de Catálogo
status: ativo-implementacao
tipo: backlog-executavel
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging-e-local
responsavel: Comercial GAIATEC Sistemas
data_criacao: 2026-09-24
ultima_revisao: 2026-09-30
fonte_canonica: gaiatec-documentacao
---

# Backlog executável das Fatias 1–4

O backlog é ordenado por dependência e fail-closed. Nenhum item cria SKU, preço, estoque,
disponibilidade, importação em massa ou leitura composta do legado. Cada item só pode ser marcado
`done` com evidência vinculada ao SHA e ao ambiente.

| ID      | Fatia | Trabalho                                                                    | Owner                | Aceite mínimo                                           | Gate/rollback                                |
| ------- | ----- | --------------------------------------------------------------------------- | -------------------- | ------------------------------------------------------- | -------------------------------------------- |
| CAT-001 | F1    | migration aditiva das entidades `cms_catalog_*`, revisão e auditoria        | Tech Lead + DevOps   | RLS habilitada, sem grants indevidos, rollback local    | pgTAP/advisors; migration compensatória      |
| CAT-002 | F1    | API de Produto/termos com `expectedVersion` e conflito 409                  | Edge/API             | conflito não grava parcialmente; payload não contém SKU | contrato API, unit e RLS negativo            |
| CAT-003 | F1    | telas Operador/Administrador atrás de `catalog_v1` default-off              | Frontend             | capacidades críticas negadas no backend e AAL2          | Chrome real; desligar flag                   |
| CAT-004 | F1    | taxonomia `Categoria/Família de Produto` com ciclo e múltiplo pai recusados | Data steward         | exatamente um termo ativo na publicação                 | pgTAP; revisão compensatória                 |
| CAT-005 | F2    | estados Rascunho/Pronto/Publicado e snapshot público                        | Edge/API             | edição publicada cria rascunho; histórico preservado    | canário read-only; voltar snapshot           |
| CAT-006 | F2    | CTA “Solicitar orçamento” e contrato sem campos comerciais                  | Frontend + API       | JSON-LD sem `Offer`, preço, estoque ou disponibilidade  | browser/contract; flag off                   |
| CAT-007 | F2    | outbox/cache por revisão publicada                                          | Edge/API             | somente snapshot aprovado é projetado                   | replay do outbox; invalidar projeção         |
| CAT-008 | F3    | tipos de relação, unidade e quantidade de composição                        | Tech Lead            | kit não aninha; ciclos/autorrelação/duplicata recusados | pgTAP; nova revisão compensatória            |
| CAT-009 | F3    | herança Variante→Modelo→Produto e exclusão local                            | Edge/API             | regra direta vence herdada e origem é exibida           | contrato determinístico; rollback de revisão |
| CAT-010 | F4    | páginas de termos opt-in e `noindex` por padrão                             | Editorial + Frontend | só publica com produto publicado e aprovação            | Chrome real, sitemap; desligar publicação    |
| CAT-011 | F4    | lista nominal prioritária, owner, aprovador e evidência UAT                 | Product Owner + QA   | 100% dos itens com revisão/aprovação antes do cutover   | gate CAT-D009; manter legado                 |
| CAT-012 | F4    | ensaio de rollback e relatório terminal                                     | DevOps + QA          | leitor retorna ao legado sem cópia entre fontes         | evidência de rollback; sem produção          |

## Dependências e estados

`CAT-001`–`CAT-004` são fundação. `CAT-005`–`CAT-007` exigem F1 verde. `CAT-008`–`CAT-009`
exigem F1/F2 verdes. `CAT-010`–`CAT-012` exigem F1–F3 verdes. Estados permitidos são
`planned → in-progress → blocked → ready-for-gate → done`; `done` exige SHA, digest, evidência e
rollback registrados. `CAT-D010` permanece `deferred` até dois ciclos manuais completos e estáveis.

## Situação vigente — staging controlado de 30 de setembro de 2026

`CAT-001`–`CAT-010` mantêm a implementação integrada, agora em
`035350ad690dcba40bd4542705a6b184b01b87bc`, com CI e ponte verdes. Migrations/deploy exclusivamente
em staging foram autorizados e executados até `0113`; essa autorização substitui a pendência de
autorização descrita na fotografia de 28 de setembro abaixo. Não refazer as implementações.

Os gates canônicos G11/G12/G17 passaram, mas o release continua bloqueado no canário de captação
positiva, que envia token dummy apesar da proteção Turnstile real. Chrome e aprovação terminal não
executaram. Manter `ready-for-gate`, não marcar `done`. A realocação dessa prova para a etapa Chrome,
com todas as assertivas de segurança/negócio preservadas, está pendente de decisão e implementação.

`CAT-011` permanece `blocked` por recaptura/aprovação nominal independente. `CAT-012` permanece
`blocked` por homologação/rollback funcional pendente, **não por falta de autorização de staging**.
Cleanup de QA foi comprovado nesta execução: zero leases ativas e resíduos comerciais do catálogo,
flag desligada e RLS preservada. Isso não substitui a prova de rollback funcional de CAT-012.

Ver [evidências e ponto de retomada](registro-resiliencia-editorial-seguranca-2026-09-30.md).
Itens 17/18 continuam provisórios, item 20 incompleto, CAT-D010 adiado e produção/carga/publicação/cutover proibidos.

## Registro histórico preservado — integração de 28 de setembro de 2026

`CAT-001`–`CAT-010` têm implementação integrada em `486fa5c40baeafe7212914591499245ddef4a5a6`,
CI `36512509486` verde, e estão `ready-for-gate`, não `done`. A integração fecha as lacunas de
RPC, telas administrativas, workflow de snapshot/outbox, relações/herança e páginas editoriais.
As migrations `0110`/`0111` foram validadas somente em banco isolado da CI.

`CAT-011` está `blocked` pela recaptura e aprovação nominal independente; `CAT-012` está
`blocked` pela ausência de autorização e evidência de homologação/rollback real em staging.
Os contratos automáticos desses dois itens estão implementados, mas não são prova de execução
real. Antes de fixtures remotas, o cleanup das novas tabelas também precisa de comprovação.

Veja o [registro completo da integração](registro-integracao-fatias-1-a-4-2026-09-28.md).
Manter feature flag default-off, itens 17/18 provisórios, sem carga/publicação/cutover. Não reabrir
trabalho concluído sem falha comprovada ou invalidação de checkpoint. CAT-D010 permanece `deferred`.

## Evidência histórica de execução

`CAT-008` e `CAT-009` estão `ready-for-gate` em local/staging, com feature flag default-off. O
commit CMS `037695887f370a8d10cad663ff89562940c7c3dd` e a migration `0109` (SHA-256
`921e9cfcf4a6947a656a17768ac04fbc67db851e39099d50abc9ed5a9178084d`) estão vinculados ao CI
`36446140298`, que terminou verde com 48 testes pgTAP da Fatia 3 e as demais lanes obrigatórias.
Não há carga, publicação ou cutover; a promoção para `done` depende da homologação de staging e
evidência Chrome/backend previstas no gate.

`CAT-010`, `CAT-011` e `CAT-012` estão `ready-for-gate` em local/staging, com feature flag
default-off. O commit CMS `8389c5da7b4d3a4736d31f1ef89bdec9f35155d9` está vinculado ao CI
`36471368672`, com quality, browser Playwright, database, smoke de runtime, pacote de staging e
métricas concluídos com sucesso. O contrato E2E `catalog-editorial-fatia4.spec.ts` passou em
desktop e mobile Chromium (4/4), cobrindo capability desligada/malformada, `noindex` e ausência
de busca editorial. A cobertura nominal e o rollback de leitor estão implementados como contratos
fail-closed; a homologação manual em Chrome real autenticado e backend de staging permanece
obrigatória antes de qualquer estado `done`. Itens 17 e 18 continuam
`user-confirmed-provisional`, sem aprovação final.

Na fase seguinte, o CMS adicionou `CatalogFatia4UatRecordSchema` e
`catalog-fatia4-uat-gate.test.ts` no commit `db6388e65441ab44f0e1ce67adbc4f9bc2e075d9`.
O envelope aceita o estado local `pending` e exige, para `passed`, Google Chrome autenticado,
backend de staging e evidência `CAT-UAT-*`; qualquer publicação, carga ou cutover é rejeitado pelo
contrato. O CI `36480366876` terminou verde com 211 arquivos/1322 testes unitários. A homologação
manual real continua pendente.
