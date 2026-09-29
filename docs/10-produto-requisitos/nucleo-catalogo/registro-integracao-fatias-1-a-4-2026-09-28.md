---
id: gaiatec-catalogo-integracao-fatias-1-a-4-2026-09-28
titulo: Integração funcional e fechamento técnico local das Fatias 1–4
status: implementado-ci-verde-homologacao-pendente
tipo: registro-de-implementacao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: local-e-ci-isolado
responsavel: Vnd93
data_criacao: 2026-09-28
ultima_revisao: 2026-09-28
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - decisoes-funcionais-aprovadas-2026-09-13.md
  - backlog-executavel-fatias-1-a-4-2026-09-24.md
  - matriz-rastreabilidade-ondas-1-a-4-2026-09-24.md
  - lista-nominal-prioritaria-cat-d009-2026-09-24.md
  - aprovacao-tecnica-plano-staging-2026-09-24.md
---

# Integração das Fatias 1–4

## Ponto correto de retomada

A implementação integrada está em `main`, SHA
`486fa5c40baeafe7212914591499245ddef4a5a6`, com
[CI 36512509486 integralmente verde](https://github.com/Vnd93/gaiatec-cms/actions/runs/36512509486).
A integração funcional foi introduzida em `407c8d5fefdaf5a3e9fc974f6d480def45938652`; o commit
seguinte corrigiu a separação entre regressão histórica de empacotamento e candidato atual.

Não reiniciar as Fatias 1–4 nem os runs antigos de release. Os registros anteriores comprovam suas
respectivas migrations, contratos e testes, mas não substituem esta integração administrativa nem
a homologação funcional. O próximo gate é a implantação/homologação controlada de staging, que
continua fora da autorização vigente. Nenhuma fatia é declarada `done` sem os gates funcionais.

## Lacunas técnicas resolvidas

| Fatia / tarefas      | Implementação integrada                                                                                                                                                                  | Verificação obtida                                                                                                                                         |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| F1 / CAT-001–CAT-004 | RPC autenticada, workspace administrativo, criação/edição, classificação principal, taxonomias, conflitos 409, comparação de versões, sobrescrita administrativa justificada e histórico | contratos, componentes, RLS, AAL2, isolamento de atores, CAS e sessão revogada                                                                             |
| F2 / CAT-005–CAT-007 | comandos de rascunho/pronto/publicado, retirada/restauração, snapshot imutável, outbox por revisão e leitor público isolado com CTA de orçamento                                         | transições inválidas recusadas, edição preserva snapshot anterior, replay idempotente, evento antigo não reativa publicação, ausência de campos comerciais |
| F3 / CAT-008–CAT-009 | edição de composição/relações, unidades/quantidades, hierarquia, herança com origem e exclusão local                                                                                     | ciclos completos, autorrelação, duplicidade e composição obrigatória; precedência não oculta relação obrigatória                                           |
| F4 / CAT-010         | editor de páginas Tecnologia/Indústria/Aplicação, revisões, publicação opt-in, retirada/301 e sitemap separado                                                                           | `noindex` por padrão, aprovação de indexação vinculada à revisão/SHA/evidência, sem fonte mista e sem autoaprovação                                        |
| F4 / CAT-011–CAT-012 | contratos de lista nominal, envelope de UAT e rollback de leitura preservados                                                                                                            | cobertura automática local; aprovação nominal e ensaio real de rollback continuam pendentes                                                                |

Entradas implementadas no CMS: `/admin/nucleo-catalogo`,
`/catalogo/itens/:slug`, `/catalogo/tecnologia/:slug`, `/catalogo/industria/:slug`,
`/catalogo/aplicacao/:slug` e `/sitemap-catalogo.xml`. As rotas novas permanecem isoladas e
desabilitadas por padrão. O leitor público legado não foi substituído.

## Migrations aditivas seladas

| Migration                                | SHA-256                                                            |
| ---------------------------------------- | ------------------------------------------------------------------ |
| `0110_catalog_workspace_integration.sql` | `c16c4064e8810520fe487ae8a6054f5ac961427abe01c461774d8df9b4ff9ac5` |
| `0111_catalog_editorial_integration.sql` | `273555d5189d2ab5d8aa126c44d47cf4e060d763c0818108c5af3c2ee5512ded` |

As migrations anteriores `0107`–`0109` não foram reescritas. As novas migrations foram aplicadas
somente ao Supabase efêmero da CI, nunca aos projetos hospedados. Nenhuma aprovação, produto,
override de feature flag, carga ou evidência de UAT foi inserida remotamente.

## Validação do SHA final

- `npm run check`: aprovado, incluindo format/lint/typecheck, 216 arquivos e 1.351 testes Vitest,
  suítes de contratos/segurança/release, avaliações e build dentro do orçamento executável.
- Banco real isolado da CI: 65 arquivos pgTAP, 2.110 testes, todos aprovados; inclui
  `rls_catalog_workspace_integration.test.sql`. As fixtures são transacionais e terminam em rollback.
- Browser automatizado da CI: aprovado. Não é homologação de Google Chrome real autenticado.
- Runtime Edge: 34 funções empacotadas duas vezes em caches independentes, bytes e atestações
  comparados antes da selagem, cold-boot sem egress externo. Mesmo runtime e digests pinados.
- Node permanece pinado pelo repositório; CLI Supabase `2.116.0`. Changelog e documentação atuais
  do Supabase foram consultados. Nenhuma dependência nos endpoints de logs removidos foi adicionada.
- Checkout CMS limpo após commit/push. Nenhum deploy, migration hospedada, carga, publicação,
  ativação global de flag ou cutover foi executado. Produção não foi alterada.

O desktop não dispõe de Docker/WSL/psql; a prova de banco é a execução real do Supabase isolado
na CI. Essa limitação não foi substituída por mock nem apresentada como validação de staging.

## Correção comprovada da CI

O [run 36511375975](https://github.com/Vnd93/gaiatec-cms/actions/runs/36511375975) falhou em
`G12_STAGING_CMS_PUBLIC_HOTFIX_CANDIDATE_SOURCE_REFUSED`: um empacotador de hotfix histórico
era aplicado indevidamente ao código novo. Banco, qualidade e navegador passaram; os gates
dependentes recusaram corretamente a entrega. Não houve mutação de ambiente nem retry cego.

O hotfix continua testado no SHA histórico exato
`e40eb0c2cc81c27fbf8f23e8671136f9dfc6f282`, sem alteração de seus pins de código, dependências ou
runtime. O candidato novo usa o inventário completo, com prova adicional obrigatória de dois
builds independentes idênticos. Apenas os bytes do candidato novo integram o artefato entregável;
o hotfix histórico não pode ser promovido como se fosse o candidato atual.

## Artefatos do run 36512509486, tentativa 1

| Artefato                                                  | ID            | Digest GitHub SHA-256                                              |
| --------------------------------------------------------- | ------------- | ------------------------------------------------------------------ |
| pacote completo `staging-frontend-486fa5c…-36512509486-1` | `11009422009` | `aacd8c8757635efc15939e0d108823206392fa2f48fc57f29cc46612eaaa1347` |
| inventário/bundles Edge                                   | `11009239960` | `05364ed7ed49fc6d52ee3c41016cbfd7fafd3cac966faa53e7403fa9ce2ba526` |
| payload de banco                                          | `11009481622` | `c71300173134979234c45d4aab48ea709f53cf46db6ae84945d174e4bc876580` |
| relatório de duração                                      | `11009832569` | `6b1d7d5b8cfcc6decfa41652331e26c006bdbf006d278c60751ef61d7ff87a9e` |

O pacote completo contém os mesmos bytes validados, não um rebuild equivalente. A existência do
artefato não é deploy nem autorização de promoção. Consumidores devem validar SHA, IDs, digests,
manifestos e estado do ambiente novamente no momento autorizado.

## Tempos reais da CI

| Etapa                                          | Baseline 36480366876 | Integração 36512509486 |
| ---------------------------------------------- | -------------------: | ---------------------: |
| preflight / release-plan                       |                 36 s |                   16 s |
| qualidade                                      |                231 s |                  215 s |
| runtime Edge                                   |                121 s |                  170 s |
| navegador automatizado                         |                133 s |                   96 s |
| banco isolado                                  |                160 s |                  172 s |
| pacote selado                                  |                 74 s |                  110 s |
| métricas                                       |                 13 s |                    9 s |
| total observado, incluindo fila e sobreposição |                368 s |                  359 s |

As validações independentes são paralelas; não somar as linhas. A lane de qualidade é a maior
validação paralela; o pacote vem depois dos gates. O runtime novo inclui uma segunda execução
completa obrigatória, e o pacote contém sua evidência. Estes dois runs não provam ganho estatístico.
Não houve release de staging nesta sessão: o SLO de 40–60 minutos do release completo não pode
ser declarado atingido usando apenas os 5min59s de CI.

## Gates restantes e ação necessária

1. Obter autorização específica para migrations/deploy e homologação restrita de staging no SHA
   final, mantendo a flag global desligada. A autorização atual não cobre mutação hospedada.
2. Antes de qualquer fixture mutante, comprovar recovery durável, writer único, fences e cleanup
   aplicáveis a todas as novas tabelas do catálogo. Não assumir que o cleanup legado cobre essas
   tabelas. Falha ou ausência de prova mantém o gate fechado, sem criar dados remotos.
3. Homologar os fluxos em Google Chrome real autenticado, backend real de staging, e executar
   rollback e verificação de resíduo zero; registrar deployment ID, snapshot do ambiente e digest.
4. Concluir recaptura e aprovação independente da
   [lista nominal CAT-D009](lista-nominal-prioritaria-cat-d009-2026-09-24.md). Os itens 17/18
   continuam `user-confirmed-provisional`; o item 20 continua bloqueado por completude.
5. Só então reavaliar o encerramento funcional. Não fazer publicação pública, carga, cutover ou
   produção por inferência. CAT-D010 permanece `deferred` até dois ciclos manuais reais estáveis.

Não existem aprovações funcionais fictícias nem evidência Chrome fabricada. A próxima sessão deve
reutilizar o trabalho versionado e validar apenas os gates ainda pendentes e os checkpoints
invalidados por mudança real de SHA/bytes/estado.
