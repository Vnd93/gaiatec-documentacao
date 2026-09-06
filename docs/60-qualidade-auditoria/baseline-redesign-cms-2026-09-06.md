---
id: cms-baseline-redesign-2026-09-06
titulo: Baseline de correções do redesign do CMS
status: ativo
tipo: audit-delta
area: qualidade-auditoria
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - ../30-cms/design-system-admin-gaiatec.md
---

# Baseline de correções do redesign do CMS

| Causa raiz                                                                 | Correção aplicada                                                                     | Verificação                                         |
| -------------------------------------------------------------------------- | ------------------------------------------------------------------------------------- | --------------------------------------------------- |
| `*:not(.rounded-full) { border-radius: 0 !important }` atravessava o admin | regra limitada a `.public-site`                                                       | controles e cards administrativos preservam 7–12 px |
| dois blocos conflitantes de `--admin-*`                                    | um bloco canônico em `admin.css`                                                      | `--admin-blue` único em `#0057de`                   |
| `--input: transparent` eliminava fundo/borda                               | input branco e borda `#d4d4d8` explícitos                                             | login, filtros e editores legíveis                  |
| CSS especializados concorriam em tokens                                    | tokens vivem somente em `admin.css`; folhas especializadas consomem os mesmos valores | cascata auditada sem redefinição temática           |

O delta não altera contrato, migração, RBAC, workflow, outbox, auditoria ou projeção pública. O
limite visual do site público é explícito e o admin mantém foco, contraste e reduced motion.
