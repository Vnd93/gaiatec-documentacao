---
id: gaiatec-arquitetura-database
titulo: Banco de dados do GAIATEC CMS
status: rascunho
tipo: arquitetura-de-dados
area: arquitetura-seguranca
fase: ev2
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-05
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - "gaiatec-cms:docs/database/README.md"
relacionados:
  - indice.md
---

# Banco

> Referência mínima importada do repositório executável; não substitui o inventário de migrations,
> políticas RLS e contratos de dados versionados no código.

Migrations são aplicadas em ordem, nunca editadas após implantação, e validadas em banco efêmero com testes RLS positivos e negativos.
