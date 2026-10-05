---
id: gaiatec-nucleo-catalogo-matriz-rastreabilidade-2026-09-24
titulo: Matriz de rastreabilidade e gates do Núcleo de Catálogo
status: ativo-implementacao
tipo: matriz-de-rastreabilidade
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging-e-local
responsavel: Comercial GAIATEC Sistemas
data_criacao: 2026-09-24
ultima_revisao: 2026-10-05
fonte_canonica: gaiatec-documentacao
decisoes: CAT-D001-CAT-D010
---

# Matriz de rastreabilidade e gates do Núcleo de Catálogo

Este documento transforma CAT-D001–CAT-D010 em unidades verificáveis para as Fatias 1–4. Não
autoriza migration remota, carga de legado, ativação global de flag, cutover ou produção. O catálogo
novo começa vazio, sem fonte mista e sem SKU, conforme CAT-D002 e CAT-D009.

## Regra de seleção de perfil

| Perfil          | Mudança permitida                                   | Gates obrigatórios                                                                       | Artefato/rollback                                       |
| --------------- | --------------------------------------------------- | ---------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| `frontend-only` | telas, copy, acessibilidade, flag sem contrato novo | check, unit, build, browser real em staging                                              | pacote frontend selado; desligar flag                   |
| `edge-only`     | contrato/Edge sem schema novo                       | check, unit, contrato API, Auth/RLS de staging, browser real                             | bundle Edge único; restaurar versão anterior            |
| `database-auth` | migration, RLS, auditoria, Auth/AAL2                | manifesto de migration, pgTAP, advisors, RLS negativo/positivo, rollback local e staging | migration imutável; compensação/rollback testado        |
| `full-release`  | combinação de áreas ou ambiguidade                  | todos os gates acima, artefato único e canário completo                                  | pacote único por SHA; rollback de leitura, Edge e banco |

Qualquer mudança que atravesse mais de uma área, altere contrato de publicação, classificação,
relações, RLS/Auth ou tenha classificação incerta seleciona `full-release`. Nenhum perfil menor pode
ser escolhido para reduzir gates.

## Mudança → decisão → gate → evidência

| Fatia                      | Entrega verificável                                                              | Decisões                             | Gates de entrada                                          | Gates de saída e evidência                                                                     | Rollback                                                |
| -------------------------- | -------------------------------------------------------------------------------- | ------------------------------------ | --------------------------------------------------------- | ---------------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| F1 — fundação              | entidades, revisão otimista, taxonomia principal, papéis e RLS                   | D001, D004, D005                     | contrato versionado, owner de taxonomia, flag default-off | migração local/staging, pgTAP concorrência/RLS, API 409, auditoria sem PII, Chrome autenticado | desativar flag; migration compensatória aprovada        |
| F2 — revisão/publicação    | Rascunho/Pronto/Publicado, snapshot público e CTA de orçamento                   | D003, D007                           | F1 verde, outbox/cache definido, sem Offer/preço/estoque  | testes de transição inválida, snapshot isolado, JSON-LD sem Offer, smoke Edge/Chrome           | leitor volta ao snapshot anterior; não apagar histórico |
| F3 — kits e relações       | tipos de relação, quantidades/unidades, herança e exclusões                      | D005, D006                           | F1 e F2 verdes, vocabulário de unidades aprovado          | pgTAP de ciclo/autorrelação/duplicata, projeção bidirecional, rollback de revisão              | nova revisão compensatória; sem exclusão física         |
| F4 — termos e cutover prep | páginas Tecnologia/Indústria/Aplicação opt-in, lista nominal e gate de cobertura | D008, D009; D010 explicitamente fora | F1–F3 verdes, UAT e owners nomeados                       | Chrome real, noindex/SEO, sitemap opt-in, lista 100% revisada, rollback ensaiado               | manter site antigo e flag off                           |

## Checkpoints e imutabilidade

Cada tentativa registra `sha`, perfil, digest do artefato, deployment ID, snapshot do ambiente,
resultado de cada gate, owner e timestamp. Retry só reutiliza um gate independente ainda válido;
mudança de SHA, bytes, schema, estado remoto ou ambiente invalida os dependentes. O desafio de
Chrome é emitido somente após os gates automáticos e watcher estarem prontos.

## Métricas de planejamento

Registrar duração por etapa (preflight, validações paralelas, mutação serial, pós-deploy somente
leitura, Chrome e evidência). O SLO de caminho feliz é 40–60 minutos; qualquer extrapolação deve
identificar o gargalo e nunca relaxar segurança. O primeiro cutover permanece bloqueado enquanto a
lista nominal não tiver 100% de cadastro, revisão e aprovação.

## Checkpoint vigente — 5 de outubro de 2026, mesmo SHA e novo estado terminal seguro

SHA `7efbedb41e7141a628ceab8fe03beeb17bb340ff`, CI `36794205281`, pacote `11133348365` e
ponte `36794950630` revalidados, sem rebuild ou mudança de deployment. A única nova execução
canônica, `37350070838`, reprovou comandos G11 em 5.241/800 ms, com leitura em 156/500 ms;
Auth 4.984 ms e RPC 241 ms na amostra lenta. Não houve exclusão de amostra ou mudança de limite.

Finalizer/watchdog `37352296308` verdes; terminal `11362602801`, SHA-256
`80fac1cac29ac1a9bd52231265f6eeef3693afadbea57bf83d5d06ac3506403b`, verificado localmente:
82 respostas, disponibilidade 100%, zero 5xx, SHA exato e nenhuma violação. Catálogo desligado,
zero produtos/snapshots/overrides e resíduo QA ativo; 114 migrations, sem concorrência ou fences.

Chrome e gates dependentes não executaram. CAT-001–010 permanecem `ready-for-gate`, CAT-011/012
pendentes. Nova validação exige diagnóstico material e revalidação dos checkpoints; a causa exclusiva
não foi demonstrada. Não repetir fatias, CI ou ponte já válidos nem tratar recovery como aprovação.
[Tempos, custódia e continuidade](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint histórico — `7efbedb`, G11 reprovado e recuperação terminal verde

SHA `7efbedb41e7141a628ceab8fe03beeb17bb340ff`; CI `36794205281` verde; pacote único
`11133348365`, SHA-256 `57a5bcbd4f214a4568517b63d4e663781de3b37b1004109e913d57b65e970cf4`;
ponte `36794950630` verde, deployment `54fc78bb-8cde-461b-9fa9-ae67ac2c7907`, sem rebuild.
Canônico `36795885719`: leitura G11 137/500 ms, comandos 5.366/800 ms, reprovado antes de Chrome.
Finalizer/watchdog `36797142872` verdes. Artefato terminal `11134650148`, SHA-256
`bac2352646e1f25e42877c044d8f9728326ab5e3e0e701129899e3bd6b34cad3`, verificado localmente:
82 respostas, disponibilidade 100%, zero 5xx, SHA exato e nenhuma violação.

114 migrations, catálogo default-off/vazio, zero resíduo ativo ou concorrência. A recuperação não
substitui o gate de desempenho nem Chrome real. A causa exclusiva da latência não está demonstrada;
não há autorização técnica para reduzir budgets ou repetir o run sem diagnóstico/fato novo.
CI/ponte só podem ser reutilizados após revalidação do SHA, digests e estado do ambiente.
CAT-001–010 seguem `ready-for-gate`; CAT-011/012, Chrome/UAT/rollback e evidência de sucesso
continuam pendentes. Tempos e fontes no [registro](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint histórico — `9719f52` recuperado e seletores sob regressão real

SHA `9719f52d756ba447751398238b2e9dab61df02dc`, CI `36786871713`, pacote `11130611711`
(`5a2735c55d82b3974a4602c2bd5450010ad337f821ada541a413c54f6cec6265`), ponte `36787751031`,
deployment `ca57dc36-6359-4c92-a8fb-5f65c7b7fb9b`. Canônico `36789268672` reprovado antes do
Chrome por seletor booleano; G11/G7 e pós-deploy passaram. Recovery/finalizer/watchdog verdes,
artefato terminal `11132346032` verificado, zero resíduo, catálogo default-off/vazio.

Correção local somente de testes: helpers compartilhados com o E2E e regressões Chromium dos
componentes reais para atributos/campanha. Mudança do SHA exige novas evidências dependentes;
20 casos desktop/mobile verdes não equivalem a homologação autenticada em staging.
Novo candidato `7efbedb41e7141a628ceab8fe03beeb17bb340ff`, seis arquivos de testes, check
completo verde; CI e cadeia remota do novo SHA ainda pendentes.
CAT-001–010 seguem `ready-for-gate`; CAT-011/012 e Chrome/UAT/rollback ainda pendentes.

## Checkpoint histórico — candidato `9719f52`, antes de nova promoção

`9719f52d756ba447751398238b2e9dab61df02dc` corrige somente os seletores de valor técnico e
acrescenta três regressões executáveis; check completo local verde com 1.418 testes Vitest.
Predecessor `aad5922` passou CI `36785393868` em 454 s (sete jobs, 67 arquivos/2.154 testes pgTAP),
sem promoção. CI/pacote/ponte/canônico/Chrome do novo SHA permanecem pendentes; staging recuperado
continua `39a8216`, sem alteração de flag ou catálogo. Não reaproveitar aprovação dependente de SHA.
CAT-001–010 seguem `ready-for-gate`; recaptura nominal e UAT/rollback ainda pendentes.

## Checkpoint histórico — recuperação editorial e candidato `aad5922`

Staging recuperado: `39a82162574195a4bd778cf7d76cc70984bc144a`, pacote `11124908964`, ponte
`36777260148`, deployment `2f8209f7-973f-48e7-a45f-595143e7ae6d`, 114 migrations, catálogo
desligado/vazio. Canônico `36778600629`: G11 29/29, G7 13/13, 47 testes públicos e ambos os gates
pós-deploy aprovados; seletor editorial/cleanup reprovados antes de Chrome. Watchdog
`36781981846` tentativa 2 verde, artefato `11129420596` com digest verificado, 19 leases encerrados,
zero resíduos/fences. Não confundir recuperação aprovada com homologação do release.

Candidato `aad5922c3efcf37c998d1280c4ad804c7896c593`, cinco arquivos QA/testes, check completo local
verde e regressões red/green para seletores, proveniência e expiração segura. Seu CI/pacote e
gates remotos ainda são pendentes; aprovação do SHA anterior não é transferida. Digests completos,
tempos e limites no [registro de execução](registro-resiliencia-editorial-seguranca-2026-09-30.md).
`CAT-001`–`CAT-010`: `ready-for-gate`; CAT-011: recaptura/aprovação; CAT-012: Chrome/UAT/rollback.
Feature flag desligada; sem carga/publicação comercial, cutover ou produção.

## Checkpoint histórico — após G11/G7 e recuperação anterior de 30 de setembro de 2026

Staging serve `a516874d8d92748b137cce5981a51dc341311695`, com 114 migrations/última `0114`,
flag desligada e zero produtos/snapshots/overrides do novo núcleo. Pacote `11118493996`, ponte
`36762840647` e deployment `7e9fb1c3-1ab8-4093-ac51-6ca720dd92f5`; mesmos bytes nos dois runs
canônicos. Digests completos e duração por etapa no
[registro de execução](registro-resiliencia-editorial-seguranca-2026-09-30.md).

G11 foi aprovado em `36764422820` e `36770201729`; G7 foi aprovado no primeiro e ficou skipped
no segundo. A correção de evidência Auth `ae70f19e63982ddca1e8094da7499a1337f703b5` tem CI
`36768904371` verde e prova remota do caminho correto. O último run reprovou o heading do teste
a11y e não emitiu challenge Chrome. Finalizer/watchdog, sonda terminal e resíduo zero passaram.
Diagnóstico único posterior verde não é evidência terminal ou UAT e não autoriza promover gates.

Não reimplementar as Fatias 1–4 nem reabrir permissões de staging, o mesmo papel para cadastro/
aprovação ou fabricante Tmeasurement do item 20. `CAT-001`–`CAT-010`: `ready-for-gate`;
`CAT-011`/`CAT-012`: recaptura/aprovação nominal e UAT/rollback pendentes. Nenhuma fatia é `done`;
catálogo default-off, sem carga comercial, publicação, cutover ou produção.

## Checkpoint histórico — antes da correção de conflitos e da validação G7

As migrations/deploy controlados foram autorizados posteriormente, exclusivamente em staging.
O ambiente tem 113 migrations, última `0113`; o frontend servido é
`88e9bcf8a324d35b12dba3c4f8cd522011270d26`, com CI `36739513362` e ponte `36740518613` verdes.
O deployment `85b12a18-538f-4d45-bc2b-b68529c9807e` consumiu o mesmo pacote selado `11109981732`.
Os digests completos e a cadeia de recuperação estão no
[registro de execução de 30/09](registro-resiliencia-editorial-seguranca-2026-09-30.md).

O diagnóstico `36742897039` é `approvable=false`: 10 checks passaram, três reprovaram, e G7 não
alcançou o trecho de produtos. Cleanup de recuperação e resíduo zero comprovados; isso não aprova
o release. A verificação de Chrome real confirmou apenas sessão e barreira default-off. Não houve
challenge nem captação positiva atestada. `CAT-001`–`CAT-010` seguem `ready-for-gate`;
`CAT-011`/`CAT-012` continuam bloqueados nos gates nominais e de UAT/rollback. Nenhuma fatia é `done`.

Esclarecimento posterior no mesmo dia: cadastro e aprovação pertencem ao mesmo papel funcional,
confirmado pelo usuário. CAT-D003 permite ao Administrador publicar o próprio conteúdo; não
acrescentar segundo aprovador ao gate CAT-011. A [lista nominal](lista-nominal-prioritaria-cat-d009-2026-09-24.md)
registra Tmeasurement no item 20, agora `pendente-recaptura`, sem afirmar equivalência de modelo.
Isso resolve as pendências de definição de papel/fabricante, não recaptura, aprovação nominal,
UAT/rollback ou qualquer gate operacional reprovado. Os controles dos demais fluxos não mudam.

## Checkpoint histórico da integração — 28 de setembro de 2026

O SHA `486fa5c40baeafe7212914591499245ddef4a5a6` reúne a implementação funcional das Fatias
1–4. CI `36512509486` integralmente verde, 1.351 testes Vitest, 2.110 pgTAP e runtime das 34
funções com dois builds independentes idênticos. Os IDs/digests e tempos estão no
[registro da integração](registro-integracao-fatias-1-a-4-2026-09-28.md).

Esse checkpoint é de código/local/CI isolado: não possui deployment ID nem homologação do backend
hospedado. `CAT-001`–`CAT-010` ficam `ready-for-gate`; `CAT-011`/`CAT-012` permanecem bloqueados
nos gates nominais e operacionais. Nenhum campo de evidência pode ser preenchido como `passed`
por analogia com testes automatizados. Nenhuma fatia está declarada `done`.

## Evidência histórica da Fatia 3 — CAT-D008/CAT-D009

- Implementação local/staging no CMS canônico: commit `037695887f370a8d10cad663ff89562940c7c3dd`.
- Migration selada: `0109_catalog_fatia_3_relations.sql`, SHA-256
  `921e9cfcf4a6947a656a17768ac04fbc67db851e39099d50abc9ed5a9178084d`.
- A migration materializa tipos de relação, unidades controladas, quantidade positiva para composição,
  herança Variante→Modelo→Produto, exclusão local, auditoria append-only e RLS; rejeita
  autorrelação, ciclo, duplicata, relação simétrica não canônica e kit aninhado.
- CI terminal verde: run `36446140298`, database pgTAP `48/48`, quality, browser, smoke de runtime,
  pacote de staging e métricas concluídos com sucesso.
- Nenhum produto, SKU, relação, carga, publicação, deploy ou cutover foi executado; `ev2.catalog_v1`
  permanece default-off. O rollback aprovado para esta fase é uma nova revisão compensatória, sem
  exclusão física.

## Evidência da Fatia 4 — CAT-010/CAT-011/CAT-012

- Implementação local/staging no CMS canônico: commit `e37eb1b729e680f2c9a346b0088593e63aa3e138`.
- Contratos editoriais adicionados para Tecnologia, Indústria e Aplicação: payload público sanitizado,
  `noindex` fail-closed, aprovação/UAT server-owned, cobertura nominal de 100% e leitor legado para
  rollback. Nenhum campo comercial, SKU, preço, estoque ou disponibilidade é exposto.
- CI terminal verde: run `36449157247`; release-plan, quality, browser Playwright, database,
  hotfix-bundle-smoke, pacote de staging e pipeline-metrics concluídos com sucesso.
- Gate E2E de homologação fechado no commit `8389c5da7b4d3a4736d31f1ef89bdec9f35155d9`:
  `tests/e2e/catalog-editorial-fatia4.spec.ts` passou em desktop e mobile Chromium (4/4),
  provando que capability desligada ou malformada mantém `noindex` e não requisita o termo.
- CI terminal do gate E2E: run `36471368672`, todas as lanes verdes.
- Envelope de evidência UAT adicionado no commit `db6388e65441ab44f0e1ce67adbc4f9bc2e075d9`:
  registra SHA, ambiente, cobertura, rollback e status do navegador sem PII; só aceita `passed`
  para Google Chrome autenticado contra staging com evidência nominal, e nunca autoriza publicação,
  carga ou cutover.
- CI terminal do envelope UAT: run `36480366876`, todas as lanes verdes; suíte unitária final
  `211` arquivos/`1322` testes aprovados.
- A lane de browser validou o pacote local de staging; a homologação manual em Chrome real
  autenticado e backend de staging ainda é gate pendente para promover os itens a `done`.
- `ev2.catalog_v1` permanece default-off. Nenhuma migration nova, carga, publicação, deploy,
  promoção ou cutover foi executado. CAT-D010 continua `deferred`.
- Rollback ensaiável: desligar a flag e selecionar o leitor legado, sem cópia entre fontes; qualquer
  correção futura exige novo SHA e revalidação dos gates dependentes.
