# Handoff controlado — fechamento final do CMS GAIATEC

> Estado de entrega: **NAO APROVADO PARA USO OPERACIONAL**. Este documento transfere o estado real
> da execucao; nao declara que o candidato foi homologado ou publicado.

## Checkpoint e lease de escrita

- Captura local: `2026-09-09T14:20:20-03:00` (`America/Sao_Paulo`).
- Captura UTC canonica: `2026-09-09T17:20:20.684Z`.
- Nenhum workflow remoto estava `queued` ou `in_progress` na consulta dos 100 runs mais recentes.
- Nenhuma operacao local atomica estava em andamento.
- A partir da publicacao deste handoff, Codex Desktop permanece somente leitura ate o claim explicito
  pelo Claude Code ou a devolucao/cancelamento explicito do handoff.
- Claim executado por Claude Code em `2026-09-09T17:58:05.187Z`. Codex Desktop permanece somente
  leitura ate a devolucao ou o cancelamento explicito deste lease.
- Revalidacao imediatamente anterior ao claim: perfil GitHub `Vnd93`; codigo em `main` com HEAD e
  `origin/main` iguais a `0ab1fa84eec65c762644ed9368bfcfb213402b17` e checkout limpo; documentacao em
  `docs/g12-production-release` igual a `2e29771c7df6eda8b13314c34601ec827f0f3b96`; nenhum run
  `queued` ou `in_progress` nos 100 mais recentes; `/healthz` de staging servindo `4b9184b3...` e o de
  producao servindo `f48bb453...`; Supabase staging `glcqsosxwgmlhzgcsnzv` com 34 Edge Functions,
  `cms-public` em 56 deployments e migrations `0001`-`0088`; Supabase production
  `chfuhctnhqgyjowkvllv` `Healthy` com ultima migration `cms_audit_identity_detach`.
- Limitacao observada na revalidacao: a lista de Edge Functions do projeto de producao nao renderiza
  no dashboard Supabase; o inventario de funcoes de producao deve ser confirmado pelo pipeline final.

```yaml
writerState: CLAIMED
currentWriter: CLAUDE_CODE
previousWriter: CODEX_DESKTOP
codeCandidateSha: 0ab1fa84eec65c762644ed9368bfcfb213402b17
capturedAt: 2026-09-09T17:20:20.684Z
claimedAt: 2026-09-09T17:58:05.187Z
```

## Objetivo integral e criterio de conclusao

Entregar o CMS GAIATEC, o frontend redesenhado, backend, banco, Edge Functions, integracoes,
Cloudflare e site publico totalmente funcionais e operacionais em producao. A aprovacao depende de
evidencia vinculada ao mesmo SHA e ao mesmo artefato para o ciclo real:

`criar -> rascunho incompleto -> fechar -> recuperar -> editar -> autosave -> recarregar -> validar
-> revisar -> comentar -> comparar diff -> aprovar -> visualizar -> publicar -> conferir no site
publico -> pesquisar -> atualizar -> republicar -> invalidar cache -> restaurar -> reverter release
-> despublicar -> conferir retirada -> arquivar`.

O escopo preservado inclui F-001 a F-018, RB-001 a RB-060, redesign, EV2, todas as superficies
descobertas no SHA final, navegacao, campos, acoes, permissoes, RLS, auditoria, consumidores publicos,
CMS/RDO, integracoes e infraestrutura. A precedencia e: instrucao vinculante; seguranca e gates;
documentacao canonica ativa; HTML apenas para decisoes visuais; codigo como estado atual; historico
apenas como evidencia imutavel. Devem ser reconciliados `src/admin/README.md`, `docs/ev2/README.md`,
`docs/30-cms`, ADRs, matrizes, controles de release, redesign, contratos, migrations e testes.

A conclusao exige, no minimo:

- 100% de requisitos, rotas, menus, abas, campos, acoes, APIs, Edge Functions, permissoes, RLS e
  consumidores classificados e aprovados, sem elemento nao testado nem `N/A` indevido;
- nenhuma operacao cotidiana dependente de JSON, UUID, slug, schema ou identificador tecnico;
- uma fonte canonica para produto/PIM, sem dual-write divergente e com reconciliacao v1/v2;
- Microsoft Edge real, sessao autenticada, MFA e backend real, inclusive duas sessoes para conflito;
- testes positivos e negativos de AAL/RLS/IDOR/XSS/injecao/CORS/rate limit/replay/payload alterado;
- cobertura responsiva em `390x844`, `768x1024`, `1440x900` e `1920x1080`, teclado, foco, contraste,
  leitor de tela, reduced motion e zoom de 200%;
- zero falha critica ou alta, erro relevante de console, 4xx/5xx inesperado, segredo ou dado pessoal;
- backup e restore drill, rollback, artefato imutavel, CI e pos-deploy aprovados no mesmo SHA;
- publicacao refletida no site publico e retirada/rollback comprovados;
- operador corporativo em producao com MFA normal e nenhum bypass ativo;
- `main` limpa, enviada ao `origin`, producao saudavel e SHA servido identificado.

Build, tela renderizada, handler acionado, mock, resposta simulada, teste isolado, navegador headless,
analise estatica ou canario parcial nao substituem prova de persistencia, auditoria e efeito publico.

## Repositorios e estado Git

| Item                                 | Estado no checkpoint                                                                |
| ------------------------------------ | ----------------------------------------------------------------------------------- |
| Perfil GitHub                        | `Vnd93`                                                                             |
| Codigo                               | `Vnd93/gaiatec-cms`                                                                 |
| Branch do codigo                     | `main`                                                                              |
| HEAD do codigo                       | `0ab1fa84eec65c762644ed9368bfcfb213402b17`                                          |
| `origin/main`                        | `0ab1fa84eec65c762644ed9368bfcfb213402b17`                                          |
| Checkout do codigo                   | limpo                                                                               |
| Candidato vigente                    | `0ab1fa84eec65c762644ed9368bfcfb213402b17`                                          |
| Candidato anterior                   | `63c1b563b3fb685e445960545fbabcaee84437bb`                                          |
| Documentacao                         | `Vnd93/gaiatec-documentacao`                                                        |
| Branch documental                    | `docs/g12-production-release`                                                       |
| Base documental antes do handoff     | `641889875e8d425f7902474e9f5e0700a4e8b5dc`                                          |
| Alteracoes preexistentes preservadas | `docs/ev2/README.md` modificado e estudo LLM nao rastreado; ambos fora deste commit |

O checkpoint inicialmente esperado, `63c1b563b3fb685e445960545fbabcaee84437bb`, foi substituido por
`0ab1fa84eec65c762644ed9368bfcfb213402b17` e nao pode ser usado como candidato final.

## Historico de commits e pushes relevantes

Todos os commits abaixo foram enviados sem force para `origin/main`:

| SHA curto | Commit                                      | Motivo                                                                                                               |
| --------- | ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `0ab1fa8` | `fix(qa): bind production evidence names`   | Vincula o manifesto terminal aos nomes reais dos arquivos de evidencia de producao e adiciona validacao fail-closed. |
| `63c1b56` | `fix(release): accept SQL created response` | Aceita HTTP 200 ou 201 apenas no preflight SQL do migration canary; o helper geral continua fail-closed.             |
| `4b9184b` | `fix(release): stabilize bridge gates`      | Estabiliza controles do bridge e originou o atual frontend canonico de staging.                                      |
| `b02263c` | `align staging database gates`              | Alinha gates do banco de staging.                                                                                    |
| `ff01b9d` | `verify idempotent deploys`                 | Verifica idempotencia de deploy.                                                                                     |
| `a4c5ea9` | `bind command idempotency`                  | Vincula idempotencia de comandos.                                                                                    |
| `58b6b29` | `canonicalize function inventory`           | Canonicaliza o inventario de funcoes.                                                                                |
| `5802338` | `tolerate variable visibility lag`          | Trata atraso de visibilidade de variavel sem enfraquecer o gate.                                                     |

A ultima correcao alterou apenas o materializador da matriz terminal e seu teste. Entre `4b9184b` e
`0ab1fa8` nao ha alteracao em `src`, `supabase/functions` ou `supabase/migrations`; isso preserva a
utilidade diagnostica das evidencias anteriores, mas nao autoriza usa-las para aprovar o SHA final.

## Testes locais e CI do SHA exato

### Candidato `0ab1fa84eec65c762644ed9368bfcfb213402b17`

- Validacao focada da ultima correcao: 21/21 testes, Prettier, ESLint e diff check aprovados.
- CI run `34377871781`, tentativa 1, `success`:
  <https://github.com/Vnd93/gaiatec-cms/actions/runs/34377871781>.
- Job quality `102555132955`: `npm run check`, 168 arquivos/1.052 testes, EV2/evals/integracoes,
  typecheck, lint, format, build de staging e auditoria com zero vulnerabilidade.
- Job database `102555133317`: reset local e 44 arquivos/1.544 assercoes pgTAP/RLS, aprovado.
- Job browser `102555133412`: 40 testes Playwright/Chromium headless, aprovados; nao substitui Edge.
- Artefato CI `10114757476`, nome
  `site-0ab1fa84eec65c762644ed9368bfcfb213402b17`, digest
  `sha256:2d21f6bf23c29e681a5b1070a43b090b5af538da00368b880cf5bb765d4b4fbf`, nao expirado.
- Manifesto interno: 1.490 arquivos, digest
  `sha256:0fbe235ec17345f73969eed26f6d5529dda43265b4494fb5ee8acc8fc2c0a786`.
- Esse e um build CI de staging; **nao** e o artefato final unico selado para staging e producao.

## Workflows e gates remotos

| Run / tentativa                                                                    | Workflow e SHA                             | Estado  | Resultado ou observacao                                                                     |
| ---------------------------------------------------------------------------------- | ------------------------------------------ | ------- | ------------------------------------------------------------------------------------------- |
| [`34377871781`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34377871781) / 1 | CI, `0ab1fa8`                              | success | Quality, database e browser aprovados.                                                      |
| [`34332351815`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34332351815) / 1 | staging frontend bridge, `4b9184b`         | success | Bridge legacy-f48, promocao canonica e cleanup aprovados.                                   |
| [`34367910654`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34367910654) / 1 | deploy staging, `4b9184b`                  | failure | Migrations e funcoes passaram; migration canary rejeitou HTTP 201 antes da correcao `63c1`. |
| [`34368713733`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34368713733) / 2 | deploy staging watchdog                    | success | Recuperacao, probe e compare-and-clear aprovados.                                           |
| [`34372327742`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34372327742) / 1 | CI, `63c1b56`                              | success | Evidencia superada pelo SHA atual.                                                          |
| [`34373095263`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34373095263) / 1 | bridge, `63c1b56`                          | failure | Parou antes de mutacao por recovery store ocupado.                                          |
| [`34373755969`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34373755969) / 1 | bridge watchdog                            | failure | Corrida com estado anterior; estado foi resolvido depois.                                   |
| [`34374494260`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34374494260) / 1 | bridge, `63c1b56`                          | failure | Preview e probe passaram; fixture detectou contrato legacy-f48 ausente.                     |
| [`34375290243`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34375290243) / 1 | bridge watchdog                            | success | Cleanup, zero residuo, alias original, probe e limpeza HMAC aprovados.                      |
| [`34296232516`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34296232516) / 1 | provisionar operador production, `f48bb45` | failure | Falhou no gate de SHA antes de qualquer mutacao externa.                                    |
| [`34069047721`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34069047721) / 1 | deploy production, `f48bb45`               | success | Release atualmente servido em producao, historico.                                          |
| [`34202958259`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34202958259) / 1 | backup production                          | success | Backup valido do release anterior; sem restore drill.                                       |
| [`34327900390`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34327900390) / 1 | backup production                          | failure | Preflight recusou configuracao de DB; sem mutacao nem artefato.                             |

No checkpoint nao ha run ativo, fila pendente nem variavel de recovery residual.

## Deployments, URLs, manifests e artefatos

| Ambiente         | URL / identidade                                       | Estado e SHA servido                                                                                                                                                                                                                                    |
| ---------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Staging canonico | <https://ev2-g17-canary.gaiatec-cms-staging.pages.dev> | `/healthz` 200/ready; `environment=staging`; SHA `4b9184b3616b4df64b55037029b8dd02d2751e1b`; deployment `6d4de4d3-5716-4659-8b3d-fce93071e193`; URL imutavel <https://6d4de4d3.gaiatec-cms-staging.pages.dev>.                                          |
| Preview isolado  | <https://42e8e886.gaiatec-cms-staging.pages.dev>       | `/healthz` 200/ready; SHA `63c1b563b3fb685e445960545fbabcaee84437bb`; deployment `42e8e886-c106-49dc-b60c-d6dbc5d068e2`; alias <https://ev2-g12-canary.gaiatec-cms-staging.pages.dev>.                                                                  |
| Producao         | <https://gaiatecsistemas.com.br>                       | `/healthz` 200/ready; `environment=production`; SHA `f48bb4530566456a0090a98cd39caf1cacb51b09`; URL Pages registrada <https://ddc96e7e.gaiatec-website.pages.dev>. O UUID completo do deployment nao existe na evidencia disponivel e nao foi inferido. |

O host base `https://gaiatec-cms-staging.pages.dev/healthz` responde 404 e nao e o alias canonico do
release. O candidato `0ab1fa8` nao esta implantado em staging nem em producao.

Artefatos relevantes:

- Bridge staging `4b9184b`: evidencia `10096579555`, digest
  `sha256:2228c40f3b4ac1d8a72e6acb3d92e42f407f19ba90a1767a88ac4eb4a57ba13b`; archive
  `sha256:9b12da734eaa26fe105ea020b78e4fa2ff2e57f1d5e72d5b0bfcac8aee6cd8ec`; tree
  `sha256:90e65340733fd91640426b024ee0eea9c71aabefe2ded6582181e73580761c22`.
- Recovery do bridge falho: `10113525792`, digest
  `sha256:aa4e24ae12ccef5330bcd56e793db158a51f06c9d87e9ac363b0dff0f08b1b9f`.
- Watchdog terminal: `10113622208`, digest
  `sha256:a2e2922d9f7bc06a4c7f7f0e46a743af080244ee4cdc2cec79dfb99685d90f94`.
- Preview isolado `63c1`: archive
  `sha256:4062bb81939fed801524a8ab457beb98453b2f114f6eecf664f528324d140944`.
- Release production `f48`: `9999946449`, digest
  `sha256:7db71dced257dcba2b9c836bcdd4db4f5c4859b21d49568ce074591564c388c0`.
- Backup production historico: `10046578442`, digest
  `sha256:58f0b27185cddb93f17aff2c1b51daba4b07708818ab2a1fe432d5cd3e25fe83`.

Ainda nao existe artefato final unico selado para `0ab1fa8`. Canary e producao devem usar exatamente
os mesmos bytes, sem recompilacao.

## Supabase, migrations, Storage e Edge Functions

- Projeto staging: `glcqsosxwgmlhzgcsnzv`.
- Projeto production: `chfuhctnhqgyjowkvllv`.
- Os projetos, environments GitHub e origens Cloudflare sao separados.
- Staging: migrations sequenciais `0001` a `0088` aplicadas e verificadas; ultima
  `0088_cms_runtime_integrity_followup.sql`.
- Production atual `f48`: evidencia historica confirma `0001` a `0056`; aplicar/verificar o candidato
  final continua pendente.
- Inventario de schema no codigo: 178 relacoes, 479 funcoes/RPCs e 4 buckets; classificacao terminal
  de runtime para o SHA final ainda pendente.
- Staging recebeu e verificou 34 Edge Functions ACTIVE no mesmo fonte backend de `0ab1`:
  `cms-ai`, `cms-ai-execute`, `cms-attributes`, `cms-bulk`, `cms-collaboration`, `cms-content`,
  `cms-controlled-vocabularies`, `cms-documents`, `cms-drafts-v2`, `cms-leads`, `cms-master-data`,
  `cms-media`, `cms-outbox-worker`, `cms-pim`, `cms-preview`, `cms-public`, `cms-quality`,
  `cms-recovery`, `cms-releases`, `cms-scopes`, `cms-search-admin`, `cms-session`, `cms-sites`,
  `cms-system`, `cms-users`, `cms-visual`, `lead-capture`, `rdo-command`, `rdo-invite`,
  `rdo-notify`, `rdo-otp`, `rdo-sign`, `rdo-team`, `submit-contact`.
- `cms-public` em staging esta ACTIVE v56 e serve o contrato sanitizado `public-v2`.
- Production atual possui 32 funcoes na evidencia `f48`; `cms-documents` e `cms-recovery` ainda nao
  fazem parte desse release e devem entrar apenas no deploy final controlado.
- Storage privado, RLS, modos JWT/no-JWT, Vault e regressao RDO passaram no deploy de staging 4b, mas
  a evidencia terminal do SHA final deve ser produzida pelo pipeline final.

Nao resetar o banco nem reaplicar manualmente migrations para documentar. O proximo pipeline deve
verificar idempotencia e estado remoto antes de qualquer aplicacao correspondente ao ambiente.

## Cloudflare Pages, Worker e saude

- Projeto Pages staging: `gaiatec-cms-staging`.
- Projeto Pages production: `gaiatec-website`.
- Nao existe deployment Cloudflare Worker separado. O roteador e o Worker Advanced Mode de Pages:
  `cloudflare/_worker.js` e parametrizado/copiado por `scripts/prepare-cloudflare-worker.mjs` para
  `dist/_worker.js`, incluido no artefato e implantado pelos comandos `wrangler pages deploy`.
- A identidade, URL, deployment e estado do Worker sao, portanto, os mesmos de cada deployment Pages.
  O manifest do staging canonico registra `_worker.js` com digest
  `sha256:6d9db774271de4993f271cdaf69f54c433cc220e98964b61ad15d8db675b2e8e`; o manifest de producao
  atual registra `sha256:b38590fa13dfe0f97613e4f1f74fbaaf7a94dce7e7413cbfbaa782a96b79c46a`.
- Os endpoints canonicos de `/healthz` e `release-manifest` descritos acima respondem com os SHAs
  registrados e headers de seguranca; staging esta `noindex`.
- Rotas React/Worker e CSP foram inventariadas estaticamente, mas a matriz terminal e os probes do
  candidato final ainda sao obrigatorios.
- Nao alterar o staging canonico `4b9184b` nem a producao saudavel `f48` apenas para preparar o
  handoff.

## Flags e configuracao por ambiente

| Ambiente/etapa            | Configuracao comprovada ou prevista                                                                                                                                                                                                                                                                                                                       |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Staging bridge atual      | `VITE_CMS_ENVIRONMENT=staging`, `VITE_CONTACT_CAPTCHA_ALWAYS=true`, `VITE_EV2_DRAFT_V2_CANDIDATE=false`; overrides sinteticos foram limpos e flags de banco permanecem default-off/fail-closed.                                                                                                                                                           |
| Production frontend final | Deve usar `VITE_CMS_ENVIRONMENT=production`, `VITE_CONTACT_CAPTCHA_ALWAYS=true` e manter `VITE_EV2_DRAFT_V2_CANDIDATE`, `MASTER_DATA`, `PIM`, `DAM`, `SEARCH_QUALITY`, `COLLABORATION_BULK`, `RBAC_SCOPED`, `VISUAL_STUDIO`, `MULTISITE`, `AI_ASSIST` e `SYSTEM_ASSURANCE` em `false` no artefato frontend, salvo gate individual aprovado e documentado. |
| Production backend final  | Workflow previsto habilita `CMS_EV2_PRODUCTION_ENABLED=true` e `CMS_AI_EXTERNAL_PROVIDER_ENABLED=true`; isso ainda nao foi aplicado para `0ab1`. IA deve permanecer no provedor/modelo aprovado, com revisao humana e kill switch.                                                                                                                        |

Nao afirmar flags efetivas do release `f48` alem do que seu artefato registra. Antes da promocao,
provar que o build nao carregou `.env.local`, configuracao local, endpoint ou credencial de staging.

## Nomes de secrets confirmados

Somente os nomes foram consultados; nenhum valor foi acessado ou registrado.

Staging:

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`
- `EVIDENCE_SALT`
- `RELEASE_GUARD_TOKEN`
- `STAGING_SUPABASE_ANON_KEY`
- `STAGING_SUPABASE_URL`
- `SUPABASE_ACCESS_TOKEN`

Production:

- `BACKUP_ENCRYPTION_PASSPHRASE`
- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_CACHE_PURGE_TOKEN`
- `EVIDENCE_SALT`
- `LEAD_EVIDENCE_SALT`
- `OPENROUTER_API_KEY`
- `OUTBOX_WORKER_SECRET`
- `PRODUCTION_AUTH_CANARY_EMAIL`
- `PRODUCTION_AUTH_CANARY_PASSWORD`
- `PRODUCTION_AUTH_CANARY_TOTP_SECRET`
- `PRODUCTION_OPERATOR_EMAIL`
- `PRODUCTION_SUPABASE_ANON_KEY`
- `PRODUCTION_SUPABASE_DB_URL`
- `PRODUCTION_SUPABASE_SERVICE_ROLE_KEY`
- `PRODUCTION_SUPABASE_URL`
- `RATE_LIMIT_SALT`
- `RELEASE_GUARD_TOKEN`
- `RESEND_API_KEY`
- `SUPABASE_ACCESS_TOKEN`
- `TURNSTILE_SECRET_KEY`
- `VITE_TURNSTILE_SITE_KEY`

Os nomes `PRODUCTION_AUTH_CANARY_PASSWORD` e `PRODUCTION_AUTH_CANARY_TOTP_SECRET` estao presentes e
resolvem somente o gate de disponibilidade dessas credenciais. Variaveis publicas de repositorio:
`GOOGLE_MAPS_BROWSER_KEY` e `TURNSTILE_STAGING_SITE_KEY`.

## Operador, MFA, CMS/RDO e auditoria

- O operador corporativo de staging autenticou em Microsoft Edge e abriu `/admin/auditoria`; a
  superficie autorizada de superadministracao CMS, menu e eventos de auditoria foram observados.
- Nenhum e-mail, UUID de usuario, senha, segredo TOTP, cookie ou armazenamento da sessao foi copiado.
- A conta corporativa nao deve ser usada para fixtures; testes destrutivos usam conta sintetica.
- A separacao CMS/RDO permanece obrigatoria. RLS, papel, escopo, AAL e auditoria devem ser confirmados
  positiva e negativamente no ciclo terminal.
- O workflow de operador production `34296232516` falhou antes de qualquer mutacao por divergencia
  de SHA. Portanto, operador production e MFA nao estao homologados para o candidato atual.
- Matricula, desafio correto/incorreto/expirado/reutilizado, renovacao, expiracao e revogacao de
  sessao ainda devem ser comprovados no SHA final.
- Nao ha evidencia suficiente para afirmar se existe bypass temporario ativo. Antes da aprovacao,
  provar que toda excecao expirou/foi removida e repetir login e fluxo critico com MFA normal.

## Evidencias reais de navegador e seguranca

- Navegador exigido: Microsoft Edge real, nao headless.
- Evidencia autenticada existente: staging `/admin/auditoria`, sidebar, papel CMS autorizado e eventos
  de auditoria; historica e insuficiente para aprovar `0ab1`.
- Documento legado foi atestado limpo pelo Microsoft Defender, aprovado por segundo ator AAL2 no
  Edge, e `cms_legacy_documents_promotion_ready()` retornou verdadeiro.
- Evidencia externa preservada: `cms-release-evidence/DEFENDER-STAGING-20260909-4b9184b3-001.txt`,
  digest `sha256:ae4c19de5781035ddf5f636052e27badc28d221a31edd1b0361929c657d163e4`.
- A evidencia acima esta vinculada a `4b9184b`; nao repeti-la apenas para outro formato, mas
  revalidar no SHA final quando o gate/bytes correspondentes exigirem.
- Homologacao terminal autenticada, quatro viewports, console/rede, ciclo editorial e MFA do SHA
  final ainda nao foram produzidos.
- Antes da submissao real do formulario publico protegido por Turnstile, obter a confirmacao humana
  exigida no momento da acao e nunca registrar resposta, token ou dado identificavel.

## Matriz de cobertura transportada

O inventario estrutural transportado e util para continuidade porque nao houve diff em `src` ou no
backend desde `4b9184b`; ele nao substitui a regeneracao e a evidencia runtime do SHA final:

| Dimensao                           |                                                 Quantidade transportada |
| ---------------------------------- | ----------------------------------------------------------------------: |
| Rotas administrativas              |                                                             36 patterns |
| Superficies administrativas        |                                                                      52 |
| Destinos de navegacao              |                                                                      29 |
| Controles unicos                   |  1.010: 505 fields, 373 actions, 79 links, 26 forms, 23 tabs, 4 dialogs |
| Chamadas frontend                  |                                                                     156 |
| Rotas publicas                     |                                                                      53 |
| Edge Functions                     |                                                                      34 |
| Chamadas backend                   |                                                                     293 |
| Bindings helper/API para Edge      |                                                                      24 |
| Relacoes / funcoes-RPC / buckets   |                                                           178 / 479 / 4 |
| Permissoes                         |                                                                     216 |
| Requisitos / regras / divergencias |                                                             18 / 60 / 3 |
| Bindings controle-superficie       | 3.852: 3.818 obrigatorios e 34 `N/A` canonicos sujeitos a revisao final |
| Provas superficie-viewport         |                                                                     208 |
| Disposicoes controle-viewport      |                                                                  15.408 |
| Contratos de campo / acao / abas   |                                                     1.648 / 2.103 / 101 |
| Consumidores publicos              |                                         118 contratos em 42 superficies |

Fonte transportada verificavel: artifact GitHub `10110922714`, nome
`staging-4b9184b3616b4df64b55037029b8dd02d2751e1b`, do run `34367910654`, digest do artifact
`sha256:c29ca5e7279c53dffc45da7a4af60a43a00cee923be76a1fdf50878ba7000c55`, nao expirado. Dentro dele,
`candidate/outputs/g12-cms-coverage-matrix.json` tem 26.288.615 bytes, digest
`sha256:03104d349b295d672ffa327ee17972ff8298b23cc807890474266d43450aab1d`, `sourceSha=4b9184b...`,
`sourceDirty=false`, 52 linhas de superficies e secoes detalhadas de controles, chamadas frontend,
rotas publicas, Edge Functions, bindings, chamadas backend e inventario de migrations. O gerador
versionado no candidato e `scripts/qa/cms-coverage-inventory.mjs`; o materializador terminal e
`scripts/qa/materialize-cms-terminal-coverage.mjs`.

Esse artifact e uma ancora auditavel para continuidade, nao uma aprovacao de `0ab1`. A matriz final
deve ser regenerada no SHA final, conter a evidencia runtime e receber novo digest/artefato.

A matriz terminal deve conter identificador, origem, requisito, menu/aba/rota, persona, finalidade,
campos/limites, semantica, estados, permissao/escopo/site/ambiente/flag/AAL, contrato/API/Edge,
RPC/tabela/Storage/integracao, `consumer_id`, cenarios positivos e negativos, concorrencia,
idempotencia, persistencia, auditoria, efeito publico, testes, evidencia, erro, causa, correcao e
status. Deve falhar com rota ou controle orfao, campo sem consumidor/finalidade, acao sem efeito,
backend sem teste, consumidor de payload editorial bruto, nao testado ou `N/A` sem justificativa.

Saidas canonicas esperadas, ainda ausentes para `0ab1`:

- Staging: `candidate/outputs/cms-terminal-coverage-matrix.json`.
- Production: `candidate/outputs/cms-terminal-coverage-matrix-production.json`.

A matriz deve ser regenerada depois de qualquer correcao e antes da homologacao final.

## Dados sinteticos e auditoria preservada

- Tag do migration canary anterior: `QA-CMS-FINAL-20260909-4b9184b3`. A operacao de ator nao iniciou
  por causa do erro HTTP 201; o relatorio confirmou zero residuo, zero mutacao de producao e nenhum
  segredo persistido.
- O bridge `63c1` criou fixture isolada; cleanup e residue passaram, residuo ativo ficou zero e os
  eventos de setup/cleanup foram preservados em auditoria.
- O conjunto terminal unico `QA-CMS-FINAL-<AAAAMMDD>-<sha-curto>` ainda nao foi criado para o SHA
  final. Deve conectar fabricante, marca, linha, categoria, vocabularios, atributos, quatro entidades
  de descoberta, produto/modelo/variante/SKU, midia, documento, conteudo, paginas, campanha,
  formulario, lead, SEO, redirect/retirada, tarefa, comentario, release, site/ambiente e proposta de
  IA quando elegivel.
- Ao terminar, despublicar/arquivar/remover conforme a politica, provar retirada e zero residuo ativo,
  sem apagar auditoria imutavel.

## Erros, causas raiz e correcoes

### Corrigido no candidato atual

- Erro: o manifesto terminal procurava nomes genericos enquanto o pipeline produzia arquivos com
  sufixo `-production`.
- Causa raiz: bindings de nomes divergentes entre produtor e materializador.
- Correcao `0ab1fa8`: nomes reais para setup, cleanup, residuo, SHA e matriz de producao, validacao
  fail-closed e teste de regressao; 21/21 testes focados e CI completo aprovados.

### Corrigido no candidato anterior

- Erro: Supabase Management `/database/query` retornou HTTP 201 em sucesso e o migration canary
  aceitava somente 200.
- Correcao `63c1b56`: aceitar 200/201 apenas nesse preflight, com regressao e helper geral intacto.

### Bloqueio atual ainda nao corrigido

- Rota/acao: staging frontend bridge, setup de fixture publica do formulario.
- Esperado: provar o frontend candidato contra o contrato real legacy-f48 ainda servido em producao.
- Obtido: `QA_CMS_PUBLIC_BRIDGE_LEGACY_FORM_CONTRACT_NOT_LIVE` no run `34374494260`.
- Causa raiz: o deploy staging anterior atualizou `cms-public` para `public-v2`, que remove IDs e
  metadados internos; o gate exige deliberadamente o shape legacy-f48 (`formId`, `versionId`, SLA,
  retencao e status) para provar compatibilidade com o backend atual de producao.
- Nao corrigir aceitando silenciosamente ambos os contratos. Isso enfraqueceria a evidencia.
- Cleanup compensatorio terminou com zero residuo, auditoria preservada, alias canonico intacto e
  recovery state limpo.

## Gates aprovados e pendentes

### Aprovados ou reutilizaveis como diagnostico

- Perfil, repo, `main`, checkout limpo e `origin/main` igual ao HEAD.
- CI completo `34377871781` para `0ab1`, inclusive testes locais/RLS e artefato CI.
- Separacao staging/production em Supabase, GitHub environments e Cloudflare.
- Staging com migrations `0001`-`0088` e 34 Edge Functions verificadas no mesmo fonte backend.
- Recuperacao, zero residuo e ausencia de lease/recovery remoto apos os runs falhos.
- `/healthz` do staging canonico e da producao atual saudaveis.
- Bridge legacy-f48 `4b9184b` e aprovacao Defender/Edge historicos, apenas como diagnostico.
- Presenca dos nomes de secrets de auth canary production.

### Pendentes e bloqueantes para aprovacao operacional

1. Corrigir minimamente o bridge para oferecer backend legacy-f48 isolado/temporario e restaurar
   `cms-public public-v2` em `finally`, com regressao e evidencia de zero residuo.
2. Como essa correcao mudara o SHA, gerar novo candidato e revalidar todos os gates vinculados.
3. Executar novo staging frontend bridge contra o SHA final e o baseline canonico `4b9184b`.
4. Executar deploy integral de staging, migration/RLS canary idempotente, inventario de funcoes e
   gerar/selar o unico artefato final.
5. Resolver a revisao documental canonica e regenerar a matriz integral do SHA final.
6. Homologar em Edge autenticado/MFA com backend real, duas sessoes, ciclo editorial completo e
   quatro viewports, incluindo console/rede e consumidores publicos.
7. Validar negativas RLS/AAL/IDOR/XSS/injecao/CORS/rate limit/replay/payload, bundle e secret scan.
8. Validar Supabase Auth, Storage, RPCs, todas as Edge Functions, RDO, Turnstile, Resend, outbox,
   OpenRouter, cache, Worker, CSP, logs e auditoria imutavel.
9. Executar backup e restore drill validos para o SHA final e provar rollback.
10. Provisionar/validar operador production e MFA normal no SHA final, sem bypass ativo.
11. Obter apenas as autorizacoes literais emitidas pelos gates para o SHA final.
12. Promover os mesmos bytes para producao, aplicar migrations/funcoes no projeto correto, executar
    smoke, E2E autenticado, probes, janela de saude, rollback testado e cleanup final.
13. Materializar as matrizes terminais de staging e production e emitir o relatorio final verdadeiro.

## Proxima acao exata

Sem iniciar novo deploy ou migration, o proximo escritor deve:

1. Fazer claim explicito do lease e verificar novamente GitHub/profile, `main`, HEAD/origin, checkout
   e runs ativos.
2. Implementar uma correcao minima no workflow/script do bridge que:
   - capture versao/digest atuais de `cms-public` no staging;
   - publique temporariamente **somente** `cms-public` do SHA historico
     `f48bb4530566456a0090a98cd39caf1cacb51b09` no projeto staging
     `glcqsosxwgmlhzgcsnzv`;
   - confirme que apenas o contrato publico de formulario corresponde a legacy-f48;
   - execute fixtures sinteticas sem tocar producao;
   - restaure em `finally` somente o `cms-public` do candidato atual, mesmo em falha;
   - prove `public-v2`, ausencia de UUID/metadados internos, zero residuo e estado de recovery limpo;
   - inclua teste de regressao e concorrencia exclusiva para impedir dois bridges simultaneos.
3. Executar os testes focados, commit/push direto em `main`, obter o novo SHA e invalidar/revincular
   toda evidencia dependente do SHA.
4. Somente depois, despachar um novo `promote-staging-frontend-bridge.yml` para o novo SHA, usando
   `4b9184b3616b4df64b55037029b8dd02d2751e1b` como baseline esperado. Nao reexecutar o run `63c1`.

Se houver infraestrutura isolada disponivel para o backend legacy, ela e preferivel. Caso contrario,
a troca temporaria em staging deve ser serializada, sintetica, auditada e possuir restauracao
fail-safe independente do resultado do bridge.

## Autorizacoes literais e validade

- Recebida anteriormente:
  `AUTORIZO-RENOVAR-OPERADOR-CMS:f48bb4530566456a0090a98cd39caf1cacb51b09:365-DIAS`.
  Foi fornecida duas vezes, mas e valida apenas para `f48bb453...`; o workflow falhou antes de mutar e
  ela esta invalida para `0ab1` ou qualquer SHA futuro.
- Controle historico de producao:
  `AUTORIZO-G12-PRODUCAO:f48bb4530566456a0090a98cd39caf1cacb51b09`, valido somente para o release
  `f48` ja implantado.
- Nao reutilizar qualquer literal. Quando um gate futuro solicitar autorizacao ligada ao SHA final,
  apresentar somente a frase exata emitida por esse gate e aguardar.

## NAO REPETIR

- Nao rerodar CI `34377871781` nem qualquer run ja terminal apenas para outro formato de relatorio.
- Nao reutilizar artefato/evidencia de SHA anterior para aprovar o SHA final.
- Nao reexecutar `34374494260`; criar novo run somente depois da correcao do baseline legacy.
- Nao reaplicar/resetar migrations `0001`-`0088` nem redeployar manualmente as 34 funcoes para
  documentar; o pipeline final deve verificar/aplicar idempotentemente o necessario.
- Nao limpar recovery state as cegas; ele ja foi compare-and-clear e esta ausente.
- Nao promover o preview `63c1`, alterar staging canonico `4b` ou redeployar/rollbackar producao `f48`
  como parte do handoff.
- Nao repetir Defender/Edge apenas para gerar outro formato; revalidar quando o SHA/bytes exigirem.
- Nao usar operador corporativo para fixtures e nao usar dados comerciais reais.
- Nao cancelar workflows saudaveis, duplicar canario/deploy, modificar allowlist documental do codigo
  nem adicionar `AGENTS.md`/`HANDOFF.md` ao repositorio executavel durante o release.

## REVALIDAR SE O SHA MUDAR

- CI e checks, inventario/matrizes, build, manifest, seal, tree/archive digests e secret scan.
- Migration/RLS canary, inventario/digests de Edge Functions e regressao RDO.
- Bridge, canario, Microsoft Edge autenticado, MFA/AAL, quatro viewports e ciclo editorial.
- Autorizacao negativa, consumidores publicos, cache/SEO, Turnstile, Resend/outbox e OpenRouter.
- Backup/restore, rollback, autorizacoes literais, deploy de producao, smoke/E2E/probes/janela de saude.
- Cleanup dos sinteticos, auditoria preservada e relatorio final.

## Limitacoes reais abertas

- `0ab1fa8` nao esta live em staging nem producao.
- O bloqueio imediato e a incompatibilidade deliberadamente detectada entre o baseline legacy-f48
  exigido pelo bridge e o `public-v2` atualmente servido em staging.
- A matriz terminal runtime do SHA final ainda nao existe.
- O artefato final unico canario-producao ainda nao foi selado.
- Operador/MFA production, backup/restore, integracoes e ciclo Edge final ainda nao foram aprovados.
- Producao `f48` esta saudavel, mas nao e o candidato atual e nao fundamenta aprovacao operacional.

O unico bloqueio para iniciar a proxima etapa e implementar com seguranca a ponte de compatibilidade
legacy em staging com restauracao fail-safe. Todos os demais itens acima sao gates subsequentes, nao
motivos para enfraquecer ou omitir essa correcao.
