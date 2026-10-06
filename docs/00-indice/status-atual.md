---
id: gaiatec-status-atual-2026-09-13
titulo: Status atual do site e CMS GAIATEC
status: ativo
tipo: status-consolidado
area: governanca-documental
fase: execucao
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-10-06
fonte_canonica: gaiatec-documentacao
substitui:
  - gaiatec-status-atual-2026-09-06
relacionados:
  - comece-aqui.md
  - ambientes-e-execucao.md
  - mapa-repositorios.md
  - ../60-qualidade-auditoria/registro-consolidacao-2026-09-13.md
  - ../10-produto-requisitos/nucleo-catalogo/registro-staging-controlado-fatias-1-a-4-2026-09-29.md
  - ../10-produto-requisitos/nucleo-catalogo/registro-modelo-gratuito-zdr-2026-09-29.md
  - ../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md
---

# Status atual do site e CMS GAIATEC

## Estado vigente do candidato cfced5e após recuperação de staging

O candidato `cfced5edc5814ec68dc62720d5a1ffe0b0673c63` passou na CI `37406768067`
(446 s) e na ponte `37407555266` (572 s), usando o pacote original `11387189827` sem
rebuild. O canônico `37408480359` reprovou na latência de revogação RDO: acesso negado
corretamente com HTTP 403, mas suspensão e verificação somaram 16.570 ms, acima dos
10.000 ms exigidos. Chrome real não foi alcançado; não há atestado de homologação.

Finalizador e watchdog `37409540156` verdes; staging recuperado no mesmo SHA, catálogo
desligado, zero resíduo ativo e nenhuma operação concorrente. A sonda terminal mediu 82
respostas válidas, zero 5xx e p95 público de 697,460 ms. Uma sonda independente posterior
passou com 82 respostas, zero 5xx e p95 de 557,798 ms, preservando todos os budgets.

Os logs localizaram um pico simultâneo em Auth e REST; as estatísticas SQL não explicam
sozinhas o atraso. A origem externa ao tempo SQL é uma inferência, não causa confirmada
pelo provedor. Não houve alteração de aplicação, RLS, autenticação, limite ou timeout.
Próximo passo: revalidar os checkpoints imutáveis e o estado vivo antes de uma execução
controlada do canônico. CI e ponte já válidas não serão refeitas; gates dependentes do
ambiente serão medidos novamente. Fatias 1–4 e aprovação funcional das 20 linhas estão
preservadas. Continuam pendentes Chrome/UAT/rollback e recaptura documental, sem
publicação/carga comercial, cutover ou produção.
[Diagnóstico, recuperação e tempos](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado — retomada do rascunho corrigida; candidato `cfced5e`

A correção de segurança `bcc9a22` passou na CI `37399525765` (432 s) e na ponte
`37400226203` (790 s). O canônico `37401502431` passou nos gates automáticos e pós-deploy,
mas reprovou no teste de criação de produto, antes do challenge Chrome. Finalizador e
watchdog `37404324597` verdes; staging recuperado em `bcc9a22`, com 82 respostas válidas,
zero 5xx, p95 público de 538,331 ms e zero resíduo ativo. Não repetir esse run sem correção.

O diagnóstico local reproduziu a retomada pendente do rascunho privado: o teste não escolhia
a versão salva no servidor e esperava `cms-content/create`, embora o editor promova por
`cms-drafts-v2/promote`. O CMS `cfced5edc5814ec68dc62720d5a1ffe0b0673c63` corrige apenas
a homologação automatizada: restaura o rascunho do ator QA isolado, aguarda o autosave e
exige recibo de promoção vinculado a ambiente, comando, correlação, rascunho e versão CAS.
Não houve alteração de aplicação, banco, flag, workflow, timeout ou controle de segurança.

Validação integral local verde: 224 arquivos/1.452 testes Vitest, demais suítes/evals,
lint, tipos e build de 799.039 bytes. A reprodução Chromium local é regressão sintética,
não homologação Chrome autenticada. Próximo gate: CI e pacote próprios desse SHA, ponte,
canônico e Chrome real. O catálogo/20 linhas permanecem aprovados e default-off; sem
publicação/carga comercial, cutover ou produção. Fatias 1–4 não serão reiniciadas.
[Recibos, diagnóstico e tempos](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado — correção de segurança transitiva validada; nova CI pendente

A CI [37398025403/1](https://github.com/Vnd93/gaiatec-cms/actions/runs/37398025403), do
diagnóstico `5d7cfd1`, terminou em `failure` após 356 s: o check completo passou, mas a auditoria
detectou a vulnerabilidade alta GHSA-68fv-2mgg-jv7q em `source-map-js` 1.2.1. O empacotamento
recusou a entrada reprovada; nenhum pacote de staging, ponte ou deploy desse SHA foi produzido.

A correção mínima atualiza somente essa dependência transitiva para a versão 1.2.2 no lockfile
e acrescenta quatro regressões de segurança ao contrato existente. Nenhuma dependência direta,
workflow, timeout, limite de auditoria ou versão do Node foi alterada. Auditoria local: zero
vulnerabilidades; contrato focado: nove testes aprovados. O check completo passou com 222
arquivos/1.428 testes Vitest, demais contratos/evals, lint, tipos e build de 799.039 bytes.
Correção versionada em `bcc9a22b8cef068429152cd4a488b7727bf52dd0`; a próxima etapa é a CI
desse SHA e seu próprio pacote selado, antes de qualquer ponte ou canônico de staging.

O catálogo e suas 20 linhas permanecem funcionalmente aprovados, sem reiniciar as Fatias 1–4.
Staging segue no baseline recuperado `0a3027b`, catálogo default-off e sem carga/publicação
comercial, cutover ou produção. O 503 intermitente ainda depende da evidência do diagnóstico.
[Correção, fontes e rastreabilidade](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado — catálogo aprovado; staging recuperado após 503 público

O canônico [37393929352](https://github.com/Vnd93/gaiatec-cms/actions/runs/37393929352)
reutilizou exatamente o candidato `0a3027b`, o pacote `11366810234` e a ponte `37360387443`,
sem rebuild. Terminou em `failure` às 00:43:20 UTC de 06/10 (21:43 de 05/10 em São Paulo),
após 17 min 52 s: a navegação de acessibilidade recebeu HTTP 503 em home, contato e campanha
inexistente. Chrome autenticado não foi alcançado; nenhum challenge ou atestado foi produzido.
Comandos p95 de 649 ms e leitura de 177 ms ficaram abaixo dos respectivos tetos de 2.000/500 ms.

Finalizador e watchdog terminaram verdes. O artefato terminal, baixado e conferido por SHA-256,
comprovou 82 respostas, disponibilidade de 100%, zero 5xx, p95 público de 550,356 ms e SHA exato.
Conferência independente: zero workflows concorrentes, fences, overrides ou leases QA ativos;
115 migrations/0115, catálogo desligado, zero produtos/snapshots novos. A recuperação não aprova
o run reprovado. [Diagnóstico e tempos](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

A aprovação funcional das 20 linhas permanece válida; não reabrir essa decisão nem as Fatias 1–4
já implementadas. Os manuais primários Chemins dos itens 2/3 foram recuperados e conferidos no
Chrome; revisão impressa ausente fica explicitamente registrada, sem inferência. O diagnóstico
sanitizado está versionado no CMS `5d7cfd18fdc3b7aa5aca1aa1f4267147273a5dba`: `npm run check`
integral verde, 1.424 testes Vitest e 133 contratos QA aprovados, build dentro do orçamento.
A próxima etapa é CI, pacote único, ponte e canônico desse SHA; não reutilizar a aprovação de
release de outro SHA. Sem modificar timeouts, status exigidos, acessibilidade ou os limites de
publicação/carga/cutover/produção. O diagnóstico não declara corrigida a causa intermitente do 503.

## Retomada anterior — catálogo aprovado e infraestrutura de Actions recuperada

Em 5 de outubro de 2026, o responsável aprovou funcionalmente o catálogo e a composição
nominal atual de 20 itens, vinculados ao CMS `0a3027b` e à lista de `f48014e`.
Essa aprovação está [registrada nominalmente](../10-produto-requisitos/nucleo-catalogo/lista-nominal-prioritaria-cat-d009-2026-09-24.md);
não será solicitada novamente. Recaptura documental e evidência técnica não foram fabricadas,
e os itens 17/18 mantêm sua condição documental provisória.

A CI documental `37372372423` terminou verde (job 19 s). Na retomada às 00:18 UTC de
06/10 (21:18 de 05/10 em São Paulo), o componente Actions constava operacional, atualizado
às 21:54:22 UTC de 05/10. O incidente então aberto tratava de páginas de billing/licenciamento,
não de alocação de runners. GitHub `Vnd93`, ambos os repositórios limpos/sincronizados,
zero workflows ativos ou fences; staging no SHA exato `0a3027b`, 115 migrations/0115,
catálogo desligado/vazio e zero resíduo ativo. Pacote original e prova da ponte não expiraram.

Próxima execução: revalidar identidades e retomar o canônico de staging com o mesmo pacote
selado e ponte, sem refazer CI nem as Fatias 1–4. Chrome real permanece um gate obrigatório,
just-in-time. Nenhuma homologação foi declarada concluída nesta retomada e nenhuma carga,
publicação comercial, cutover ou ação em produção foi autorizada.

## Checkpoint técnico preservado — 5 de outubro de 2026: comandos até 2 s em staging, G11/G12 verdes e Chrome pendente

A autorização de latência foi implementada no candidato
`0a3027b8156ed1bc7d787994c02a27ed3a3a1d49`: **p95 de comandos em staging ≤ 2.000 ms**;
produção/local continuam em 800 ms e leitura administrativa em 500 ms. Segurança, MFA/AAL2,
RLS, auditoria, revisão independente, protocolo de amostragem, recovery e cleanup preservados.
A migration aditiva 0115 foi aplicada somente em staging. As Fatias 1–4 não foram reiniciadas.

CI [37359438103](https://github.com/Vnd93/gaiatec-cms/actions/runs/37359438103) e ponte
[37360387443](https://github.com/Vnd93/gaiatec-cms/actions/runs/37360387443) verdes; pacote
original `11366810234`, sem rebuild. O canônico
[37362073565](https://github.com/Vnd93/gaiatec-cms/actions/runs/37362073565) aprovou G11
**29/29**, G12, regressões públicas e os dois gates pós-deploy. Comandos p95 **309/2.000 ms**;
leitura **354/500 ms**. A melhora observada não é atribuída à mudança de limite e o run anterior
de 5.241 ms continua reprovado.

Chrome e métricas foram cancelados pelo GitHub sem receber runner, em contexto de
[incidente oficial de Actions](https://www.githubstatus.com/incidents/3q1yb5m7ltvb).
O canônico terminou em `failure`: 70 min 22 s; cadeia desde a CI, 91 min 32 s,
incluindo 40 min 23 s de filas conhecidas no caminho crítico. Não há SLO final nem homologação
Chrome aprovados. Finalizer verde, evidência terminal verificada: 82 respostas, 100% de
disponibilidade, zero 5xx, SHA exato e p95 público 733,498 ms.

O watchdog `37369660884` também terminou: classificador sem runner; compensação confirmou
estado de recovery já removido pelo finalizer e falhou de forma fechada, sem mutação. Ele não
é contado como verde. Nova conferência: 115 migrations/0115, `ev2.catalog_v1=false`, zero
produtos/snapshots, overrides/leases QA ativos, concorrência, lock waits ou fences. Histórico e
auditoria preservados. Nenhum retry cego, carga/publicação comercial, cutover ou ação em produção.

Suporte sanitizado enviado ao Supabase por autorização, com acesso ao projeto desabilitado.
CAT-001–010 seguem `ready-for-gate`; CAT-011 exige recaptura/aprovação nominal, com avanço
nas [fontes dos itens 6–8 e 11](../10-produto-requisitos/nucleo-catalogo/lista-nominal-prioritaria-cat-d009-2026-09-24.md).
CAT-012 exige Chrome/UAT/rollback. [Digests, tempos, provas e retomada exata](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Registro histórico preservado — 5 de outubro de 2026: `7efbedb`, G11 reprovado e staging recuperado

As Fatias 1–4 e as correções anteriores não foram refeitas. O candidato continua
`7efbedb41e7141a628ceab8fe03beeb17bb340ff`: CI `36794205281`, pacote único `11133348365` e
ponte `36794950630` revalidados e reutilizados, sem rebuild. Depois da mitigação de rede publicada
pelo Supabase em 01/10 às 20:23 UTC, foi executado **um** novo canônico controlado de staging:
[37350070838](https://github.com/Vnd93/gaiatec-cms/actions/runs/37350070838), tentativa 1.

O run reprovou G11 comandos: **5.241 ms / limite 800 ms**; leitura passou em **156 / 500 ms**.
A décima amostra concentrou 4.984 ms na autenticação, 241 ms na RPC e 30.038,35 ms externos.
Não houve descarte, redução de limite ou repetição após a falha. Os logs agregados e a revisão
do caminho de autenticação não isolam a causa; é necessária correlação da requisição com o
provedor antes de escolher uma correção ou outra execução. O incidente público ainda aberto é
contexto, não prova de causalidade exclusiva. Ver [diagnóstico e roteiro de continuidade](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

Finalizer e watchdog `37352296308` verdes. Prova terminal: 82 respostas, disponibilidade 100%,
zero 5xx, SHA exato, p95 público 786,767 ms e todos os budgets por rota aprovados. Estado posterior:
114 migrations, `ev2.catalog_v1=false`, zero overrides/produtos/snapshots, leases QA ativos,
queries concorrentes ou lock waits; GitHub sem operação ativa ou fence. Produção intocada.

CAT-001–010 permanecem implementados e `ready-for-gate`, não `done`. Chrome positivo e suas
verificações dependentes não executaram; CAT-011 exige fontes/recaptura/aprovação nominal e
CAT-012 exige UAT/rollback real. Mesmo papel de cadastro/aprovação, Tmeasurement e itens 17/18
provisórios permanecem registrados. Sem carga/publicação comercial ou cutover.

## Registro histórico preservado — 30 de setembro de 2026: candidato validado na CI, G11 reprovado e recuperado

Candidato exato `7efbedb41e7141a628ceab8fe03beeb17bb340ff`: CI
[36794205281](https://github.com/Vnd93/gaiatec-cms/actions/runs/36794205281) verde em 378 s e
ponte [36794950630](https://github.com/Vnd93/gaiatec-cms/actions/runs/36794950630) verde em 552 s.
O pacote único `11133348365` foi promovido sem rebuild para o deployment de staging
`54fc78bb-8cde-461b-9fa9-ae67ac2c7907`.

O canônico [36795885719](https://github.com/Vnd93/gaiatec-cms/actions/runs/36795885719)
reprovou G11: comandos p95 **5.366 ms / limite 800 ms**; leitura **137 ms / limite 500 ms**.
Chrome real e os gates dependentes não executaram. Finalizer e watchdog `36797142872` terminaram
verdes; a sonda terminal verificou 82 respostas, disponibilidade 100%, zero 5xx, p95 590,213 ms
e SHA exato. Recuperação aprovada não equivale a homologação do candidato.

Em 01/10/2026 às 00:58 UTC (30/09, 21:58 em São Paulo): 114 migrations, catálogo default-off,
zero overrides/produtos/snapshots, leases QA ativos, queries concorrentes e lock waits. GitHub
sem workflows ativos ou fences. O incidente oficial de latência do API Gateway permanece aberto;
sua coincidência com a falha é contexto, não causa exclusiva comprovada. Não houve nova tentativa,
mudança de limite, descarte de amostras ou alteração de infraestrutura.

CAT-001–010 continuam implementados e `ready-for-gate`, não `done`. O índice de fontes na
[lista nominal](../10-produto-requisitos/nucleo-catalogo/lista-nominal-prioritaria-cat-d009-2026-09-24.md)
avança a preparação da recaptura sem aprovar identidades ambíguas ou carregar produtos.
CAT-011/012, Chrome positivo, UAT/rollback e evidência terminal de sucesso continuam pendentes.
Sem produção, carga/publicação comercial ou cutover. Ver
[provas, tempos e critério de retomada](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Registro histórico preservado — staging recuperado e regressões no navegador

O candidato `9719f52d756ba447751398238b2e9dab61df02dc` passou CI e ponte de staging,
promovendo o pacote único `11130611711`, sem rebuild. O canônico
[36789268672](https://github.com/Vnd93/gaiatec-cms/actions/runs/36789268672) aprovou deploy,
G11 29/29, G7 e ambos os gates pós-deploy. Parou antes do Chrome real: o seletor exato de
rótulo do campo booleano não encontra o `select` no Playwright, embora passe no teste de componente.

Finalizer e [watchdog 36792304154](https://github.com/Vnd93/gaiatec-cms/actions/runs/36792304154)
terminaram verdes. A sonda terminal comprovou SHA exato, 100% de disponibilidade, zero 5xx e
p95 649,283 ms. Não há workflows ativos, fences, atores QA ativos ou lock waits; 114 migrations,
catálogo desligado, zero overrides, produtos e snapshots. Produção permanece intocada.

A correção local fica restrita aos testes. Regressões com os componentes reais renderizados e
Chromium reproduzem a falha booleana e quatro problemas subsequentes de seleção na campanha
(modelo aprovado, visibilidade em busca, formulário e título). Os mesmos helpers usados pelo E2E
passam nos cinco tipos de atributo e nos campos de campanha em desktop/mobile. O candidato
`7efbedb41e7141a628ceab8fe03beeb17bb340ff` passou o check completo (221 arquivos/1.418 testes
Vitest, demais suítes, build 18,16 s) e 20 testes Chromium sem retry em 11,4 s. CI/pacote/ponte/
canônico desse novo SHA ainda estão pendentes; não é aprovação de staging ou Chrome real.

As Fatias 1–4 não foram refeitas. CAT-001–010 permanecem `ready-for-gate`; recaptura/aprovação
nominal e UAT/rollback real continuam pendentes. Sem carga/publicação comercial ou cutover.
Ver [SHAs, digests e tempos](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Registro histórico preservado — candidato de seletores `9719f52`, antes dos gates remotos

O CI [36785393868](https://github.com/Vnd93/gaiatec-cms/actions/runs/36785393868) aprovou o
candidato `aad5922` em 454 s: sete jobs, 67 arquivos/2.154 testes PostgreSQL, incluindo as sete
regressões de recovery; auditoria sem vulnerabilidades. Antes de qualquer promoção, a revisão
encontrou mais uma ambiguidade na mesma sequência: “Valor” selecionava quatro controles.
Três testes novos reproduziram o defeito para booleano/número/texto e passaram com busca exata.

O candidato atual é `9719f52d756ba447751398238b2e9dab61df02dc`, apenas dois arquivos de testes
adicionais, check completo aprovado (221 arquivos/1.418 testes Vitest, nove focados, demais
suítes e build). CI e gates remotos desse SHA ainda estão pendentes; `aad5922` não foi promovido.
Staging permanece recuperado em `39a8216`, catálogo desligado/vazio. Chrome real autenticado foi
observado com a tela default-off; isso não é aprovação do novo SHA nem captação positiva.

As Fatias 1–4 não foram reiniciadas. Recaptura/aprovação nominal, Chrome/UAT/rollback e evidência
terminal ainda faltam; carga/publicação comercial, cutover e produção continuam fora do escopo.

## Registro histórico preservado — recuperação editorial comprovada e primeiro candidato corrigido

As Fatias 1–4 continuam implementadas, sem reinício. O canônico
[36778600629](https://github.com/Vnd93/gaiatec-cms/actions/runs/36778600629), candidato
`39a82162574195a4bd778cf7d76cc70984bc144a`, aprovou G11 (29/29), G7 (13/13), os 47 testes
públicos aplicáveis e ambos os gates pós-deploy. Parou antes do Chrome real em um seletor
ambíguo do teste editorial. A limpeza expôs dois defeitos adicionais: resolução ambígua de
proveniência no SQL e redução indevida da janela temporal do lease durante recovery.

A recuperação foi restrita ao único ator/conteúdo sintético ainda ativo, mantendo todas as
verificações. O [watchdog 36781981846, tentativa 2](https://github.com/Vnd93/gaiatec-cms/actions/runs/36781981846)
terminou verde: 19 leases encerrados, zero resíduo, fences removidos pelo fluxo oficial,
disponibilidade 100%, zero 5xx. Staging permanece em `39a8216`; o catálogo segue desligado e vazio.

A correção mínima está em `aad5922c3efcf37c998d1280c4ad804c7896c593`, com check completo aprovado,
regressões red/green e sete verificações PostgreSQL acrescentadas para o CI. Não muda runtime da
aplicação, migrations, RLS, Auth, dependências ou limites. CI/pacote/ponte/canônico desse novo SHA
ainda devem executar; Chrome positivo e evidência terminal permanecem pendentes. Resultados do
SHA anterior não são aprovação do novo candidato.

`CAT-001`–`CAT-010` seguem `ready-for-gate`; CAT-011 exige recaptura/aprovação nominal e CAT-012
UAT/rollback real. Mesmo papel para cadastro/aprovação, Tmeasurement no item 20 e itens 17/18
provisórios estão preservados. Produção, carga, publicação comercial, cutover e CAT-D010 continuam
fora da execução. Ver [evidências e tempos](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Registro histórico preservado — G11/G7 aprovados e diagnóstico de acessibilidade

As Fatias 1–4 continuam implementadas. Staging serve `a516874d8d92748b137cce5981a51dc341311695`,
com 114 migrations e catálogo default-off/vazio. A migration `0114` elimina retries indevidos de
recusas de negócio `40001`, preservando fences, RLS, AAL2 e auditoria. A janela após a correção
teve zero desses erros, contra 5.360 em 62 segundos antes. CI e ponte do pacote selado passaram.

G11 passou nos dois runs canônicos: leitura p95 189/300 ms, limite 500 ms; comandos 800/254 ms,
limite 800 ms. G7 aprovou os 13 checks no primeiro run, inclusive produtos governados. A falha
seguinte de localização da evidência Auth foi corrigida em `ae70f19`, com regressões e CI verdes.
O mesmo pacote e ponte foram reaproveitados, sem reconstrução.

O último canônico [36770201729](https://github.com/Vnd93/gaiatec-cms/actions/runs/36770201729)
parou numa asserção de H1 visível do teste automatizado de acessibilidade: 46 passaram, três skips,
uma falha. A rota não estava identificada no erro original. Finalizer/watchdog e recuperação
terminaram verdes, com disponibilidade 100%, zero 5xx, zero resíduo e nenhuma operação concorrente.
Um diagnóstico único posterior, sem mutação, passou 47 testes com três skips, sem ampliar prazos
ou repetir amostras. Isso não explica definitivamente a falha nem aprova o release.

Chrome positivo, suas verificações dependentes e homologação terminal ainda não executaram.
`CAT-001`–`CAT-010` permanecem `ready-for-gate`; CAT-011 exige recaptura/aprovação nominal e CAT-012
UAT/rollback. Mesmo papel para cadastro/aprovação e fabricante Tmeasurement do item 20 já estão
esclarecidos. Itens 17/18 continuam provisórios e CAT-D010 adiado. Produção, carga, publicação do
catálogo e cutover permanecem intocados. Evidências, SHAs, digests e tempos estão no
[registro atualizado](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Registro histórico preservado — responsabilidade e fabricante esclarecidos

O usuário confirmou o mesmo papel funcional para cadastro e aprovação do Catálogo. A decisão
CAT-D003 já permite ao Administrador publicar o próprio conteúdo, com auditoria; não exigir segunda
pessoa ou outra equipe. A pendência anterior de aprovador independente era uma interpretação
incorreta, agora corrigida, sem alterar os controles dos outros módulos ou presumir aprovação nominal.

**Tmeasurement** foi informado pelo usuário para o item 20 e tem fonte primária da marca registrada
na [lista nominal atualizada](../10-produto-requisitos/nucleo-catalogo/lista-nominal-prioritaria-cat-d009-2026-09-24.md).
O item passa de fabricante ausente para `pendente-recaptura`; não foi aprovado ou carregado.
Itens 17/18 continuam `user-confirmed-provisional`. CAT-011 exige recaptura e aprovação registrada,
não nova definição de papel; CAT-012 exige UAT/rollback. CAT-D010 permanece adiado.

Permissões técnicas para migrations/deploy controlados em staging já existem. Nenhum novo deploy
ou retry foi disparado: persistem G11 reprovado e landing HTTP 503, sem prova de correção ou de
estabilidade suficiente. As Fatias 1–4 não foram refeitas. CMS `main` permanece em `830664f`,
staging em `88e9bcf`, catálogo default-off e vazio; produção, carga/publicação/cutover intocados.
Os 11 testes existentes de governança do catálogo passaram novamente no SHA completo registrado
abaixo; o contrato já aceita os papéis iguais. Não houve mudança de código, schema ou permissões.

## Registro histórico preservado — antes dos esclarecimentos de responsabilidade e fabricante

As Fatias 1–4 e a realocação aprovada da captação positiva para Chrome real estão implementadas.
Não reiniciá-las. O candidato `88e9bcf8a324d35b12dba3c4f8cd522011270d26` passou no check completo,
no CI `36739513362` e na ponte `36740518613`, que promoveu o pacote selado sem rebuild.

O [diagnóstico único 36742897039](https://github.com/Vnd93/gaiatec-cms/actions/runs/36742897039)
terminou em 859 s: 10 checks passaram e três reprovaram. G11 leitura p95 **4.924 ms / limite 500 ms**;
landing editorial HTTP 503, embora sua API retornasse 200; primeira tentativa de cleanup incompleta.
A landing interrompeu G7 **antes dos produtos**: não há prova remota da correção de pré-requisitos.
O diagnóstico não aprova o release e não foi seguido por novo deploy canônico ou retry de gates.

A retomada de cleanup já prevista no workflow passou, revogou cinco atores e comprovou resíduo zero.
Watchdog `36744646809` verde; 14 leases do diagnóstico estão limpas. Estado posterior: 113 migrations,
última `0113`, flag `ev2.catalog_v1=false`, zero overrides, produtos, snapshots ou leases QA ativas;
nenhum workflow ativo ou fence. Chrome real confirmou sessão autenticada e barreira default-off,
não UAT funcional nem captação positiva. Produção e carga/publicação/cutover do catálogo intocados.

Foi identificada uma lacuna adicional de diagnóstico: os códigos das etapas recusadas no cleanup
eram descartados. A correção preserva somente rótulos fixos e indicadores sem dados sensíveis;
não altera a limpeza, seus gates ou retries. Está publicada em `origin/main` no SHA
`830664f6384e6bf15e19b91816b82ccc42ba1ef6`, com check local completo e 41 testes focados verdes.
O CI `36746568215` terminou integralmente verde, attempt 1, em 480 s. Esse SHA **não foi promovido**:
staging permanece em `88e9bcf`.
Sua validação e revisão exata estão no
[registro de execução](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

Faltam estabilidade e diagnóstico dos gates operacionais, Chrome positivo e UAT/rollback. CAT-011
exige aprovador funcional independente e recaptura; itens 17/18 seguem provisórios e o item 20 precisa
de fabricante/origem verificável. CAT-D010 continua adiado. A pausa da automação histórica não foi
confirmada: a consulta ao serviço não respondeu, e nenhum agendamento substituto foi criado.

## Registro histórico preservado — antes da validação remota da fixture G7

As Fatias 1–4 e a realocação aprovada da captação positiva para Chrome real já estão implementadas.
Não reiniciá-las. O diagnóstico dirigido `36733465791` terminou em 941 s, com 11 checks aprovados
e dois reprovados: G11 de leitura em 647 ms / limite 500 ms e fixture editorial G7 usando termos
corporativos fora do escopo QA. Cleanup, resíduo e watchdog `36735461416` foram aprovados.

O candidato `88e9bcf8a324d35b12dba3c4f8cd522011270d26` corrige a fixture com termos e atributos
governados pertencentes ao lease, SKUs sintéticos distintos e identificadores de especificação por
produto. Passou no check local completo: 220 arquivos/1.403 testes da aplicação, suítes contratuais,
lint, tipos e build. A regressão de colisão de ID falhou antes e passou depois da correção.
A homologação remota desse SHA ainda está pendente; CI anterior não aprova bytes alterados.

Permanecem obrigatórios G11, ciclo editorial real, Chrome autenticado, captação positiva e suas
13 verificações, UAT/rollback e evidência terminal. Não elevar budgets, escolher amostras favoráveis
ou converter diagnóstico em aprovação. CAT-011 exige aprovação nominal independente; itens 17/18
são provisórios e falta a origem/fabricante do item 20. CAT-D010 continua adiado.

O [registro de execução](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md)
separa diagnóstico, correção e entrega. Catálogo default-off; produção, publicação do catálogo,
carga comercial e cutover permanecem fora do escopo.

## Registro histórico preservado — 30 de setembro de 2026: Chrome implementado; G11 bloqueia homologação

O usuário aprovou mover a captação positiva e suas dependências para Chrome real, sem retirar
controles. A implementação `cccedddc22b895a58f8bca74b649ede3200a1572` passou no check completo
e no CI `36719306735`. A ponte `36720500359` promoveu o mesmo pacote selado para staging.
Não refazer as Fatias 1–4 nem reconstruir o artefato promovido.

A promoção passou no attempt 1; somente a consulta de métricas falhou com HTTP 502. Recuperação,
backend restaurado, cleanup e watchdog foram comprovados. Uma única retomada **somente de métricas**
passou no attempt 2, sem novo deploy. O controle `624eaf0b1256485fbe8ae1174c8219ff94846885`
passou no check completo, em 44 testes focados e no CI `36724177499`. Vincula a prova ao produtor
original e o relatório ao attempt verde, recusando qualquer mudança de execução.

O [deploy canônico 36725530364](https://github.com/Vnd93/gaiatec-cms/actions/runs/36725530364)
consumiu o candidato e pacote originais, mas reprovou o **G11: p95 de leitura administrativa 958 ms,
limite 500 ms**. Comandos passaram em 454 ms / limite 800 ms. A etapa Chrome ficou skipped e não
houve challenge nem captação positiva atestada. Não repetir automaticamente ou aumentar budgets.

Finalizer aprovado em 212 s e watchdog `36728015014` verde, sem recuperação adicional necessária.
Sonda terminal: 100% de disponibilidade, zero 5xx, identidade exata e p95 público 688,970 ms.
O diagnóstico somente leitura confirmou índices válidos e ausência de locks ativos; o custo está
concentrado no snapshot/RPC. O código Supabase/G11 não mudou desde `035350a`; o incidente de latência
do Supabase permanece aberto, mas não comprova sozinho a causa. Próximo passo: diagnóstico dirigido
desse gate antes de outra execução canônica; não reiniciar CI/ponte válidos nem as Fatias 1–4.

O [registro da realocação e retomada](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md)
contém matriz, testes, artefatos e tempos. O release completo e Chrome real ainda não foram homologados.
Flag desligada; 113 migrations; zero dados comerciais, overrides e leases QA ativas.
Produção, publicação do catálogo, carga comercial e cutover continuam fora do escopo.

## Registro histórico preservado — 30 de setembro de 2026: G17 anterior aprovado

O candidato `035350ad690dcba40bd4542705a6b184b01b87bc` está em `main` e em staging. Foram
entregues correções de leitura pública, patches de segurança e UUIDs completos nas fixtures de IA.
CI `36658205367` e ponte `36658865515` verdes; mesmo pacote selado, sem rebuild. Não refazer as Fatias 1–4.

O [deploy canônico 36660065421](https://github.com/Vnd93/gaiatec-cms/actions/runs/36660065421)
passou G11 (29/29), G12 e G17 (12 checks, inferência real Sante gratuita/ZDR). Blog e campanha/formulário
também passaram, mas a **captação positiva foi recusada pelo Turnstile**: o canário ainda envia token
dummy antes da etapa Chrome. O release não está homologado; as lanes posteriores ficaram skipped.

Finalizer e watchdog `36661969245` verdes; sonda terminal com 100% de disponibilidade/zero 5xx.
113 migrations, última `0113`; catálogo default-off, zero overrides, produtos, snapshots e leases QA
ativas; RLS preservada. Produção, carga comercial, publicação do catálogo e cutover intocados.

A próxima decisão é realocar a captação positiva e suas provas dependentes para a etapa Chrome real,
preservando todas as negativas, idempotência, RBAC/AAL2, LGPD, cleanup e evidência terminal. Não aceitar
token dummy, retirar gate ou repetir o run. A pausa da automação histórica não foi confirmada.
O [registro de correções, tempos, artefatos e retomada](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md)
detalha a evidência. Aprovação nominal independente e UAT/rollback do catálogo continuam pendentes;
itens 17/18 provisórios, item 20 incompleto e CAT-D010 adiado.

## Registro histórico preservado — 29 de setembro de 2026: modelo gratuito com ZDR

A autorização de substituição do modelo foi executada exclusivamente em staging. O candidato
`840049128e28e0d66bdd2725cf9df140a326ff29` passou no CI e bridge; migration `0113` aplicada.
O modelo ativo é `inclusionai/ling-3.0-flash-sante:free`, com ZDR, coleta negada e preços máximos
zero. Dados reais, publicação automática, acesso direto ao banco e fallback pago continuam proibidos.

O canário operacional executou inferência real com dados sintéticos e aprovou 12 checks no
[diagnóstico 36620622496](https://github.com/Vnd93/gaiatec-cms/actions/runs/36620622496), com cleanup
e resíduo aprovados. **Esse diagnóstico não aprova o release nem substitui o gate canônico G17.**

O [deploy canônico 36618100708](https://github.com/Vnd93/gaiatec-cms/actions/runs/36618100708)
permanece reprovado por latência G11. O diagnóstico também reprovou comandos (p95 3.675 ms / budget
800 ms) e o ciclo editorial da landing sintética (página/API HTTP 503). O incidente ativo de latência
do Supabase é compatível com parte dos atrasos; não comprova a causa de todos os sintomas.
Finalizer e watchdogs terminaram verdes. Não repetir deploy cegamente nem aumentar budgets.

Estado posterior: 113 migrations, última `0113`, flag `ev2.catalog_v1` desligada, zero overrides,
produtos, snapshots ou leases de QA ativas; RLS preservada. Produção não foi alterada. Chrome real
confirmou apenas sessão autenticada e barreira default-off, não homologação funcional completa.

O [registro da substituição e diagnóstico](../10-produto-requisitos/nucleo-catalogo/registro-modelo-gratuito-zdr-2026-09-29.md)
contém SHAs, digests, resultados Qwen/Sante, tempos e retomada. Não refazer as Fatias 1–4. Faltam
estabilidade/diagnóstico dos bloqueios, gates canônicos, Chrome real completo, UAT/rollback e
aprovação nominal independente. Itens 17/18 permanecem provisórios, item 20 incompleto e CAT-D010
adiado. Não houve carga comercial, publicação do catálogo ou cutover.

## Registro histórico preservado — 29 de setembro de 2026: antes da substituição

O texto abaixo registra a fotografia anterior à autorização de selecionar outro modelo. Sua decisão
pendente foi resolvida pela autorização e execução descritas acima; o registro histórico permanece.

O usuário autorizou migrations e deploy controlados **exclusivamente em staging**. Foram aplicadas
as migrations até `0111` e implantados os bytes selados do candidato
`87010df64300c4c41089f9d0fc74e6bd6ed1a6a7`, sob o controle de release
`92b87565111d09d7b2eb25f3e1f307e9219d8766`. Não reiniciar a implementação das Fatias 1–4.

O [deploy 36595593172](https://github.com/Vnd93/gaiatec-cms/actions/runs/36595593172) passou pelos
gates de migrations, integridade, compatibilidade, três janelas G12 e regressões de navegador,
mas **não foi homologado**: o canário de IA recebeu `OPENROUTER_NO_ALLOWED_PROVIDER`. A consulta
ao OpenRouter confirmou zero endpoints para o modelo fixado. Finalizer e watchdog terminaram
verdes; estado/fences foram liberados por CAS e não havia operação concorrente ao fechar a evidência.

`ev2.catalog_v1` permanece desligada, com zero overrides, produtos, snapshots e leases de QA ativos.
As tabelas do catálogo mantêm RLS. A inspeção em Chrome real autenticado confirmou apenas a barreira
default-off; não substitui UAT funcional. Não houve publicação de catálogo, carga, cutover nem alteração
de produção.

O bloqueio imediato exige decidir entre manter o modelo atual e aguardar disponibilidade ou autorizar
a seleção e validação de outro modelo gratuito com ZDR e coleta de dados proibida. Não há retry
automático nem autorização implícita para trocar o modelo ou reduzir privacidade. Após resolver esse
gate, ainda faltam a homologação Chrome completa, o UAT/rollback do catálogo e a aprovação nominal
independente; itens 17/18 continuam provisórios e item 20 incompleto.

O [registro de staging controlado](../10-produto-requisitos/nucleo-catalogo/registro-staging-controlado-fatias-1-a-4-2026-09-29.md)
contém a cadeia exata de SHA/artefatos, correções já concluídas, recuperação, tempos e ponto de retomada.
Esta atualização prevalece sobre as fotografias históricas abaixo somente quanto ao estado atual.

## Registro histórico preservado — 28 de setembro de 2026

O texto desta seção registra o escopo e o estado daquela data. A restrição então vigente a migrations
e deploy hospedados foi substituída exclusivamente para staging pela autorização de 29 de setembro.

O desenvolvimento integrado das Fatias 1–4 do Núcleo de Catálogo está em `main`, SHA
`486fa5c40baeafe7212914591499245ddef4a5a6`. O
[run 36512509486](https://github.com/Vnd93/gaiatec-cms/actions/runs/36512509486) terminou
integralmente verde: qualidade, banco isolado, navegador automatizado, runtime Edge, pacote e
métricas. Foram aprovados 1.351 testes Vitest e 2.110 testes pgTAP.

O código inclui workspace administrativo, RPCs, revisão/publicação por snapshot, relações,
herança e páginas editoriais. A feature flag continua default-off. Não houve migration hospedada,
deploy, carga, publicação ou cutover; produção não foi alterada. Chrome real autenticado em staging,
aprovação nominal e rollback real permanecem pendentes: CI verde não equivale a esses gates.

Consulte o [registro de integração e gates restantes](../10-produto-requisitos/nucleo-catalogo/registro-integracao-fatias-1-a-4-2026-09-28.md)
para SHA, artefatos, digests, tempos e ponto de retomada. A próxima ação é obter autorização
específica para implantação/homologação controlada de staging; não reiniciar fatias implementadas
nem repetir os runs históricos. Itens 17/18 continuam provisórios e CAT-D010 continua adiado.

## Registro histórico preservado — 13 de setembro de 2026

O texto abaixo é evidência histórica, não instrução operacional vigente. Sua antiga “próxima ação”
foi substituída pelo ponto de retomada acima. Sempre confirmar o estado remoto antes de agir.

Fotografia verificada em **13 de setembro de 2026, 14:50 BRT**. Consulte o estado remoto novamente
antes de qualquer decisão operacional.

## Código e GitHub

- `Vnd93/gaiatec-cms`: branch padrão `main`, SHA
  `0d8386e51ad3185300479ee42642bdf19d935f82`.
- CI desse SHA: [run 34770336844](https://github.com/Vnd93/gaiatec-cms/actions/runs/34770336844),
  concluído com sucesso.
- bridge de frontend de staging:
  [run 34770627214](https://github.com/Vnd93/gaiatec-cms/actions/runs/34770627214), concluído com
  sucesso.
- deploy de staging:
  [run 34771260324](https://github.com/Vnd93/gaiatec-cms/actions/runs/34771260324), concluído com
  falha no ciclo editorial autenticado e mutante. O job finalizer concluiu com sucesso.
- watchdog do deploy:
  [run 34772770045](https://github.com/Vnd93/gaiatec-cms/actions/runs/34772770045), concluído com
  sucesso.
- Ao fim da observação não havia workflow em fila ou execução.

Conclusão correta: o código está publicado em `main` e passou no CI, mas o candidato **não foi
homologado** pelo deploy de staging. Finalizer e watchdog verdes provam encerramento seguro; não
transformam o gate funcional reprovado em aprovação.

## Supabase

Os projetos Staging (`glcqsosxwgmlhzgcsnzv`) e Production (`chfuhctnhqgyjowkvllv`) estão na mesma
organização, **GAIATEC Production**, com isolamento preservado. Staging permanece à frente de
produção. Consulte [ambientes e execução](ambientes-e-execucao.md).

## Documentação

- `Vnd93/gaiatec-documentacao` é a fonte canônica da documentação humana.
- O fluxo vigente é direto em `main`, conforme o `AGENTS.md`; a política antiga de branch + PR foi
  substituída.
- A branch antiga `docs/g12-production-release`, seus commits locais e o trabalho não commitado foram
  preservados no commit `060c05f` e na tag
  `archive/docs-g12-production-release-2026-09-13` antes da consolidação.
- Cópias soltas e a antiga pasta local `FONTE_DE_VERDADE` são material histórico, não instrução
  operacional vigente.

## Próxima ação vigente de desenvolvimento — 5 de outubro de 2026, candidato `0a3027b`

Aguardar melhora material na alocação de runners do GitHub e revalidar lease, zero operação
concorrente, recovery/fences, SHA, pacote, ponte e deployment live. Reutilizar apenas checkpoints
independentes ainda válidos do `0a3027b`; nunca reconstruir o pacote nem refazer as Fatias 1–4.
Gates live, segurança, amostragem e cleanup devem ter provas válidas para a nova execução.
Chrome real continua just-in-time após os gates prévios e watcher pronto, com captação positiva,
antirreplay e verificações dependentes. Só então concluir CAT-011/012 com fontes, revisão,
UAT/rollback e evidência próprios. Catálogo default-off; sem carga/publicação comercial,
cutover ou produção. Recuperação verde não significa projeto finalizado.

## Próxima ação histórica — 5 de outubro de 2026, antes do orçamento autorizado

Partir de `7efbedb`, não do run histórico abaixo. Correlacionar a latência de autenticação/transporte
de `37350070838` com o provedor, usando a janela UTC e métricas sanitizadas do registro vigente.
Não há correção de código comprovada nem autorização para relaxar controles ou repetir o canônico
sem fato novo. Quando houver diagnóstico material, revalidar lease, estado remoto e checkpoints;
preservar o pacote original se os bytes não mudarem. Depois dos gates automáticos verdes,
executar Chrome real just-in-time, captação positiva e dependências. Só após o pipeline completo
verde, seguir com CAT-011/012, proveniência, cleanup e rollback próprios. Não declarar finalizado
antes dessas provas.

## Próxima ação histórica — superada pelos checkpoints acima

Retomar a partir do SHA atual, investigar a falha do passo “Run the complete authenticated mutating
editorial cycle first” no run 34771260324 e corrigir somente a causa comprovada. Revalidar CI e o
deploy de staging no novo SHA. Não promover produção e não repetir o mesmo run.
