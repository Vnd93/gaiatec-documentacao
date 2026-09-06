---
id: gaiatec-mapa-repositorios
titulo: Mapa de repositorios do site e CMS
status: ativo
tipo: mapa-de-repositorios
area: governanca-repositorios
fase: transversal
ambiente: local-e-github
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - status-atual.md
  - ../70-governanca-legal/controles-repositorio.md
  - ../70-governanca-legal/origem.md
---

# Mapa de repositórios do site e CMS

| Repositório ou área                    | Papel                                                                       | Escrita autorizada                  | Estado em 2026-09-06                                                                |
| -------------------------------------- | --------------------------------------------------------------------------- | ----------------------------------- | ----------------------------------------------------------------------------------- |
| `Vnd93/gaiatec-documentacao`           | Fonte canônica da documentação humana                                       | Branch + PR pelo perfil `Vnd93`     | `main` é a base canônica; reorganização em `docs/reorganizacao-documental`          |
| `Vnd93/gaiatec-cms`                    | Código, infraestrutura, testes, workflows, fixtures e controles executáveis | Branch + PR pelo perfil `Vnd93`     | fase 17 no PR nº 35; saneamento empilhado em `chore/saneamento-documentacao`        |
| `pedronishida/website_gaiatecsistemas` | Referência histórica somente leitura                                        | Nenhuma                             | remoto original preservado; push local definido como `DISABLED`                     |
| `Arquivo Histórico GAIATEC/site-cms`   | Cópias históricas, pacotes e manifestos com hash                            | Processo controlado de arquivamento | clone legado e cópias selecionadas validados; não é repositório canônico ativo      |
| `.codex-artifacts`                     | Área transitória por tarefa                                                 | Ferramentas locais                  | classificada por tarefa; somente resultados encerrados e necessários são arquivados |
| `.g6-homologation-aab55f7`             | Worktree Git com trabalho local                                             | Somente após reconciliação própria  | preservado, com alterações locais; fora desta migração                              |
| `.codex-worktrees`                     | Worktrees administrados pela ferramenta                                     | Comandos próprios da ferramenta/Git | fora do escopo; não mover manualmente                                               |
| `%SystemDrive%` literal                | Anomalia de cache local não documental                                      | Tratamento manual do sistema        | mantida em quarentena; não arquivada nem promovida a fonte                          |

## Regra de autoridade

- Documentação para leitura humana: `gaiatec-documentacao`.
- Comportamento executável e controles consumidos por automação: `gaiatec-cms`.
- Evidência histórica: repositório documental ou arquivo histórico, conforme o manifesto; nunca
  reclassificar evidência imutável como narrativa vigente.
- A única identidade GitHub humana autorizada para administração e escrita é `Vnd93`.
- IA é apoio técnico e não representa conta, revisor ou aprovador GitHub adicional.

## Bases de trabalho desta reorganização

| Frente       | Branch de trabalho              | Base                      | Estratégia de PR                                                                      |
| ------------ | ------------------------------- | ------------------------- | ------------------------------------------------------------------------------------- |
| Documentação | `docs/reorganizacao-documental` | `origin/main` (`bee751b`) | PR separado para `main`                                                               |
| CMS          | `chore/saneamento-documentacao` | fase 17 (`123a15e`)       | PR separado e dependente do PR nº 35; retarget para `main` após integração da fase 17 |

Não há autorização para merge automático, force-push, alteração de default branch, deploy ou
publicação como parte desta frente.
