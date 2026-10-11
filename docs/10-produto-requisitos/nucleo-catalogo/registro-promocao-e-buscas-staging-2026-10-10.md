---
id: gaiatec-promocao-buscas-staging-2026-10-10
titulo: Promoção e verificação das buscas administrativas em staging
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

# Promoção e verificação das buscas administrativas em staging

A correção das buscas de artigos e produtos foi promovida em staging e passou
nas verificações funcionais em Google Chrome real autenticado, com backend real.
Não houve criação de produtos, importação, carga comercial, habilitação da flag
global ou alteração de produção. Os resultados desta rodada não homologam o
ciclo de escrita do catálogo nem comprovam a resolução do HTTP 503 público.

Os eventos ocorreram em 11 de outubro UTC, ainda 10 de outubro no horário local.
Este registro atualiza o
[registro anterior de leitura e busca](registro-chrome-leitura-e-busca-administrativa-2026-10-10.md)
sem modificar sua evidência histórica.

## Identidade da promoção

O candidato é `a6c2c2e2a3004cea8c0d51084b9a16a606a12939`, em `main`.
O [CI original](https://github.com/Vnd93/gaiatec-cms/actions/runs/38099349665)
passou nos sete jobs na tentativa 1. O
[bridge](https://github.com/Vnd93/gaiatec-cms/actions/runs/38099931970)
passou na tentativa 1, de `00:53:02Z` a `01:02:01Z`: 539 segundos.
O job de promoção levou 521 segundos; o de métricas, 11 segundos.
O [watchdog](https://github.com/Vnd93/gaiatec-cms/actions/runs/38100447116)
terminou como `skipped`, sem necessidade de compensação adicional.

| Vínculo                    | Identidade confirmada                                                                                    |
| -------------------------- | -------------------------------------------------------------------------------------------------------- |
| Produtor e pacote original | CI `38099349665/1`, artefato `11687154595`                                                               |
| Digest GitHub do pacote    | `sha256:f0b4581a01287ec23910b46f32dc5b92c596cdfe43ef2e2439fc194804f7b6fe`                                |
| Arquivo frontend selado    | `cc56e4dfab195ed4b8cd62d371c7d82bc586c79eb0f111fc448c651f6f97aa78`                                       |
| Árvore frontend selada     | `edc7681bb3a0caa1c391c6417cbf852ce1de8bbda6b8e10fba9f04a63701e528`                                       |
| Deployment canônico        | `f7761b44-4816-44cc-ae4b-9cd833daf89b`, criado `2026-10-11T00:59:28.880941Z`                             |
| Evidência do bridge        | Artefato `11687238779`, digest `sha256:6580667932dc28616107b03c4bb39e25e95e81d728cbd9e001e1c642ba742733` |
| Restauração do backend     | Artefato `11687611488`, digest `sha256:e1828325e86f690c4ee7edb7a93ba4beace7723f7ecd4c8c897ad16a287a843b` |

O bridge verificou e promoveu os bytes originais, sem rebuild equivalente.
A evidência baixada foi aceita pelo validador oficial
`verify-staging-frontend-bridge-evidence.mjs`, com SHA, tentativa, deployment,
produtor, ID e digest esperados. Cloudflare confirmou o mesmo SHA no deployment
canônico; a paginação completa dos deployments terminou sem operação ativa.

## Recuperação e segurança da execução

O snapshot e os bytes de recuperação foram publicados e conferidos remotamente
antes da mutação. O bridge preservou escritor único, fences, lease exclusivo do
backend temporário, CAS e restauração obrigatória. As fixtures isoladas foram
somente de página, campanha e formulário, sem produtos. Os canários de
compatibilidade passaram com submissão bloqueada sem token, zero POST de lead,
limpeza e resíduo aprovados, mantendo a auditoria.

O backend `cms-public` foi restaurado na versão 784, com bundle
`83f2f7f1e2f483511f71b3768a9b998dc95babc0a2e4301574da80825b6d63f9`
e contrato `public-v2` confirmado por três sucessos consecutivos. O registro de
restauração declara produção intocada. Isso não equivale ao deploy completo e à
homologação de todas as funções do candidato.

Após o término, os cinco estados ativos do GitHub estavam vazios nos dois
repositórios, sem variáveis de recovery/fence/lease remanescentes. A consulta
somente leitura ao staging confirmou `ev2.catalog_v1=false`, zero produtos em
`cms_catalog_products`, zero leases QA ativos e zero manifests em `prepared` ou
`compensating`. RLS de `cms_content_drafts` e SELECT de `authenticated` sobre
`item_id` e `payload` permanecem habilitados.

## Buscas verificadas no Chrome real

Acesso: <https://ev2-g17-canary.gaiatec-cms-staging.pages.dev>.
A sessão administrativa existente foi usada sem leitura de credenciais nem
override de MFA. As verificações foram somente leitura e usaram registros
preexistentes; nenhum formulário de criação ou edição foi enviado.

| Fluxo                          | Resultado funcional observado                                                                                                                                 |
| ------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Artigos por título             | Correspondência positiva com artigo sintético já existente; uma linha de dados e nenhum alerta                                                                |
| Artigos sem correspondência    | Estado vazio sem o erro de pesquisa; Anterior e Próxima desabilitados                                                                                         |
| Artigos com situação           | Título de registro em rascunho combinado com Arquivado retornou vazio, sem alerta                                                                             |
| Limpeza do filtro editorial    | Listagem original retornou, com dez linhas na primeira página                                                                                                 |
| Produtos por nome e fabricante | As duas consultas retornaram o registro preexistente visível, sem alerta                                                                                      |
| Produtos sem correspondência   | Estado “Nenhum produto encontrado”; paginação desabilitada; nenhum alerta                                                                                     |
| Limpeza do filtro de produtos  | Consulta vazia e registro preexistente novamente visível                                                                                                      |
| Mobile                         | Título positivo, busca editorial por `q` na URL, fabricante positivo e estados vazios funcionaram em viewport 412 × 915, sem overflow horizontal do documento |

Não foi necessário criar produtos para provar as buscas. A listagem administrativa
usa registros preexistentes de `cms_content_items`, distintos de
`cms_catalog_products`, que permanece vazio. Títulos, nomes, slugs e payloads
comerciais não são reproduzidos neste registro. Os filtros e o viewport temporário
foram restaurados ao final.

A prova funcional vem do DOM renderizado no Chrome real e de consultas ao backend
real, sem mock, resposta simulada ou navegador headless. A captura sanitizada do
conteúdo principal falhou por timeout do comando de screenshot. Não existe
screenshot válido nem homologação visual completa desta rodada. A sessão
autenticada não prova isoladamente AAL2 dos comandos de escrita.

## Limites e trabalho restante

As buscas corrigidas estão promovidas e verificadas funcionalmente em staging.
O bridge comprova compatibilidade, não submissão positiva, persistência de leads
ou homologação completa do catálogo. O HTTP 503 público continua com causa
interna do transporte não comprovada, aguardando o suporte autorizado.

Cadastro, revisões, relações, gravação editorial e recuperação durável do catálogo
em ciclo real continuam pendentes conforme o
[roteiro do sistema vazio](roteiro-homologacao-sistema-vazio-staging-2026-10-10.md).
Não repetir o deploy completo ou criar fixtures de produto apenas para obter
verde. A flag permanece OFF e produção não está liberada.
