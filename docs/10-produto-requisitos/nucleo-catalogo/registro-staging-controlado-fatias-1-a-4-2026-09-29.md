---
id: gaiatec-catalogo-staging-controlado-2026-09-29
titulo: Implantação controlada das Fatias 1–4 em staging e bloqueio do provedor de IA
status: implantado-staging-recuperado-homologacao-bloqueada
tipo: registro-de-execucao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-09-29
ultima_revisao: 2026-09-29
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - registro-integracao-fatias-1-a-4-2026-09-28.md
  - aprovacao-tecnica-plano-staging-2026-09-24.md
  - lista-nominal-prioritaria-cat-d009-2026-09-24.md
  - backlog-executavel-fatias-1-a-4-2026-09-24.md
  - matriz-rastreabilidade-ondas-1-a-4-2026-09-24.md
---

# Staging controlado: implantação executada, homologação ainda bloqueada

## Autorização e ponto correto de retomada

Em 29 de setembro, o usuário autorizou: “Autorizo migrations e deploy controlados exclusivamente em
staging”. A autorização permite esta implantação no projeto Supabase `glcqsosxwgmlhzgcsnzv` e no
Cloudflare de staging. Não autoriza publicação do catálogo, carga comercial, cutover, produção,
ativação de `ev2.catalog_v1`, autoaprovação nominal ou relaxamento dos gates.

O [registro de 28 de setembro](registro-integracao-fatias-1-a-4-2026-09-28.md) permanece histórico e
imutável. As Fatias 1–4 já estão implementadas; não devem ser refeitas. Nesta execução, as migrations
hospedadas e o deploy de backend avançaram, mas o release completo não terminou verde. O bloqueio
atual é a disponibilidade do modelo de IA aprovado, após a correção das falhas técnicas abaixo.

## Identidade e integridade da entrega

| Elemento                                   | Identidade exata                                                                       |
| ------------------------------------------ | -------------------------------------------------------------------------------------- |
| candidato da aplicação e rollback frontend | `87010df64300c4c41089f9d0fc74e6bd6ed1a6a7`                                             |
| controle do workflow executado em `main`   | `92b87565111d09d7b2eb25f3e1f307e9219d8766`                                             |
| CI do candidato                            | [36587692187 — success](https://github.com/Vnd93/gaiatec-cms/actions/runs/36587692187) |
| CI do controle                             | [36594653421 — success](https://github.com/Vnd93/gaiatec-cms/actions/runs/36594653421) |
| bridge preservado                          | [36589138106 — success](https://github.com/Vnd93/gaiatec-cms/actions/runs/36589138106) |
| deploy completo, tentativa 1               | [36595593172 — failure](https://github.com/Vnd93/gaiatec-cms/actions/runs/36595593172) |
| deployment Cloudflare canônico             | `70b24904-aa0c-4e1b-869c-4f9b2a05cde1`                                                 |
| origem de staging                          | `https://ev2-g17-canary.gaiatec-cms-staging.pages.dev`                                 |
| perfil                                     | `full-release`, `diagnostic_run=false`                                                 |
| archive SHA-256 do frontend                | `ebaf4ee0527024b520b6f8528a3022e0b1b678e7c78fac0126cec23281accfac`                     |
| tree SHA-256 do frontend                   | `ac0d453ebc894a2fe8f492308a4262ba783c0191dbd5e6197f672f689950fd9f`                     |

O controle `92b8756` contém somente a correção do vínculo do checkout de canários e seus testes. O
workflow valida o CI protegido desse controle e, separadamente, o candidato ancestral `87010df`, seu
CI, bridge, artefato e identidade viva. O pacote produzido pela CI de `92b8756` **não foi implantado**.
Não houve rebuild equivalente do candidato, troca de bytes nem reutilização de aprovação de outro
SHA. As aprovações funcionais ainda inexistentes não são inferidas dessa cadeia técnica.

### Artefatos imutáveis

IDs e digests abaixo são os registrados pelo GitHub. O workflow verificou os bindings antes de
consumir os bytes; os relatórios terminal, preliminar e de duração foram consultados após o término.

| Artefato / run                          | ID            | Digest GitHub SHA-256                                              |
| --------------------------------------- | ------------- | ------------------------------------------------------------------ |
| pacote unificado / 36587692187          | `11043170502` | `ddb5e5948257d21330501e470ec10dcb652852cd4cb9140034fbda7ce490434c` |
| inventário e bundles Edge / 36587692187 | `11042830605` | `ffe749587c96c707636fa300183b4b151dc2204779bb243dcdd07bbb0f24c43c` |
| payload de banco / 36587692187          | `11042333764` | `f3ca8af7c61e94d4709a85b02f02ee7d713c14013336825e1b4c84ca2707276b` |
| evidência bridge / 36589138106          | `11043413473` | `cd304a87e2c13ce7967467d62f07e67df71f56cd7d297c2cfe96305dd3f7aefe` |
| recovery pré-mutação / 36595593172      | `11045917297` | `69aa02169714e4527e55eb6097ee68fae132c249d685bf1c7c2c5e63a89cd723` |
| evidência preliminar / 36595593172      | `11047140964` | `96fadd390e9b37eaba8e851ad0256ff1bd8ee2bd0f1e22e4b85ad3171f2ac46b` |
| evidência terminal / 36595593172        | `11047761818` | `3c78d377909774660c1538d56ba0a92575a88d47c597e73adcc35f0b576f7749` |
| duração / 36595593172                   | `11048530523` | `f7f5fb33ee78b3a60b4692aac4d98637128a5015ab6484ce3342944c6f2fbe50` |

## Correções concluídas: não repetir investigação nem runs históricos

Cada falha foi diagnosticada antes de uma nova execução. Houve recuperação terminal comprovada
antes da retomada; nenhum retry foi usado para ignorar uma guarda.

| Falha comprovada                                                                               | Correção versionada                                                                                      | Evidência posterior                                                                                                                            |
| ---------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| parser de migrations com versões de quatro dígitos, aspas e coluna remota vazia                | `4365c081d125a16ceb087aa6d44ad9bf78029879`                                                               | CI `36566119097`; snapshot remoto corretamente distingue 105 aplicadas e 6 pendentes antes da implantação                                      |
| checkpoint bootstrap recusava bytes da matriz/política seladas                                 | `a58654e4c7108b15fcfd168975227a9e0579e18f`                                                               | CI `36570813447`; bootstrap `full-release` sem gates cacheados ou extensão de TTL                                                              |
| bridge interrompido por throttling de registry; recuperação recusava resultado CLI “No change” | `46f08708f6b4dd45eee02b96bca7d042e16e40c8`                                                               | recovery `36575263145` verde, com bundle/versão/timestamp estáveis e três sentinelas; CI `36574358082`                                         |
| configuração autorizada incrementava versões das 34 funções, provocando falsa deriva           | `bdd93cb56b8ad98f7e745dff84b16c3975308b0e` e teste de caminho `814195b4257a037cbce3c57d0541461227a26f55` | receipts estritos por etapa/SHA/run/attempt/baseline; CI `36582350985` verde; nenhuma tolerância genérica de drift                             |
| verificação de source usava checkout sem os arquivos Deno materializados do artefato           | `87010df64300c4c41089f9d0fc74e6bd6ed1a6a7`                                                               | verificação passa a consumir o mesmo source selado; 57 testes focados, `npm run check` e CI `36587692187` verdes                               |
| workspace isolado de migrations estava vinculado, mas checkout do canário não                  | `92b87565111d09d7b2eb25f3e1f307e9219d8766`                                                               | link do projeto exato após guarda de SHA/checkout limpo; 55 testes focados, `npm run check` e CI `36594653421` verdes; canário remoto aprovado |

A correção de linkage não removeu `project.linked === true`, não vinculou produção e não alterou o
payload de migrations. Os testes recusam projeto ausente, ref/nome/região errados, vínculo ausente,
falso ou com tipo incorreto antes de solicitar chaves ou criar fixtures.

Os deploys anteriores permaneceram reprovados, mesmo com finalizer verde:

| Run           | Bloqueio                                                         | Encerramento                                                                                       |
| ------------- | ---------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| `36569074004` | checkpoint antes de mutação                                      | finalizer seguro sem mutação armada                                                                |
| `36571706964` | registry antes do upload legado                                  | watchdog `36572810034` recusou recuperação ambígua; fence mantida até recovery `36575263145` verde |
| `36577142069` | deriva após configuração                                         | finalizer verde; watchdog `36579040584` verde                                                      |
| `36585170673` | source digest do checkout divergente dos arquivos materializados | finalizer verde; watchdog `36586684425` verde                                                      |
| `36591105403` | contexto do projeto não vinculado                                | finalizer verde; watchdog `36593185361` verde                                                      |

## O que passou no deploy 36595593172

- Preflight, validações independentes de source e baseline vivo, artefatos/digests exatos e recovery
  durável anterior à mutação.
- Migrations do payload isolado até `0111`, configuração com receipts e verificação dos mesmos bytes
  das 34 Edge Functions; banco, RLS, Storage e Vault verificados.
- Canary de migrations: **132 checks**, sem falha de operação/cleanup; fixtures ativas, sessões,
  credenciais, overrides, publicações e projeções ativas zerados.
- Compatibilidade do frontend de rollback com backend avançado e probe público de rotas.
- **Três janelas saudáveis G12**, 29/29 checks herdados G11, P0/P1 zero, segurança e restore aprovados.
- Regressões automatizadas de catálogo público, rotas, mobile, acessibilidade e CSP.

Node permanece pinado pelo repositório, executado localmente em `22.23.2`; Supabase CLI `2.116.0`.
O `npm run check` completo aprovou 1.351 testes Vitest em 216 arquivos, contratos, avaliações e
orçamento de build. A CI do candidato aprovou 2.110 testes pgTAP em 65 arquivos e os gates Edge.
Nenhum desses testes automatizados substitui Chrome real autenticado.

## Bloqueio atual: nenhum endpoint do modelo aprovado

O canário autenticado de IA recebeu HTTP `503`, `CMS_AI_PROVIDER_UNAVAILABLE`, com
`providerFailure=OPENROUTER_NO_ALLOWED_PROVIDER` e `preserved=true`. A política permanece no modelo
`inclusionai/ling-3.0-flash-vl:free`, `provider.zdr=true` e `provider.data_collection="deny"`.

Consulta somente leitura à [API de endpoints desse modelo](https://openrouter.ai/api/v1/models/inclusionai/ling-3.0-flash-vl%3Afree/endpoints),
às **16:41:29 UTC**, retornou `endpointCount=0`. A [documentação oficial de endpoints](https://openrouter.ai/docs/api/api-reference/endpoints/list-all-endpoints-for-a-model)
define essa resposta como o inventário de endpoints disponíveis. Isso sustenta a indisponibilidade
externa observada no canário; não autoriza trocar o modelo, permitir coleta, retirar ZDR ou atribuir
o erro a credenciais sem evidência.

O relatório `g17-staging-canary.json` ficou vazio na falha: não existe aprovação G17. Os jobs
`post_deploy_*`, `browser_attestation` e `evidence` ficaram `skipped`. Não foi produzido challenge
Chrome just-in-time nem atestado completo. A evidência terminal é de **recuperação**, não de release
funcional aprovado.

A decisão solicitada ao responsável é manter o modelo e aguardar sua disponibilidade, ou autorizar
seleção e validação de outro modelo gratuito com as mesmas restrições de privacidade. A simples
presença de um modelo em uma listagem pública não prova endpoint saudável nem elegibilidade da chave.
Nenhum substituto foi selecionado, configurado ou tratado como aprovado nesta execução.

## Recuperação e estado final observado

O finalizer convergiu o backend exato a partir do pacote persistido, preservando as migrations
aditivas. Não houve downgrade destrutivo de schema. Na verificação final das funções, nenhuma nova
mutação ou reconciliação foi necessária. Auth, configuração Edge e identidade canônica passaram nos
controles de recovery; variáveis redundantes foram removidas somente após comparação por CAS.

O [watchdog 36598690288](https://github.com/Vnd93/gaiatec-cms/actions/runs/36598690288) concluiu
`success`: classificação aprovada e compensação adicional `skipped`, pois o finalizer já encerrara
a recuperação. Conferência posterior: zero runs `queued`, `in_progress`, `waiting`, `pending` ou
`requested`; nenhuma variável de recovery/fence/lease no repositório ou ambiente staging.

| Verificação posterior                 | Resultado                                                                                      |
| ------------------------------------- | ---------------------------------------------------------------------------------------------- |
| histórico de migrations               | 111 aplicadas; última `0111`                                                                   |
| `ev2.catalog_v1` global               | `false`                                                                                        |
| overrides dessa flag                  | 0                                                                                              |
| produtos e snapshots do novo catálogo | 0 / 0                                                                                          |
| leases de QA ativos                   | 0                                                                                              |
| tabelas públicas do catálogo sem RLS  | 0                                                                                              |
| recovery de navegador                 | `already-terminal`; 8 leases terminais; zero restantes ativos; nenhuma credencial no relatório |
| probe terminal                        | `pass`; disponibilidade 100%; HTTP 5xx 0%; p95 725,879 ms; SHA/health exatos                   |

“Resíduo zero” aqui significa **zero resíduo ativo**, conforme os contratos. Auditoria imutável,
tombstones e fixtures arquivadas são preservados. O canário de migrations reportou uma mídia
sintética retida com um job de GC agendado; não se afirma exclusão física já concluída. O G12
reportou atores sintéticos retidos e lead anonimizado separadamente, sem credenciais, sessões,
overrides ou payload pessoal de lead ativos. Isso não representa carga de produtos do novo catálogo.

Não houve mutação de produção. Os advisories foram comparados: nenhuma ocorrência `ERROR`; o novo
aviso informativo da tabela de aprovações editoriais sem policy é deny-all intencional. Avisos
preexistentes de funções e proteção de senha não foram resolvidos reduzindo segurança nem alterando
configuração de Auth fora de escopo.

## Chrome real: limite da evidência obtida

Em **16:25:47 UTC**, Google Chrome real, sessão autenticada e backend real de staging exibiram
`/admin/nucleo-catalogo` com o título “Núcleo de Catálogo” e a mensagem “O novo catálogo está em
preparação. A leitura pública permanece no catálogo atual.” O header da rota confirmou o candidato
`87010df`. A inspeção foi somente leitura, sem mutações de catálogo.

Essa observação comprova somente a barreira default-off. Não comprova criação/edição, aprovação,
publicação, relações, páginas editoriais, ensaio real de rollback ou aprovação nominal CAT-D009.

## Tempos reais e SLO

| Etapa                                        | Duração observada | Resultado                        |
| -------------------------------------------- | ----------------: | -------------------------------- |
| CI do candidato `36587692187`                |             329 s | success                          |
| bridge `36589138106`                         |             825 s | success, reutilizado sem rebuild |
| CI do controle `36594653421`                 |             390 s | success                          |
| preflight do deploy atual                    |              40 s | success                          |
| source / baseline vivo, em paralelo          |      60 s / 163 s | success                          |
| lane serial de deploy                        |           1.065 s | failure no canário de IA         |
| finalizer                                    |             216 s | success                          |
| métricas                                     |              13 s | success                          |
| deploy atual completo: 16:09:03–16:34:16 UTC |           1.513 s | non-happy-path                   |

O artefato de métricas capturou 1.508 s às 16:34:11 UTC, antes do término do próprio job; o valor
1.513 s vem dos timestamps terminais do run. Validações paralelas não devem ser somadas.

O baseline versionado do pipeline é **2.759 s**, com confiança provisória até o primeiro full-release
verde. Os runs falhos anteriores `36577142069`, `36585170673` e `36591105403` duraram 894 s, 757 s e
986 s, respectivamente, mas pararam em gates diferentes: não são comparáveis como ganho de desempenho.
O run atual avançou até IA e incluiu recovery. Seus 25min13s **não demonstram** o SLO de 40–60 minutos
do caminho feliz ponta a ponta.

O relatório identifica a lane `deploy` como gargalo e, dentro dela, as três janelas G12 (269 s).
Outros gates concluídos custaram 144 s no canário de migrations, 90 s nas regressões de navegador e
77 s na compatibilidade de rollback. Nenhuma janela, teste de segurança, cleanup, recuperação ou
evidência terminal foi removida para reduzir esses tempos.

## Retomada segura e pendências reais

1. Resolver a decisão sobre o modelo indisponível. Não repetir o deploy enquanto o mesmo bloqueio
   persistir. Troca de modelo exige alteração versionada, testes, novo SHA/artefato e revalidação das
   aprovações/checkpoints dependentes; nenhuma substituição silenciosa em secrets.
2. Confirmar novamente writer único, lease/handoff, estado remoto terminal, árvores limpas e
   identidade Vnd93 antes de qualquer escrita. TTL expirado não transfere autorização.
3. Retomar os gates invalidados e restantes com SHA/digests/deployment/snapshot exatos e recovery
   durável. Reutilizar somente checkpoints independentes cuja validade continue comprovada.
4. Concluir o pipeline de staging e a homologação Chrome real. Só gerar challenge após os gates
   automáticos prévios e watcher pronto; preservar antirreplay, prazo e consentimentos exigidos.
5. Antes de fixtures mutantes específicas do catálogo, comprovar cleanup/recovery de todas as suas
   tabelas. Concluir UAT e rollback sem publicar, carregar dados comerciais ou ativar a flag global.
6. Completar a [lista nominal CAT-D009](lista-nominal-prioritaria-cat-d009-2026-09-24.md), com recaptura
   e aprovador independente. Itens 17/18 continuam `user-confirmed-provisional`; item 20 incompleto.
   CAT-D010 permanece `deferred` até dois ciclos manuais reais estáveis.

O lease permanece com o holder vigente, sem transferência implícita. As Fatias 1–4 estão
implementadas, mas ainda não são `done` operacionalmente. A pausa da automação histórica
`cms-organiza-o-p-s-handoff` não pôde ser confirmada pelas ferramentas disponíveis; isso não autoriza
uma nova execução mutante nem a criação de um agendamento duplicado.
