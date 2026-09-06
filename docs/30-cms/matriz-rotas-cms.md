---
id: cms-matriz-rotas-2026
titulo: Matriz de rotas do CMS
status: ativo
tipo: matriz
area: cms
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - ../90-historico/cms-fases-0-a-11/fase-9/MATRIZ_FINAL_ROTAS_CMS.md
relacionados:
  - inventario-telas-e-componentes.md
---

# Matriz de rotas do CMS

| Rota                                                                           | Superfície/aba                           | Permissão mínima                          |
| ------------------------------------------------------------------------------ | ---------------------------------------- | ----------------------------------------- |
| `/admin/login`, `/admin/recuperar-senha`, `/admin/definir-senha`, `/admin/mfa` | autenticação                             | pública controlada ou sessão em transição |
| `/admin`                                                                       | Visão geral                              | sessão CMS ativa                          |
| `/admin/leads`                                                                 | Leads                                    | `cms:leads.read`                          |
| `/admin/assistente`                                                            | Assistente IA                            | `cms:ai.read` + flag elegível             |
| `/admin/qualidade`                                                             | Centro de Qualidade                      | `cms:quality.read` + flag elegível        |
| `/admin/produtos`                                                              | Produtos · Catálogo                      | `cms:products.read`                       |
| `/admin/produtos/importacao`                                                   | Produtos · Cadastro em massa             | `cms:products.edit`                       |
| `/admin/listas-mestras`                                                        | Produtos/Serviços · Listas mestras       | `cms:vocabularies.read`                   |
| `/admin/busca`                                                                 | Produtos · Busca e sinônimos             | `cms:search.read`                         |
| `/admin/produtos/:id`                                                          | Editor de produto                        | `cms:products.read`; mutações por ação    |
| `/admin/descoberta/service`                                                    | Serviços e abas                          | `cms:services.read`                       |
| `/admin/descoberta/industry`                                                   | Indústrias e abas                        | `cms:industries.read`                     |
| `/admin/descoberta/application`                                                | Aplicações e abas                        | `cms:applications.read`                   |
| `/admin/descoberta/solution`                                                   | Soluções e Composição                    | `cms:solutions.read`                      |
| `/admin/conteudo` e `/:id`                                                     | Editorial                                | `cms:posts.read`; mutações por ação       |
| `/admin/paginas` e `/:id`                                                      | Páginas, Modelos, Blocos, Tema e Builder | `cms:pages.read` ou `cms:homepage.read`   |
| `/admin/midia`                                                                 | Mídia                                    | `cms:media.read`                          |
| `/admin/marketing` e `/campanhas/:id`                                          | Campanhas                                | `cms:campaigns.read`                      |
| `/admin/marketing/formularios`                                                 | Formulários                              | `cms:forms.read`                          |
| `/admin/site?section=navigation`                                               | Navegação                                | `cms:navigation.read`                     |
| `/admin/site?section=site_settings`                                            | Dados globais                            | `cms:settings.read`                       |
| `/admin/site?section=placement`                                                | Posicionamentos                          | `cms:placements.read`                     |
| `/admin/usuarios`                                                              | Usuários e acessos                       | `cms:users.read`                          |
| `/admin/perfil`                                                                | Perfil e sessão                          | sessão CMS ativa                          |
| `/admin/auditoria`                                                             | Auditoria                                | `cms:diagnostics.read`                    |
| `/admin/diagnosticos`                                                          | Diagnósticos                             | `cms:diagnostics.read`                    |

## Compatibilidade e consolidação

- `/admin/meu-trabalho` redireciona para `/admin`;
- `/admin/produtos/importacao`, `/admin/listas-mestras` e `/admin/busca` permanecem URLs compatíveis,
  mas são apresentadas como abas de Produtos;
- `/admin/assistente/execucao`, `/admin/pim`, `/admin/dados-mestres`, `/admin/estudio-visual` e
  `/admin/sites` permanecem compatíveis e ocultas fora de suas flags;
- `descoberta/:tipo`, `site?section=...` e editores mantêm os contratos existentes;
- rota administrativa desconhecida apresenta 404 do CMS; rota protegida sem sessão redireciona ao
  login sem revelar dados.

RBAC no menu é conveniência, não fronteira de segurança: edge function, RPC e RLS repetem a decisão
e falham fechados.
