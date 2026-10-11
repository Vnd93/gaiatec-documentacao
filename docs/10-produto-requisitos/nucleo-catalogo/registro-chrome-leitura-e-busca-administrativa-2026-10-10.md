---
id: gaiatec-catalogo-chrome-leitura-busca-2026-10-10
titulo: Verificações de leitura e correção da busca administrativa
status: validacao-parcial
tipo: registro-validacao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-10
ultima_revisao: 2026-10-10
fonte_canonica: gaiatec-documentacao
---

# Verificações de leitura e correção da busca administrativa

As verificações em Google Chrome real, com sessão administrativa autenticada e
backend real de staging, confirmaram os bloqueios do catálogo desligado e
identificaram uma falha na busca editorial. Não houve criação de produtos,
importação, publicação, alteração da flag ou acesso a produção. Esta rodada não
homologa os fluxos de escrita do catálogo.

## Candidato observado e resultados

As telas observadas em 11 de outubro UTC, ainda 10 de outubro no horário local, correspondem ao
staging preservado em `46d4fef53d5c3bd728898f31d909ea0219e29e77`, não ao código
local posteriormente corrigido. O acesso é
<https://ev2-g17-canary.gaiatec-cms-staging.pages.dev>.

| Verificação                                | Resultado observado                                                                                                                 | Limite da evidência                                                    |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| `/admin/nucleo-catalogo`                   | Acesso autenticado; aviso de preparação; nenhum campo de cadastro no conteúdo principal                                             | Não prova cadastro, revisão ou AAL2 das mutações                       |
| Menu administrativo mobile                 | Diálogo com nome acessível; foco inicial no botão fechar; Shift+Tab permanece no diálogo; Escape fecha e restaura foco ao acionador | Verificação dirigida, não auditoria completa de acessibilidade         |
| Layout mobile                              | Conteúdo principal sem overflow horizontal, viewport solicitado de 412 × 915                                                        | Largura útil do documento de 397 px com scrollbar                      |
| `/catalogo/tecnologia/medicao-vazao`       | “Conteúdo não disponível”; `noindex,follow`                                                                                         | Prova de fechamento, não de conteúdo publicado                         |
| `/catalogo/aplicacao/monitoramento-remoto` | Mesmo fechamento e `noindex,follow`, sem overflow horizontal                                                                        | Nenhuma relação ou termo foi criado                                    |
| `/catalogo/industria/protecao-catodica`    | Mesmo fechamento e `noindex,follow`, sem overflow horizontal                                                                        | Não confundir com a rota legada `/industrias/protecao-catodica` do 503 |
| `/admin/conteudo`                          | Busca por título e filtro por situação disponíveis; paginação desabilitada quando a busca falha                                     | O estado vazio da busca não passou                                     |

O formulário “Novo artigo” apresentou campos de título, resumo, corpo, autor,
categoria, tags, relações, SEO e direitos. Antes da criação, somente o controle
“Criar rascunho” estava disponível, sem ações de revisão ou publicação. A tela
foi inspecionada sem preencher, enviar ou restaurar backup; a navegação retornou
à listagem sem criar rascunho. Isso não valida a gravação nem os seus erros.

O teste do atalho para o conteúdo não produziu evidência conclusiva da sequência
de foco; não foi marcado como aprovado. A captura sanitizada do conteúdo principal
falhou por timeout do comando de screenshot. Não há screenshot válido nem prova
visual completa desta rodada. Os resultados acima vêm do DOM do Chrome real,
sem mock, headless, leitura de credenciais ou alteração do DOM.

## Causa independente e correção mínima

A pesquisa por título retornou “Não foi possível pesquisar os títulos dos
artigos”. A listagem sem filtro não exibiu esse erro. O frontend solicitava
`cms_content_drafts.content_id`; a consulta ao schema real de staging comprovou
que essa coluna não existe e que a chave é `item_id`. A mesma referência
incorreta estava na busca de nomes e fabricantes em `AdminProductsPage`.

As permissões SELECT de `authenticated` para a tabela, `item_id` e `payload`
estão presentes e RLS permanece habilitada. A correção troca somente a projeção
e o mapeamento para `item_id` nas duas telas. Não cria migration, grant, policy,
novo endpoint ou mudança de timeout/retry. A documentação atual de SELECT do
Supabase e o changelog foram consultados; o runtime Node pinado foi preservado.

Dois testes de regressão verificam a coluna solicitada e os IDs usados no filtro
da listagem. Ambos falharam antes da correção; depois dela, os 11 testes focados
de busca, integridade e paginação passaram. Fixtures desses testes existem
somente em memória local, sem inserir produtos ou artigos em staging.

O ajuste está no SHA `a6c2c2e2a3004cea8c0d51084b9a16a606a12939`, com três
arquivos próprios, 26 inserções e quatro remoções. `npm run check` passou:
238 arquivos Vitest, 1.681 testes, contratos, avaliações, lint, tipos e build
em 19,73 segundos. A revisão do diff e `git diff --check` passaram.

O [CI 38099349665](https://github.com/Vnd93/gaiatec-cms/actions/runs/38099349665)
concluiu com sucesso nos sete jobs, no SHA exato acima. Durações: plano 15 s,
runtime 148 s, banco 149 s, qualidade 214 s, navegador 109 s, pacote 100 s e
métricas 8 s, com validações independentes paralelas. O pacote original de staging
é o artefato `11687154595`, digest de arquivo informado pelo GitHub
`sha256:f0b4581a01287ec23910b46f32dc5b92c596cdfe43ef2e2439fc194804f7b6fe`.
O pacote não foi baixado, promovido nem recompilado para deploy nesta sessão.
Plano `11687260455`, seleção `11687054861` e métricas `11687460378` permanecem
vinculados ao mesmo produtor e tentativa 1.

O ajuste ainda precisa ser homologado em staging depois da promoção dos bytes
selados e dos gates aplicáveis. Não declarar que a busca observada no Chrome já
foi corrigida no ambiente remoto. O 503 público continua com causa interna do
transporte pendente do suporte e não foi corrigido por esta mudança.

## Segurança e trabalho restante

A consulta somente leitura ao backend confirmou zero produtos do novo catálogo,
zero leases QA ativos, zero manifests em `prepared` ou `compensating` e
`ev2.catalog_v1=false`. Não houve fixture remota, override individual, novo
challenge Chrome, migration ou deploy nesta inspeção.

O perfil GitHub `Vnd93`, `main`, fetch e sincronização por fast-forward foram
confirmados antes das mudanças, sem alterações preexistentes. O lease permaneceu
com o mesmo holder e handoff explícito concluído. Antes da edição, os cinco estados
ativos do GitHub estavam vazios nos dois repositórios; Cloudflare staging tinha
727 deployments inventariados, nenhum ativo, e o deployment canônico
`e5e96d1b-e770-47ef-bc2f-6c15a6016269` seguia no SHA observado.

Cadastro, validação dos formulários, permissões de escrita, revisões/conflitos,
relações, editorial habilitado, rollback e recuperação durável em ciclo real
permanecem pendentes conforme o
[roteiro do sistema vazio](roteiro-homologacao-sistema-vazio-staging-2026-10-10.md).
Esses fluxos não podem ser marcados como homologados pela inspeção da tela
fechada. Produção continua fora do escopo e sem liberação.
