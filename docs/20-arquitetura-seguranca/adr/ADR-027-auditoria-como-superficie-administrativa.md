# ADR-027 — Auditoria como superfície administrativa

**Status:** aceita<br>
**Data:** 6 de setembro de 2026

## Contexto

A trilha existia no backend, mas não era uma superfície operacional consultável.

## Decisão

Expor Auditoria no menu Administração com KPIs diários, filtros por usuário, área, resultado e
período, alvo técnico em mono, uso por usuário e exportação CSV. O registro é somente leitura:
nenhum papel recebe edição ou exclusão. Exportações também ficam rastreáveis.

## Consequências

Investigações e prestação de contas ficam acessíveis sem enfraquecer a imutabilidade ou revelar
payload sensível.
