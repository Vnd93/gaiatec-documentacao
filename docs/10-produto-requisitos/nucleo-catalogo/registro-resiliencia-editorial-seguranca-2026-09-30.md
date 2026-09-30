---
id: gaiatec-catalogo-resiliencia-editorial-seguranca-2026-09-30
titulo: Resiliência editorial, dependências e G17 canônico em staging
status: g17-canonico-validado-editorial-bloqueado
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

# Correções entregues; G17 aprovado; captação positiva ainda bloqueada

## Resultado e limites

O candidato `035350ad690dcba40bd4542705a6b184b01b87bc` está em `origin/main` e foi
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

### Bloqueio atual: prova positiva do Turnstile

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

A implementação dessa realocação ainda não foi feita. Antes de um novo run, a matriz versionada e
os testes contratuais devem provar a preservação de: captação 201 real; idempotência; persistência,
consentimento e outbox; RBAC negativo; exportação AAL2; anonimização; cleanup/resíduo; challenge
SHA/deployment-bound, validade e antirreplay; recuperação durável e evidência terminal obrigatória.
Não eliminar uma assertiva de API/compatibilidade apenas por existir uma verificação visual parecida.

## Encerramento seguro e retomada

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
