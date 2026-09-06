# ADR-024 — Navegação achatada e abas internas

**Status:** aceita<br>
**Data:** 6 de setembro de 2026

## Contexto

O acordeão elevava o custo de localização e transformava subferramentas do mesmo cadastro em áreas
aparentemente independentes.

## Decisão

Adotar sidebar fixa com seis seções e itens visíveis em um clique. Subferramentas ficam em abas
sublinhadas sob o cabeçalho. “Meu trabalho” é consolidado na Visão geral. URLs anteriores continuam
compatíveis; PIM, Dados mestres, Estúdio Visual e Multisite permanecem sob flag e contexto do módulo.

## Consequências

Menor profundidade e orientação consistente; o shell precisa derivar visibilidade do RBAC e manter
breadcrumbs/redirects compatíveis.
