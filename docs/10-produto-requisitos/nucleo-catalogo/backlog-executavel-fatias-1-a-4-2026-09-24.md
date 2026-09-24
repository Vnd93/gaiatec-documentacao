---
id: gaiatec-nucleo-catalogo-backlog-fatias-1-a-4-2026-09-24
titulo: Backlog executável das Fatias 1–4 do Núcleo de Catálogo
status: ativo-planejamento
tipo: backlog-executavel
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging-e-local
responsavel: Comercial GAIATEC Sistemas
data_criacao: 2026-09-24
ultima_revisao: 2026-09-24
fonte_canonica: gaiatec-documentacao
---

# Backlog executável das Fatias 1–4

O backlog é ordenado por dependência e fail-closed. Nenhum item cria SKU, preço, estoque,
disponibilidade, importação em massa ou leitura composta do legado. Cada item só pode ser marcado
`done` com evidência vinculada ao SHA e ao ambiente.

| ID | Fatia | Trabalho | Owner | Aceite mínimo | Gate/rollback |
| --- | --- | --- | --- | --- | --- |
| CAT-001 | F1 | migration aditiva das entidades `cms_catalog_*`, revisão e auditoria | Tech Lead + DevOps | RLS habilitada, sem grants indevidos, rollback local | pgTAP/advisors; migration compensatória |
| CAT-002 | F1 | API de Produto/termos com `expectedVersion` e conflito 409 | Edge/API | conflito não grava parcialmente; payload não contém SKU | contrato API, unit e RLS negativo |
| CAT-003 | F1 | telas Operador/Administrador atrás de `catalog_v1` default-off | Frontend | capacidades críticas negadas no backend e AAL2 | Chrome real; desligar flag |
| CAT-004 | F1 | taxonomia `Categoria/Família de Produto` com ciclo e múltiplo pai recusados | Data steward | exatamente um termo ativo na publicação | pgTAP; revisão compensatória |
| CAT-005 | F2 | estados Rascunho/Pronto/Publicado e snapshot público | Edge/API | edição publicada cria rascunho; histórico preservado | canário read-only; voltar snapshot |
| CAT-006 | F2 | CTA “Solicitar orçamento” e contrato sem campos comerciais | Frontend + API | JSON-LD sem `Offer`, preço, estoque ou disponibilidade | browser/contract; flag off |
| CAT-007 | F2 | outbox/cache por revisão publicada | Edge/API | somente snapshot aprovado é projetado | replay do outbox; invalidar projeção |
| CAT-008 | F3 | tipos de relação, unidade e quantidade de composição | Tech Lead | kit não aninha; ciclos/autorrelação/duplicata recusados | pgTAP; nova revisão compensatória |
| CAT-009 | F3 | herança Variante→Modelo→Produto e exclusão local | Edge/API | regra direta vence herdada e origem é exibida | contrato determinístico; rollback de revisão |
| CAT-010 | F4 | páginas de termos opt-in e `noindex` por padrão | Editorial + Frontend | só publica com produto publicado e aprovação | Chrome real, sitemap; desligar publicação |
| CAT-011 | F4 | lista nominal prioritária, owner, aprovador e evidência UAT | Product Owner + QA | 100% dos itens com revisão/aprovação antes do cutover | gate CAT-D009; manter legado |
| CAT-012 | F4 | ensaio de rollback e relatório terminal | DevOps + QA | leitor retorna ao legado sem cópia entre fontes | evidência de rollback; sem produção |

## Dependências e estados

`CAT-001`–`CAT-004` são fundação. `CAT-005`–`CAT-007` exigem F1 verde. `CAT-008`–`CAT-009`
exigem F1/F2 verdes. `CAT-010`–`CAT-012` exigem F1–F3 verdes. Estados permitidos são
`planned → in-progress → blocked → ready-for-gate → done`; `done` exige SHA, digest, evidência e
rollback registrados. `CAT-D010` permanece `deferred` até dois ciclos manuais completos e estáveis.
