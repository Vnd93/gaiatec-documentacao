---
id: gaiatec-mapa-repositorios
titulo: Mapa de repositórios do site e CMS
status: ativo
tipo: mapa-de-repositorios
area: governanca-repositorios
fase: transversal
ambiente: local-e-github
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-13
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - status-atual.md
  - ambientes-e-execucao.md
  - ../70-governanca-legal/controles-repositorio.md
  - ../70-governanca-legal/origem.md
---

# Mapa de repositórios do site e CMS

| Repositório ou área                    | Papel                                                             | Linha vigente   |
| -------------------------------------- | ----------------------------------------------------------------- | --------------- |
| `Vnd93/gaiatec-documentacao`           | documentação humana canônica                                      | `main`          |
| `Vnd93/gaiatec-cms`                    | código, infraestrutura, testes, workflows e controles executáveis | `main`          |
| `pedronishida/website_gaiatecsistemas` | referência histórica somente leitura                              | nenhuma escrita |
| `_ARQUIVO_HISTORICO` local             | cópias, pacotes e manifestos preservados                          | não operacional |

Ambos os repositórios `Vnd93` são públicos, usam `main` como branch padrão e têm proteção contra
deleção, force-push e histórico não linear. O perfil humano administrativo confirmado é `Vnd93`.

## Checkouts locais

Nomes de diretório não definem autoridade. Antes de trabalhar, confirme `remote`, branch, SHA e
estado do checkout.

- `C:\dev\cms-site\gaiatec-documentacao`: checkout documental canônico.
- `C:\dev\cms-site\gaiatec-cms-faixa-a`: checkout que continha a `main` atual do CMS nesta
  fotografia.
- `C:\dev\cms-site\gaiatec-cms`: checkout de uma faixa de trabalho anterior; não presumir que seja
  `main` pelo nome.
- `_source_website_gaiatecsistemas`, `website_gaiatecsistemas-main` e
  `worktrees-reorganizacao`: cópias congeladas ou históricas; não desenvolver nelas.
- `.codex-worktrees`: gerenciada pela ferramenta; não mover ou remover manualmente.
- `.secrets`: fora de documentação, versionamento e auditoria de conteúdo.

## Regra de autoridade

- Narrativa atual para pessoas: `gaiatec-documentacao/main`.
- Comportamento real e automação: `gaiatec-cms/main` e estado remoto dos serviços.
- Evidência histórica: `docs/90-historico`, tags `archive/*` ou arquivo histórico local.
- Pastas soltas, clones antigos e handoffs datados nunca prevalecem sobre essas fontes.
