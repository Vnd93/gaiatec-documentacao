---
id: gaiatec-cms-validacao-local-2026-08-29
titulo: Ultima validacao local do ciclo Remodelagem em 29 de agosto de 2026
status: historico
tipo: evidencia-de-validacao
area: qualidade-auditoria
fase: remodelagem
ambiente: local
responsavel: Vnd93
data_criacao: 2026-08-29
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - gaiatec-cms/docs/validacao-local/ULTIMA_VALIDACAO.md
relacionados:
  - ../../00-indice/manifesto-migracao-documental.md
---

# Ultima validacao local

Este registro preserva o resultado gerado no CMS em 29 de agosto de 2026. Ele e historico, nao
representa a validacao atual e nao autoriza merge ou deploy.

**Resultado geral:** APROVADO

**Inicio:** 2026-08-29T17:12:34.556Z

**Fim:** 2026-08-29T17:13:52.185Z

**Branch:** `Remodelagem`

**Commit-base:** `bbcaf615707b5a74962f1ffaf004a63c88542e2d`

**Estado inicial:** com alteracoes locais ainda nao commitadas

| Verificacao                     | Resultado | Duracao aproximada |
| ------------------------------- | --------- | ------------------ |
| Formatacao                      | APROVADO  | 2s                 |
| Lint                            | APROVADO  | 12s                |
| TypeScript                      | APROVADO  | 7s                 |
| Testes unitarios                | APROVADO  | 4s                 |
| Testes de integracao            | APROVADO  | 1s                 |
| Contencoes da Fase 1            | APROVADO  | 1s                 |
| Fundacao da Fase 3              | APROVADO  | 1s                 |
| Produto vertical da Fase 4      | APROVADO  | 1s                 |
| Catalogo e descoberta da Fase 5 | APROVADO  | 1s                 |
| Auditoria de dependencias       | APROVADO  | 2s                 |
| Build de staging                | APROVADO  | 20s                |
| Manifesto do artefato           | APROVADO  | 2s                 |
| Testes de navegador             | APROVADO  | 27s                |

## Limite da validacao original

O banco Supabase efemero nao integrou o comando porque o host nao dispunha de Docker. A evidencia
nao comprovava GitHub Actions, environments ou branch protection e nao autorizava merge em `main`
nem deploy de producao.
