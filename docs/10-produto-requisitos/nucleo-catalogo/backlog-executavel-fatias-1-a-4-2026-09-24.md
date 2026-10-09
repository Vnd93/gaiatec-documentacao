---
id: gaiatec-nucleo-catalogo-backlog-fatias-1-a-4-2026-09-24
titulo: Backlog executável das Fatias 1–4 do Núcleo de Catálogo
status: ativo-implementacao
tipo: backlog-executavel
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging-e-local
responsavel: Comercial GAIATEC Sistemas
data_criacao: 2026-09-24
ultima_revisao: 2026-10-09
fonte_canonica: gaiatec-documentacao
---

# Backlog executável das Fatias 1–4

## Escopo vigente — sistema vazio para operação manual, 8 de outubro

A instrução atual do responsável é entregar o sistema para que ele faça a operação e
os cadastros. Não carregar produtos, SKUs, importações ou dados comerciais. Manter
a flag global desligada; migrations/deploys somente em staging. Produção e cutover
continuam proibidos. Esta decisão prevalece para a entrega atual sobre a recaptura
da lista nominal nos checkpoints históricos abaixo, que permanecem preservados.
CAT-011 é **fora do escopo desta entrega vazia**, não `done`; os gates de eventual
carga/cutover futuro não são dispensados nem bloqueiam a homologação do sistema vazio.

### Checkpoint de 9 de outubro — diagnóstico ativo e corrida editorial comprovada

O candidato `ca8bbb5c98a7b98092c433f5f9992715b180fe2c` acrescentou correlação
restrita a staging, sem mudar timeouts, retries, respostas ou controles. A CI
`37954244582/1` passou nos sete jobs. A bridge `37955364021/1` promoveu os mesmos
bytes do pacote original `11627343555`, sem rebuild, ao deployment
`98c11bf5-1f64-4410-9d7a-45470fa2b1f4` do alias staging. O marcador permite
correlacionar documento e tentativas com início/fim no backend; 129 inícios e 129
términos foram observados no SHA exato, sem conteúdo sensível. Isso não comprova
a causa do HTTP 503 histórico.

O canônico `37957485073/1` passou no G12, incluindo 29 checks herdados, segurança e
restore; nas 47 regressões públicas/mobile/acessibilidade; e no G17 com inferência
real `apodex/apodex-1.1-mini:free`, 12 checks, sem dados reais ou mutação de produção.
Falhou depois no ciclo editorial, antes do Chrome real. Causa comprovada por
receipt/auditoria do mesmo fixture: agendado para `16:35:01Z`, publicado pelo
scheduler às `16:35:03.405926Z`; o teste tentou publicar novamente às
`16:35:04.148Z` e recebeu `CMS_SCHEDULE_NOT_DUE`. Não é falha do scheduler.
A correção mínima em validação local substitui a espera fixa/mutação duplicada por
polling somente leitura de publicação, projeção e auditoria da revisão exata,
backoff/saída antecipada e o mesmo orçamento de 7,5 segundos. Não aceita erro como
sucesso nem desliga o worker. Um novo SHA exigirá revalidar seus gates dependentes.

Finalizador e watchdog `37960580623` passaram. Artefatos locais com ZIP SHA-256
verificado: terminal `11629828684`,
`914cae1f18537c9709ab139a971efaedc9a0cf9e537170b9962a679a532aea35`;
métricas `11630708307`,
`fbd0acad32b3b4875749e28ce8351dc6a801a41d402ffaed53abd433b7bb25f0`;
preliminar `11629793508`,
`d82cb7f04500de23eb3380c416cd83d838250b8351da855bad70a052c70901e2`.
Probe terminal: 100% disponível, zero 5xx, p95 552,22 ms. Estado real após
recuperação: 117 migrations, zero leases/overrides QA ativos, zero produtos,
flag global desligada, zero operação concorrente ou fence. Produção intocada.

Permanecem pendentes a recuperação/limpeza específicas do catálogo antes de
fixtures hospedadas e a homologação operacional completa em Chrome real,
com permissões, AAL2/RLS, relações/editorial, rollback e resíduo zero.
Não declarar o sistema pronto nem repetir CAT-001–010. O checkpoint abaixo é
histórico; sua pendência de inferência foi superada pelo G17 no SHA `ca8bbb5`.

### Estado histórico de 9 de outubro — após recuperação do candidato `d45dba3`

O inventário abaixo preserva as funcionalidades já implementadas. Sua evidência automatizada
mais recente é a CI `37945245618/1`, sete jobs verdes no SHA
`d45dba3305c9697e201356197d0aba5817222595`, incluindo reset isolado e pgTAP reais.
Isso atualiza a referência histórica `aab0b27` da matriz; não homologa os ciclos de operação.

A bridge `37946920054/1` passou promovendo o pacote original `11623766117`, produtor `/1`,
sem rebuild. Alias staging `9c192362-5abf-465f-89f6-c162d711b142`, SHA exato.
O canônico `37948954408/1` falhou em quatro documentos `/`, no G12/G11 de acessibilidade,
antes do G17 e do desafio Chrome. O Worker registrou `page-by-path;timeout;2;503;2900`;
as 90 invocações `cms-public` da janela consultada responderam 200. Não há correlação
requisição a requisição suficiente para atribuir a causa a backend, transporte ou roteamento.
O teste focado posterior, sem retry, passou (7 testes, 1 skip, 31 s): não é correção comprovada.

Finalizador e watchdog `37951272508` passaram. Prova terminal `11625184206`, SHA-256
`6a93c8a176be070f02283cd82eafff72a0adb55107fd42385b36ef7f7a6a228e`:
82 respostas, 100% disponíveis, zero 5xx, p95 783,10 ms. Saúde ready no SHA exato,
117 migrations, zero leases/overrides QA ativos e zero produtos, flag global desligada.
O novo modelo gratuito Apodex mantém ZDR/coleta proibida, mas sua inferência real ainda
não foi alcançada pelo canônico e permanece pendente; não substituir esse gate por elegibilidade.

Próximo trabalho bloqueante: diagnóstico mínimo e restrito a staging com marcador aleatório
por requisição/tentativa, horários de início/fim no backend e horário de observação da falha.
Sem payloads, credenciais, identificadores pessoais ou alteração de status, timeouts/retries/gates.
Novo código/SHA exige novas evidências dos bytes alterados; não repetir release buscando verde.
Após resolver a falha, permanecem: recuperação/limpeza específicas de `cms_catalog_*` antes
de qualquer fixture hospedada, Chrome real autenticado com backend real, permissões/AAL2/RLS,
operações manuais/editoriais/relações, rollback e resíduo zero. CAT-001–010 não devem ser refeitos.
Produção permanece intocada; nenhuma carga comercial foi realizada.

| Área                      | Implementado                                               | Validado reutilizável                                                                 | Pendente para entrega homologada                                                         |
| ------------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| Fundação e permissões     | CAT-001–004, RPCs de workspace/comando, capacidades e CAS  | CI do SHA `aab0b27`, testes locais/contratuais e banco; migrations 0116 em staging    | Chrome autenticado: operador/admin, negações e conflitos                                 |
| Cadastro manual e revisão | Produtos/modelos/variantes, histórico, estados e snapshots | Testes de contrato, componentes e pgTAP do candidato                                  | Ciclos reais criar/editar/revisar com fixture sintética isolada e recuperação durável    |
| Relações e classificação  | CAT-008–009, kits, herança, ciclos e exclusões             | Contratos e pgTAP; não equivalem a UAT                                                | Chrome: relações, origem herdada, quantidades/unidades e mensagens de erro               |
| Editorial                 | CAT-010, termos, rascunhos, noindex e indexação separada   | Componentes/contratos/pgTAP; flag global off                                          | Chrome e backend real: validação, revisão e páginas opt-in isoladas                      |
| Estados vazios            | Tela de preparação com flag off                            | Observação autenticada em Chrome no SHA `aab0b27`                                     | Workspace opt-in vazio, formulários inválidos e falhas sem perda de edição               |
| Release/rollback          | DAG, artefato único, fences, finalizador e watchdog        | Bridge `37653825738/2`, produtor original `/1`; recuperação do canônico `37868132027` | Resolver diagnóstico 503; novo SHA exige cadeia própria; Chrome/UAT e terminal verde     |
| Limpeza de catálogo QA    | Infraestrutura geral de lease/recovery existente           | Zero produtos, overrides e leases ativos após recuperação                             | Provar cobertura específica de `cms_catalog_*` antes de criar qualquer fixture hospedada |

Nenhuma linha acima está homologada somente por existir código ou teste automatizado.
CAT-001–010 permanecem `ready-for-gate`; CAT-012 exige UAT/rollback/resíduo zero.
Não reimplementar as Fatias 1–4 nem criar exigência de dados comerciais para testar os formulários.

### Checkpoint confirmado e lacuna de diagnóstico

Em 9 de outubro, a retomada preservou o estado e produziu o candidato diagnóstico
`add1312b1edbc4f9ac8de4d653754c11993fcc9a`. Validação integral local aprovada:
227 arquivos/1.543 testes Vitest, contratos/evals, segurança, lint, tipos e build
(25,78 s; 799.883 bytes iniciais). O diagnóstico distingue HTTP/timeout/transporte
apenas no documento público reprovado em staging, sem alterar gates, limites ou
tentativas, nem expor payloads/credenciais. A causa histórica permanece não comprovada;
CI, promoção dos bytes selados e homologação do novo SHA continuam pendentes.

Em 8 de outubro (horário de Brasília), o GitHub confirmou a bridge
`37653825738/2` verde, preservando o produtor `/1` e o pacote original. O canônico
`37868132027/1` falhou no documento mobile de `/industrias/instrumentacao`, HTTP 503
em vez de 200. Finalizador e watchdog `37870009505` passaram; não houve desafio Chrome.
Terminal `11589469665`, SHA-256
`c4c4023499ea4a763c8c5286215dfbabcca3932ba20a2098a1f1e2ecbf91cd30`:
82 respostas, 100% disponíveis, zero 5xx, p95 662,48 ms e SHA exato.

As 12 sondagens posteriores da rota e a reprodução mobile focada passaram, mas não
provam a causa da falha. A janela consultada no backend não apresentou 5xx. Faltam
headers diagnósticos do documento reprovado e a distinção Worker entre timeout,
rejeição de transporte e resposta HTTP. O diagnóstico direcionado deve preservar
status, limites e tentativas; não autoriza retry cego do release nem marca a falha resolvida.

Estado remoto reconferido: candidato `aab0b27a4899ab0d9a7bc84a6f10d2512019d233`,
alias `41fb747e-0003-4d33-83d8-e02b723584e9`, saúde ready, 116 migrations,
zero produtos/overrides/leases QA ativos, flag global off e ausência de operações concorrentes.

O backlog é ordenado por dependência e fail-closed. Nenhum item cria SKU, preço, estoque,
disponibilidade, importação em massa ou leitura composta do legado. Cada item só pode ser marcado
`done` com evidência vinculada ao SHA e ao ambiente.

| ID      | Fatia | Trabalho                                                                    | Owner                | Aceite mínimo                                           | Gate/rollback                                |
| ------- | ----- | --------------------------------------------------------------------------- | -------------------- | ------------------------------------------------------- | -------------------------------------------- |
| CAT-001 | F1    | migration aditiva das entidades `cms_catalog_*`, revisão e auditoria        | Tech Lead + DevOps   | RLS habilitada, sem grants indevidos, rollback local    | pgTAP/advisors; migration compensatória      |
| CAT-002 | F1    | API de Produto/termos com `expectedVersion` e conflito 409                  | Edge/API             | conflito não grava parcialmente; payload não contém SKU | contrato API, unit e RLS negativo            |
| CAT-003 | F1    | telas Operador/Administrador atrás de `catalog_v1` default-off              | Frontend             | capacidades críticas negadas no backend e AAL2          | Chrome real; desligar flag                   |
| CAT-004 | F1    | taxonomia `Categoria/Família de Produto` com ciclo e múltiplo pai recusados | Data steward         | exatamente um termo ativo na publicação                 | pgTAP; revisão compensatória                 |
| CAT-005 | F2    | estados Rascunho/Pronto/Publicado e snapshot público                        | Edge/API             | edição publicada cria rascunho; histórico preservado    | canário read-only; voltar snapshot           |
| CAT-006 | F2    | CTA “Solicitar orçamento” e contrato sem campos comerciais                  | Frontend + API       | JSON-LD sem `Offer`, preço, estoque ou disponibilidade  | browser/contract; flag off                   |
| CAT-007 | F2    | outbox/cache por revisão publicada                                          | Edge/API             | somente snapshot aprovado é projetado                   | replay do outbox; invalidar projeção         |
| CAT-008 | F3    | tipos de relação, unidade e quantidade de composição                        | Tech Lead            | kit não aninha; ciclos/autorrelação/duplicata recusados | pgTAP; nova revisão compensatória            |
| CAT-009 | F3    | herança Variante→Modelo→Produto e exclusão local                            | Edge/API             | regra direta vence herdada e origem é exibida           | contrato determinístico; rollback de revisão |
| CAT-010 | F4    | páginas de termos opt-in e `noindex` por padrão                             | Editorial + Frontend | só publica com produto publicado e aprovação            | Chrome real, sitemap; desligar publicação    |
| CAT-011 | F4    | lista nominal prioritária, owner, aprovador e evidência UAT                 | Product Owner + QA   | 100% dos itens com revisão/aprovação antes do cutover   | gate CAT-D009; manter legado                 |
| CAT-012 | F4    | ensaio de rollback e relatório terminal                                     | DevOps + QA          | leitor retorna ao legado sem cópia entre fontes         | evidência de rollback; sem produção          |

## Dependências e estados

`CAT-001`–`CAT-004` são fundação. `CAT-005`–`CAT-007` exigem F1 verde. `CAT-008`–`CAT-009`
exigem F1/F2 verdes. `CAT-010`–`CAT-012` exigem F1–F3 verdes. Estados permitidos são
`planned → in-progress → blocked → ready-for-gate → done`; `done` exige SHA, digest, evidência e
rollback registrados. `CAT-D010` permanece `deferred` até dois ciclos manuais completos e estáveis.

## Decisão vigente — aprovação funcional do catálogo recebida

O responsável aprovou o catálogo e a composição nominal das 20 linhas da lista de `f48014e`,
vinculados ao candidato `0a3027b`. A decisão funcional de CAT-011 está satisfeita; não há
nova aprovação funcional a pedir. O saldo de CAT-011 é recaptura e evidência verificável;
CAT-012 continua exigindo Chrome/UAT/rollback. A aprovação não transforma esses gates em
`done` nem revoga as restrições de carga/publicação/cutover. Itens 17/18 mantêm a ressalva
documental provisória. [Registro da aprovação](lista-nominal-prioritaria-cat-d009-2026-09-24.md).

## Checkpoint vigente após diagnóstico do observador

O SHA `ba75ba0` tem CI `37639707508` e ponte `37643707867` verdes, com pacote
original `11492131363`. O canônico `37645779746` passou na navegação pública,
deploy e gates pós-deploy somente leitura, mas falhou no ciclo Auth por classificar
o cancelamento de uma leitura redundante como erro de rede. Finalizador e watchdog
`37650298431` verdes, ambiente recuperado e sem resíduos ativos.

Cinco navegações diagnósticas reproduziram o problema e cinco passaram após a
correção do observador; 73 testes focados aprovados. A prova exige o par exato de
GETs e resposta HTTP 200 integral dentro do deadline original; cancelamentos
genéricos e falhas de segurança não são dispensados. Chrome/UAT não foram
substituídos pelos diagnósticos. Correção `aab0b27a4899ab0d9a7bc84a6f10d2512019d233`,
três arquivos de QA; validação integral verde com 1.528 testes Vitest, demais
contratos/evals, lint, tipos e build. O novo controle precisa de validação remota própria.

CAT-001–010 continuam `ready-for-gate`, sem reimplementar Fatias 1–4. CAT-011
preserva a aprovação funcional das 20 linhas e exige recaptura técnica; CAT-012
exige Chrome/UAT/rollback. CAT-D010 permanece `deferred`. Flag global off;
sem produção, carga/publicação comercial ou cutover.
[Provas e recuperação](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após o gate de navegação pública

O candidato `c53d183` tem CI `37629341311` e ponte `37630829420` verdes,
pacote original preservado e auditoria zerada. O canônico `37633039283` passou
nas 134 verificações de migrations e três janelas G11/G12, mas falhou no título
de uma página pública dentro do prazo original. Finalizador e watchdog
`37636530296` passaram; ambiente recuperado e sem resíduos ativos.
A correção mínima `ba75ba0e087896a00c035b35018ef65b7311d1e2` de transporte
das leituras públicas passou na validação integral local com 1.490 testes Vitest;
aguarda CI, ponte e canônico próprios. O SHA mudou:
não refazer as Fatias 1–4 nem reclassificar a execução reprovada como aprovada.

CAT-001–010 permanecem `ready-for-gate`; CAT-011 preserva a aprovação funcional
das 20 linhas e a pendência de recaptura técnica; CAT-012 exige Chrome/UAT/rollback.
CAT-D010 continua `deferred`. Flag global desligada, sem carga/publicação comercial,
cutover ou produção. [Diagnóstico e provas](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após a auditoria de imagens

Em 7 de outubro, o canônico `37626820878` do candidato `eb52399` parou antes
de qualquer deploy: auditoria alta de Sharp por `GHSA-wq5f-xc86-pv6w`.
Watchdog `37627287149` verde, sem compensação, ambiente preservado e sem resíduos
ativos. A correção mínima `c53d183b8b822e571ab2e5ca7328bead0bba76f4` fixa
Sharp 0.35.5; auditoria zerada e regressão real de SVG/PNG/WebP/AVIF aprovadas.
Validação integral verde, com 1.471 testes Vitest e demais contratos/evals.
A cadeia remota própria do novo SHA continua obrigatória. Não repetir
implementações das Fatias 1–4.

CAT-001–010 permanecem `ready-for-gate`; CAT-011 mantém aprovação funcional e
pendência de recaptura técnica; CAT-012 exige Chrome/UAT/rollback. CAT-D010 continua
`deferred`. Catálogo global desligado; sem carga/publicação comercial, cutover,
produção ou fonte mista. [Evidências](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após G11 G12 e ciclo editorial aprovados

CMS `5bf1ffc`: CI `37459306938` verde, com 2.207 testes pgTAP; ponte `37460371263`
verde e pacote original preservado. Migration 0116 aplicada. Canônico `37461954151`
passou em G11/G12 (leitura p95 564 ms, comandos 336 ms) e no ciclo editorial; parou
na consulta pública com HTTP 503 por timeout na assinatura de imagens. Não reabrir
as Fatias 1–4 nem as correções editoriais já exercitadas.

Recuperação e watchdog `37465049191` aprovados, sem resíduos ativos; catálogo
default-off e vazio. Correção mínima `eb52399252855bfc32b2190ed3bc82803d1420f9`,
com validação local integral verde e 1.469 testes Vitest: uma repetição
somente da leitura interrompida, sem ampliar limites ou repetir mutações. O novo
SHA exige revalidação dos bytes alterados; o canônico reprovado não vira aprovação.
CAT-001–010 continuam `ready-for-gate`, CAT-011 mantém aprovação funcional e
recaptura/evidência pendentes, CAT-012 exige Chrome/UAT/rollback e CAT-D010 continua
`deferred`. Sem publicação/carga comercial, fonte mista, cutover ou produção.
[Registro técnico](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado da autorização de leitura e candidato 5bf1ffc

A autorização explícita de 6 de outubro inclui leitura administrativa p95 de até
2.000 ms apenas em staging. Implementação CMS
`5bf1ffc5de7c774da7d7f99582df629c1c5e89d8`: 0116 aditiva, contratos compatíveis
e G11/G12 ambientais, sem alterar os 500 ms de local/produção ou limites de comandos.
Validação local integral verde, com 1.453 testes Vitest. A CI deve executar os novos
pgTAP antes de qualquer migration remota; pacote, ponte e canônico serão próprios
desse SHA. Não converter falhas históricas em aprovação nem refazer fatias concluídas.

CAT-001–010 continuam `ready-for-gate`; CAT-011 preserva aprovação funcional e
pendência de recaptura/evidência; CAT-012 exige Chrome/UAT/rollback. CAT-D010 segue
`deferred`. Todos os controles de segurança, amostragem, recuperação e resíduo zero
permanecem. Flag global desligada; sem carga/publicação comercial, fonte mista,
cutover ou produção. [Registro técnico](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após a validação remota da expiração

CMS `80cd1cf`: CI `37413734179` e ponte `37414450752` verdes, pacote original
`11389982761`. O canônico `37415633407` reprovou em G11; recuperação e watchdog
passaram. O diagnóstico único `37417658843` confirmou a correção editorial: quatro
campanhas verificadas por item/revisão e HTTP 301/404/410/302, 13 verificações do
ciclo editorial aprovadas, sem retry de mutação. Não reabrir essa correção nem as fatias.

Doze dos treze gates diagnósticos passaram. A leitura administrativa p95 de 737 ms
continua acima de 500 ms; comandos mediram 647 ms, dentro dos 2.000 ms de staging.
Cleanup/resíduo e watchdog `37418625814` passaram. Staging está limpo e default-off.
Nova execução canônica exige estabilidade comprovada ou decisão explícita sobre
o orçamento de leitura; a autorização anterior foi aplicada somente a comandos.
Nenhum limite foi alterado nem um diagnóstico foi usado como aprovação de release.

CAT-001–010 permanecem `ready-for-gate`; CAT-011 tem aprovação funcional satisfeita
e recaptura/evidência pendentes; CAT-012 exige Chrome/UAT/rollback. CAT-D010 segue
`deferred`. Sem publicação/carga comercial, fonte mista, cutover ou produção.
[Evidências e tempos](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado da verificação de expiração editorial

O canônico `37410264055/1` passou no gate de revogação RDO (1.262 ms) e nos gates
automáticos anteriores à expiração editorial. Reprovou porque o teste contava apenas
a chamada explícita e não a execução concorrente legítima do worker agendado. As quatro
campanhas têm recibos individuais de retirada. Finalizador e watchdog `37412259086`
verdes, flag desligada e zero resíduo ativo; Chrome ainda não foi alcançado.

A correção local preserva a chamada única, verifica os quatro itens/revisões e o estado
terminal esperado antes dos testes HTTP 301/404/410/302. Polling somente leitura, limitado,
sem retry de mutação ou alteração de cron, timeout de produto ou controles de segurança.
Correção `80cd1cfeef749d546da4b9413c1461e1f761d87d`: 49 testes focados e validação
integral verdes. A nova CI, pacote único, ponte e canônico são os próximos gates.
CAT-001–010 continuam `ready-for-gate`; CAT-011 mantém aprovação funcional satisfeita e
recaptura/evidência pendentes; CAT-012 exige Chrome/UAT/rollback. Não repetir as fatias.
[Provas e tempos](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após a recuperação do gate de revogação

CMS `cfced5e`: CI `37406768067` e ponte `37407555266` verdes, pacote único original
`11387189827`. Canônico `37408480359` falhou antes de Chrome na latência RDO de 16.570 ms,
com suspensão efetiva e acesso negado; o limite de 10.000 ms permanece intacto.
Finalizador e watchdog `37409540156` verdes, SHA preservado, flag desligada e zero resíduo
ativo. A investigação localizou um pico entre serviços; a sonda independente posterior
passou com 82 respostas, zero 5xx e p95 de 557,798 ms. A continuação revalida o estado
vivo e os checkpoints existentes, sem refazer CI/ponte, rebuild ou Fatias 1–4.
CAT-001–010 permanecem `ready-for-gate`; CAT-011 tem aprovação funcional satisfeita e
recaptura/evidência pendentes; CAT-012 exige Chrome/UAT/rollback. Nenhum item foi marcado
`done` por recuperação verde.
[Tempos, diagnóstico e artefatos](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado — 06/10 UTC, correção do fluxo de homologação do produto

O candidato `bcc9a22` teve CI/ponte verdes e gates automáticos/pós-deploy aprovados.
Canônico `37401502431` falhou antes do challenge Chrome porque o teste não resolvia a
retomada do rascunho privado nem acompanhava sua promoção atômica. Recuperação/finalizador
e watchdog `37404324597` verdes, sem resíduo ativo. Correção de testes no CMS
`cfced5edc5814ec68dc62720d5a1ffe0b0673c63`, check integral verde/1.452 testes Vitest.
Falta a cadeia remota desse SHA e Chrome real, sem diminuir controles ou repetir fatias.
CAT-001–010 continuam `ready-for-gate`; a aprovação funcional de CAT-011 permanece
satisfeita, e CAT-012 ainda exige UAT/rollback verificáveis.
[Diagnóstico, recibos e tempos](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado — 06/10 UTC, recuperação concluída e diagnóstico HTTP

O canônico `37393929352` reutilizou os bytes originais de `0a3027b` e falhou em HTTP 503 na
navegação de acessibilidade, antes de Chrome real. Latência de comandos/leitura ficou em
649/177 ms; finalizador e watchdog `37395470961` verdes, zero concorrência e resíduo ativo.
O diagnóstico sanitizado está no CMS `5d7cfd18fdc3b7aa5aca1aa1f4267147273a5dba`, com
`npm run check` integral verde; falta a cadeia remota desse SHA, sem reduzir nenhum gate.
Não reiniciar as Fatias 1–4 nem declarar CAT-001–012 `done` por CI ou recuperação verdes.
[Tempos e evidências](registro-resiliencia-editorial-seguranca-2026-09-30.md).
Manuais Chemins dos itens 2/3 recuperados; essa lacuna documental está resolvida, sem carga.

## Checkpoint histórico — 5 de outubro de 2026, orçamento aprovado e homologação bloqueada por runners

Candidato `0a3027b`, migration 0115 e teto de comandos de staging em 2.000 ms, autorizado;
produção/local em 800 ms e leitura em 500 ms, sem alteração de segurança ou amostragem.
CI `37359438103` e ponte `37360387443` verdes, pacote único `11366810234`, sem rebuild.
O canônico `37362073565` aprovou G11 29/29 (comandos 309 ms; leitura 354 ms), G12 e
pós-deploy; Chrome e métricas ficaram sem runner e foram cancelados. Finalizer verde e recovery
comprovado; watchdog `37369660884` terminal, fail-closed sem mutação depois da ausência do
classificador e do estado já limpo. Não houve retry cego nem repetição das fatias.

CAT-001–010 continuam `ready-for-gate`, não `done`. CAT-011 avançou na identificação de
fontes primárias dos itens 6–8 e do modelo ILT24/item 11, mas recaptura e aprovação não
foram substituídas pela pesquisa. CAT-012 continua dependente de Chrome/UAT/rollback reais.
Catálogo desligado/vazio, sem resíduos ativos ou operações concorrentes; produção intocada.
Próximo gate: recuperação material de runners e revalidação dos checkpoints antes da continuação.
[Provas, tempos e limites](registro-resiliencia-editorial-seguranca-2026-09-30.md) e
[fontes nominais](lista-nominal-prioritaria-cat-d009-2026-09-24.md).

## Situação histórica — 5 de outubro de 2026, `7efbedb` sem reinício das fatias

O mesmo `7efbedb` foi revalidado uma vez em staging após nova mitigação de rede do provedor,
reutilizando CI `36794205281`, pacote `11133348365` e ponte `36794950630` após verificar sua
validade. O canônico `37350070838` reprovou G11 comandos (5.241/800 ms); leitura 156/500 ms.
Na amostra lenta: Auth 4.984 ms, RPC 241 ms. Finalizer/watchdog `37352296308` verdes, catálogo
default-off/vazio, zero resíduo ou concorrência. Não houve retry após a falha nem alteração de código.

CAT-001–010 continuam implementados e `ready-for-gate`; CAT-011, recaptura/aprovação nominal;
CAT-012, Chrome/UAT/rollback. Nenhum item foi promovido a `done` por recuperação verde. Antes
de outro canônico, obter diagnóstico material/correlação com o provedor. Depois, revalidar os
checkpoints, preservar o pacote único e completar a cadeia com todos os gates. Ver
[evidências e roteiro exato](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Situação histórica — candidato `7efbedb` recuperado; G11 e homologação pendentes

`7efbedb41e7141a628ceab8fe03beeb17bb340ff` passou CI `36794205281` (378 s) e ponte
`36794950630` (552 s), com pacote original `11133348365`, sem rebuild. O canônico `36795885719`
reprovou G11 comandos: p95 5.366 ms / limite 800 ms; leitura 137 ms / limite 500 ms. Finalizer,
watchdog `36797142872` e sonda terminal passaram; catálogo desligado/vazio e zero resíduo ativo.
Chrome e gates dependentes não executaram. Não repetir a cadeia sem fato novo e revalidar os
checkpoints antes de reutilizá-los. Ver [diagnóstico e provas](registro-resiliencia-editorial-seguranca-2026-09-30.md).

CAT-001–010 seguem implementados e `ready-for-gate`, não `done`. CAT-011 avançou com
[índice de fontes e ambiguidades](lista-nominal-prioritaria-cat-d009-2026-09-24.md), ainda sem
recaptura/aprovação completa. CAT-012 depende de UAT/rollback real. As Fatias 1–4 não foram
refeitas, itens 17/18 continuam provisórios e CAT-D010 adiado. Nenhuma carga/publicação comercial,
cutover ou produção foi executada.

## Situação histórica — staging recuperado, regressões de navegador em validação

`9719f52` passou CI `36786871713` e ponte `36787751031` com o pacote original `11130611711`.
O canônico `36789268672` passou deploy/G11/G7/pós-deploy e falhou antes do Chrome na seleção
do atributo booleano. Finalizer e watchdog `36792304154` recuperaram o estado, sem resíduo ou
concorrência; catálogo desligado e vazio. A correção local de testes reproduz a diferença real entre
RTL/Playwright e os seletores subsequentes de campanha antes de nova validação remota.
Novo candidato `7efbedb41e7141a628ceab8fe03beeb17bb340ff`: check completo e 20 regressões
Chromium aprovados; CI/pacote/ponte/canônico desse SHA ainda pendentes.

CAT-001–010 seguem `ready-for-gate`, não `done`. CAT-011 exige recaptura/aprovação nominal;
CAT-012 exige UAT/rollback real. As Fatias 1–4 não foram reiniciadas. Produção/carga/publicação/cutover
continuam fora do escopo. Evidência completa no [registro](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Situação histórica — revisão de seletores concluída, candidato `9719f52`

`aad5922` passou CI `36785393868` (454 s, sete jobs, 2.154 testes pgTAP), mas não foi promovido.
A revisão anterior ao deploy encontrou e reproduziu a ambiguidade adicional de “Valor”. Correção
`9719f52d756ba447751398238b2e9dab61df02dc`, dois arquivos de testes, nove regressões focadas e
check completo verdes; gates remotos desse SHA pendentes. Estado recuperado, escopo default-off
e pendências CAT-011/CAT-012 permanecem como abaixo. Não reiniciar fatias nem transferir aprovações
entre SHAs. Ver [evidência atualizada](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Registro histórico preservado — correção e recuperação editorial de 30 de setembro de 2026

`CAT-001`–`CAT-010` seguem implementados e `ready-for-gate`. O canônico `36778600629` aprovou
G11 29/29, G7 13/13, 47 testes públicos e pós-deploy; falhou no seletor do teste editorial antes
do Chrome real. Defeitos de cleanup/proveniência e janela temporal foram diagnosticados sem
relaxar controles. Watchdog `36781981846`, tentativa 2, verde após reparação exata: 19 leases
encerrados e zero resíduo/fences. O release reprovado não foi repetido.

Candidato corrigido `aad5922c3efcf37c998d1280c4ad804c7896c593`: check completo e regressões locais
verdes; CI, pgTAP novo, pacote/ponte/canônico e Chrome real ainda pendentes para esse SHA.
`CAT-011` exige recaptura/aprovação nominal; `CAT-012`, UAT/rollback. Mesmo papel, Tmeasurement,
itens 17/18 provisórios e CAT-D010 adiado preservados. Catálogo default-off, sem carga comercial,
publicação, cutover ou produção. Ver [provas e tempos](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Registro histórico preservado — gates G11/G7 e recuperação anterior

`CAT-001`–`CAT-010` permanecem implementados e `ready-for-gate`. A correção de transporte dos
conflitos de negócio em `a516874` foi aplicada exclusivamente em staging como migration `0114`;
CI, ponte, G11 e G7 de produtos têm evidência remota aprovada. O controle `ae70f19` corrigiu a
localização do relatório Auth com regressões, sem mudar autenticação ou o pacote promovido.

O run `36770201729` parou no heading do teste automatizado a11y, antes de Chrome. Recuperação,
watchdog, resíduo zero e estado default-off comprovados. Diagnóstico único posterior dos testes
públicos: 47 aprovados, três skips, sem retry ou ampliação de prazo. Não equivale a homologação;
ver [SHAs, artefatos, tempos e limites](registro-resiliencia-editorial-seguranca-2026-09-30.md).

`CAT-011` continua bloqueado por recaptura/aprovação nominal, e `CAT-012` por UAT/rollback real.
O mesmo papel pode cadastrar/aprovar, conforme esclarecimento abaixo; Tmeasurement no item 20
já está confirmado. Não reabrir essas decisões. Nenhuma fatia é `done` antes da evidência exigida.
Itens 17/18 provisórios, CAT-D010 adiado, catálogo desligado e sem carga/publicação/cutover.

## Registro histórico preservado — esclarecimentos de 30 de setembro de 2026

`CAT-001`–`CAT-010` continuam implementados e `ready-for-gate`, sem reinício das Fatias 1–4.
O usuário confirmou o mesmo papel para cadastro/aprovação; CAT-D003 já permite ao Administrador
publicar o próprio conteúdo. A exigência de segunda pessoa nos registros posteriores foi uma
interpretação incorreta, não um novo gate aprovado. Não se exige outra equipe, nem se removem
segregação dos demais fluxos, AAL2, RLS, auditoria ou homologação.

`CAT-011` continua `blocked` por recaptura e evidência de aprovação nominal, não por falta de
definição de papel. Fabricante do item 20: Tmeasurement, informado pelo usuário; origem da marca
verificada e limites registrados na [lista nominal](lista-nominal-prioritaria-cat-d009-2026-09-24.md).
O item 20 passa a `pendente-recaptura`; itens 17/18 permanecem provisórios. Nenhuma linha foi aprovada,
carregada ou publicada. `CAT-012` depende de UAT/rollback; CAT-D010 permanece `deferred`.

Os gates técnicos reprovados continuam pendentes. Não houve repetição de pipeline ou novo deploy;
a autorização de staging já existe e não substitui estabilidade, Chrome real ou evidência terminal.

## Registro histórico preservado — diagnóstico anterior aos esclarecimentos de 30 de setembro de 2026

`CAT-001`–`CAT-010` permanecem implementados e `ready-for-gate`, não `done`. A realocação para
Chrome foi aprovada e implementada; não reabrir essa decisão nem as Fatias 1–4. O SHA de staging
`88e9bcf8a324d35b12dba3c4f8cd522011270d26` tem CI e ponte verdes, com pacote único e recuperação
comprovada. O diagnóstico `36742897039` reprovou G11, landing HTTP 503 e primeiro cleanup; a
retomada de cleanup prevista passou e deixou resíduo zero. Não houve novo run canônico.

A fixture de produtos corrigida **não chegou a ser exercitada remotamente**: G7 parou antes dela.
G17 aprovou 12 checks, mas não substitui os gates reprovados nem a homologação Chrome positiva.
Uma correção adicional de diagnóstico preserva códigos seguros das etapas de cleanup, sem mudar
operações ou critérios. Ver SHA, testes e limites no
[registro de execução](registro-resiliencia-editorial-seguranca-2026-09-30.md).

`CAT-011` continua bloqueado por recaptura e aprovação funcional independente. `CAT-012` depende
de UAT e rollback real, não de nova autorização genérica para staging. Itens 17/18 continuam
`user-confirmed-provisional`; falta a origem/fabricante verificável do item 20. CAT-D010 segue
`deferred`. Catálogo default-off e vazio; nenhuma publicação, carga comercial, produção ou cutover.

## Registro histórico preservado — correção local da fixture G7

`CAT-001`–`CAT-010` conservam a implementação integrada e permanecem `ready-for-gate`, não `done`.
A realocação da captação positiva para Chrome foi **aprovada e implementada** em `ccceddd`;
não há nova decisão de sequência pendente. O candidato atual
`88e9bcf8a324d35b12dba3c4f8cd522011270d26` corrige a fixture editorial G7, não reimplementa as
Fatias 1–4. Check local completo aprovado; homologação remota desse SHA ainda pendente.

O diagnóstico `36733465791` comprovou dois bloqueios: G11 leitura p95 647 ms / 500 ms e termos
corporativos indevidamente usados pela fixture QA. A correção usa opções/atributos sintéticos
governados e isolados pelo lease; não relaxa RLS, AAL2 ou validações e não altera o contrato sem SKU
do novo catálogo. A captação positiva e suas 13 verificações continuam exigindo Chrome real.

`CAT-011` continua `blocked`: composição final, recaptura e aprovação nominal independente não
podem ser inferidas da autorização técnica. `CAT-012` continua `blocked` por UAT/rollback real,
não por falta de autorização de staging. Itens 17/18 mantêm `user-confirmed-provisional`; item 20
exige origem/fabricante verificável. CAT-D010 fica `deferred` até os dois ciclos manuais estáveis.

As 113 migrations de staging e a recuperação anterior estão comprovadas. `ev2.catalog_v1=false`,
sem carga comercial/publicação/cutover ou produção. Ver o
[registro de execução e retomada](registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Registro histórico preservado — antes da aprovação da realocação em 30 de setembro de 2026

`CAT-001`–`CAT-010` mantêm a implementação integrada, agora em
`035350ad690dcba40bd4542705a6b184b01b87bc`, com CI e ponte verdes. Migrations/deploy exclusivamente
em staging foram autorizados e executados até `0113`; essa autorização substitui a pendência de
autorização descrita na fotografia de 28 de setembro abaixo. Não refazer as implementações.

Os gates canônicos G11/G12/G17 passaram, mas o release continua bloqueado no canário de captação
positiva, que envia token dummy apesar da proteção Turnstile real. Chrome e aprovação terminal não
executaram. Manter `ready-for-gate`, não marcar `done`. A realocação dessa prova para a etapa Chrome,
com todas as assertivas de segurança/negócio preservadas, está pendente de decisão e implementação.

`CAT-011` permanece `blocked` por recaptura/aprovação nominal independente. `CAT-012` permanece
`blocked` por homologação/rollback funcional pendente, **não por falta de autorização de staging**.
Cleanup de QA foi comprovado nesta execução: zero leases ativas e resíduos comerciais do catálogo,
flag desligada e RLS preservada. Isso não substitui a prova de rollback funcional de CAT-012.

Ver [evidências e ponto de retomada](registro-resiliencia-editorial-seguranca-2026-09-30.md).
Itens 17/18 continuam provisórios, item 20 incompleto, CAT-D010 adiado e produção/carga/publicação/cutover proibidos.

## Registro histórico preservado — integração de 28 de setembro de 2026

`CAT-001`–`CAT-010` têm implementação integrada em `486fa5c40baeafe7212914591499245ddef4a5a6`,
CI `36512509486` verde, e estão `ready-for-gate`, não `done`. A integração fecha as lacunas de
RPC, telas administrativas, workflow de snapshot/outbox, relações/herança e páginas editoriais.
As migrations `0110`/`0111` foram validadas somente em banco isolado da CI.

`CAT-011` está `blocked` pela recaptura e aprovação nominal independente; `CAT-012` está
`blocked` pela ausência de autorização e evidência de homologação/rollback real em staging.
Os contratos automáticos desses dois itens estão implementados, mas não são prova de execução
real. Antes de fixtures remotas, o cleanup das novas tabelas também precisa de comprovação.

Veja o [registro completo da integração](registro-integracao-fatias-1-a-4-2026-09-28.md).
Manter feature flag default-off, itens 17/18 provisórios, sem carga/publicação/cutover. Não reabrir
trabalho concluído sem falha comprovada ou invalidação de checkpoint. CAT-D010 permanece `deferred`.

## Evidência histórica de execução

`CAT-008` e `CAT-009` estão `ready-for-gate` em local/staging, com feature flag default-off. O
commit CMS `037695887f370a8d10cad663ff89562940c7c3dd` e a migration `0109` (SHA-256
`921e9cfcf4a6947a656a17768ac04fbc67db851e39099d50abc9ed5a9178084d`) estão vinculados ao CI
`36446140298`, que terminou verde com 48 testes pgTAP da Fatia 3 e as demais lanes obrigatórias.
Não há carga, publicação ou cutover; a promoção para `done` depende da homologação de staging e
evidência Chrome/backend previstas no gate.

`CAT-010`, `CAT-011` e `CAT-012` estão `ready-for-gate` em local/staging, com feature flag
default-off. O commit CMS `8389c5da7b4d3a4736d31f1ef89bdec9f35155d9` está vinculado ao CI
`36471368672`, com quality, browser Playwright, database, smoke de runtime, pacote de staging e
métricas concluídos com sucesso. O contrato E2E `catalog-editorial-fatia4.spec.ts` passou em
desktop e mobile Chromium (4/4), cobrindo capability desligada/malformada, `noindex` e ausência
de busca editorial. A cobertura nominal e o rollback de leitor estão implementados como contratos
fail-closed; a homologação manual em Chrome real autenticado e backend de staging permanece
obrigatória antes de qualquer estado `done`. Itens 17 e 18 continuam
`user-confirmed-provisional`, sem aprovação final.

Na fase seguinte, o CMS adicionou `CatalogFatia4UatRecordSchema` e
`catalog-fatia4-uat-gate.test.ts` no commit `db6388e65441ab44f0e1ce67adbc4f9bc2e075d9`.
O envelope aceita o estado local `pending` e exige, para `passed`, Google Chrome autenticado,
backend de staging e evidência `CAT-UAT-*`; qualquer publicação, carga ou cutover é rejeitado pelo
contrato. O CI `36480366876` terminou verde com 211 arquivos/1322 testes unitários. A homologação
manual real continua pendente.
