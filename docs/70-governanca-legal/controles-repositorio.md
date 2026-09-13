---
id: gaiatec-controles-repositorios
titulo: Estado dos controles dos repositórios
status: ativo
tipo: registro-de-controles
area: governanca-repositorios
fase: transversal
ambiente: github
responsavel: Vnd93
data_criacao: 2026-09-05
ultima_revisao: 2026-09-13
fonte_canonica: gaiatec-documentacao
substitui:
  - CONTROLES_REPOSITORIO.md
relacionados:
  - governanca.md
  - origem.md
  - ../00-indice/status-atual.md
  - ../00-indice/mapa-repositorios.md
---

# Estado dos controles dos repositórios

**Verificado em:** 13 de setembro de 2026  
**Administrador humano:** `Vnd93`

| Controle                                        | Documentação                 | CMS                 |
| ----------------------------------------------- | ---------------------------- | ------------------- |
| Repositório                                     | `Vnd93/gaiatec-documentacao` | `Vnd93/gaiatec-cms` |
| Visibilidade                                    | público                      | público             |
| Branch padrão                                   | `main`                       | `main`              |
| `main` protegida                                | sim                          | sim                 |
| Administração incluída na proteção              | sim                          | sim                 |
| Histórico linear obrigatório                    | sim                          | sim                 |
| Force-push                                      | proibido                     | proibido            |
| Exclusão da branch                              | proibida                     | proibida            |
| Reviews obrigatórias                            | não configuradas             | não configuradas    |
| Status checks obrigatórios na proteção clássica | não configurados             | não configurados    |

A configuração é coerente com a política atual de trabalho direto em `main`. Tornar pull request ou
review obrigatório exigiria mudar primeiro a política operacional e garantir uma segunda identidade
humana autorizada; essa mudança não foi feita implicitamente.

## Qualidade documental

O workflow `Documentation quality` executa em push para `main` e pull request, fixa actions por SHA,
usa permissões de leitura e roda `npm ci` e `npm run check`. O check valida Prettier, links locais,
frontmatter obrigatório e padrões conhecidos de segredo.

Os repositórios permanecem públicos. A visibilidade não foi alterada porque isso pode afetar Pages,
Actions, integrações e acesso; organização documental não exige mudança de visibilidade.
