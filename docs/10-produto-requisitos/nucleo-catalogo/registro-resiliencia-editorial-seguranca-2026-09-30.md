---
id: gaiatec-catalogo-resiliencia-editorial-seguranca-2026-09-30
titulo: Resiliência editorial, dependências e G17 canônico em staging
status: realocacao-chrome-implementada-homologacao-bloqueada-g11
tipo: registro-de-execucao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-09-30
ultima_revisao: 2026-09-30
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - registro-modelo-gratuito-zdr-2026-09-29.md
  - registro-integracao-fatias-1-a-4-2026-09-28.md
  - backlog-executavel-fatias-1-a-4-2026-09-24.md
  - lista-nominal-prioritaria-cat-d009-2026-09-24.md
  - ../../00-indice/status-atual.md
---

# Captação positiva realocada para Chrome; homologação bloqueada em G11

## Resultado vigente: recuperação comprovada, sem aprovação do release

O SHA servido em staging é `88e9bcf8a324d35b12dba3c4f8cd522011270d26`, com check local, CI e
ponte verdes. Seu diagnóstico único `36742897039` reprovou G11, landing editorial e primeiro cleanup.
A recuperação prevista terminou limpa. A correção G7 de produtos não foi alcançada pelo run;
continua sem validação remota. Não houve run canônico subsequente, challenge ou captação positiva.

Uma lacuna de diagnóstico do cleanup foi confirmada e corrigida no código: os rótulos constantes
das etapas recusadas passam a ser preservados com indicadores de resíduo/auditoria. Nenhuma mensagem
bruta, payload, identificação de ator ou credencial entra no relatório. O ajuste não muda operações,
condições de reprovação, retries, RLS, AAL2, budgets ou runtime. A revisão e a validação exatas são
registradas abaixo. O código em `origin/main` avançou para `830664f6384e6bf15e19b91816b82ccc42ba1ef6`;
não foi promovido a staging. Não reimplementar Fatias 1–4 nem a realocação Chrome já aprovada.

## Resultado histórico anterior à validação remota da fixture G7

Após o diagnóstico dirigido descrito abaixo, o candidato
`88e9bcf8a324d35b12dba3c4f8cd522011270d26` corrigiu a fixture G7 com dados governados e isolados.
Passou no check local completo; a homologação remota desse novo SHA continua pendente.
Os resultados anteriores permanecem históricos, não autorização reaproveitável.

A realocação aprovada foi implementada em `cccedddc22b895a58f8bca74b649ede3200a1572`, com check
completo, CI e ponte aprovados. O controle adicional `624eaf0b1256485fbe8ae1174c8219ff94846885`
também passou no check e CI. O run canônico `36725530364` consumiu os mesmos bytes, mas foi
interrompido pelo budget de latência G11 antes do Chrome. Finalizer e watchdog recuperaram staging;
a seção de execução abaixo registra a falha, sem converter CI verde em homologação funcional.

Antes da aprovação de sequência abaixo, o candidato `035350ad690dcba40bd4542705a6b184b01b87bc` foi
implantado exclusivamente em staging, com o mesmo pacote selado no CI e promovido pela ponte.
O run canônico passou G11, G12 e G17, mas **não homologou o release**: o ciclo editorial tentou
captar um lead usando um token dummy incompatível com a prova Turnstile exigida. Finalizer e
watchdog terminaram verdes. Não houve retry do run, redução de proteção ou operação de produção.

O trabalho integrado das Fatias 1–4 permanece preservado; não deve ser reiniciado. Não houve
carga comercial, publicação do catálogo ou cutover. A flag `ev2.catalog_v1` continua desligada.
Os horários deste registro são UTC; a execução atravessou a noite de 29 para 30 de setembro em BRT.

## Correções em main

| SHA completo                               | Alteração e prova                                                                                                                                                                                                                                             |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `95c21a5a6eaba362e626b454e336d5c17a9ca2fc` | Leitura do formulário público via GET na RPC STABLE, seletores nulos omitidos e retry interno do SDK desligado; preservados teto de 900 ms e duas tentativas externas de leitura, sem retry de escrita ou recusa de autorização. 37 testes focados passaram.  |
| `a94c33d903416587f6136e88a2bd1b2e3d7d3a6d` | Patches de segurança Undici 7.29.1/8.10.2; a primeira forma de overrides passou localmente, mas falhou no npm 10.9.8 da CI. Nenhum pacote final foi promovido.                                                                                                |
| `9752b9dd61654bbd770806a3f8858e0bc1de4771` | Overrides por major da dependência folha, sem alterar os bytes do lockfile anterior. Instalação limpa com npm 10.9.8 e CI completos passaram; novos alertas independentes do Dependabot impediram promoção.                                                   |
| `5ae3566e3a094b8a58402a0a77ff7eec0b1c2a21` | Patches brace-expansion 1.1.21/2.1.7/5.0.12, sem upgrade de major consumidor. Três entradas do lockfile alteradas; metadados libc preservados. Audit e Dependabot zerados.                                                                                    |
| `035350ad690dcba40bd4542705a6b184b01b87bc` | Referências sintéticas de G17 mantêm o UUID completo, evitando colisão de prefixo numérico truncado com o detector de telefone. Quatro regressões SQL e contratos Node adicionados/ajustados; detector, modelo, prompt, schema e runtime não foram alterados. |

O `npm run check` final passou com 220 arquivos/1.388 testes Vitest, suites Node, evals, lint,
tipos e build de 28,22 s. O budget dos quatro chunks iniciais ficou em 798.432 bytes. Permanecem
16 skips de symlink específicos de Windows já existentes. O primeiro check da correção G17
identificou o contador pgTAP complementar ainda em 46; ele foi atualizado para 50 e o check completo
foi repetido com sucesso, sem remoção de testes. A CI final aprovou 65 arquivos/2.137 testes pgTAP.

Node 22, CLI Supabase 2.116.0 e locks Deno foram preservados. Não houve atualização ampla de
dependências. As correções de segurança foram conferidas nas fontes primárias:
[Undici 7.29.1](https://github.com/nodejs/undici/releases/tag/v7.29.1),
[Undici 8.10.2](https://github.com/nodejs/undici/releases/tag/v8.10.2),
[brace-expansion GHSA-q2hr-2g5m-vwhr](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-q2hr-2g5m-vwhr),
[GHSA-qhr7-859c-m2p7](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-qhr7-859c-m2p7) e
[GHSA-6j4f-fj2g-mc7p](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-6j4f-fj2g-mc7p).

## Histórico de runs e baseline real

| Run                                                                          | SHA curto | Resultado                                                                     | Duração |
| ---------------------------------------------------------------------------- | --------- | ----------------------------------------------------------------------------- | ------- |
| [36650624152](https://github.com/Vnd93/gaiatec-cms/actions/runs/36650624152) | `95c21a5` | CI bloqueado por audit Undici; lanes funcionais verdes                        | 328 s   |
| [36651628213](https://github.com/Vnd93/gaiatec-cms/actions/runs/36651628213) | `a94c33d` | CI bloqueado por instalação npm 10.9.8                                        | 218 s   |
| [36652204008](https://github.com/Vnd93/gaiatec-cms/actions/runs/36652204008) | `9752b9d` | CI verde; não promovido devido aos alertas brace-expansion                    | 452 s   |
| [36653515334](https://github.com/Vnd93/gaiatec-cms/actions/runs/36653515334) | `5ae3566` | CI verde                                                                      | 475 s   |
| [36654315402](https://github.com/Vnd93/gaiatec-cms/actions/runs/36654315402) | `5ae3566` | Ponte verde; watchdog `36655114487` skipped                                   | 597 s   |
| [36655248545](https://github.com/Vnd93/gaiatec-cms/actions/runs/36655248545) | `5ae3566` | Deploy reprovado em G17; finalizer 148 s verde e watchdog `36657273172` verde | 1.538 s |
| [36658205367](https://github.com/Vnd93/gaiatec-cms/actions/runs/36658205367) | `035350a` | CI verde, attempt 1                                                           | 429 s   |
| [36658865515](https://github.com/Vnd93/gaiatec-cms/actions/runs/36658865515) | `035350a` | Ponte verde; watchdog `36659591120` skipped                                   | 554 s   |
| [36660065421](https://github.com/Vnd93/gaiatec-cms/actions/runs/36660065421) | `035350a` | Deploy reprovado na captação editorial; recuperação verde                     | 1.495 s |

O run automático duplicado de push `36651625981` foi cancelado pela concorrência do CI; não foi
um retry manual nem produziu artefato promovido. Todos os candidatos seguintes corresponderam a
correções distintas, com novo SHA e nova validação, não a reruns cegos de uma falha.

No candidato final, o CI durou 7m09, a ponte 9m14 e o deploy encerrado com recuperação 24m55.
A soma é 41m18; o intervalo entre início do CI e fim do deploy foi 48m43. **Isso não comprova o SLO
de caminho feliz de 40–60 minutos**, pois Chrome e evidência final não executaram. Não há comparação
end-to-end verde válida com os candidatos anteriores que pararam em gates diferentes.

| Etapa do run `36660065421`                               | Tempo observado |
| -------------------------------------------------------- | --------------- |
| Preflight                                                | 32 s            |
| Validação de fonte, paralela ao baseline                 | 48 s            |
| Validação do baseline real                               | 115 s           |
| Job serial deploy, incluindo gates até a falha editorial | 1.161 s         |
| Dentro do deploy: download do pacote selado              | 42 s            |
| Dentro do deploy: canário de migrations sintéticas       | 142 s           |
| Dentro do deploy: G11 herdado e três janelas G12         | cerca de 273 s  |
| Finalizer                                                | 159 s           |
| Métricas                                                 | 13 s            |

As linhas internas não devem ser somadas novamente ao job deploy. O caminho serial de validação
continua concentrando a duração; a incompatibilidade da captação é o bloqueio funcional imediato.
Nenhum limite de produto, amostra lenta, teste de segurança ou recuperação foi removido para atingir tempo.

## Pacote, deployment e evidências do candidato final

- CI `36658205367`, attempt 1, perfil `full-release` (bootstrap sem checkpoint terminal verde).
- Artefato final `11073600773`, digest SHA-256
  `53fd3bf600cd35e43f6cbd49de2ce56d468bc39f18c0b0b6d482478a2ad9eab2`.
- Dist archive SHA-256 `cf262f8b9cb26438364f296f130a064a9922d29a21f8eda3d10c0d01497cb516`.
- Dist tree SHA-256 `74922456212680b140bfa344c62c766ac9ab8eea59ff5e2daa097810bc74d5cc`.
- Ponte `36658865515`, evidência `11073328319`, digest
  `4047001d21354fdd9a0597b7e431a9f8904f7a777ddbf40030f7c78c9a4680d0`.
- Deployment canônico `5820955e-dfc7-4dc8-8497-7ab57fb4f8b7`, criado em `2026-09-30T02:20:25.750Z`,
  marcador `g12-staging-bridge-run-36658865515-1`.
- Deploy canônico `36660065421`: início `02:29:17Z`, término `02:54:12Z`, attempt 1,
  candidato e rollback `035350ad690dcba40bd4542705a6b184b01b87bc`, `diagnostic_run=false`.
- Evidência preliminar `11073913788`, digest
  `253e2b37789f87a43fdff577ffb89cc279d13e51d5409306236087f0ec62183a`.
- Estado durável `11073374828`, digest
  `3e13e01201f2e17a7caee0c57b6941c0ae1b5c01d67706084b4857d1d0ca6f1f`.
- Recovery `11073683902`, digest
  `8b9999ae8030b8119197c9c0c0b2cdbf6ee17a58ff04add4d78ff13448370fba`.
- Evidência terminal de recuperação `11074716859`, digest
  `5e76ca08e33547e3ada92d7b6ae604af76adfa3e49a3a73a2b6292bda29bfd40`.
- Relatório de duração `11074483900`, digest
  `e76f1501fe11aa69afb70860bcd646c4b3ec3ed67c8880734f04985e48f95d04`.
- Watchdog [36661969245](https://github.com/Vnd93/gaiatec-cms/actions/runs/36661969245): sucesso,
  terminado às `02:55:07Z`.

O artefato terminal comprova recuperação, não aprovação funcional do release. Nenhum rebuild
equivalente substituiu o pacote selado. A ponte comprovou compatibilidade/fail-closed, não envio
positivo de formulário nem homologação Chrome.

## Diagnósticos e progresso efetivamente provado

### G17 e privacidade

O run anterior `36655248545` falhou com `CMS_AI_UNREDACTED_DATA`. Uma consulta pura ao detector
reproduziu a recusa de referências com oito dígitos provenientes de UUID truncado; o UUID completo
foi aceito. E-mail/telefone em conteúdo aninhado continuaram recusados. O payload rejeitado original
não foi retido: não é possível atribuir sua causa exclusiva ao prefixo. A auditoria agregada mostrou
uma chamada de provedor bem-sucedida, com 207 tokens de entrada e 72 de saída, sem reter conteúdo.

Depois da correção, o **G17 canônico aprovou 12 checks** em `36660065421`, usando inferência real
com `inclusionai/ling-3.0-flash-sante:free`. Dois atores foram limpos, zero linhas de negócio ativas,
auditoria mantida. ZDR, coleta negada, preços máximos zero e proibição de fallback pago permanecem.
Não houve mudança do modelo nesta rodada.

### Desempenho e formulário público

No `5ae3566`, G11 passou 29/29: p95 servidor de leitura 180 ms e comando 401 ms; wall 495/659 ms.
No `035350a`, passou novamente 29/29: p95 servidor 97/268 ms, wall 532/817 ms. Os budgets de servidor
500/800 ms ficaram inalterados; tempos wall são apresentados separadamente e não ocultados.
As três janelas G12 tiveram 100% de disponibilidade, zero 5xx, segurança e restore aprovados,
RPO 0/RTO 1 minuto, sem promoção stable.

O ciclo editorial final aprovou identidade do shell, RBAC, recusa de publicação em AAL1, formulário
versionado, agendamento/publicação/restauração de blog e renderização da campanha/formulário. A falha
anterior de HTTP 503 nessa etapa não se repetiu neste run. Isso comprova esta execução, não estabilidade
universal nem causalidade exclusiva da correção de retry. O incidente Supabase observado no diagnóstico
anterior tampouco prova a causa de todos os atrasos históricos.

### Bloqueio diagnosticado antes da aprovação: prova positiva do Turnstile

Em `scripts/phase7/staging-roundtrip.mjs`, o canário usa `XXXX.DUMMY.TOKEN.XXXX` na captação positiva,
enquanto a sitekey configurada de staging não é uma chave dummy. O backend recusou a requisição com
HTTP 403/`challengeRequired`, depois de aprovar as negativas de token ausente/inválido.

A [documentação oficial de testes do Turnstile](https://developers.cloudflare.com/turnstile/troubleshooting/testing/)
explica a separação entre tokens/chaves dummy e reais. Além disso, a resposta dummy documentada não
prova o `cData` UUID da solicitação. Uma reprodução local somente leitura confirmou que a política
vigente rejeita esse `cData` incompatível mesmo para a chave oficial de teste. Nenhum segredo foi
lido ou alterado e nenhum token real foi capturado. Não se conclui que a configuração real esteja errada.

Nas regras atuais, a captação positiva depende do navegador real, mas a fase Chrome depende do
sucesso desse canário automático. É necessária uma decisão explícita sobre a **realocação da prova
positiva para a etapa Chrome**, preservando suas dependências e mantendo os demais gates automáticos
independentes antes do challenge. Não trocar a proteção por chaves always-pass, não aceitar dummy
como positivo, não injetar um token nem declarar o gate aprovado por ausência de erro.

Naquele encerramento, a implementação dessa realocação ainda não havia sido feita. Antes de um novo run, a matriz versionada e
os testes contratuais devem provar a preservação de: captação 201 real; idempotência; persistência,
consentimento e outbox; RBAC negativo; exportação AAL2; anonimização; cleanup/resíduo; challenge
SHA/deployment-bound, validade e antirreplay; recuperação durável e evidência terminal obrigatória.
Não eliminar uma assertiva de API/compatibilidade apenas por existir uma verificação visual parecida.

## Aprovação e matriz da realocação para Chrome real

Em 30/09/2026, o usuário aprovou explicitamente mover a captação positiva e suas verificações
dependentes para a etapa Chrome real, preservando todos os controles. Esta aprovação resolve a
decisão de sequência; não aprova um SHA novo, produção, carga comercial ou cutover.

A implementação local usa o formulário sintético da campanha exata no canário de staging. O
transporte normal serializa o corpo uma vez e, somente após o primeiro HTTP 201 com `duplicate=false`,
faz uma única duplicação deliberada dos mesmos bytes. Exige outro HTTP 201, `duplicate=true` e a
mesma referência. Não há retry após falha, extração/injeção de token, chave always-pass ou caminho
especial no backend. Formulários normais e produção continuam enviando uma única requisição.
O marcador visual `Idempotência HTTP 201 confirmada.` só aparece após essas duas respostas.
Ele é uma assertiva do código do candidato, não uma alegação de captura de tráfego pelo operador.

| Controle preservado                                                                                                                                 | Etapa obrigatória                                                              | Evidência vinculada                                                                                            |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| CAPTCHA ausente/inválido recusado; RBAC editorial, publicação AAL1 recusada, expiração, bulk, restauração e auditoria                               | Faixa automática anterior ao challenge                                         | Roundtrip editorial identifica escopo automático; não declara a captação positiva aprovada                     |
| Primeiro 201 real, segundo 201 idempotente e mesma referência                                                                                       | Formulário público no Chrome real, com widget genuíno                          | Atestação consumida, texto de sucesso e screenshot vinculados ao SHA/run/attempt/challenge; token nunca retido |
| Uma persistência, consentimento, vínculo de formulário/ator/SHA/ambiente, histórico inicial e outbox unitários                                      | Bootstrap autenticado após a atestação Chrome                                  | Leitura RLS real e prova de auditoria em `cms-final-coverage.json`                                             |
| Negativa de atribuição pelo marketing, atribuição comercial, exportação AAL1 recusada, exportação AAL2, anonimização e outbox/auditoria preservados | Após Chrome, compatibilidade legacy/hybrid, percurso semântico e rollback AAL2 | `cms-real-browser-lead-controls.json`, com 13 assertivas obrigatórias e deployment exato                       |
| Revogação dos três atores temporários; limpeza dos fixtures Chrome; ausência de resíduo                                                             | `finally` das dependências e cleanup/residue compartilhados                    | Leases duráveis, auditoria de encerramento e recuperação/watchdog existentes                                   |
| Nenhum sucesso terminal com prova ausente, falsa, reusada ou de outro alvo                                                                          | Materialização e selagem terminal                                              | Digest do relatório, bindings exatos, manifesto e upload imutável obrigatórios                                 |

A compatibilidade legacy/hybrid negativa e o percurso autenticado AAL2 do frontend rollback não
foram removidos. A captação positiva real usa o contrato público selecionado pelo formulário do
candidato; a ponte de compatibilidade não é reclassificada como prova positiva de envio legado.

Os controles pós-Chrome compartilham o limite existente de 30 minutos com o percurso rollback,
executando depois dele e falhando se qualquer comando falhar. O teto contratual de 200 minutos
entre provisionamento e cleanup continua igual, inferior à lease de 240 minutos. O primeiro
check local detectou a soma indevida de 15 minutos; a implementação foi corrigida, sem alterar o
teste de limite, o TTL, os 2.100 segundos de espera do watcher ou a validade/antirreplay do challenge.

Fontes atuais consultadas antes da mudança: [MFA do Supabase](https://supabase.com/docs/guides/auth/auth-mfa),
[migração dos endpoints de logs](https://supabase.com/changelog/48235-migration-of-supabase-management-api-logs-all-analytics-endpoint-to-logs-endpoint)
e [validação server-side do Turnstile](https://developers.cloudflare.com/turnstile/get-started/server-side-validation/).
Não houve alteração de CLI, migrations, Auth, RLS, Edge Functions, Node pinado, secrets ou endpoints de logs.

O novo candidato `cccedddc22b895a58f8bca74b649ede3200a1572` passou no `npm run check`: 220 arquivos/
1.403 testes Vitest, suites Node, evals, lint, tipos e build em 26,41 s; quatro chunks iniciais
totalizam 799.039 bytes. Permanecem os 16 skips de symlink específicos de Windows. A documentação
passou com 303 arquivos Markdown, 414 links locais e zero padrões sensíveis. O teste de escopo usa
a mesma derivação do título para chave que a UI real, recusando o prefixo sintético antigo.

O CI `36719306735` aprovou o candidato em 522 s, perfil `full-release`. O único pacote promovível
é `11098206613`, digest `sha256:542f2b6bc7525924caef3189026ba89aa64d1da483bc82644e3fcfe04482b2f3`.
O arquivo dist tem digest `6e4c50013e7fd34448c782664b82a0c6cbceb5b0e560868f31316242be5ff9c4`
e a árvore `350bd4e80736ca4ce398f6cb9d1179cbdcfd526511316ffc275186d4b707c4cd`.

### Retomada somente das métricas da ponte, sem nova promoção

A ponte `36720500359` promoveu esses mesmos bytes: job `109904084336`, attempt 1, aprovado
em 658 s. Deployment canônico `15e18a82-b107-4ba0-93bd-bcf5aba4dc49`. O backend temporário foi
restaurado na versão 506, com três probes consecutivos `public-v2` e liberação formal da lease.
As duas fixtures headless foram limpas, com resíduo zero e auditoria preservada.

O workflow terminou inicialmente em falha porque **somente** `pipeline-metrics` recebeu HTTP 502
da API de jobs do GitHub. O watchdog `36721871811` confirmou `no-state-no-mutation`; a consulta
ao staging confirmou SHA exato, 113 migrations, flag desligada e zero leases de QA ou dados de
catálogo. Nenhuma promoção foi repetida e nenhum gate foi ignorado.

Após esse diagnóstico, houve uma única repetição do job de métricas: `109912879805`, attempt 2,
aprovado em 9 s. A ponte ficou verde e o watchdog `36723103432` foi skipped como previsto.
O artefato de promoção continua `11098867415`, digest
`sha256:40fa91e025e2fcbe4d6a2a4d018e69afe81c4d2320d32488fc418293265a1952`, produzido no attempt 1.
O GitHub copia a dependência aprovada com outro ID/attempt, mas conserva timestamps e steps da
execução original. A [documentação de reruns](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/re-run-workflows-and-jobs?tool=cli)
e o [filtro de histórico de jobs](https://github.blog/changelog/2020-03-09-new-filter-parameter-in-workflow-jobs-api/)
foram consultados; o comportamento foi conferido na API autenticada, não inferido apenas pela UI.

A correção mínima de controle distingue o produtor da promoção do attempt verde de métricas.
Exige inventário completo de jobs; sucesso terminal; mesmos SHA, run, workflow e branch;
timestamps e steps idênticos para a dependência copiada; criação do artefato durante a execução
original; upload imutável e gate terminal aprovados. Qualquer nova execução de promoção, histórico
incompleto, job desconhecido ou mudança de identidade invalida a reutilização. A prova de deployment
continua vinculada ao attempt 1; a duração remota é resolvida pelo attempt 2. O estado vivo e os
digests serão novamente verificados antes do deploy, sem dispensar nenhum gate pós-deploy.

Os 14 s de `observedSeconds` do relatório do attempt 2 medem a retomada das métricas, **não** a
promoção de 658 s. A ponte inteira, incluindo diagnóstico/retomada, vai de 13:16:53 a 13:38:23 UTC
(1.290 s). Esses períodos não podem ser apresentados como um caminho feliz de 14 s.

A fotografia anterior ao dispatch registrava a revisão de controle em validação, sem mudança ou
recompilação do candidato já promovido. Deploy e Chrome estavam pendentes. A prontidão do Chrome
foi conferida com sessão autenticada em staging, sem gerar challenge antecipado.

### Execução canônica e recuperação após o bloqueio de desempenho

O controle `624eaf0b1256485fbe8ae1174c8219ff94846885` passou no check completo e em 44 testes
focados de proveniência/compatibilidade. O CI `36724177499` aprovou todas as lanes em 536 s.
O pacote gerado por esse CI de controle **não substituiu** o pacote do candidato `ccceddd`.

O [run canônico 36725530364](https://github.com/Vnd93/gaiatec-cms/actions/runs/36725530364),
attempt 1, executou de 13:58:03 a 14:17:35 UTC (1.172 s). Preflight, validação de origem, leitura
do baseline, recovery durável, verificação dos bytes e provas de migrations passaram. A resolução
da ponte confirmou produtor 1 e attempt verde 2, preservando o artefato `11098206613` e seu digest.

O G11 herdado reprovou antes de completar a etapa das três janelas G12. A única violação de budget
registrada foi `adminReadP95Ms=958`, acima de 500 ms. A sequência continuou serial, com exatamente
20 warmups e uma única janela de 20 medições; não houve descarte de amostras nem retry-until-green.

| Medida p95 na janela reprovada     | Observado | Tratamento                                        |
| ---------------------------------- | --------: | ------------------------------------------------- |
| Leitura administrativa no servidor |    958 ms | Reprovada; teto 500 ms preservado                 |
| RPC administrativa                 |    950 ms | Diagnóstico, não substitui a medida normativa     |
| Núcleo SQL do snapshot             |    695 ms | Diagnóstico da subfase, sem excluir custo do gate |
| Rate limit                         |     21 ms | Proteção mantida                                  |
| Leitura wall                       |  1.316 ms | Reportada separadamente, sem ocultar rede         |
| Comando no servidor                |    454 ms | Aprovado; teto 800 ms preservado                  |

Os percentis são calculados separadamente e não devem ser somados ou subtraídos para atribuir
custos exatos. A maior amostra de leitura no servidor foi 1.886 ms; a correspondente subfase SQL
registrou 1.184 ms. Disponibilidade de G11 foi 100%, outbox lag 0, auditoria 100%, RPO 0 e RTO
1 minuto. A recusa de review da medição reprovada é o fail-closed esperado, não uma aprovação ausente
a ser suprida manualmente. As lanes pós-deploy, Chrome e evidência final ficaram skipped.

Finalizer `109928079743` passou em 212 s. O watchdog `36728015014` terminou verde e classificou
`recoveryRequired=false`; não houve compensação adicional nem nova promoção. A prova terminal
`11103552620`, digest `sha256:71bef85c5902c046af05d0dc1aab481bb2df05b4b2cdca88bf690827d6eefaec`,
registrou 100% de disponibilidade, zero 5xx, p95 público 688,970 ms e SHA exato `ccceddd`.
O relatório de duração `11103168473`, digest
`sha256:6cfa41a264b8ccf3fd69779e3f9bd4f1cedcf492ce30325bd094bbf15feabd56`, classifica a execução como
`non-happy-path`; seus 1.168 s foram capturados antes da conclusão final do workflow.

Da abertura do CI do candidato às 13:06:45 até o encerramento desse deploy às 14:17:35 decorreram
4.250 s (70 min 50 s), incluindo o 502 da ponte, diagnóstico, correção de controle e seu CI.
Isso excede a meta de 40–60 minutos e **não** constitui SLO de caminho feliz: a homologação falhou.

### Diagnóstico somente leitura e condição de retomada

Após a recuperação, o inventário remoto confirmou zero workflows queued/in_progress/waiting/
pending/requested nos dois repositórios, zero fences de recovery e zero leases de QA ativas.
Staging conservou 113 migrations/última `0113`, `ev2.catalog_v1=false`, zero overrides, produtos,
snapshots e tabelas do catálogo sem RLS. A identidade GitHub `Vnd93`, o holder e os checkouts main
limpos/sincronizados foram reconfirmados. Produção permaneceu intocada.

A comparação `035350a..ccceddd` não contém alterações em Supabase, G11 ou no orquestrador G12.
A inspeção de catálogo e estatísticas encontrou zero índices inválidos e zero espera ativa por
lock. A consulta dos eventos críticos usou o índice parcial existente (`Index Only Scan`,
zero leituras de disco, 1,578 ms de execução), não justificando criar outro índice para esse trecho.
As estatísticas acumuladas da RPC cronometrada registram 800 chamadas, média 97,29 ms e máximo
1.764,49 ms; não são uma janela do run reprovado nem provam estabilidade atual.

Foram consultados o [changelog atual do Supabase](https://supabase.com/changelog), a
[orientação de inspeção do banco](https://supabase.com/docs/guides/observability/inspect) e o
[status de latência](https://status.supabase.com/). Em 30/09 havia incidente de latência intermitente
para clientes no leste dos EUA, ainda sem resolução. Isso é contexto operacional, **não** prova da
causa exclusiva do custo SQL observado. A versão de banco consultada era 17.6; não foi executado
upgrade, reindexação, ajuste de configuração, migration, limpeza de histórico ou redução de controle.

A mudança de sequência está entregue, mas a captação positiva real e as 13 verificações dependentes
ainda não têm prova executada neste candidato. Não gerar atestação, reaproveitar aprovação de outro
SHA ou marcar o release como verde. Antes de outro run canônico, isolar a latência G11 em diagnóstico
dirigido; preservar e revalidar o CI, ponte e pacote exatos que continuem válidos. Não repetir o
deploy cegamente, reconstruir os mesmos artefatos ou reiniciar as Fatias 1–4.

## Diagnóstico dirigido após a recuperação de ccceddd

O passe único [36733465791](https://github.com/Vnd93/gaiatec-cms/actions/runs/36733465791), attempt 1,
usou controle `624eaf0b1256485fbe8ae1174c8219ff94846885` e candidato
`cccedddc22b895a58f8bca74b649ede3200a1572`. Executou de 15:00:43 a 15:16:24 UTC: **941 s**,
11 checks aprovados e dois reprovados. É diagnóstico `approvable=false`, não aprovação terminal.
Não aplicou migration, não promoveu frontend nem implantou Edge Functions.

O G11 manteve uma janela de 20 aquecimentos e 20 amostras, sem descarte ou alteração de budget:
leitura administrativa p95 **647 ms / limite 500 ms**, comandos **322 ms / limite 800 ms**.
Na leitura, RPC p95 639 ms, snapshot SQL p95 404 ms e wall p95 925,91 ms. A melhora em relação
a 958 ms não torna o resultado aprovado. Nenhuma repetição automática foi autorizada pelo diagnóstico.

O outro bloqueio ficou isolado no ciclo editorial G7: o dry-run de dois produtos sintéticos
selecionava opções corporativas por service role. A normalização escopada da migration `0078`
recusava corretamente esses termos para os atores QA. A fixture também precisava usar uma definição
de atributo homologada do catálogo governado e SKUs sintéticos distintos. Não é autorização para
adicionar SKU ou importação ao Núcleo de Catálogo: trata-se do canário legado já existente.

A correção reutiliza o provisionador autenticado da fixture Chrome: cinco opções privadas e cinco
entidades mestras QA, definição/conjunto técnico pertencentes ao ator, prova de catálogo e lease
durável antes da primeira mutação. Os containers corporativos não são alterados ou adotados como
dados QA. Somente `ev2.master_data` e `ev2.pim_v2` recebem overrides temporários de usuário, por
30 minutos; `ev2.catalog_v1` permanece default-off. A limpeza terminal existente continua obrigatória.

O diagnóstico aprovou cleanup/resíduo; o watchdog `36735461416` terminou verde e sua compensação
ficou skipped. A consulta posterior confirmou 113 migrations/última `0113`, zero leases QA ativas,
overrides do catálogo, produtos ou snapshots; sem workflow ativo ou fence de recovery.

| Evidência do diagnóstico | Identidade imutável                                                                                |
| ------------------------ | -------------------------------------------------------------------------------------------------- |
| Relatórios               | Artefato `11106313192`, SHA-256 `96cbefdbc018faae88be1d44349208c2360763d172679176be1602e459a54409` |
| Métricas                 | Artefato `11106323538`, SHA-256 `775e3415f42d163c02fb3905d1a2129dfe5f6d8b8a9ca16accb8f76e7322884b` |

### Limites do diagnóstico de infraestrutura

Não havia queries ativas, espera por lock, transações antigas, índices inválidos ou I/O de disco/temp
na RPC cronometrada. Os crons próximos ao run anterior duraram no máximo 176 ms. O EXPLAIN dirigido
dos filtros levou 111,595 ms de planejamento e 6,260 ms de execução, mas sem contexto QA ativo;
**não substitui o gate autenticado**. JIT permaneceu desligado e nenhuma configuração foi alterada.

No dashboard do projeto staging exato, a observação das 15:14 UTC mostrou 406,52 MB de RAM,
288,51 MB usados, 112,54 MB de cache/buffers e 607,14 MB de swap. O percentual de swap mostrado
era relativo à RAM, não à capacidade total de swap. CPU 35,60% era uma amostra, não média da janela.
Commit de memória de 1,67 GB também não prova sozinho pressão física sustentada.
Segundo a [documentação atual de memória e swap](https://supabase.com/docs/guides/troubleshooting/memory-and-swap-usage-explained-aPNgm0),
swap pode guardar páginas frias normalmente. Não foi comprovada necessidade de upgrade pago.

O [incidente de latência do Supabase](https://status.supabase.com/) continuava aberto na atualização
de 30/09 às 14:54 UTC. Pode contribuir para a variabilidade, mas não é causa exclusiva demonstrada.
Não houve upgrade, migração regional, tuning especulativo, exclusão de histórico ou redução de gates.
O próximo teste de candidato corrigido deve verificar o G7 e todos os controles aplicáveis; não serve
para escolher uma janela conveniente de G11 nem permite reutilizar aprovações do SHA anterior.

### Correção local e revisão antes de nova promoção

O commit `0494b6de521a15a0e1c076c71774f633325a998e` implementou os pré-requisitos governados.
Passou em 38 testes focados, check local completo e
[CI 36738377833](https://github.com/Vnd93/gaiatec-cms/actions/runs/36738377833), de 15:39:15 a
15:46:45 UTC, 450 s. Não foi promovido. A revisão seguinte encontrou um detalhe da fixture:
o ID de valor técnico era clonado entre produtos, mas a projeção possui chave primária global.
Uma regressão reproduziu a colisão antes da correção e passou com ID distinto por produto.

O commit `88e9bcf8a324d35b12dba3c4f8cd522011270d26` contém esse ajuste mínimo, sem modificar o
schema ou controles de produto. O novo `npm run check` passou: 220 arquivos/1.403 testes da aplicação,
suítes Node/contratuais, evals, lint, tipos e build em 19,33 s, com 799.039 bytes iniciais dentro do
budget. Os skips existentes de symlink no Windows não foram transformados em prova de Linux;
o CI próprio do candidato continua obrigatório. Runtime Node e CLI pinados preservados.

A validação remota deve consumir exclusivamente o pacote selado do SHA `88e9bcf`, após seu CI,
com nova vinculação de ponte e diagnóstico. Os pacotes anteriores continuam preservados como
histórico, não como artefato equivalente do novo candidato.

## Validação remota da fixture G7 — candidato 88e9bcf

| Execução                                                                                 | Resultado                                                | Duração terminal             |
| ---------------------------------------------------------------------------------------- | -------------------------------------------------------- | ---------------------------- |
| [CI 36739513362](https://github.com/Vnd93/gaiatec-cms/actions/runs/36739513362)          | Sucesso, attempt 1, perfil `full-release` fail-closed    | 392 s, 15:48:19–15:54:51 UTC |
| [Ponte 36740518613](https://github.com/Vnd93/gaiatec-cms/actions/runs/36740518613)       | Sucesso, attempt 1, mesmos bytes selados                 | 756 s, 15:56:22–16:08:58 UTC |
| [Diagnóstico 36742897039](https://github.com/Vnd93/gaiatec-cms/actions/runs/36742897039) | Reprovado, attempt 1, 10 checks aprovados / 3 reprovados | 859 s, 16:15:40–16:29:59 UTC |

Esses componentes não formam uma cadeia canônica verde: não há cumprimento comprovado do SLO de
40–60 minutos. O relatório diagnóstico capturou 852 s antes de terminar; o maior step foi o check
local, 259 s. A ponte mediu 736 s no job de promoção; sua maior etapa foi a prova de A sobre o
backend existente, 112 s. Não confundir duração parcial, diagnóstico e caminho feliz de release.

### Artefato único e recuperação da ponte

- Pacote CI `11109981732`, SHA-256
  `c90276c6906ec023e49cc569938994af2cb44c4d3461eb518f8c0fd168e79274`.
- Dist archive `f04f161c1355674cb89b35944e0d50f530fcd736a7eb88004588b9d38cc89cfb`;
  dist tree `22b3cb5fff9b42b564e7d78ac09855ec79bd1795ddf942a7a8444f7eb8954ae1`.
- Prova da ponte `11110484019`, SHA-256
  `0d569b057ee1cd3fc3119b3a88154a1f212193c53d0bc8e67464abddd7c7c388`.
- Deployment canônico `85b12a18-538f-4d45-bc2b-b68529c9807e`; preview
  `3d095702-ae75-4e3d-9684-48ec42f879ad`. Ambos vinculados ao SHA exato.
- Restauração `11109884383`, SHA-256
  `80f6c96c93e40eb047f313cf8ab5e7041d15cf2d2127dcf52238385ad08ee919`.
  Backend restaurado na versão 513, três probes `public-v2` HTTP 200 consecutivos; cleanup e resíduo
  das fixtures aprovados. Watchdog `36742084820` skipped após sucesso, sem compensação necessária.

A ponte comprovou compatibilidade com backend legado e fail-closed sem token. Não comprovou envio
positivo nem UAT do novo catálogo. Antes do diagnóstico: aliases g12/g17 servindo SHA exato,
checkouts limpos/sincronizados, GitHub Vnd93, zero operações concorrentes e fences.

### Diagnóstico reprovado e encerramento seguro

G11 manteve 20 aquecimentos e 20 amostras de leitura, com 10 comandos (uma mutação e nove replays
idempotentes). Leitura p95 **4.924 ms / limite 500 ms**, RPC 4.915 ms, snapshot SQL 2.439 ms e wall
5.208,98 ms. Comandos passaram em **277 ms / limite 800 ms**, wall 833,30 ms. Aquecimentos ficaram
entre 61–415 ms; todas as leituras medidas ficaram entre 818–5.965 ms. Não houve descarte,
novo aquecimento seletivo, mudança de budget ou retry-until-green. A causa exclusiva não está provada.

O ciclo G7 confirmou shell, RBAC, recusa de publicação AAL1, formulário versionado e blog
agendado/publicado/restaurado. Parou em landing HTTP 503 / API HTTP 200, antes de testar os produtos
governados. Portanto, o ajuste da fixture ainda não foi validado remotamente. G17 aprovou 12 checks,
mas não substitui essa falha. O incidente público de latência do Supabase continuava aberto;
não foi usado como desculpa para promover, nem como prova de necessidade de upgrade pago.

O primeiro cleanup retornou `QA_CMS_FIXTURE_CLEANUP_INCOMPLETE`. A retomada de recuperação já
prevista no workflow passou, suspendeu cinco atores, preservou dois eventos de auditoria e provou
resíduo ativo zero em todas as categorias. O diagnóstico permanece reprovado pelo primeiro resultado.
O relatório original não conservou o rótulo da etapa recusada; não é possível reconstruir sua causa
exata a partir do erro genérico. A correção de observabilidade não inventa esse dado histórico.

Watchdog `36744646809` passou; compensação ficou skipped. Consulta posterior confirmou as 14 leases
criadas no diagnóstico como `cleaned`, sem falhas de lease registradas; zero leases ativas. Catálogo
default-off, sem overrides, produtos ou snapshots; 113 migrations/última `0113`, sem workflow ativo
ou fence. Chrome real confirmou acesso autenticado e a mensagem de preparação do catálogo, sem
mudança da flag. Produção e carga/publicação/cutover comercial não foram tocados.

| Evidência                 | Identidade imutável                                                                       |
| ------------------------- | ----------------------------------------------------------------------------------------- |
| Relatórios do diagnóstico | `11111637812`, SHA-256 `0a3626414b445d522ec70e8cc8ed88006890b776a72e1d782dd7485cd555265b` |
| Métricas do diagnóstico   | `11111911974`, SHA-256 `ad830193a9216a32e04888376150eaaca79971bd6bb488865952399532f156aa` |

Não houve outra promoção ou repetição de gate após essa falha. A próxima execução depende de
estabilidade diagnosticada, nova validação dos bytes alterados e preservação integral dos gates.
Continuam pendentes o aprovador funcional independente de CAT-D009, a origem/fabricante do item 20,
Chrome positivo e UAT/rollback. Itens 17/18 provisórios; CAT-D010 adiado. A pausa da automação antiga
não foi confirmada: duas consultas ao serviço expiraram, sem alteração de configuração ou criação
de agendamento duplicado.

## Correção mínima da evidência de cleanup — 830664f

O commit `830664f6384e6bf15e19b91816b82ccc42ba1ef6` preserva o erro bloqueante
`QA_CMS_FIXTURE_CLEANUP_INCOMPLETE` e adiciona ao relatório somente códigos de etapas permitidos
em uma lista fixa, deduplicados, e indicadores booleanos de verificação de resíduo/auditoria.
Valores desconhecidos viram `QA_CMS_FIXTURE_UNKNOWN_CLEANUP_STEP`; mensagens brutas e payloads
não são serializados. Erros não produzidos pelo tipo interno não podem fornecer esse diagnóstico.

Revisão do diff limitada a `scripts/qa/cms-browser-fixture.mjs` e seu teste: nenhuma alteração em
migrations, workflows, ambiente, bibliotecas, operações de cleanup, condições de falha, número de
retries ou autorização. Mesmo com resíduo zero, uma etapa recusada mantém a reprovação original.
Essa correção não reconstrói retroativamente a etapa que falhou no run `36742897039`.

Validação local concluída:

- Três regressões novas: códigos deduplicados com gate reprovado; ausência de dados sensíveis ou
  diagnóstico forjado; distinção entre verificação ausente e prova terminal limpa.
- 41 testes focados passaram no runner nativo, cobrindo fixture, transporte de conclusão de lease
  e pré-requisitos dos produtos. A regressão foi observada falhando antes da implementação.
- `npm run check` integral passou: 220 arquivos Vitest / 1.403 testes, suites Node e contratos,
  evals, lint, tipos e build. Build em 18,84 s, quatro chunks iniciais / 799.039 bytes; Excel e PDF
  continuam lazy. Os skips existentes de symlink no Windows não foram convertidos em aprovações.
- Formatação e `git diff --check` passaram. GitHub Vnd93, repositórios canônicos em `main`, fetch
  sem divergência, mudanças alheias não incluídas. Commit e push sem force, stash ou rebuild de
  artefatos remotos.

O [CI 36746568215](https://github.com/Vnd93/gaiatec-cms/actions/runs/36746568215) terminou verde,
attempt 1, em **480 s** (16:45:46–16:53:46 UTC). Durações dos jobs: plano 31 s, quality 333 s,
browser 93 s, banco 169 s, runtime Edge 153 s, pacote 91 s e métricas 13 s. Os jobs independentes
se sobrepõem; não somar suas durações como caminho crítico. Quality foi a maior etapa desta CI,
com 263 s no check. A seleção manteve `full-release`/`bootstrap-full` fail-closed. O SLO registrado
é `component-only`, não aprovação do caminho feliz completo.

O pacote selado novo é `11113216731`, SHA-256
`d673e5f6226331fc6bf8b2e802b92675018b31c731603db8118df8826c0e823a`.
Dist archive `100d70dd5291d2799dd3c232f19e38e5c9cc16a761a5e16c7a66e6854dc264ec`;
dist tree `7850590d782cce60088ff5f95ea767f3159a10bd2f0dbf94cd4647ac3976d7f8`.
Seleção imutável `11112942147`, SHA-256
`acaeb203ccecfb3ca214e997ff2cc9237bf011f359ad72704761a09d31095af4`;
métricas `11112309704`, SHA-256
`ac237ba06e0a043ba0284774c4180869c0465a6712de4aeadc588d7295758253`.
Esses artefatos pertencem somente a `830664f`; não substituem as evidências do staging `88e9bcf`.
Nenhuma ponte ou promoção desse SHA foi disparada.
O frontend live continua em `88e9bcf`, não no novo commit. Deploy permanece bloqueado pelos gates
operacionais reprovados; a correção de diagnóstico não é uma resolução presumida de G11 ou do 503.

## Encerramento histórico anterior — candidato 035350a

A sonda terminal do candidato final teve 100% de disponibilidade, zero 5xx e p95 público 510,270 ms.
Após finalizer/watchdog: 113 migrations, última `0113`; flag desligada; zero overrides, produtos,
snapshots, leases de QA ativas e tabelas de catálogo sem RLS. Não havia workflow concorrente nem
fence/estado de recovery pendente. GitHub `Vnd93`; ambos os checkouts canônicos em `main`, limpos,
fetch e sincronização fast-forward conferidos; holder existente mantido, sem takeover por TTL.

O Chrome real permaneceu disponível com sessão autenticada, mas o challenge deste run não foi criado:
as lanes pós-deploy, Chrome e evidência de aprovação ficaram skipped. Não há homologação funcional
completa do catálogo. CAT-011 continua dependendo de recaptura/aprovação nominal independente;
CAT-012 continua dependendo de UAT/rollback real. Itens 17/18 são provisórios, item 20 incompleto,
CAT-D010 adiado até dois ciclos manuais estáveis. A autorização de staging não resolve essas decisões.

A pausa da automação histórica `cms-organiza-o-p-s-handoff` **não pôde ser confirmada**: a consulta
retornou somente um cartão, sem configuração, e não foram encontrados arquivos `automation.toml`
na pasta padrão; `CODEX_HOME` estava ausente. Nenhuma automação substituta foi criada nem campos
desconhecidos sobrescritos. Se ela ainda constar ativa no aplicativo, o responsável deve pausá-la
enquanto a decisão de sequência estiver pendente. Não repetir deploy automaticamente.

Este registro é documental: validar, commitar e publicar no repositório de documentação não exige
novo deploy do CMS e não altera o SHA candidato já implantado.
