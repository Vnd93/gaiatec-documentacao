# ADR-028 — Vínculos bidirecionais do catálogo

**Status:** aceita<br>
**Data:** 6 de setembro de 2026

## Nota de escopo posterior — Núcleo de Catálogo

Para o novo Núcleo de Catálogo `cms_catalog_*`, a definição de Indústria como categoria principal
foi parcialmente superada pelas
[decisões funcionais aprovadas em 13 de setembro de 2026](../../10-produto-requisitos/nucleo-catalogo/decisoes-funcionais-aprovadas-2026-09-13.md).
`Categoria/Família de Produto` é a única classificação principal; Indústria e Aplicação são
vínculos N:N complementares. A projeção bidirecional e a preservação de IDs canônicos permanecem
aplicáveis.

## Contexto

O cliente precisa entender setor, situação de uso, oferta aplicável e cross-sell sem duplicação de
taxonomia.

## Decisão

Indústria é a categoria principal; Aplicação é o segmento específico dentro dela; Solução agrupa
produtos do mesmo tipo. Aplicações recomendam produtos e serviços com nota opcional por item.
Vínculos são editados uma vez e projetados nos dois sentidos: produto sugere aplicações/serviços e
as superfícies de descoberta listam a composição correspondente.

## Consequências

O contrato mantém IDs canônicos, valida existência/publicação e evita cópia de conteúdo. Alterações
precisam de revisão, auditoria e testes de projeção pública.
