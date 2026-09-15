# ADR-007 — Publicação, outbox e cache

**Status:** aprovada — Pedro Nishida, Tech Lead
**Data:** 28 de agosto de 2026

## Nota de escopo posterior — Núcleo de Catálogo

No novo Núcleo de Catálogo `cms_catalog_*`, “restaurar e republicar” significa criar um novo
Rascunho a partir da revisão histórica e submetê-lo novamente ao fluxo
`Rascunho → Pronto → Publicado`, conforme as
[decisões funcionais aprovadas em 13 de setembro de 2026](../../10-produto-requisitos/nucleo-catalogo/decisoes-funcionais-aprovadas-2026-09-13.md).
A restauração nunca substitui diretamente o snapshot público vigente nem reescreve a revisão
histórica.

## Decisão

Publicação é um comando transacional que cria revisão imutável, atualiza projeção publicada, grava outbox e audit log. Workers processam busca, sitemap, cache e integrações de forma idempotente. Cache é versionado por entidade/tag.

Falha nunca substitui conteúdo válido por rascunho ou payload parcial. Restauração republica uma revisão anterior como nova versão auditada.
