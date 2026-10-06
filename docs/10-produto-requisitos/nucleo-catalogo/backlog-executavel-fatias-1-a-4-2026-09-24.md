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
ultima_revisao: 2026-10-05
fonte_canonica: gaiatec-documentacao
---

# Backlog executável das Fatias 1–4

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

## Checkpoint técnico preservado — 5 de outubro de 2026, orçamento aprovado e homologação bloqueada por runners

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
