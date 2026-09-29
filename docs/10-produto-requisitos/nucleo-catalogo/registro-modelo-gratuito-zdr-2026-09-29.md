---
id: gaiatec-catalogo-modelo-gratuito-zdr-2026-09-29
titulo: Substituição controlada do modelo gratuito com ZDR em staging
status: inferencia-diagnostica-validada-release-bloqueado
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
  - registro-staging-controlado-fatias-1-a-4-2026-09-29.md
  - registro-integracao-fatias-1-a-4-2026-09-28.md
  - lista-nominal-prioritaria-cat-d009-2026-09-24.md
  - backlog-executavel-fatias-1-a-4-2026-09-24.md
  - ../../00-indice/status-atual.md
---

# Modelo gratuito: inferência real validada, release ainda bloqueado

## Autorização e resultado correto

O usuário autorizou selecionar e validar outro modelo gratuito, mantendo ZDR e coleta de dados
proibida. Permanece a autorização anterior de migrations e deploy controlados exclusivamente em
staging. Não há autorização para produção, carga comercial, publicação do catálogo ou cutover.

Foi selecionado `inclusionai/ling-3.0-flash-sante:free`, disponível pelo provedor Novita no OpenRouter.
O canário operacional executou uma **inferência real com dados sintéticos**, aprovou 12 checks e
encerrou as fixtures. Esse resultado veio de um passe **diagnóstico, não aprovável**: não substitui
o gate canônico G17, não entra como aprovação em matriz terminal e não homologa o release completo.

O release continua reprovado em desempenho G11; o diagnóstico também encontrou HTTP 503 na landing
do ciclo editorial. Nenhum budget foi aumentado, nenhuma amostra lenta foi descartada e nenhuma
proteção foi retirada. Não reiniciar as Fatias 1–4, que já estão implementadas.

Este registro é aditivo ao
[registro anterior de staging](registro-staging-controlado-fatias-1-a-4-2026-09-29.md), preservado como
fotografia histórica anterior à autorização de substituição do modelo.

## Política efetiva e mudança versionada

Código publicado em `main`:
[`840049128e28e0d66bdd2725cf9df140a326ff29`](https://github.com/Vnd93/gaiatec-cms/commit/840049128e28e0d66bdd2725cf9df140a326ff29).
Migration aditiva `0113_cms_ai_sante_free_model_transition.sql`, SHA-256
`3796d0d1f2ef8d8c622e15d3bec44185baf4155ece60de3806d40091a77e211a`.

| Controle                                                    | Estado verificado                                      |
| ----------------------------------------------------------- | ------------------------------------------------------ |
| Modelo ativo                                                | `inclusionai/ling-3.0-flash-sante:free`                |
| Roteamento                                                  | `provider.zdr=true`, `provider.data_collection="deny"` |
| Preço máximo                                                | prompt, completion e request iguais a zero             |
| Fallback pago ou troca automática de modelo                 | ausentes                                               |
| Ambientes da policy `f015-openrouter-v4`                    | somente `local` e `staging`                            |
| Dados reais, publicação automática e acesso direto ao banco | proibidos                                              |
| Delegação de service-role                                   | proibida                                               |
| Opt-out de treinamento                                      | ativo                                                  |
| Catálogo `ev2.catalog_v1`                                   | desligado; sem override                                |

A migração preservou as três policies históricas e adicionou a quarta, sem reescrever evidência
imutável. A troca da configuração ativa usa precondição/CAS sobre a policy anterior. Os sete wrappers
de IA mantêm verificações de shape, identidade, privilégios, MFA/AAL2, contexto e histórico; o código
recusa drift. O frontend reconhece os quatro modelos históricos, mas a execução nova fica fixada em
Sante. A policy de produção não foi alterada e nenhum deploy de produção ocorreu.

A resposta do provedor continua sujeita a JSON estrito, fidelidade à fonte e proposta com revisão
humana. O teste sintético editorial não autoriza uso de dados reais nem representa avaliação clínica
do modelo. A disponibilidade futura de um endpoint gratuito não é garantida por este teste.

As consultas públicas à
[API do modelo](https://openrouter.ai/api/v1/models/inclusionai/ling-3.0-flash-sante%3Afree/endpoints)
e à [lista de endpoints ZDR](https://openrouter.ai/api/v1/endpoints/zdr), às 18:50:39 UTC, mostraram
Novita, status `0`, prompt/completion gratuitos e presença na lista ZDR. Às 19:50:52 UTC, o endpoint
continuava listado com preço zero. A política de roteamento segue a
[documentação oficial do OpenRouter](https://openrouter.ai/docs/guides/routing/provider-selection).
Essas listagens são elegibilidade pública, não substituem a inferência real nem auditam os sistemas
internos do fornecedor.

As skills Supabase orientaram a consulta ao changelog, a migration versionada e as verificações de
RLS/privilégios. Foi preservado o Node pinado do repositório e o Supabase CLI `2.116.0`; não houve
upgrade de runtime, engine ou dependências nem uso do endpoint removido `logs.all`.

## Tentativa anterior: Qwen não qualificado

O primeiro substituto foi `qwen/qwen3.8-27b:free`, no SHA
`a5621056e472d449ee62588c31d9981262de6ecb`, migration `0112`, hash
`a9da7e25bd72bad8807f3b63706f5c3fdbf8e35c45c603cc46a45781463b3853`.

| Etapa           | Run                                                                          | Resultado / duração                     |
| --------------- | ---------------------------------------------------------------------------- | --------------------------------------- |
| CI              | [36604567692](https://github.com/Vnd93/gaiatec-cms/actions/runs/36604567692) | success; 394 s                          |
| Bridge          | [36605544842](https://github.com/Vnd93/gaiatec-cms/actions/runs/36605544842) | success; 584 s                          |
| Deploy completo | [36607277583](https://github.com/Vnd93/gaiatec-cms/actions/runs/36607277583) | failure; 1.469 s; `OPENROUTER_HTTP_429` |
| Watchdog        | [36610183328](https://github.com/Vnd93/gaiatec-cms/actions/runs/36610183328) | success; recuperação confirmada         |

O HTTP 429 não demonstra sozinho se a restrição era do provedor ou da quota da conta. Não houve
compra de créditos, fallback pago, relaxamento de privacidade ou repetição cega da chamada.
O finalizer preservou migrations aditivas, recuperou o candidato e liberou os fences por CAS.

Pacote Qwen: ID `11051185761`, digest
`2552608a5410fad415b56956239a57d8fdb51f49820c62f9586710a972776e0d`.
Bridge: ID `11050822943`, digest
`6fccfef1fa60d0d7b54c0be132730fe60c55691a1e1ad010283b7538d53b5ad6`.
Recovery terminal: ID `11053132111`, digest
`bc892c6a9dd0a1c79cfb385bfdd5f4b30a02f670d1303479dae35215bd7b0212`.

## Sante: CI, artefato único e bridge concluídos

O [CI 36612502995](https://github.com/Vnd93/gaiatec-cms/actions/runs/36612502995) terminou verde na
tentativa 3, no mesmo SHA. As tentativas anteriores não geraram pacote final:

1. Tentativa 1: `ECONNRESET` na obtenção do mirror JSR, antes do smoke Edge. Banco, navegador e
   qualidade passaram. Uma leitura independente verificou os hashes dos 164 arquivos pinados
   (683.138 bytes) antes de permitir uma única repetição da falha de rede.
2. Tentativa 2: Edge passou, mas `--failed` herdou o plano da tentativa 1. O seletor recusou
   corretamente a ausência do plano vinculado à tentativa corrente; build/upload final ficaram
   `skipped`. A repetição parcial foi uma escolha operacional inadequada para esse contrato.
3. Tentativa 3: reexecução desde o plano, com dependências completas e sem mudança de SHA. O plano
   corrente foi emitido e o pacote final foi construído pela primeira e única vez. A guarda que
   recusa plano de outra tentativa permaneceu intacta.

Validações locais: 218 arquivos Vitest, 1.367 testes; suites Node aprovadas, com 16 skips locais de
symlink específicos do Windows; avaliações e build de 21,46 s aprovados. Referências de teste
anteriores ao modelo e offsets da cauda de migrations foram corrigidos e revalidados. O primeiro
comando local integrado parou nessas referências; não se declara que esse comando terminou verde.
Na CI, o `npm run check` completo passou, assim como 2.133 testes pgTAP em 65 arquivos, Edge e browser.

| Elemento                                          | Identidade                                                                                  |
| ------------------------------------------------- | ------------------------------------------------------------------------------------------- |
| SHA candidato / controle                          | `840049128e28e0d66bdd2725cf9df140a326ff29`                                                  |
| Run CI / tentativa produtora / tentativa de gates | `36612502995` / `3` / `3`                                                                   |
| Pacote único                                      | ID `11054599893`; 1.106.451.282 bytes                                                       |
| Digest GitHub do pacote                           | `3cdfe6615932d9751a6fcd51d0ad0958a79c4fbbe1e9ac18a90ad75012ad3b73`                          |
| Artefato Edge                                     | ID `11054264569`; digest `bed605e950b72124647ed781d356e51757e8a18f4d47f3f2a5aa248b73e23467` |
| Payload de banco                                  | ID `11054484435`; digest `c4a3702c6c282eb3f5c842807888d23b2366abaa8f59b0f8b2707ce244e37f8e` |
| Bridge                                            | [36615867178 — success](https://github.com/Vnd93/gaiatec-cms/actions/runs/36615867178)      |
| Evidência bridge                                  | ID `11055732094`; digest `05939ca728033f53ca41b49d4285c2f1c17c87e2715dd2d268a9be8e24e5bbb3` |
| Deployment canônico                               | `fa1506bd-50e3-49b9-bda8-8fe89cfd0de8`                                                      |
| Archive SHA-256 do frontend                       | `d9ec24ccc96f3efc2964b7c1258907745448322522ef3c5ae1e99c474ffa4225`                          |
| Tree SHA-256 do frontend                          | `fecb65886f04203e27008e932257e2ab4498604fdd378079e39b9593b2b62efd`                          |

O bridge promoveu os mesmos bytes e provou compatibilidade contra o backend legado; não implantou
o backend candidato. Cleanup e resíduo passaram; `rollbackReady=true`. O watchdog `36617278573`
ficou `skipped` porque o parent terminou verde. Os testes headless de compatibilidade não equivalem
ao envio positivo e à homologação em Chrome real.

## Deploy canônico: latência reprovada e recuperação segura

O [run 36618100708](https://github.com/Vnd93/gaiatec-cms/actions/runs/36618100708) aplicou a migration
`0113`, verificou a política de IA, migrations/RLS/Storage/Vault e cenários sintéticos, e provou a
compatibilidade de rollback. O G11 herdado pelas janelas G12 reprovou:

| Medida                                                 | Observado |                          Limite |
| ------------------------------------------------------ | --------: | ------------------------------: |
| p95 leitura administrativa completa                    |  3.342 ms |                          500 ms |
| p95 comandos completos                                 |    893 ms |                          800 ms |
| p95 RPC da leitura, diagnóstico de componente          |  3.336 ms | não substitui o budget completo |
| p95 SQL interno do snapshot, diagnóstico de componente |    369 ms | não substitui o budget completo |

O protocolo reteve 20 warmups e 20 amostras medidas de leitura, mais 10 comandos; nenhuma amostra
lenta foi removida. A diferença entre RPC e SQL indica atraso predominante fora do SQL do snapshot
nessa janela, mas não identifica sozinha a camada ou causa raiz.

A [página oficial de status do Supabase](https://status.supabase.com/api/v2/summary.json) registrava
o incidente `w91bvbjhqf0f`, **Intermittent latency in Eastern US**, iniciado às 16:26:33 UTC e ainda
`identified` na consulta. O aviso abrange clientes e funções no leste dos EUA, independentemente da
região do projeto. É compatível com os atrasos observados; não se atribui causalidade definitiva nem
se presume que explique todo HTTP 503.

G17 canônico, gates pós-deploy, challenge Chrome e evidência terminal de aprovação não foram
executados. O finalizer terminou verde e o watchdog
[36620316298](https://github.com/Vnd93/gaiatec-cms/actions/runs/36620316298) confirmou recuperação.
O probe terminal passou: disponibilidade 100%, 5xx zero, p95 público 582,538 ms e identidade exata.
Migration aditiva permaneceu aplicada; não houve downgrade destrutivo.

Artefato de recuperação terminal: ID `11058077604`, digest
`e6beccac371e7feece4310cb7cbc6b3f8f1f8e74ab718f0750d9e2a24ab8b203`.
Preliminar: ID `11056608618`, digest
`c75e6f38c46b3d0d4dfd7220cdd0074547b679dbc94e2e7fae7c1e147c037025`.
Duração: ID `11056904038`, digest
`e111999154497f6bf500fd1361b22a90634975a0c492cfbeb84dcbbe00eb23bd`.

## Diagnóstico único: Sante funcional, duas falhas independentes

Após recuperação terminal, árvores limpas, writer único e zero operações/fences, foi executado
um único [passe diagnóstico 36620622496](https://github.com/Vnd93/gaiatec-cms/actions/runs/36620622496)
sobre o mesmo SHA já implantado. Esse modo não aplica migrations, não altera secrets, não faz
deploy nem sela/promove artefato; suas mutações se limitam a fixtures sintéticas com cleanup.

O resultado consolidado é `approvable=false`, **11 de 13 verificações diagnósticas PASS**, duas FAIL:

- **IA operacional:** `G17_CANARY_PASS`, 12 checks, inferência real OpenRouter/Sante, dois atores
  sintéticos, zero dados reais e zero mutações de produção. Cleanup reteve uma evidência imutável
  do provedor, cinco eventos e nove eventos de auditoria; zero linhas de negócio ativas de IA.
- **G11:** leitura p95 199 ms, mas comando p95 3.675 ms contra budget de 800 ms. A medição confirma
  que o problema de desempenho não estava encerrado. Não executar retry-until-green.
- **Ciclo editorial:** shell, RBAC/MFA, formulário versionado e blog passaram; a landing governada
  não recebeu o formulário, com `pageStatus=503` e `apiStatus=503`. A causa específica desse 503
  ainda precisa ser correlacionada; não é atribuída ao Sante. As quatro leases desse ciclo foram
  encerradas, com 18 eventos de auditoria preservados.
- **Fixture MFA, cleanup e resíduo:** aprovados. O watchdog
  [36622350719](https://github.com/Vnd93/gaiatec-cms/actions/runs/36622350719) terminou verde.

Em steps com `continue-on-error`, a API de jobs pode mostrar `conclusion=success` embora o comando
tenha falhado. A indicação intermediária de sucesso G11 foi corrigida usando `steps.*.outcome`, os
logs e o relatório consolidado. Nunca usar aquela indicação intermediária como aprovação.

Artefato diagnóstico: ID `11058861626`, digest
`2601f10819105ed6769ecf41c61cb4572dea04722cd42e1470cbd470bb7b0c84`. Trata-se de registro de investigação,
**não de evidência aprovável de release**. O teste real demonstra funcionamento sintético do modelo
nessa execução; não dispensa revalidar G17 no fluxo canônico.

## Estado seguro após o diagnóstico

Consulta posterior confirmou 113 migrations, última `0113`; `ev2.catalog_v1=false`; zero overrides,
produtos, snapshots, leases de QA ativas ou tabelas públicas do catálogo sem RLS. A policy ativa
permanece Sante, ZDR, coleta negada e preços máximos zero. Histórico e auditoria foram preservados:
resíduo ativo zero não significa apagar auditoria, tombstones ou materiais já arquivados.

Não havia workflow concorrente nem fence/lease de recovery no repositório ou ambiente staging.
Advisors não reportaram `ERROR`; permanecem as categorias preexistentes de avisos sobre
security-definer, proteção de senha e RLS deny-all sem policy. Não se declara segurança sem avisos.

Chrome real foi apenas recarregado para confirmar sessão autenticada e a barreira default-off do
Núcleo de Catálogo. Nenhum challenge positivo foi gerado; essa inspeção não é homologação funcional,
UAT de catálogo ou aprovação de release.

## Tempos reais e próxima retomada

| Etapa                                    |      Duração | Resultado                            |
| ---------------------------------------- | -----------: | ------------------------------------ |
| CI Sante, tentativa verde 3              |        484 s | success                              |
| Bridge Sante                             |        702 s | success                              |
| Preflight canônico                       |         36 s | success                              |
| Source / baseline vivo, paralelos        | 61 s / 126 s | success                              |
| Faixa serial de deploy                   |        740 s | failure no G11                       |
| Finalizer                                |        189 s | success                              |
| Deploy canônico completo                 |      1.117 s | 19:16:46–19:35:23 UTC; failure       |
| Diagnóstico completo                     |        886 s | 19:38:02–19:52:48 UTC; não aprovável |
| Canário operacional de IA no diagnóstico |         30 s | 12 checks; PASS                      |

O CI Qwen custara 394 s, bridge 584 s e deploy falho 1.469 s, mas atingiu outro gate. Essas execuções
falhas/diagnósticas não demonstram ganho de caminho feliz nem cumprimento do SLO de 40–60 minutos.
O tempo adicional de rede e plano de CI foi registrado; nenhuma proteção foi removida por tempo.

Retomada correta, sem reiniciar implementação:

1. Preservar o Sante e os bytes do SHA `8400491`; não repetir migrations, CI ou bridge concluídos
   sem invalidação real de SHA, digest, deployment ou snapshot.
2. Acompanhar a estabilização do caminho Supabase e diagnosticar especificamente o 503 da landing.
   Correlacionar respostas e controles existentes; não inferir causa apenas do status global nem
   usar endpoints removidos de logs. Manter budgets 500/800 ms e a regra de única medição por passe.
3. Antes de nova execução canônica, confirmar recuperação, writer/lease, identidade Vnd93, árvores
   limpas, ausência de operações concorrentes e validade exata de artefatos/baseline. Não disparar
   automaticamente outro deploy enquanto os dois bloqueios persistirem.
4. Concluir os gates canônicos e só então o challenge Chrome just-in-time, com watcher pronto,
   sessão real, backend real, validade e antirreplay. O diagnóstico não pode preencher esses gates.
5. Permanecem UAT/rollback de catálogo e aprovação nominal independente CAT-D009. Itens 17/18 são
   `user-confirmed-provisional`, item 20 está incompleto e CAT-D010 aguarda dois ciclos manuais.
   Feature flag global, publicação comercial, carga, cutover e produção continuam fora da liberação.

O pedido de substituição do modelo foi atendido no limite diagnóstico descrito. Não há declaração
de conclusão operacional de todas as Fatias 1–4 nem de aprovação produtiva.
