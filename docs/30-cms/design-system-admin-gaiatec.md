---
id: cms-design-system-admin-2026
titulo: Design system administrativo GAIATEC
status: ativo
tipo: especificacao-visual
area: cms
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - ../90-historico/cms-fases-0-a-11/fase-11/DESIGN_SYSTEM_ADMIN_GAIATEC.md
relacionados:
  - inventario-telas-e-componentes.md
  - matriz-rotas-cms.md
---

# Design system administrativo GAIATEC

O protótipo HTML aprovado em `Análise front end do CMS` é a fonte da verdade visual. Este documento
substitui a especificação da F11 sem alterar seu registro histórico.

## Tokens canônicos

| Grupo                      | Valor                                                           |
| -------------------------- | --------------------------------------------------------------- |
| UI                         | `Instrument Sans`, pesos 400/500/600/700                        |
| técnico                    | `JetBrains Mono`; slugs, códigos, IDs e valores técnicos        |
| canvas/sidebar/superfície  | `#fafafa` / `#f4f4f5` / `#ffffff`                               |
| linha/sutil                | `#e4e4e7` / `#f0f0f1`; input `#d4d4d8`                          |
| texto/secundário/terciário | `#18181b` / `#71717a` / `#8e8e96`                               |
| acento                     | `#0057de`; hover `#0047b8`; ativo `#e4ecf9` com texto `#0047b8` |
| sucesso                    | fundo `#e7f4ec`, texto `#166a41`                                |
| aviso                      | fundo `#fbf1e1`, texto `#8a5407`                                |
| perigo                     | fundo `#fdebe9`, texto `#b42318`                                |
| informação                 | fundo `#e9f1fe`, texto `#0b57c2`                                |
| neutro                     | fundo `#f1f2f4`, texto `#5a616c`                                |

Cor nunca é o único indicador de estado. O foco é visível, azul e atende WCAG AA.

## Forma, elevação e densidade

- controles: raio de 7–8 px, altura de 38–40 px e alvo mínimo de 42 px;
- cards: raio de 12 px, padding de 20–28 px;
- sombra comum: `0 1px 2px rgba(0,0,0,.04)`;
- drawer: `-8px 0 32px rgba(0,0,0,.08)`, largura de 400 px no desktop;
- tabela: linha de aproximadamente 48 px e números tabulares;
- página: `max-width: 1160px`, padding horizontal de 36–40 px;
- sidebar: 236 px fixa, sem topbar separada e sem acordeão.

## Tipografia

- título de página: 22 px/600;
- título de card: 15 px/600;
- corpo: 13–14 px;
- label de campo: 12,5 px/600;
- micro-rótulo: 10,5–11 px, caixa alta e tracking 0,06–0,07 em; `#8e8e96` é o token visual
  terciário, mas texto informativo pequeno usa a derivação acessível `#5f5f66` sobre superfícies claras;
- KPIs e tabelas: `font-variant-numeric: tabular-nums`.

## Componentes e comportamento

`PageHeader`, `ModuleTabs`, `StepTabs`, `SectionCard`, `FilterBar`, `DataTable`, `Badge`,
`RecordDrawer`, ficha completa, `StatusRail`, `ConfirmDialog`, toast, skeleton e estados vazio/erro
formam o vocabulário comum. O cabeçalho oferece ações e “Sobre esta tela”; o guia inicia fechado e
expõe Nesta tela, Impacto público e Próximo passo.

Listagens abrem primeiro um resumo em drawer e só depois o editor ou ficha completa. Ações terminais
produzem toast por cerca de 2,6 s. Transições duram 160–200 ms e são reduzidas por
`prefers-reduced-motion`. Inputs administrativos têm fundo branco e borda explícita; nenhuma regra
visual do site público pode atravessar o limite `.public-site`.
