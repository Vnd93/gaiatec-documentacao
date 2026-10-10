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
ultima_revisao: 2026-10-10
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

### Checkpoint vigente de 10 de outubro sobre o diagnóstico de snapshot

O CI `38072650903/1`, fonte `20fee6f`, terminou verde nos sete jobs.
Pacote original `11677114581`, digest
`65b6c19d81f7f93a2a217ce08ea4547f905ba29637561faf840c969407484d1e`,
não implantado. O staging continua em `64a87ed`.

A fonte `9da477363722316a0178b77278b89f4c5dc42e01` adicionou observação
numérica de recursos durante o diagnóstico local: no máximo 13 leituras,
intervalo mínimo de cinco segundos, sem sobreposição ou retries, sem
labels ou dados pessoais. Validação integral local aprovada: 235 arquivos,
1644 testes da aplicação, contratos, avaliações e build de 19,28 s.
Uma janela de 17:49:53,629 a 17:50:49,475 UTC reproduziu p95 3537 ms,
pico 4474 ms. Banco: 40 chamadas, 24264,68343 ms, 65165 hits, zero leituras
físicas. As nove projeções de recursos eram idênticas; a atualização
temporal não foi comprovada. Esses valores não excluem pressão de recursos
durante o pico. Evidência local
`outputs/g11-snapshot-resource-with-fixture-64a87ed-9da4773.json`, SHA-256
`cd2938827e35cfcdac48a0116143ad32099a6b7237314f8faa974cc91c086adb`.

A fonte `9f19fce84db24c7a2e643af1e58c7fe72a96543d` acrescentou contagens
diretas e agregadas de `pg_stat_activity`, excluindo a própria conexão,
sem query text ou identidades. Contratos G11, onze testes focados, lint,
formatação e revisão aprovados. A janela de 17:54:52,594 a 17:55:19,860 UTC
teve p95 1314 ms e pico 1468 ms. Banco: 40 chamadas, 4910,554357 ms,
66150 hits, zero leituras físicas. Nas cinco amostras diretas, zero
bloqueios, esperas de I/O e transações ociosas; zero ou uma conexão ativa.
Isso não explica a janela anterior nem dispensa o gate canônico.
Evidência local
`outputs/g11-snapshot-live-waits-with-fixture-64a87ed-9f19fce.json`, SHA-256
`85f3e398697cb58daf42436a9cdb348a8593966da7eccb865d569cee82810290`.

Ambas as janelas tiveram 12 checks aprovados, dois leases encerrados,
nove eventos imutáveis de auditoria e zero resíduo ativo. Sem entrega
externa, produtos, ativação global, deploy ou mutação de produção.
São diagnósticos, não aprovação de release ou Chrome UAT.

Fonte `a300c857f2807111d9ad29b30854738dfe3a0bd6`, enviada a `main`:
validação local integral aprovada, 235 arquivos e 1644 testes da aplicação,
contratos de segurança/release, avaliações e build de 19,47 s. CI
`38071335889/1` verde nos sete jobs. Pacote original `11676818044`, digest
`86fb408efe54624e6136814c3d2ad9515e30290f8d7d3b363e1dd942c7356d4f`,
não implantado. O staging continua servindo `64a87ed`.

O diagnóstico local de snapshot exige modo explícito, destino de evidência,
SHA de fonte e SHA servido; é recusado no CI e não aprova release.
A CLI foi fixada na versão 2.116.0 e no diretório canônico. Duas recusas de
preflight ocorreram antes das fixtures: falta de vínculo local e argumento
com aspas literais no Windows. A reprodução isolada comprovou
`EINVALIDPACKAGENAME`; a correção tem regressão e preflight real aprovado.

Uma janela serial, 20 aquecimentos e 20 medições, sem formulário ou lead
ativos, concluiu de 17:17:40,975 a 17:18:05,130 UTC: p95 administrativo
663 ms. Estatísticas do banco sem reset: 40 chamadas, 1868,572476 ms de
execução agregada, 61183 hits de buffers e zero leituras físicas. A média
agregada de 46,714 ms não atribui exclusivamente o intervalo ao diagnóstico
nem explica a reprovação anterior de 3546 ms. Evidência local sanitizada
`outputs/g11-snapshot-diagnostic-64a87ed-a300c85.json`, SHA-256
`0227d483d0bc270ed83fde6a7a2ffab245b9517059b9ce6f3193cc4fe6430be6`.

Dez checks passaram; dois leases encerrados, nove eventos imutáveis de
auditoria e zero resíduo ativo. Estado real: zero leases QA, overrides
ativos e produtos, flag global OFF.

A comparação com formulário e lead sintéticos do próprio lease concluiu
com fonte `20fee6f893113e5d49085a4736457fc50fdb3f0b`, staging servido
`64a87ed`, de 17:33:56,976 a 17:34:29,624 UTC. Doze checks passaram,
p95 1846 ms, pico 2125 ms, sem entrega externa. Banco: delta de 40 chamadas,
7340,90488 ms de execução, 63647 hits e zero leituras físicas. Houve um
pico transitório entre as amostras 27 e 36; as leituras voltaram a cair sem
alterar a fixture. O sweeper executou em 9,169 ms às 17:34:00 UTC,
fora desse pico. Não está comprovado que a fixture causou a diferença.

A primeira comparação parou antes das medições: o diagnóstico esperava
`processed`, mas o contrato SQL usa `completed`. A correção mínima e sua
regressão passaram em 29 testes focados; o perfil comparativo já havia
passado na validação integral e build de 20,10 s. As duas execuções tiveram
limpeza aprovada. Evidência corrigida sanitizada
`outputs/g11-snapshot-diagnostic-with-fixture-64a87ed-20fee6f.json`, SHA-256
`db79d56454eeeb4135db45089d30c45283645de45ae089b4ddda5928e91d5a0a`:
dois leases encerrados, nove eventos imutáveis e zero resíduo ativo.
O resultado não aprova release nem Chrome UAT.

Próxima investigação: correlacionar a cauda transitória com transporte,
pool de conexões e recursos do banco, sem repetir um release. CAT-001–010
não homologados; CAT-011 fora do escopo; CAT-012 pendente.
HTTP 503 históricos continuam sem causa comprovada.

### Histórico de 10 de outubro sobre desempenho administrativo

SHA `64a87ed07a5f246fa86f14add0b669a60b08e8ff`: validação local integral
aprovada, CI `38065762352/1` verde (sete jobs, 422 s), bridge
`38066354913/1` verde (674 s), evidência validada oficialmente. Pacote
original `11674632761`, digest
`5b58686be2e41d294528ce44d2f5e01d8f2e589668af441a4056004c511a5f13`,
promovido sem rebuild. Diagnósticos de página e tentativas do Worker
implantados em staging, sem alterar budgets ou precedência HTTP.

Canônico `38067281450/1` reprovou em 1024 s. Três janelas G12 públicas
passaram; a falha foi G11: p95 administrativo 3546 ms no servidor e 3834 ms
total, contra limite de 2000 ms. Comando: p95 637 ms no servidor e 914 ms
total. Disponibilidade 100%, auditoria 100%, RPO zero, restauração em um
minuto, MFA, isolamento, acessibilidade e limpeza aprovados. Não há evidência
Chrome desse candidato nem homologação das Fatias 1–4.

Finalizador e watchdog `38068448877` verdes. Terminal `11676047051`, digest
`87be9af0a5541b6b2c4be6c111630fa97a29dee883944e233b72cd89ec0d23ef`,
verificado: 82 respostas válidas, zero 5xx, p95 651,739 ms. Métricas
`11675832237`, digest
`3ee6e7850b08ddcd4c4ac0a973f4619f74406d0aa2afe185fb7182a2ad067d97`.
Estado reconfirmado: zero operações concorrentes, fences, leases QA,
overrides ativos e produtos; 710/710 deployments únicos, nenhum ativo;
flag global OFF e produção intocada.

Próxima ação: diagnóstico direcionado da cauda de leitura administrativa,
com correlação temporal de snapshot, RPC e banco. Estatísticas cumulativas
não provam a causa na janela; o sweeper levou 59, 13 e 182 ms nela.
Os HTTP 503 históricos permanecem separados e sem causa comprovada.
CAT-001–010 implementados, não homologados; CAT-011 fora do escopo;
CAT-012 pendente. Não repetir o canônico para buscar verde.

### Histórico de 10 de outubro sobre o transporte do Worker

`dc132ba1ada3e998687cf8338cd76cadf2a40fac`: CI `38063987001/1`
verde, sete jobs e 431 s; qualidade 320 s. Seleção e plano verificados por
digest e validador oficial, pacote original `11674366032`, digest
`c69b17b5ffb9c9465af94f6af627203c9b3e07c87e4ede0c2ffeafb9b678c0eb`.
Bridge `38064557890/1` reprovou no candidato isolado contra o backend vigente,
antes da troca legado: `/contato`, ordinal 2, HTTP 503 e
`page-by-path;timeout;2;503;2900` no Worker. Trace
`5350906d-a4e3-47c8-99c7-456b768bb7e6`: backend `f3211fc`, duas execuções
200, 402 e 234 ms. Não houve implantação do diagnóstico Edge do novo SHA.
Comparação de relógios entre provedores não prova a origem do atraso.

Compensação `11675236158`, digest
`94e06812d7a48312489a1623ee406608f02072731b61c68134a2a47a7a65ab1b`,
verificada: estado `restored`, baseline `f3211fc`, 82 respostas válidas,
zero 5xx, p95 950,134 ms. Watchdog `38065009489` verde.
Zero operações concorrentes, fences, leases QA, overrides ativos e produtos;
Cloudflare 706/706 deployments únicos, nenhum ativo; flag global OFF.
Evidência sanitizada local:
`outputs/catalog-staging-dc132ba-bridge-38064557890-evidence/document-transport-correlation.json`.
Medição local adicional: início, duração e resultado por tentativa do Worker,
restrita a falhas públicas de staging. Mantém 2200 ms por tentativa, hedge
700 ms, máximo de duas tentativas e primeira resposta HTTP vencedora.
25 testes Vitest e cinco Node focados passaram; validação integral pendente.
CAT-001–010 não homologados; CAT-011 fora do escopo; CAT-012 pendente.
Nenhuma carga comercial ou alteração em produção; não repetir o bridge reprovado.

### Histórico de 10 de outubro sobre o erro de leitura de página

SHA `f3211fcf2f6194a91806d5b26d20e0629af38311`: CI `38060207911/1`
verde (sete jobs, 362 s), bridge `38060981114/1` verde e watchdog do bridge
`38061569026` corretamente ignorado. Pacote original `11673131369`, digest
`d93dba1808ff9db93e031907178bf670bf3fa7f50a314a91092bc10a273c1028`,
promovido sem rebuild. Canônico `38061729738/1` reprovou na primeira janela
G12 com HTTP 503 em `/contato`: 81/82 respostas válidas, p95 551,890 ms.
Não executou G11 nem Chrome; a troca da revogação de sessões pela API Auth
está implementada, mas ainda não validada por esse canônico.

Trace `d1068ee7-23be-43bb-ae45-de18ecfed120`: Worker recebeu HTTP 503;
Edge da primeira tentativa terminou 503 em 1817 ms e gateway confirmou o status.
A segunda execução terminou 200 em 1412 ms, depois da resposta de erro; não
recupera a disponibilidade do documento reprovado. Falta localizar a etapa interna
que produziu o 503. Diagnóstico local restrito a staging observa leitura primária,
headers, corpo e resultado do SDK, além de identificar a etapa de falha sem
registrar seletores, payloads, erros brutos ou dados pessoais. Não muda os dois
limites de 900 ms, a precedência, o status ou o consumo único da resposta.
47 testes focados passaram; validação integral e entrega do diagnóstico pendentes.

Finalizador e watchdog `38062967880` verdes. Terminal `11673513343`, digest
`0511861b222f56f8814501202d5f53d28fe910f1ff606300f32992cac66abfe9`,
verificado: 82 respostas, zero 5xx, p95 1061,907 ms; seis leases terminais,
zero ativos. Métricas `11673817942`, digest
`2a4fe8605e5ccdec5f482b25c320b9c7d24094142e9ed833610a80c40ab93638`:
1101 s no caminho reprovado, deploy 718 s e etapa reprovada 209 s.
Evidência sanitizada local:
`outputs/catalog-staging-f3211fc-canonical-38061729738-evidence/document-transport-correlation.json`.
Estado remoto: zero operações concorrentes, fences, leases QA, overrides ativos
e produtos; Cloudflare 705/705 deployments únicos, nenhum ativo; flag global OFF.
CAT-001–010 não homologados; CAT-011 fora do escopo; CAT-012 pendente.
Nenhuma publicação, carga comercial, cutover ou alteração em produção.

### Histórico de 10 de outubro sobre a limpeza de sessões

Canônico `38057930080/1`, SHA `ce1b425`, reprovou no encerramento G11:
`G11_STAGING_MANAGEMENT_QUERY_FAILED:502:unknown` ao revogar sessões pela
API de gestão do Supabase. Nenhuma falha operacional G11 precedeu a limpeza;
os três probes públicos anteriores passaram, 82 respostas cada e zero 5xx.
p95 G11: leitura administrativa 108 ms no servidor e 525 ms total;
comando 428 ms no servidor e 825 ms total. Não atribuir esta falha ao 503
histórico do documento nem tratar os testes aprovados como homologação.

Finalizador e watchdog `38059085851` verdes. Artefato terminal `11672361601`,
digest `2bc9222068cdd6745fc6de4367a4f0bd4392a1cb82e300e7762f52a8dbceeb37`,
verificado antes da extração. Probe terminal: 82 respostas, 100% disponíveis,
zero 5xx, p95 público 599,984 ms. Recovery: seis leases terminais, zero ativos.
Evidência sanitizada local:
`outputs/catalog-staging-ce1b425-canonical-38057930080-evidence/cleanup-failure-sanitized.json`.
Estado remoto atual: zero operações concorrentes e fences; Cloudflare 701/701
deployments únicos, nenhum ativo; zero leases QA, overrides ativos e produtos;
flag global OFF. Chrome não executou; produção intocada.

Correção em validação local: revogar atores autenticados pelo logout global
oficial Auth, depois de conferir identidade e lease exatos. Fixtures parciais
sem JWT mantêm revogação SQL. Nenhum retry adicional, aumento de timeout,
aceitação de erro ou gate removido. Contagem independente de sessões,
conclusão do lease, auditoria e resíduo zero continuam obrigatórios.
Documentação consultada: [logout administrativo](https://supabase.com/docs/reference/javascript/auth-admin-signout)
e [sessões Auth](https://supabase.com/docs/guides/auth/sessions).
CAT-001–010 não homologados; CAT-011 excluído desta entrega vazia; CAT-012 pendente.

### Histórico de 10 de outubro após o bridge instrumentado

SHA `ce1b4255916a9023cec7bb4f989b60dacaf54aba` publicado em `main`.
CI `38056427709/1`: sete jobs verdes, 417 s; qualidade 254 s.
Pacote original `11671411810`, digest
`ff3c88dc914053bddce69e026e02562f8cbfcb9765047a25a7d9cd228f29f542`;
dist `3f26cb497e0ba5097c17d8ea87d4fb66d27d35419d09c9713fae1b54338a7560`,
árvore `25665713e8cd3b0777f6eb5be9e1ee799ce8778cc284220ff001ee33ffa8ec34`.
Seleção, plano e métricas verificados por digest e pelo validador oficial;
produtor e gate attempt 1, perfil full-release sem redução de gates.

Bridge `38057038529/1` verde; promoção 518 s. Artefato `11671062800`, digest
`9c2d6fdc103cd3e72cd6824b8bff1b07da915970513bb892dae3ae308137fa2e`,
verificado. Deployment canônico `6ef7aa00-ccec-4f29-8992-94eecb919b30`
vinculado ao mesmo SHA e aos mesmos bytes. Restauração `11671492693`, digest
`2aa3e6e7c14462232fe323015c328f932442e830a4f2155847834fdd60ccfa22`,
verificada: backend candidato versão 733, contrato public-v2; produção intocada,
sem segredo persistido. Watchdog `38057613390` corretamente ignorado.
Health canônico HTTP 200, `ready`, release exato. Zero operações concorrentes,
leases QA, overrides habilitados e produtos; flag global OFF.

O teste isolado contra o backend vigente passou em 59 s. Os logs reais de
gateway capturaram o marcador gerado por tentativa em staging; três amostras
HTTP 200, em 253 ms, 351 ms e 285 ms. Isso valida a instrumentação, não
comprova a causa do timeout anterior. Próximo gate: canônico, seguido de
Chrome real autenticado somente depois dos gates automáticos e consumer pronto.
CAT-001–010 não homologados; CAT-011 fora do escopo; CAT-012 pendente.

### Histórico de 10 de outubro sobre o timeout do documento

O bridge `38055014940/1`, SHA `48cda0b`, falhou em `/contato` com HTTP 503
antes da troca para o backend legado. O Worker recebeu o documento completo,
em 2923,330 ms, e registrou `page-by-path;timeout;2;503;2900`.
Trace `9cf076da-d928-4d63-8312-c22b69017233`: as tentativas `.1` e `.2`
responderam HTTP 200 na Edge, em 81 ms e 210 ms, com backend `7eb9c7f`.
Isso comprova o timeout observado pelo Worker, não a origem do atraso no transporte.
Não atribuir o atraso a banco, fila ou relógio sem evidência adicional.

Artefato de diagnóstico `11670064929`, digest
`594e8b8d868f2bbc8748e7b9c242a197851666f7109a11abc8261c5ec78536ea`,
verificado antes da extração. Correlação sanitizada local:
`outputs/catalog-staging-48cda0b-bridge-38055014940-evidence/document-transport-correlation.json`.
O join por request ID não encontrou gateway correspondente. Os dois registros
`cms-public` encontrados na janela ampliada não compartilham o execution ID.
Ausência de registro não significa ausência de requisição; não comparar relógios
de provedores distintos como prova causal.

Compensação: 82 respostas válidas, zero 5xx; watchdog `38055412150` verde.
Zero workflows concorrentes, fences, operações Cloudflare, leases QA,
overrides habilitados ativos e produtos; flag global OFF. Nenhum canônico de
`48cda0b` foi disparado e nenhum bridge foi repetido cegamente.

O candidato local `ce1b4255916a9023cec7bb4f989b60dacaf54aba` contém somente
a correlação por tentativa em User-Agent gerado pelo Worker em staging e testes
de regressão. Valores do visitante são ignorados e produção não recebe o marcador.
Timeouts, hedge, retries, orçamentos e falha fechada permanecem inalterados.
Check completo local aprovado: 235 arquivos/1640 testes, contratos, avaliações,
lint, tipos e build de 19,35 s; 32 testes focados aprovados. Publicação Git,
CI, artefatos selados e validação em staging ainda pendentes para esse SHA.

CAT-001–010 implementados, não homologados; CAT-011 fora do escopo vazio;
CAT-012 pendente de recovery durável do catálogo sintético, Chrome real com
backend de staging e rollback funcional. Produção, carga e cutover proibidos.

### Histórico de 10 de outubro sobre diagnóstico da janela medida

O bridge `38051410344/1` do SHA `7eb9c7f` passou com os artefatos originais.
O canônico `38052712195/1` reprovou uma resposta 5xx em `/`, com 81 de 82
respostas válidas e p95 público de 616,872 ms. O finalizador reprovou no probe
terminal. O watchdog `38053635334` recuperou staging: 82 respostas válidas,
zero 5xx e p95 público 624,238 ms. Artefato `11670782411`, digest
`8c875483a5160e7e4fd0bdb34fc081ab298c97cacc6bf1215228e0db9383eaa9`,
verificado antes da extração; quatro leases terminais e zero ativos restantes.
Ausência de operações concorrentes, produtos e overrides habilitados confirmada;
flag global OFF. Evidência sanitizada local:
`outputs/catalog-staging-7eb9c7f-canonical-38052712195-evidence/public-route-failure-correlation.json`.

A janela temporal contém 127 respostas Edge `page-by-path` HTTP 200, com
duração interna máxima de 356 ms. Isso não identifica a requisição falha nem
comprova a causa: o probe não persistiu o diagnóstico calculado da janela medida
sem um caminho opcional de saída. O SHA `48cda0bfcab508ede74399b22831af4d81605369`
corrige somente esse registro. Uma resposta 503 permanece fatal, sem novo request;
nenhum payload, corpo, header privado ou erro bruto é registrado.

Check local completo aprovado: 235 arquivos/1640 testes Vitest, contratos,
avaliações, segurança, lint, tipos e build de 20,19 s; 11 testes focados aprovados.
CI `38054246328/1`: sete jobs verdes. Pacote original `11670509121`, digest
`bb082829cd9668050d7d9f4c4680a7d486fa7aa1698ab8477eaca18174d21e96`;
arquivo dist `7e3e5495dc9828187655f886b2d783254fde5257ce84bf5cc816e8244759a5a5`;
árvore `85998a174a7edf000cc07cd9c387433e6f1d2ba2a938a9f103df940d9a52bb0a`.
Seleção, plano e métricas verificados por digest e validador oficial; produtor
e gate attempt 1. Bridge/canônico desse SHA ainda pendentes; não é homologação.

CAT-001–CAT-010 permanecem implementados, não homologados; CAT-011 fora do
escopo vazio; CAT-012 pendente de recuperação durável do catálogo sintético,
UAT manual e rollback. Não reiniciar fatias nem relaxar gates para obter verde.
Produção, carga comercial, publicação global e cutover continuam proibidos.

### Histórico de 10 de outubro sobre a coleção pública

O canônico `38048258644/1`, SHA `6cf5178b1cc294042fcca6c4196ae960f29577e2`,
falhou em `public_collection_available:503`, depois de 47 testes públicos,
mobile e acessibilidade, CSP, canário autenticado de backend e ciclo editorial
aprovados. A janela temporal registra uma resposta Edge 503 em 2201 ms, mas
não vincula a consulta PostgREST por trace; o identificador de execução é
reutilizado. A causa permanece não comprovada.

Finalizador e watchdog `38049964687` concluíram com sucesso. Artefato terminal
`11669580720`, digest
`8435c0b26f67e26b0cb99f263342efc2b00410016e257be243b73e046a4a0567`;
métricas `11669186098`, digest
`9ba2c4dbbb5c55cc7e6aa66b12341b27097734916ca409caf6e10adb08cd9e01`.
Digests verificados antes da extração. Recuperação: 82 respostas, zero 5xx,
p95 público 825,209 ms; pipeline com falha 1732 s, deploy 1233 s.
Ausência de concorrência, leases QA, overrides habilitados e produtos confirmada;
flag global permanece desligada. Evidência sanitizada local:
`outputs/catalog-staging-6cf5178-canonical-38048258644-evidence/collection-edge-correlation.json`.

Diagnóstico direcionado `7eb9c7fa488db3277df7683ee52435063815a04a` inclui
somente a leitura primária de `products` na correlação por SHA/trace. O probe
registra início e resposta sanitizados, continua reprovando HTTP 503 e não
faz request adicional. Sem logs de payload, seletores, credenciais ou erros brutos.
Validação local completa aprovada: 235 arquivos e 1639 testes Vitest, contratos,
avaliações, segurança, lint, tipos e build; após revisão, 55 testes focados e dois
testes do probe também aprovados. Build 19,05 s; orçamento inicial 799883 bytes.

CI `38050782235/1`: sete jobs verdes, 334 s, qualidade 224 s. Pacote original
`11669815028`, digest
`e0382e8494dd6f57f690dcf72d9f1e3679f913272079c2c5281ed6b5d7170895`;
arquivo dist `4b37602232c5c8f184f4080c844c0d2fa085c1aced98f37627c67992effe2230`;
árvore `bddc767cc33817c3cb0bb8aa53aecb96ac17c2cff5dcae6021e0e78959937920`.
Seleção/plano/métricas verificados por digest e validador oficial; produtor e
gate attempt 1. Bridge e canônico deste SHA ainda pendentes. Não é homologação.

Inventário vigente: CAT-001–CAT-010 implementados e aguardando gates reais;
CAT-011 fora do escopo da entrega vazia; CAT-012 pendente de recuperação durável
dos dados sintéticos, UAT manual das operações e rollback. Não reiniciar fatias
concluídas nem tratar testes simulados como homologação. Produção, carga e cutover proibidos.

### Histórico de 10 de outubro sobre leitura de entidade e recuperação

O candidato `52be92c31f23fdb7a944fd078d299036cf26a41f` concluiu a CI
`38042537850/1` e o bridge `38043253517/1`, com o pacote original
`11665424890`, digest
`436486d202c11f3eaa25ccfa433ff4d8304a1668a6eb0ed2d3840c40bd5c672b`.
Sem rebuild. A validação canônica `38044372481/1` falhou no documento
`/industrias/saneamento`: HTTP 503, 46 testes aprovados e três ignorados.
O diagnóstico de renderização registrou sete módulos HTTP 200, nenhuma
leitura de página, nenhum erro de execução e zero eventos descartados.

A correlação exata de documento, Worker e Edge identifica `entity-detail`:
documento em 2235 ms; Worker recebeu HTTP 503 em 2071 ms; Edge terminou
HTTP 503 em 1811 ms. Isso não identifica a causa no transporte ou na
consulta PostgREST. O identificador de execução da função é reutilizado
entre invocações; respostas posteriores HTTP 200 do gateway não são prova
da consulta que falhou. A atribuição ao service worker também não prova
que ele causou a falha. Evidência sanitizada preservada, sem payloads,
seletores, credenciais ou mensagens brutas de erro.

Finalizador e watchdog `38045678647` concluíram com sucesso. ZIP terminal
`11667263774`, digest
`3c11fc05d673958ab47907a8d12e4a901c11d056791e4d61fcfc985d22bd2e9f`;
métricas `11666943114`, digest
`b973bd942ff5aea89909c7fa05cf84fd99c146e76a1f650b7d78ef39e4962095`.
Digests verificados antes da extração. Sonda terminal: 82 respostas,
100% disponibilidade, zero 5xx, p95 656,953 ms, SHA e budgets exatos.
Pipeline observado: 1348 s; deploy: 962 s; três janelas G12: 267 s;
finalização: 220 s. Caminho com falha, não comparação de caminho feliz.

Instrumentação mínima `6cf5178b1cc294042fcca6c4196ae960f29577e2`: leitura primária `entity-detail`
e `detail`, com trace vinculado ao SHA, headers, consumo único do corpo,
duração da consulta e classificação fechada do envelope do SDK. Exclui
leituras relacionadas, outras tabelas, outros ambientes e escritas.
Mantém duas tentativas de 900 ms, os resultados HTTP e os controles.
Não é correção de causa comprovada nem autorização para rerun cego.
Quatro arquivos próprios revisados; validação integral local aprovada:
235 arquivos e 1635 testes Vitest, contratos, avaliações, segurança,
formatação, lint, tipos e build em 19,25 s, com 799883 bytes iniciais.
Novo SHA exige CI, artefatos selados e gates próprios antes de staging.

Retomada: GitHub `Vnd93`, checkouts canônicos sincronizados, zero operações
concorrentes e fences, 688 deployments únicos sem atividade, zero leases
QA/overrides ativos/produtos e flag global OFF. CAT-001–010 implementados,
não homologados; CAT-011 fora do escopo vazio; CAT-012 pendente de recovery
durável do catálogo, Chrome autenticado, backend real, rollback e resíduo
ativo zero. Nenhuma carga comercial, produção ou cutover.

### Checkpoint histórico de 10 de outubro sobre renderização e recuperação

A correção `d381676384cb3251f20ef3589016a4f9277bc7d5` passou nos sete jobs
da CI `38038282653/1`. Bridge `38039040077/1` aprovado, com validador
oficial sem violações, preservando o produtor e o pacote selado original
`11664682180`, digest
`2f0f3769eab9b5c46d8f51b130bb130304cb282facb87de8bbe6f1e91f00dae9`.
Deployment canônico `cf4bb841-5146-4d61-bbb2-58197ae85f1a`, no SHA exato,
sem rebuild. Bridge: 672 s; CI: 505 s. Esses resultados não são homologação.

A validação canônica `38040158857/1` falhou na projeção mobile da página
de privacidade: o documento respondeu HTTP 200, mas o título esperado não
apareceu no prazo original de cinco segundos. Foram 49 testes aprovados
e uma falha. Não confundir esse incidente com o 503 histórico nem atribuir
a causa ao backend sem correlação. A evidência preliminar não preservou
o diagnóstico de renderização; a lacuna está sendo corrigida nos testes,
sem modificar prazos, retries, status esperados ou controles do produto.

Finalizador aprovado e watchdog `38041344022` concluído com sucesso.
ZIP terminal `11666106252`, digest
`751f70c708e32036c56bb48950f3474373a2cd351e9f3a22ed2def4dab307a4b`;
preliminar `11665996024`, digest
`07d2e17811fa01ceaf06242a089d1ac04f77f4738aab6fc7af9c0571f9ab5e46`;
métricas `11665836784`, digest
`af68fb01aaa02ea5e967c3d1a16d99417bff5e6f220df0b557ce9a9928408f58`.
Digests verificados antes da extração. Probe terminal: 82 respostas,
100% de disponibilidade, zero 5xx, p95 558,991 ms. Pipeline: 1203 s;
deploy: 822 s; três janelas G12: 256 s. Evidência de recuperação, não UAT.

A reprodução local somente leitura contra staging terminou com 47 testes
aprovados e três ignorados, dois workers e zero retries. A passagem posterior
não comprova a causa da falha intermitente. Chrome real autenticado e os
gates dependentes ainda precisam ser concluídos pelo release canônico.
CAT-001–010 permanecem implementados, não homologados; CAT-011 fora do
escopo vazio; CAT-012 pendente. A retomada confirmou zero operações
concorrentes, 683 deployments únicos sem atividade, zero leases QA e
overrides ativos, zero produtos e flag global OFF. Produção intocada.

### Checkpoint histórico de 10 de outubro sobre a política de retries

O diagnóstico `eb8092e9c122ffeafe7d46b28c044af5de764523` passou nos sete jobs
da CI `38036857823/1`. Ainda não foi promovido em staging: antes de uma nova
entrega, foi reproduzida uma violação concreta do orçamento de transporte.

O PostgREST 2.112.4 selado para as Edge Functions habilita três retries por
padrão, com esperas de 1, 2 e 4 segundos. Cada tentativa do SDK envolve as
duas tentativas de 900 ms do transporte existente. Em teste isolado, sem
rede e com relógio controlado, uma leitura permanentemente bloqueada fez
oito chamadas e terminou em 14200 ms. Com o retry do SDK desligado, foram
duas chamadas e 1800 ms, sem alterar o limite do transporte ou do Worker.

O pacote oficial foi verificado por SRI antes da extração. O bundle
PostgREST testado tem SHA256
`d457ad36136e6c47328fb948aff16bc74058885d07e7a2a61b2adb9d600a4dd0`.
O código oficial do wrapper Supabase 2.112.4 também foi verificado:
repassa `db.retry` ao PostgREST. O wrapper local 2.105.3 não repassa essa
opção; por isso as regressões versionadas exercitam o proprietário do
retry diretamente. Nenhuma dependência ou versão de runtime foi alterada.

A correção mínima no cliente público desliga apenas o retry interno do
SDK. Preserva as duas leituras limitadas pelo transporte, não repete
escritas ambíguas nem erros HTTP 400, 403, 409, 503 e 520 para obter verde.
Dez regressões versionadas e dois testes isolados da versão exata passaram.
Correção `d381676384cb3251f20ef3589016a4f9277bc7d5`, três arquivos próprios,
110 inserções, revisada e validada integralmente: 234 arquivos e 1615 testes
Vitest, demais contratos, avaliações de segurança, lint e tipos aprovados.
Build em 18,09 s; quatro chunks iniciais e 799883 bytes. CI, pacote selado
e gates em staging vinculados a esse novo SHA continuam necessários.
Referência: [política oficial de retries](https://supabase.com/docs/guides/api/automatic-retries-in-supabase-js).

A sobreposição de retries está comprovada, mas isso não identifica a
causa inicial da lentidão de cada incidente nem comprova a resolução do
503 mobile histórico. A instrumentação de headers, corpo e consulta é
preservada para correlacionar a próxima validação controlada. Não repetir
o candidato antigo, reconstruir artefatos equivalentes, aumentar prazos
ou aceitar o 503. CAT-001–010 permanecem implementados e não homologados;
CAT-011 está fora do escopo vazio; CAT-012 permanece pendente. Flag global
OFF, zero produtos e produção intocada.

### Checkpoint histórico de 10 de outubro sobre a correlação da leitura editorial

CI `38032919187/1` aprovada nos sete jobs para
`7b4a17d0d6394b50dccdc5ec77218dca617cd33e`. Bridge `38033671093/1` aprovado,
preservando o produtor e o pacote original `11662348117`, digest
`19d660fc33c66c93a859297ae6853146c29595ba1a0dc31fc6011c69d2b7ec54`.
Deployment canônico `50179635-48f2-47b9-bbe1-3d03a1c73875`, no SHA exato;
validador oficial aprovado e backend legado restaurado, sem rebuild.
Promoção: 521 s, contra 760 s no checkpoint anterior; a comparação não
comprova por si só melhora causada pela mudança. Produção permanece intocada.

Validação canônica `38034385832/1` falhou no artigo arquivado. A correção do
relatório foi comprovada: lifecycle com 8433 bytes, status failed, oito
diagnósticos documentais e sete de publicação preservados, sem aceitar o 503.
Limpeza: três leases de atores encerrados e 15 eventos imutáveis de auditoria
retidos. Finalizador aprovado e watchdog `38035859209` concluído com sucesso.

O documento começou às 07:47:36,942Z e respondeu 503 às 07:47:41,991Z,
com TTFB 5049,451 ms. O Worker registrou uma tentativa, timeout e duração
5009 ms. O trace técnico `c50f1dbf-b4f2-4bdf-9787-f8991773e84a.1`
correlaciona a chamada exata com `post-detail`: início da função às
07:47:37,282Z e término 404 às 07:47:44,129Z, duração 6848 ms. Assim,
o backend respondeu depois do limite do Worker. Ainda não há correlação
unívoca com a consulta PostgREST nem distinção entre headers e corpo da
resposta; não atribuir o incidente a SQL, região ou à causa do 503 mobile
histórico. Não aumentar prazos, aceitar erros nem repetir releases às cegas.

ZIPs verificados antes da extração: terminal `11664476482`,
`2fbade89269e709443bed192b62a5b37551449c21d0055dfb51deaa6c3889735`;
preliminar `11663955772`,
`1215a6fceef213b6134e01ef484ef11c41a81448bc61ce94dcd9da7dbe4ded96`;
métricas `11663497104`,
`2b30ef6f375e9697f4bad8f8a1ceff92fd89c4b84f8c30da3ce74ca048e1169d`.
Probe terminal: 82 respostas, 100% de disponibilidade, zero 5xx, p95
524,974 ms. Deploy: 1189 s; três janelas G12: 285 s. Esses resultados
comprovam recuperação, não homologação do sistema.

Retomada confirmou Vnd93, main limpa e sincronizada nos dois repositórios,
handoff explícito do mesmo holder, zero operações concorrentes e fences,
678 deployments únicos sem operação ativa, zero leases QA e overrides
ativos, zero produtos e flag global OFF. Diagnóstico mínimo local em
validação: somente a leitura GET da projeção de artigo em staging, com
SHA e trace exatos, medindo headers, corpo e consulta e correlacionando
o gateway sem registrar seletores, dados, credenciais ou erros brutos.
Diagnóstico `eb8092e9c122ffeafe7d46b28c044af5de764523`, cinco arquivos próprios:
61 testes focados e validação completa aprovados, com 233 arquivos/1605 testes
Vitest, demais contratos, avaliações de segurança, lint, tipos e build.
Build: 18,30 s, quatro chunks iniciais/799883 bytes. CI e entrega controlada
desse diagnóstico ainda pendentes; não equivale a correção da causa do 503.

Chrome real autenticado ainda não foi alcançado pelo release canônico.
CAT-001–010 permanecem implementados, não homologados; CAT-011 fora do
escopo da entrega vazia; CAT-012 pendente. O diagnóstico não muda os
limites, retries, controles ou o requisito de homologação real. Nenhuma
carga comercial, publicação ou operação em produção foi autorizada.

### Checkpoint histórico de 10 de outubro sobre a falha e a recuperação editorial

CI `38028596441/1` aprovada nos sete jobs para
`9e94d1e9e0095f455ab2891ed169399420022985`. Bridge `38029087139/1` aprovado,
preservando o produtor e o pacote original `11661615141`, digest
`ac897c8892a92c5c34f257df43025f980cea6011fd7921a9f2f72f3048f43a13`.
Deployment canônico `ecce63fd-7015-4e7d-a3d8-2375c40408a0`, no SHA exato;
restauração do backend legado validada, sem rebuild ou operação em produção.
Promoção: 760 s; convergência do legado: 121 s.

Validação canônica `38030018015/1` falhou no ciclo editorial governado, entre
06:29:53Z e 06:31:34Z. Uma exceção da limpeza sobrescreveu o relatório principal,
deixando o artefato de lifecycle com zero bytes. O SQLSTATE `57014` registrado às
06:30:57,361Z referencia `cms_feature_flag_overrides`; não comprova falha na
projeção de produtos nem a causa dos 503 históricos. Não há diagnóstico documental
nesse run que permita atribuir a falha original ao Worker, transporte ou backend.

Finalizador aprovado e watchdog `38031423537` concluído com sucesso. ZIPs
verificados antes da extração: terminal `11661764419`,
`8357a7a5ac210b604a00c1621589d3c40691ec29b1e2e7a7bee5abf94350756c`;
preliminar `11662018811`,
`f4516fed772bc3d276c019cd46adf124131960d0132e545d9853fac376bb079e`;
métricas `11662099131`,
`13ecd16ea9f3a58cca80a8de1c2cfa00bff6fdc5a74ee7dd36d56e6290f02056`.
Probe terminal: 82 respostas, 100% de disponibilidade, zero 5xx, p95 520,977 ms.
Deploy: 1127 s; três janelas G12: 292 s. Isso confirma recuperação, não homologação.

Retomada confirmou Vnd93, main sincronizada, handoff do mesmo holder, zero
workflows/fences concorrentes, 673 deployments únicos sem operação ativa, health
no SHA exato, zero leases QA e overrides ativos, zero produtos e flag global OFF.
As três linhas antigas de overrides expirados foram preservadas. Uma leitura
equivalente por ator sintético inexistente levou 0,157 ms, sem locks atuais;
não explica retrospectivamente o timeout.

Correção mínima local em validação: preservar o relatório principal quando a
limpeza falha e seus diagnósticos sanitizados, mantendo status failed, saída não
zero e a recuperação obrigatória. Eventos imediatos seguem para stderr e o
artefato stdout permanece um documento JSON único, exigido pelo gate existente.
Complemento local `7b4a17d0d6394b50dccdc5ec77218dca617cd33e`: 18 testes focados,
91 contratos G7, 232 arquivos/1589 testes Vitest, demais contratos, avaliações de
segurança, lint, tipos e build aprovados. Na execução ampla, dois contratos G7
exigiam a antiga chamada direta; foram atualizados para provar a limpeza única,
a saída não zero e a ausência de comprovação de resíduo zero em caso de falha.
Os gates anteriores ainda válidos foram reutilizados e os afetados e restantes
revalidados. Build: 18,05 s, quatro chunks iniciais/799883 bytes. CI e promoção
desse complemento ainda pendentes. Nenhum timeout, retry, gate ou controle de
segurança foi relaxado.

Chrome real autenticado ainda não foi alcançado. CAT-001–010 permanecem
implementados, não homologados; CAT-011 fora do escopo desta entrega vazia;
CAT-012 pendente. Próximo passo é concluir a validação e entrega do diagnóstico,
investigar a falha preservada e completar a homologação, sem repetir fases
concluídas nem carregar dados comerciais. Produção permanece intocada.

### Checkpoint histórico de 10 de outubro sobre o 503 no artigo arquivado

O diagnóstico de preview foi implementado no controle
`684593052b87ce47e6e6fd46323cd0d97db261e2`, validado integralmente e aprovado
na CI `38024130162/1`. Bridge `38024686401/1` aprovada, preservando o candidato
`3279fcaa2a6408765af9d87f6ade221239e87869`, produtor `38022148808/1` e pacote
original `11658763620`: mesmos bytes, sem rebuild. Deployment canônico
`d25e68aa-eeb7-42eb-8cf5-58f236917514`; backend legado restaurado e verificado.

Validação canônica `38025361022/1` falhou: o GET do artigo arquivado retornou
503 quando o gate exige 404. Isso **não comprova que o artigo permaneceu público**.
As sete publicações observadas terminaram em 1530, 1071, 1308, 2446, 1342, 1785 e
2201 ms, sem waits de lock/IO ou bloqueios capturados. Não comprova correção da
causa histórica do SQLSTATE 57014. A leitura incidente ainda não preservava
headers/trace do Worker; a causa do 503 permanece não comprovada.

Finalizador aprovado e watchdog `38026796078` concluído com sucesso. ZIPs
verificados antes da extração: terminal `11660611305`,
`fc9962b1df5456cf64effc2ffc6db2989fbd2a5c955206d779a260d5f0bdc1d0`;
preliminar `11660575817`,
`9294880b7f3dae042cd33543aa13b0dc91dea8f6f40d1e4dec238e7e358f5697`;
métricas `11660586350`,
`70f7fc2f94f4afcb7a64069fd606563e5d6cc52d801ac575b899384f1fd6846d`.
Probe terminal: 82 respostas, 100%, zero 5xx, p95 713,092 ms. Run: 1497 s;
deploy: 1075 s; maior etapa: três janelas G12, 272 s. Estado atual confirmado:
668 deployments únicos/nenhum ativo, nenhum workflow/fence ativo, health pronto
no SHA exato, zero leases/overrides ativos e produtos, flag global OFF.

Próxima mudança mínima: preservar correlação sanitizada dos GETs documentais
existentes, sem novas requisições, retries, timeouts ou alteração de gates.
Driver implementado em `bcb220c385e9ac31cf26e4100705e61071394e10`, check completo
aprovado e CI `38027570086/1` aprovada nos sete jobs. Ainda não promovido.
A investigação de código confirmou outra lacuna: `/blog/:slug` usa `post-detail`,
ausente da lista de trace Worker/backend; `campaign-by-path` tinha a mesma lacuna.
O complemento `9e94d1e9e0095f455ab2891ed169399420022985` amplia somente a correlação staging dessas duas leituras,
sem alterar a classificação pública `other` nem a política de requisições.
Não é correção comprovada da causa do 503. A documentação atual de logging e o
changelog Supabase foram consultados; nenhum endpoint removido de logs foi introduzido.
Check local completo aprovado: 232 arquivos/1589 testes Vitest e todos os contratos,
segurança, lint, tipos e build. Ainda depende de CI, artefatos exatos e validação staging.
Chrome real não foi alcançado. CAT-001–010 continuam implementados, não
homologados; CAT-011 fora do escopo e CAT-012 pendente. Produção intocada.

### Checkpoint histórico de 10 de outubro — preview interrompido antes da publicação

A CI `38022148808/1` passou nos sete jobs para
`3279fcaa2a6408765af9d87f6ade221239e87869`, incluindo o diagnóstico de atividade
editorial. O bridge `38022718781/1` falhou no probe do preview sobre o backend
atual: 82 respostas, disponibilidade 98,7805%, um 5xx, `/contato` com 95% de
disponibilidade e máximo 2933,92 ms. Não ocorreu troca do backend legado nem
publicação sintética; o novo observador editorial ainda não foi exercitado nesse
fluxo. O agregado não preservou o status exato nem o trace da resposta incidente;
**não comprova a causa do 503 histórico nem do timeout editorial**.

Watchdog `38023219229` aprovado. A compensação terminou em `restored`, sem tocar
produção, preservando o deployment `f389dfab-7dff-4c08-bab1-9ead8911522d` e o SHA
`050ea9a5f4fcd878b6c6f092c8a4a91b781116a2`. ZIPs verificados antes da extração:
relatórios `11659635043`,
`a1350279312b0fa4c61b9bd03824977dc8d51cb060b3201f0e21668fb5bb889b`;
métricas `11659580170`,
`c0a6bbc3ea18e1aee9153fd27fe47a3cd3a378148109b37418168385d2fca852`;
compensação `11658984556`,
`fde018ac8096824560e2f60082bb4bb5d9a70c9744938a75f4f926b4b7cd70aa`.

Conferência atual: zero operações concorrentes nos cinco estados ativos em ambos
os repositórios, zero fences, 663 deployments Cloudflare únicos/nenhum ativo,
health pronto no baseline exato, zero leases/overrides ativos e produtos; flag
global OFF. Próxima alteração mínima: configurar e preservar o diagnóstico
detalhado do preview e validar estritamente os headers de correlação que o Worker
já emite em staging. Não aumentar retries/timeouts nem aceitar o erro. CAT-001–010
continuam implementados, não homologados; CAT-011 fora do escopo e CAT-012 pendente.

### Checkpoint histórico de 10 de outubro — timeout na publicação de produto sintético

CI `38018214388/1` aprovada nos sete jobs para
`050ea9a5f4fcd878b6c6f092c8a4a91b781116a2`; bridge `38018747875/1`
aprovada com o pacote original `11657341442`, sem rebuild. O deployment canônico
permanece `f389dfab-7dff-4c08-bab1-9ead8911522d`, no SHA exato.
O canônico `38019634009/1` falhou em `cms-content/publish`, HTTP 500,
SQLSTATE `57014`. O contexto Postgres de `03:30:38.938Z` identifica cancelamento
por statement timeout durante `cms_sync_product_projection`, dentro da publicação
editorial. Isso identifica o ponto de interrupção, **não prova que a projeção é o
gargalo nem se houve espera por lock**. Não aumentar timeouts nem repetir release
sem diagnóstico. Cron jobs da janela terminaram antes da falha; não atribuir a
eles a causa sem prova. A leitura de formulário instrumentada da mesma execução
retornou HTTP 200: RPC 329 ms, documento 341 ms; nenhum novo 503 foi identificado
nessa leitura. A causa precisa do 503 anterior permanece pendente.

Finalizador aprovado; watchdog `38021095473` aprovado. ZIPs baixados e verificados
antes da extração: terminal `11657852544`,
`f6c83f689823e66f92ae31ba8890ec3192c131c69a81eace8168558c0d0edcc9`;
preliminar `11657817299`,
`dfbce0da76140c38c6c2d27da51d2a644dc6e8c8b15c5ff8558c5813f648add8`;
métricas `11658876015`,
`73ebf5b4cd87609d11b9029c70dd8849bddf8eab881bbb71c131518bc0f39db0`.
Probe terminal: 82 respostas, disponibilidade 100%, zero 5xx, p95 521,50 ms.
Limpeza: três leases sintéticos e 15 eventos imutáveis preservados.
Conferência posterior: zero operações remotas nos cinco estados ativos em ambos
os repositórios, zero fences, 662 deployments Cloudflare únicos/nenhum ativo,
zero leases e overrides ativos, zero produtos de catálogo, flag global OFF;
health pronto em staging no SHA exato. Produção intocada. Nenhuma atestação Chrome
emitida; o sistema **não está homologado**.

Execução interrompida: 1479 segundos, estágio `deploy` 1114 segundos, passo G12
253 segundos; não confundir com caminho feliz ou conclusão de entrega. Próximo
diagnóstico mínimo: amostragem curta e somente leitura da atividade editorial
PostgREST durante publicação sintética, com contagens de lock/IO/bloqueio e tempo,
sem SQL bruto, payload, PID, identidade ou credencial. Mantém o comando único,
os limites existentes e o resultado exigido pelo gate; ausência de amostra não é
evidência de sucesso. CAT-001–010 continuam implementados, não homologados;
CAT-011 fora do escopo e CAT-012 pendente.

### Checkpoint histórico de 10 de outubro — timeout upstream correlacionado

A CI `38012897507/1` passou para
`49c99d8419b6c7af253c7318b4a2d4a75516a842`. A bridge `38013569733/1`
promoveu o pacote original `11655676612`, sem rebuild, ao deployment
`c26edf05-b307-4221-b5d9-768c788a7702`; seleção e evidência da bridge passaram nos
validadores oficiais. O canônico `38014678796/1` falhou no arquivamento final do
formulário sintético, **depois de a leitura do formulário restaurado passar**.
Não é repetição da falha do seletor nem comprovação de defeito na restauração.

A auditoria registra arquivamento às `02:10:38.487393Z`; a leitura iniciou às
`02:10:39.073Z` e retornou HTTP 503 em 1816 ms, com motivo fechado
`upstream_timeout`, no mesmo SHA/trace efêmero. Região Edge `us-west-1`; banco
`us-east-2`. A RPC anterior retornou HTTP 200, com 673 ms no serviço upstream.
O plano SQL posterior executou em 94,254 ms, mas **não mede a execução incidente**.
Seis leituras sem mutação, em duas regiões, não reproduziram o 503; amostra pequena,
com formulário já ausente e conexão inicial fria, não prova causa regional nem UAT.
O vencimento do prazo upstream está comprovado; a causa precisa do transporte/backend
e a causa do 503 histórico mobile continuam sem comprovação. Nenhuma região foi fixada.

Finalizador e watchdog `38016224594` passaram. ZIPs verificados e preservados:
terminal `11656780961`,
`7f6690c9ba3a5f4fd9fddb709671c044323396e5917d93a0cb68907f000335bb`;
preliminar `11656665732`,
`aa6139442399b99620aa0925ed93bee9dde0ac9338f7510dfe18ddb6dc810779`;
métricas `11656082024`,
`7903f85763ba3948c042072bdc76de6b57bd9e530033b68f14d6416f8e56f707`.
Probe terminal: 82 respostas, disponibilidade 100%, zero 5xx, p95 560,34 ms.
Limpeza: três leases e 15 eventos imutáveis de auditoria preservados. Conferência
posterior: zero leases/overrides ativos, zero produtos, flag global OFF, zero
workflows/fences e 657 deployments Cloudflare únicos, nenhum ativo; health pronto
em staging no SHA exato. Produção intocada. Nenhum challenge/atestação Chrome emitido.
Duração observada: 1466 segundos; estágio mais longo `deploy`, 1147 segundos;
passo mais longo G12, 268 segundos. É execução interrompida, não caminho feliz homologado.

A instrumentação complementar mínima registra início/fim de cada tentativa da RPC
GET exata em staging, correlacionável pelo `x-client-info` já disponível nos logs.
Mantém distintos o attempt do documento e o attempt upstream, sem registrar URL,
seletor, credenciais, payload ou erro bruto. Preserva o prazo de 900 ms e as duas
tentativas existentes, sem mudança de SQL, regiões, Auth, RLS ou segurança.
Inclui regressões de isolamento de ambiente, ausência de dados sensíveis, preservação
de resposta/headers e não colisão das correlações. Esta é observabilidade, **não uma
correção de causa já comprovada**; novo SHA/pacote exigem os gates dependentes.
CMS `050ea9a5f4fcd878b6c6f092c8a4a91b781116a2`: seis arquivos próprios,
173 inserções/3 remoções; `npm run check` aprovado com 232 arquivos/1583 testes,
contratos, segurança, evals, formatação, lint/types e build 18,19 segundos;
quatro chunks iniciais/799883 bytes. CI aprovada conforme checkpoint vigente;
homologação deste SHA não concluída.

Inventário de entrega: CAT-001–010 implementados, ainda dependentes de homologação
integrada; CAT-011 fora do escopo comercial vigente, não bloqueante e não `done`;
CAT-012 pendente, incluindo Chrome real autenticado e recuperação durável específica
dos fixtures de catálogo antes de qualquer cadastro sintético hospedado. Não repetir
fatias implementadas nem converter testes focados em entrega homologada.

### Checkpoint histórico de 9 de outubro — 503 na leitura do formulário restaurado

A CI `37977482902/1` passou nos sete jobs para o SHA
`48481d7c1f7c9f2d9a59e1bebefeeec12495c409`. A bridge `37978563462/1`
promoveu os bytes originais do pacote `11639388796`, sem rebuild; o alias permaneceu
no deployment `e04a8a17-3378-40ba-8dd0-21e574a0c4dd`. O canônico
`37980260714/1` passou nos gates anteriores, incluindo publicação agendada com
revisão/auditoria exatas, mas falhou na leitura pública após restaurar um formulário:
HTTP 503, `Formulário temporariamente indisponível.`. Esta não é a falha anterior do
seletor nem uma nova comprovação de falha no scheduler. O gate do seletor corrigido
e a homologação Chrome não foram alcançados; não declarar entrega homologada.

Finalizador e watchdog `37983633018` passaram. ZIPs preservados e verificados:
terminal `11641547572`,
`5902fd92aa8b9289256a140870fdbcb50d809824acefc54aa3266b9d6a845065`;
preliminar `11641397193`,
`8514256a0a297301004dfb07ff73c3ca7fd8f1551e9c5bd63143dfae40102ddb`;
métricas `11641812736`,
`359384699280f8503e580040ec95cd3640bb8a08d6035efb6e887950d3658011`.
Probe terminal aprovado: disponibilidade 100%, zero 5xx, p95 602,81 ms.
Limpeza editorial: três leases, 15 eventos de auditoria preservados. Conferência
remota: 117 migrations, zero leases/overrides ativos, zero produtos, flag global OFF,
zero workflows/fences e 652 deployments Cloudflare únicos, nenhum ativo. Produção
intocada. Nenhum challenge Chrome emitido.

Os logs existentes não discriminam o erro de leitura da RPC do contrato inválido;
não há causa comprovada deste 503 nem do 503 histórico de navegação. A mudança mínima
em validação acrescenta correlação efêmera no driver e diagnóstico fechado somente
em staging, com SHA, trace, operação, motivo e código estruturado permitido; sem URL,
chaves de formulário, definições, identidades, credenciais ou mensagens brutas.
Não aumenta timeouts/retries, não aceita o 503 e não altera SQL, permissões ou RLS.
Novo SHA, CI, pacote selado e validação controlada ainda serão necessários. CAT-012
e recuperação específica dos fixtures de catálogo permanecem pendentes.

### Checkpoint histórico de 9 de outubro — ciclo agendado aprovado e seletor de serviço

A CI `37969392398/1` passou nos sete jobs para
`981b0288791ed592dabf0300551695b890d6a8d0`. A bridge `37970477369/1` promoveu
os bytes originais selados do pacote `11634688217`, sem rebuild, ao deployment
`5042f373-9015-4db2-ae5c-624d85c83cbd`. O canônico `37972107754/1` passou no
G12, nas regressões públicas/mobile/acessibilidade, CSP, G17, ciclo editorial
agendado corrigido, fronteiras e gates pós-deploy somente leitura. O relatório
editorial registra 14 evidências e limpeza de três leases, com auditoria preservada.

O gate posterior de criação editorial autenticada falhou antes do challenge Chrome:
o helper tentou preencher **Categoria do serviço** como `datalist`, mas o editor
real usa `select` de vocabulário controlado. A mensagem exata foi
`Categoria do serviço: campo controlado sem datalist.`. Os códigos de prontidão do
consumidor presentes no shell não são a causa desta falha. Não houve atestação Chrome.

Finalizador e watchdog `37976261490` passaram. Três ZIPs locais conferidos:
terminal `11639191168`,
`974afb20a425b1ddb2e9da68863e964fdb8f226cab00c755c5c824768573f169`;
métricas `11638582205`,
`8e613fa2a10c3aa6c9a7f2617fb8bfcde920ec6d321715743102b4cb23d81a88`;
preliminar `11638765454`,
`a99e59c0cdd8ef089040ad3d711656c5b8be4a5a907fdc583376dfa6fac9365d`.
Probe terminal aprovado: disponibilidade 100%, zero 5xx, p95 695,93 ms.
Estado recuperado: 117 migrations, zero leases/overrides ativos, zero produtos,
flag global OFF, alias original preservado, zero workflows/fences/deploys ativos.
Inventário Cloudflare completo: 647 deployments. Produção intocada.
Duração canônica: 2143 segundos; estágio mais longo `deploy`, 1423 segundos;
passo mais longo G12, 293 segundos. Isso não é tempo de uma entrega homologada.

A correção mínima CMS `48481d7c1f7c9f2d9a59e1bebefeeec12495c409` altera somente
o teste E2E e acrescenta um contrato de regressão: seleciona opção não vazia e
habilitada no `combobox` real, exige disponibilidade e confirma o valor selecionado.
Não altera UI, segurança, SQL, runtime ou timeouts. Sete testes direcionados e
`npm run check` passaram: 230 arquivos/1566 testes Vitest, contratos, segurança,
evals, formatação, lint/types; build 19,49 segundos, quatro chunks iniciais/799883 bytes.
CI, pacote selado e homologação dependentes do novo SHA ainda estão pendentes.

CAT-012 e a recuperação específica dos fixtures de catálogo permanecem pendentes.
CAT-001–010 não serão repetidos. Nenhum dado comercial será carregado; flag global
OFF e produção sem alterações. O 503 histórico continua sem causa comprovada:
os gates que passaram neste run não autorizam declarar essa causa corrigida.

### Checkpoint histórico de 9 de outubro — correção do driver de homologação agendada

A CI `37961897229/1` e a bridge `37963052476/1` passaram no SHA
`fab55ea96c7addd1d7e6eb6cd55004e9a2ec1d9d`, preservando o pacote original
`11632136766` e seus bytes. O canônico `37964938551/1` passou no G12,
nas regressões públicas/mobile/acessibilidade e no canário autenticado G17;
falhou no ciclo editorial com `G7_SCHEDULED_PUBLICATION_READ_FAILED:projections`,
antes de emitir o challenge Chrome. Não há homologação final neste SHA.

Finalizador e watchdog `37967994398` passaram. ZIPs locais conferidos por SHA-256:
terminal `11634227921`,
`13e47eb1b82e071aa283f0298902a79563ef5fff48357744e2cca3026e5bc130`;
métricas `11634003251`,
`b047f7a0f8e0e3a84b003d164f7f63ecff679246b33807c73c2b16ae66c60617`;
preliminar `11633573490`,
`05b7d0d6051cf242a0afb5eea9a968c57ac277f5b6a93fa1b09bc0889e01e6d2`.
Probe terminal: disponibilidade 100%, zero 5xx, p95 619,52 ms. Recuperação:
117 migrations, zero leases/overrides QA ativos, zero produtos, flag global OFF,
nenhum workflow/fence/deploy concorrente; alias no deployment
`75256b41-16af-4fef-8554-244e7a635e16`, SHA exato. Produção intocada.

A conferência somente leitura confirmou o cron real `*/5 * * * *`, a existência
da projeção e sua permissão de leitura; uma consulta REST restrita retornou 200.
A correção anterior passou a depender de um cron de cinco minutos dentro de
7,5 segundos e compartilhou esse prazo com todas as leituras: desenho inadequado
do teste. O erro preservado não identifica a causa individual da leitura,
portanto não será apresentado como prova de falha de permissão ou do backend.

A correção mínima em validação mantém o orçamento de espera de 7,5 segundos,
observa o vencimento pelo relógio do servidor e conduz no máximo uma chamada da
RPC existente, protegida por locks, apenas para o fixture exato ainda agendado.
Se o scheduler publicar antes, nenhuma mutação é necessária. Se vencer a corrida
após a leitura, somente `23514/CMS_SCHEDULE_NOT_DUE` permite conferir evidência
independente: item publicado, publicação/projeção da revisão exata e uma auditoria
de publicação agendada. O erro nunca é a prova de sucesso; qualquer outra falha
ou evidência incompleta bloqueia. Não há retry de mutação, mudança de SQL/worker,
relaxamento de gates ou aumento de timeout; as leituras de prova e a RPC antes sem
limite passam a ser limitadas a cinco segundos. Diagnóstico de leitura registra apenas códigos
fechados e deadline, sem payloads. Correção CMS
`981b0288791ed592dabf0300551695b890d6a8d0`, três arquivos próprios, 195 inserções e
41 remoções. Os 24 testes focados e `npm run check` passaram: 229 arquivos/1565
testes Vitest, contratos, segurança, evals, lint/types e build de 19,35 segundos;
799883 bytes nos quatro chunks iniciais. Validação documental: 303 documentos,
477 links, zero padrões sensíveis. CI, pacote novo e gates dependentes ainda
estão pendentes; o build local não será usado como substituto do pacote selado.

Continuam pendentes a recuperação específica dos fixtures de catálogo e CAT-012
em Chrome real autenticado/backend real. Não repetir CAT-001–010 nem considerar
CI, bridge ou canário como entrega homologada. A causa do 503 histórico continua
sem comprovação; sua correlação direcionada está implementada, não é uma cura comprovada.

### Checkpoint histórico de 9 de outubro — diagnóstico ativo e corrida editorial comprovada

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
