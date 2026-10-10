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
ultima_revisao: 2026-10-10
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

## Estado vigente — entrega vazia para operação manual

SHA `64a87ed07a5f246fa86f14add0b669a60b08e8ff`: validação local integral
aprovada, CI `38065762352/1` verde nos sete jobs (422 s) e bridge
`38066354913/1` verde (674 s). O pacote original `11674632761`, digest
`5b58686be2e41d294528ce44d2f5e01d8f2e589668af441a4056004c511a5f13`,
foi promovido sem rebuild; evidência do bridge validada oficialmente.

O canônico `38067281450/1` reprovou em 1024 s: as três janelas públicas G12
passaram, mas a leitura administrativa G11 teve p95 de 3546 ms no servidor,
acima do limite autorizado de 2000 ms; p95 total de 3834 ms. Comando: 637 ms
no servidor. Disponibilidade, MFA, isolamento, auditoria, acessibilidade,
rollback e limpeza sintética passaram. Chrome não executou; os fluxos do
catálogo ainda não estão homologados neste SHA.

Finalizador e watchdog `38068448877` concluíram com sucesso. Terminal
`11676047051`, digest
`87be9af0a5541b6b2c4be6c111630fa97a29dee883944e233b72cd89ec0d23ef`,
verificado: 82 respostas válidas, zero 5xx e p95 651,739 ms. Estado remoto
reconfirmado: zero operações concorrentes, fences, leases QA, overrides
ativos e produtos; 710 deployments Cloudflare únicos, nenhum ativo; flag
global OFF. Produção intocada.

A investigação atual separa processamento do snapshot, RPC e transporte.
Estatísticas acumuladas do banco não provam o custo na janela reprovada;
o sweeper nessa janela levou 59, 13 e 182 ms. Não há causa comprovada para
essa cauda de latência nem para os HTTP 503 históricos. Não aumentar limites
nem repetir releases para obter verde. CAT-001–010: implementados, não
homologados; CAT-011: fora do escopo; CAT-012: pendente.

### Histórico da falha de transporte no bridge

`dc132ba1ada3e998687cf8338cd76cadf2a40fac` está em `main`, com CI
`38063987001/1` verde nos sete jobs (431 s). A seleção e o plano foram
verificados por digest e pelo validador oficial; pacote original `11674366032`,
digest `c69b17b5ffb9c9465af94f6af627203c9b3e07c87e4ede0c2ffeafb9b678c0eb`.
O bridge `38064557890/1` reprovou antes da troca de backend: `/contato`
retornou 503 por timeout de transporte no Worker. O backend ainda era `f3211fc`;
as duas execuções Edge correlacionadas terminaram 200 (402 e 234 ms).
O diagnóstico Edge de `dc132ba` não chegou a ser implantado.

Compensação e watchdog `38065009489` concluíram com sucesso. Evidência
`11675236158`, digest
`94e06812d7a48312489a1623ee406608f02072731b61c68134a2a47a7a65ab1b`,
verificada: baseline restaurado, 82 respostas válidas, zero 5xx, p95 950,134 ms.
Zero operações concorrentes, fences, leases QA, overrides ativos e produtos;
flag global OFF. Não houve homologação Chrome nem alteração em produção.
A causa do atraso de transporte permanece aberta; a próxima medição local
registra início, duração e resultado de cada tentativa do Worker, somente em
falhas públicas de staging, sem alterar limites, hedge, status ou precedência.
25 testes Vitest e cinco testes Node focados passaram; validação integral pendente.
CAT-001–010 permanecem implementados, não homologados; CAT-011 fora do escopo;
CAT-012 pendente. Não repetir o bridge anterior para buscar verde.

### Histórico da falha de leitura no canônico

SHA `f3211fcf2f6194a91806d5b26d20e0629af38311`: CI `38060207911/1`
verde nos sete jobs (362 s) e bridge `38060981114/1` verde. O pacote original
`11673131369`, digest
`d93dba1808ff9db93e031907178bf670bf3fa7f50a314a91092bc10a273c1028`,
foi preservado e promovido sem rebuild. A validação canônica `38061729738/1`
falhou na primeira janela pública G12: `/contato` retornou HTTP 503,
81 de 82 respostas válidas. G11 e Chrome não chegaram a executar nessa tentativa.

O trace `d1068ee7-23be-43bb-ae45-de18ecfed120` correlaciona o documento,
Worker e backend: a primeira execução Edge terminou 503 em 1817 ms; a segunda
terminou 200 em 1412 ms, depois da resposta de erro. O gateway registrou 503
para o marcador da primeira tentativa. Isso comprova um erro HTTP do backend
nesta ocorrência, não sua causa interna nem a causa do 503 histórico.

Finalizador e watchdog `38062967880` concluíram com sucesso. Artefato terminal
`11673513343`, digest
`0511861b222f56f8814501202d5f53d28fe910f1ff606300f32992cac66abfe9`,
verificado antes da extração: 82 respostas válidas, zero 5xx, p95 1061,907 ms,
seis leases terminais e nenhum ativo. Nova consulta confirmou zero operações
concorrentes, fences, leases QA, overrides ativos e produtos; flag global OFF.
Produção permanece intocada. O diagnóstico local acrescenta correlação da leitura
primária e identificação fechada da etapa de erro de `page-by-path`, somente em
staging, sem alterar status, timeout, tentativas ou precedência. Os 47 testes
focados passaram; validação integral e entrega deste diagnóstico estão pendentes.
CAT-001–010 continuam implementados, não homologados; CAT-011 fora do escopo;
CAT-012 e Chrome real autenticado pendentes.

### Histórico da falha na limpeza de sessões

O canônico `38057930080/1`, SHA `ce1b425`, reprovou na limpeza sintética
G11: revogação de sessões recebeu `G11_STAGING_MANAGEMENT_QUERY_FAILED:502:unknown`
da API de gestão do Supabase. Não foi um 503 de documento: os três probes
anteriores passaram com 82 respostas cada, zero 5xx. Os testes operacionais G11
passaram antes da limpeza, inclusive MFA, segregação, auditoria e desempenho;
isso não torna o canônico aprovado.

Finalizador e watchdog `38059085851` concluíram com sucesso. Evidência terminal
`11672361601`, digest
`2bc9222068cdd6745fc6de4367a4f0bd4392a1cb82e300e7762f52a8dbceeb37`,
verificada antes da extração: 82 respostas, zero 5xx, p95 público 599,984 ms;
seis leases terminais, nenhum ativo. Nova consulta confirmou zero operações
concorrentes, fences, overrides ativos e produtos; catálogo global OFF.
Chrome não executou. Produção permanece intocada.

A correção em validação local troca a revogação dos atores autenticados pela
API oficial Auth com logout global, vinculada ao ator, SHA, ambiente e lease
ativo. Mantém a revogação SQL para fixtures parciais sem token, os limites
existentes, a contagem independente em `auth.sessions`, a conclusão do lease e
a prova de resíduo zero. Não faz retry nem aceita erro de logout. O motivo do
502 da plataforma e a causa subjacente do 503 histórico não estão comprovados.
CAT-001–010 ainda não homologados; CAT-011 fora do escopo; CAT-012 pendente.

### Histórico do bridge instrumentado

Atualização após o bridge: `ce1b4255916a9023cec7bb4f989b60dacaf54aba`
está publicado em `main`. CI `38056427709/1` verde nos sete jobs, em 417 s;
bridge `38057038529/1` verde, com promoção de 518 s e watchdog `38057613390`
corretamente ignorado. Seleção, plano, métricas, evidência do bridge e restauração
foram verificados por digest. O pacote original `11671411810`, digest
`ff3c88dc914053bddce69e026e02562f8cbfcb9765047a25a7d9cd228f29f542`,
foi promovido sem rebuild. A restauração devolveu o backend candidato, versão
733; health canônico HTTP 200, `ready`, release exato. Zero operações
concorrentes, leases QA, overrides habilitados e produtos; flag global OFF.

Os logs reais de gateway capturaram o marcador gerado em staging com respostas
200, comprovando o novo vínculo diagnóstico. O próximo gate é a validação
canônica e, somente após seus gates automáticos, Chrome real autenticado.
O 503 histórico ainda não tem causa subjacente localizada. Compatibilidade verde
não equivale a homologação nem a uma correção comprovada desse atraso.

### Histórico de 10 de outubro sobre o timeout e a instrumentação

O bridge `38055014940/1` de `48cda0b` reprovou HTTP 503 em `/contato`
no teste isolado do backend vigente, antes da troca para o backend legado.
Compensação e watchdog `38055412150` concluíram com sucesso: 82 respostas
válidas, zero 5xx. A validação canônica desse SHA não foi disparada.

A correlação pelo mesmo trace comprova duas tentativas encerradas por timeout
no Worker; ambas responderam HTTP 200 na Edge, em 81 ms e 210 ms. O atraso
no caminho de transporte ainda não está localizado. Os registros de gateway
disponíveis não coincidem por request ID nem execution ID; timestamps de
provedores distintos não comprovam causalidade.

O candidato local `ce1b4255916a9023cec7bb4f989b60dacaf54aba` acrescenta
um marcador gerado por tentativa ao User-Agent capturado pelos logs de gateway,
somente em staging, sem dados do visitante. Não altera timeout, retry, orçamento
ou tratamento de 5xx. Check completo local aprovado: 235 arquivos/1640 testes,
contratos, avaliações, lint, tipos e build; 32 testes focados aprovados.
Publicação Git, CI, artefatos selados e validação em staging desse candidato
ainda pendentes. A recuperação confirmou zero operações concorrentes, leases QA,
overrides habilitados ativos e produtos, com flag global OFF. Produção intocada.

CAT-001–CAT-010 permanecem implementados, não homologados; CAT-011 fora do
escopo vazio; CAT-012 ainda depende de recovery durável, Chrome autenticado,
backend real e rollback. Não há entrega homologada nem liberação em produção.

### Histórico de 10 de outubro sobre o diagnóstico da janela medida

O candidato vigente é `48cda0bfcab508ede74399b22831af4d81605369`. A CI
`38054246328/1` concluiu sete jobs com sucesso. O pacote original `11670509121`,
digest `bb082829cd9668050d7d9f4c4680a7d486fa7aa1698ab8477eaca18174d21e96`,
teve seleção, plano e métricas verificados por digest e pelo validador oficial.
Bridge e validação canônica desse SHA ainda não foram executados.

O bridge anterior `38051410344/1` passou, mas o canônico `38052712195/1`
reprovou uma resposta 5xx em `/`: 81 de 82 respostas válidas, p95 público
616,872 ms. O finalizador reprovou no probe terminal; o watchdog `38053635334`
recuperou staging com 82 respostas válidas, zero 5xx e p95 de 624,238 ms.
Seu artefato `11670782411` foi verificado por digest. Zero leases QA,
overrides habilitados ativos e produtos; flag global OFF. Produção intocada.

O probe calculava, mas não registrava o diagnóstico sanitizado da janela medida
quando o workflow não definia um arquivo opcional. A correção vigente registra
esse diagnóstico no log em caso de falha, sem alterar orçamento, timeout, retry
ou resultado do gate. Validação completa local aprovada: 235 arquivos/1640
testes Vitest, contratos, avaliações, lint, tipos e build; 11 testes focados
incluem uma resposta 503 fatal, sem request adicional ou exposição de corpo/header
privado. Isso corrige a perda de evidência, não comprova a causa dos 503.

CAT-001–CAT-010 continuam implementados, não homologados. CAT-011 permanece
fora do escopo comercial da entrega vazia; CAT-012 depende de recuperação
durável dos dados sintéticos, Chrome autenticado com backend real e rollback.

### Histórico de 10 de outubro sobre instrumentação da coleção

Em 10 de outubro, o candidato `7eb9c7fa488db3277df7683ee52435063815a04a`
concluiu a CI `38050782235/1`, com sete jobs aprovados em 334 s. O pacote
original `11669815028` permanece selado; seleção, plano e métricas foram
verificados por digest e pelo validador oficial. A instrumentação da coleção
pública é restrita a staging, sem novos retries ou alteração de timeouts.
Bridge e validação canônica deste candidato ainda estão pendentes.

O canônico anterior `38048258644/1`, de `6cf5178`, falhou em
`public_collection_available:503`, depois de 47 testes públicos/mobile/acessibilidade
e do ciclo editorial aprovados. Finalizador e watchdog `38049964687` recuperaram
staging com sucesso: 82 respostas, zero 5xx e p95 público de 825,209 ms.
A causa no transporte/consulta ainda não foi comprovada. Catálogo vazio,
flag global OFF, nenhum lease QA ou override habilitado ativo.
Ainda faltam recuperação durável do catálogo sintético, homologação manual
com Chrome autenticado e backend real, rollback funcional e relatório de entrega.
Não carregar catálogo comercial nem alterar produção ou realizar cutover.
[Checkpoint e evidências atuais](../10-produto-requisitos/nucleo-catalogo/backlog-executavel-fatias-1-a-4-2026-09-24.md).

## Histórico da primeira validação de 10 de outubro

Em 10 de outubro, CI `38042537850/1` e bridge `38043253517/1` aprovados
para `52be92c31f23fdb7a944fd078d299036cf26a41f`, preservando o pacote
selado original. Canônico `38044372481/1` reprovado por HTTP 503 em
`/industrias/saneamento`; 46 testes aprovados e três ignorados. A correlação
documento–Worker–Edge comprova a resposta 503 de `entity-detail`, mas não
a causa da falha no transporte ou na consulta. Sem rerun cego.

Finalizador e watchdog `38045678647` verdes; artefatos terminais verificados
por digest. Sonda de recuperação: 82 respostas, zero 5xx e p95 656,953 ms,
com SHA e budgets exatos. Ausência de operações concorrentes/fences e
resíduos QA ativos reconfirmada. Catálogo vazio e flag global OFF.
Instrumentação direcionada da leitura primária em validação local, sem
alterar timeouts, retries ou resultados HTTP. Ainda não homologado em
Chrome real; CAT-012, fluxo manual do catálogo e relatório final pendentes.
Produção, carga comercial e cutover permanecem proibidos.
[Checkpoint e evidências atuais](../10-produto-requisitos/nucleo-catalogo/backlog-executavel-fatias-1-a-4-2026-09-24.md).

## Histórico da retomada de 9 de outubro

Retomada em 9 de outubro: candidato de diagnóstico
`add1312b1edbc4f9ac8de4d653754c11993fcc9a`, validação local integral verde
(227 arquivos/1.543 testes Vitest, contratos, segurança, lint, tipos e build).
O Worker distingue HTTP/timeout/transporte somente em falhas públicas de staging,
com vocabulário limitado e isolamento por requisição. Não altera status, tentativas
ou deadlines. Isso fecha a lacuna de observabilidade, **não comprova a causa do 503**.
A CI `37934288884/1` e a ponte `37935408250/1` concluíram verdes, com o
pacote original `11617434200` e os mesmos bytes selados, sem rebuild.
O canônico `37939241290/1` passou nas rotas públicas/mobile, mas falhou no G17:
`cms-ai` retornou 503/`OPENROUTER_NO_ALLOWED_PROVIDER`. A causa desta falha
é a indisponibilidade do modelo gratuito Sante sob a política exigida; é distinta
do 503 histórico de documento, cuja causa continua não comprovada.
Finalizador e watchdog `37942386716` verdes, artefatos terminais verificados.
Estado vivo: deployment `844802d1-1505-40e2-ba9b-1998bba854da`, mesmo SHA
`add1312`, saúde ready/HTTP 200, 116 migrations, zero produtos/leases QA/overrides
ativos e flag global desligada. Sonda terminal: 82 respostas, 100% disponibilidade,
zero 5xx, p95 632,880 ms. Chrome terminal ainda não foi alcançado.

Em preparação local: sucessor gratuito `apodex/apodex-1.1-mini:free`, endpoint
Novita listado com preço zero e ZDR em 9 de outubro. Elegibilidade pública não
é inferência homologada. A transição aditiva 0117 mantém as quatro policies
históricas, MFA/AAL2, RLS, auditoria, preço zero, coleta proibida e ZDR.
O novo candidato depende de validações, CI, ponte e canônico próprios.

Escopo confirmado: funcionalidades administrativas, catálogo manual e editorial;
sem carga de produtos/SKUs/dados comerciais, flag global off, apenas staging.
Recaptura da lista nominal não bloqueia esta entrega vazia. Implementado não significa
homologado: CAT-001–010 continuam `ready-for-gate`; CAT-012 exige Chrome/UAT/rollback.
[Inventário de implementado, validado e pendente](../10-produto-requisitos/nucleo-catalogo/backlog-executavel-fatias-1-a-4-2026-09-24.md).

GitHub reconfirmado: bridge `37653825738/2` verde com produtor `/1` e artefatos
originais; canônico `37868132027/1` reprovado por documento mobile HTTP 503 em
`/industrias/instrumentacao`. Finalizador e watchdog `37870009505` verdes.
Recuperação comprovada, alias original preservado, saúde ready e zero resíduos ativos.
O teste focado posterior passou; a causa histórica continua sem comprovação.
Diagnóstico seguro de Worker/documento já implementado e validado; a próxima
correção bloqueante é o modelo gratuito de IA, sem alterar timeouts, aceitar
503 ou repetir releases às cegas. Chrome/UAT do catálogo ainda pendentes.

Checkouts limpos/sincronizados e GitHub `Vnd93` confirmados antes da implementação.
Produção, publicação comercial e cutover não autorizados. Os checkpoints abaixo
permanecem como histórico, não como estado vigente ou nova exigência de carga.

## Estado vigente após diagnóstico do cancelamento de leitura redundante

O candidato `ba75ba0e087896a00c035b35018ef65b7311d1e2` concluiu a CI
`37639707508` e a ponte `37643707867` com o mesmo pacote original selado.
O canônico `37645779746` passou no gate público antes bloqueante, no deploy e
nos dois gates pós-deploy somente leitura. Parou no observador do ciclo Auth:
uma leitura redundante de página foi cancelada após outra completar HTTP 200.
Finalizador e watchdog `37650298431` verdes; staging recuperado, 116 migrations,
flag global desligada e zero resíduos ativos. Chrome ainda não foi alcançado.

Cinco navegações somente leitura reproduziram a classificação incorreta.
A correção mínima do observador exige dois GETs públicos sobrepostos na mesma
aba, URL e chave pública, sem Authorization, resposta vencedora HTTP 200 com
corpo concluído dentro do prazo original e cancelamento posterior da única
tentativa excedente. Erros HTTP, corpo interrompido, timeout, origem divergente,
outra aba ou ausência dessa prova continuam bloqueantes. A seleção focada passou
em 73 testes e cinco navegações posteriores passaram com contagem explícita do
cancelamento comprovado. Esse diagnóstico não substitui Chrome/UAT autenticado.

Correção CMS `aab0b27a4899ab0d9a7bc84a6f10d2512019d233`, três arquivos de QA,
38 novos testes. Validação integral verde: 227 arquivos/1.528 testes Vitest,
demais contratos/evals, lint, tipos e build em 25,60 s, mantendo 799.883 bytes
iniciais. Aplicativo, backend e dependências não foram alterados. A cadeia remota
do novo SHA ainda é necessária.

CAT-001–010 continuam `ready-for-gate`; CAT-011 mantém a aprovação funcional das
20 linhas, com recaptura técnica pendente; CAT-012 exige Chrome/UAT/rollback.
Sem produção, carga/publicação comercial ou cutover. As Fatias 1–4 não serão
reimplementadas. [Provas e tempos](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após falha intermitente na navegação pública

Em 7 de outubro, o candidato `c53d183b8b822e571ab2e5ca7328bead0bba76f4`
concluiu CI `37629341311` em 524 s e ponte `37630829420` em 837 s, promovendo
o pacote original `11485863462`, sem rebuild. O canônico `37633039283` durou
1.506 s e passou pela auditoria, 134 verificações de migrations e três janelas
G11/G12. Parou no teste público: 46 casos passaram, três foram pulados e um
não exibiu o título de `/industrias/protecao-catodica` nos cinco segundos originais,
apesar do documento HTTP 200. Chrome e a aprovação terminal não foram alcançados.

Finalizador e watchdog `37636530296` concluíram com sucesso. A sonda terminal
obteve 82 respostas, 100% de disponibilidade, zero 5xx e p95 de 662,378 ms.
Staging serve o mesmo SHA no deployment `3a0d0704-5a9b-4065-995c-0cf7984a475f`;
116 migrations/0116, catálogo global desligado, zero produtos/snapshots, leases QA,
overrides ativos e operações concorrentes conferidos após a recuperação.

O diagnóstico isolado reproduziu carregamento pendente em outra rota pública,
com cinco chamadas sem resposta no trace. Outra sequência instrumentada completou
30 navegações, sem erro de JavaScript; isso confirma intermitência, não aprova o
release reprovado. A correção `ba75ba0e087896a00c035b35018ef65b7311d1e2`
fica limitada ao transporte das leituras de página,
sem aumentar o prazo do gate, repetir erros HTTP ou modificar Auth/RLS/backend.
Não refazer Fatias 1–4. UAT/rollback e recaptura técnica continuam pendentes;
sem produção, publicação/carga comercial ou cutover.
Validação integral local verde: 226 arquivos/1.490 testes Vitest, demais
contratos/evals, lint, tipos e build em 20,01 s, com 799.883 bytes iniciais.
O novo SHA exige CI, pacote original selado, ponte e canônico próprios.
[Diagnóstico e evidências](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após bloqueio de segurança na dependência de imagens

Em 7 de outubro, a retomada canônica `37626820878` foi interrompida antes do
deploy pela auditoria de dependências: Sharp 0.35.4 passou a ser classificado como
vulnerável por `GHSA-wq5f-xc86-pv6w`. Os três alertas altos correspondem à mesma
cadeia Sharp → Miniflare → Wrangler. Não houve migration, publicação ou mutação
do backend nessa execução. O watchdog `37627287149` encerrou verde, sem compensação.

A correção mínima `c53d183b8b822e571ab2e5ca7328bead0bba76f4` fixa Sharp 0.35.5
e seus binários corrigidos, sem atualizar Wrangler ou Node. Auditoria zerada e
validação integral verde: 225 arquivos/1.471 testes Vitest, contratos/evals,
lint, tipos e build de 799.039 bytes iniciais. Os novos testes exercitam
decodificação real SVG e conversão PNG/WebP/AVIF. O novo SHA exige CI,
pacote selado, ponte e homologação canônica próprios.
Não reutilizar a aprovação dos bytes anteriores nem refazer as Fatias 1–4.

Staging permanece no deployment `5bd29847-5540-4d42-8fb4-390cf3dd0f3c`, SHA
`eb52399252855bfc32b2190ed3bc82803d1420f9`, com 116 migrations/0116 e catálogo
global desligado. Zero produtos/snapshots, leases QA, overrides ativos e concorrência
confirmados após o encerramento. Chrome, UAT/rollback e recaptura técnica continuam
pendentes. Sem produção, publicação/carga comercial ou cutover.
[Diagnóstico e evidências](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após recuperação da leitura do formulário

O candidato `eb52399252855bfc32b2190ed3bc82803d1420f9` tem CI `37466998968`
e ponte `37468364236` verdes, com o pacote original `11415657605`, sem rebuild.
O canônico `37470394233` falhou na última leitura do formulário sintético:
o comando de arquivamento respondeu HTTP 200, mas a consulta pública seguinte
respondeu 503. O teste não chegou ao Chrome; não há aprovação terminal do release.

Finalizador e watchdog `37474097904` passaram. A sonda terminal mediu 100% de
disponibilidade, zero 5xx e p95 público de 706,843 ms. Em 7 de outubro, 12 leituras
consecutivas do formulário retirado retornaram HTTP 204, sem mutação. Conferência
independente: flag desligada, zero leases QA e overrides ativos, sem concorrência.
O frontend mantém o deployment `5bd29847-5540-4d42-8fb4-390cf3dd0f3c` e o mesmo SHA.

O pacote não expirou e a prova da ponte foi revalidada contra seus vínculos exatos.
Próximo passo: uma execução canônica controlada dos gates dependentes do ambiente,
com watcher prévio para Chrome real. Não refazer CI, ponte ou Fatias 1–4; não
reclassificar o run reprovado. O 503 está isolado na leitura pública, mas sua causa
interna não foi registrada pelo ramo de erro; timeout permanece hipótese, não fato.
Catálogo aprovado funcionalmente, default-off; UAT/rollback e recaptura técnica
continuam pendentes. Sem carga/publicação comercial, cutover ou produção.
[Evidências e limites do diagnóstico](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após recuperação da consulta pública

O candidato `5bf1ffc5de7c774da7d7f99582df629c1c5e89d8` passou na CI
`37459306938` (69 arquivos SQL, 2.207 testes pgTAP) e na ponte `37460371263`,
com o pacote original, sem rebuild. A migration 0116 foi aplicada em staging.
No canônico `37461954151`, G11/G12 passaram: leitura administrativa p95 de
564 ms / 2.000 ms, comandos 336 ms / 2.000 ms e três janelas públicas verdes.
O ciclo editorial também passou. Não refazer essas implementações.

O release parou no probe seguinte: a consulta pública retornou HTTP 503 após a
assinatura temporária das imagens atingir o prazo de 900 ms. A operação usa POST,
embora só leia objetos, e não tinha a repetição limitada existente nas leituras GET.
A correção mínima `eb52399252855bfc32b2190ed3bc82803d1420f9` adiciona uma única repetição desse caso, mantendo
paths, TTL, autorização, prazo por tentativa e todos os gates. Não repete escritas,
recusas de acesso, erros estruturados ou cancelamentos.
Revisão e validação local integral aprovadas: 225 arquivos/1.469 testes Vitest,
demais contratos/evals, lint, tipos e build de 799.039 bytes iniciais. Falta a
cadeia remota própria do novo SHA; o live permanece em `5bf1ffc`.

Finalizador e watchdog `37465049191` passaram. Evidência terminal selada: 20 respostas,
100% de disponibilidade, zero 5xx e p95 público de 535,776 ms. Conferência independente:
116 migrations/0116, flag global desligada, zero produtos, snapshots, overrides e
leases QA ativos; sem operação concorrente. Chrome não foi alcançado neste run.
Fatias 1–4 e aprovação funcional das 20 linhas permanecem preservadas; UAT/rollback e
recaptura técnica ainda pendentes. Sem publicação/carga comercial, cutover ou produção.
[Diagnóstico e evidências imutáveis](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado da autorização de leitura até 2 segundos

Em 6 de outubro, o responsável confirmou que o teto de 2.000 ms também se aplica
ao p95 das leituras administrativas, exclusivamente em staging. A implementação
é `5bf1ffc5de7c774da7d7f99582df629c1c5e89d8`: migration aditiva 0116, capability
compatível com o orçamento anterior e gates G11/G12 vinculados ao ambiente exato.
Local e produção mantêm 500 ms; comandos mantêm 2.000 ms em staging e 800 ms nos
demais ambientes. MFA/AAL2, RLS, auditoria, revisão independente, amostragem,
rollback, Chrome real e cleanup não mudam.

Revisão do diff e `npm run check` integral aprovados: 224 arquivos/1.453 testes
Vitest, demais contratos/evals, lint, tipos e build dentro do orçamento de 799.039
bytes iniciais. Os testes pgTAP da migration ainda dependem da CI com PostgreSQL.
Próximo gate: CI própria do novo SHA, pacote único selado, ponte compatível e
canônico de staging. A migration ainda não foi aplicada remotamente neste checkpoint.
Os runs antigos continuam reprovados sob seus limites originais; não são
reclassificados nem usados como homologação do novo candidato.

Fatias 1–4 e aprovação funcional das 20 linhas permanecem preservadas. Catálogo
global default-off; sem carga/publicação comercial, cutover ou produção. Ainda
faltam homologação Chrome/UAT/rollback e recaptura técnica.
[Escopo, hashes e evidências](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado após o diagnóstico de expiração e latência

O candidato `80cd1cfeef749d546da4b9413c1461e1f761d87d` tem CI `37413734179`
e ponte `37414450752` verdes, com o pacote original `11389982761`, sem rebuild.
O canônico `37415633407` reprovou na leitura administrativa: p95 de 2.406 ms,
acima dos 500 ms vigentes. Finalizador e watchdog passaram e recuperaram staging.

O [diagnóstico 37417658843/1](https://github.com/Vnd93/gaiatec-cms/actions/runs/37417658843)
terminou em 701 s com **12 de 13 gates aprovados**. O ciclo editorial passou em
13 verificações, incluindo as quatro campanhas, suas revisões e rotas HTTP
301/404/410/302. A correção da expiração está exercitada remotamente; não refazê-la.
G11 continua reprovado: leitura p95 de 737 ms / 500 ms; comandos 647 ms / 2.000 ms.
O diagnóstico não publica, não sela nem aprova release. A captação positiva e seus
controles dependentes continuam obrigatórios na etapa Chrome real.

Cleanup, resíduo zero e watchdog `37418625814` passaram. A sonda pública mediu
82 respostas, disponibilidade de 100%, zero 5xx e p95 de 500,825 ms. Conferência
independente: 115 migrations/0115, catálogo desligado e vazio, sem overrides ou
leases QA ativos, operações concorrentes ou fences. Produção permanece intocada.

Não haverá repetição cega do canônico. A autorização de 1–2 s foi implementada
somente para comandos de staging; aplicar esse teto à leitura administrativa
depende de esclarecimento do responsável. Até lá, os 500 ms permanecem válidos.
CI, pacote e ponte serão preservados e revalidados antes da continuação.
Fatias 1–4 e aprovação funcional das 20 linhas estão preservadas; ainda faltam
Chrome/UAT/rollback e recaptura técnica, sem carga/publicação comercial ou cutover.
[Tempos, digests e diagnóstico](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado da correção da verificação de expiração

O canônico [37410264055/1](https://github.com/Vnd93/gaiatec-cms/actions/runs/37410264055)
reutilizou `cfced5e`, o pacote original e a ponte já verificados. Os gates de migrations,
revogação RDO, G11/G12, navegador público e canário autenticado passaram. A execução
reprovou em 25 min 27 s na verificação de expiração editorial, antes do challenge Chrome.
O worker agendado expirou três campanhas; a chamada explícita expirou a quarta. O teste
exigia incorretamente que uma única chamada processasse todas, apesar dos quatro recibos.

Finalizador e watchdog `37412259086` verdes; staging recuperado em `cfced5e`, catálogo
desligado e sem resíduo ativo. A sonda terminal teve 82 respostas válidas, zero 5xx e
p95 público de 531,841 ms. A correção local troca a contagem global pela prova individual
de item/revisão, arquivamento, retirada, outbox e rota, mantendo os quatro testes HTTP.
Correção `80cd1cfeef749d546da4b9413c1461e1f761d87d`: 49 testes focados e `npm run check`
integral aprovados, com 1.452 testes Vitest, demais contratos/evals, lint, tipos e build
dentro do orçamento. Falta a nova cadeia remota. O SHA corrigido terá CI e artefato próprios,
sem reutilizar aprovação de outro SHA.

As Fatias 1–4 e a aprovação funcional das 20 linhas permanecem preservadas. Chrome/UAT,
rollback e recaptura documental continuam pendentes; não há carga/publicação comercial,
cutover, ativação global nem produção.
[Diagnóstico, recuperação e tempos](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md).

## Checkpoint preservado do candidato cfced5e após recuperação de staging

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
