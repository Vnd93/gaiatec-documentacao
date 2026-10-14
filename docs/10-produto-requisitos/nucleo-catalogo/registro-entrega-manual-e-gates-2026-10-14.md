---
id: gaiatec-registro-entrega-manual-e-gates-2026-10-14
titulo: Entrega manual e gates de homologação em staging
status: homologacao-pendente
tipo: registro-de-evidencia
area: cms
fase: homologacao
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-14
ultima_revisao: 2026-10-14
fonte_canonica: gaiatec-documentacao
---

# Entrega manual e gates de homologação em staging

O candidato implementa operação manual com IA externa desativada por decisão
do responsável. A entrega integral ainda depende dos gates e da homologação
real. A flag global `ev2.catalog_v1` permanece OFF. Não há autorização de
publicação em produção, cutover, importação de SKUs ou carga comercial.

## Correção dos alertas operacionais promovida

O candidato vigente é `5187b2eb2d3dd99e90f8f704425dc18c5ae7b672`.
No Chrome real autenticado, Diagnósticos apresentava 50+ alertas, todos os
50 exibidos sendo eventos informativos da rotina de retenção, sem falha.
O banco confirmou 23.123 eventos informativos abertos e nenhum warning ou
critical nessa fotografia. A consulta confundia informação com alerta e
ocupava a lista destinada às ocorrências que exigem acompanhamento.

A correção acrescentou somente a seleção de severidades warning e critical
à leitura paginada. Nenhum evento, auditoria, permissão, RLS, índice ou timeout
foi alterado. A regressão exige ambas as severidades, a seleção de eventos
não resolvidos, a ordenação e o limite de 51 registros; proíbe exclusão por
tipo de evento, mutação e contagem exata do acervo. Os cinco testes focados
e a validação completa passaram: 244 arquivos Vitest, 1.717 testes, suites
contratuais, lint, tipos e build em 24,95 s.

O [CI 38595985790, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38595985790)
passou nos sete jobs em 471 s. O
[bridge 38597503867, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38597503867)
passou em 770 s, promovendo exatamente o pacote original `11909144529`,
ZIP SHA256 `cb77ab3cce4b1a5e3783a29ae01ba177b6a327721e57c8238855013f1555a074`.
O archive do dist é `39b705134c4d12a895994cbfa7d2c62b6ebd9e9d1a595dc4ce0be6bc64536b59`
e a árvore é `cb7b3ceaeeee9e4dd7c680bfe13893c373718ee93db58aefffdf76b4e898e0db`.
Os validadores oficiais de origem, seleção, run e evidência passaram.

A implantação canônica é `dc59f88a-62a3-442f-b14d-102cc57cb308`, criada em
`2026-10-14T16:32:22.254Z`, marcador `g12-staging-bridge-run-38597503867-1`.
O ZIP da evidência `11913236726` foi verificado com SHA256
`d065d28e26aa939b2d6ecbc95f1f6188a667cdef7ead45dec45e16515a9961e9`.
O cms-public foi restaurado na versão 848, com três probes consecutivos 200;
ZIP da restauração `11912526984`, SHA256
`a4f6c40b9ea67667d5cbc92f548a393850ed6907e1534540298011694b18d5cd`.
O watchdog `38599335136` ficou skipped, sem recuperação adicional necessária.

A fotografia cliente `2026-10-14T16:36:32.922Z` confirmou o SHA exato no
health e header, ambiente staging, migrations até 0121 e zero QA ativo,
recovery aberto, override ativo, operação concorrente ou fence. O scan
completo confirmou 774 implantações e zero deploy ativo. A flag segue OFF.

Depois da promoção, a mesma sessão operacional no Chrome mostrou zero
alertas, “Nenhuma falha aberta”, todos os indicadores numéricos e nenhum
erro. O teclado alcançou Atualizar diagnóstico com foco de 2 px. A tela
a 390 × 844 permaneceu sem overflow; o viewport temporário foi restaurado.
Essas são provas da área corrigida, não da homologação integral do sistema.
Nenhum novo canônico foi repetido para tentar obter verde no 503.

A leitura do contrato oficial de recuperação confirmou funções owner-only,
fences e integração da recuperação terminal, e nenhuma tabela do catálogo
sem RLS. Ela não substitui o ensaio hospedado de preparação em transação
anterior, conflito entre atores, compensação e resíduo zero. O novo endereço
QA informado ainda não recebeu convite; a conta operacional foi preservada.

No backend real de staging, a leitura anônima de workspace, workspace editorial
e histórico de produto, com assinaturas e parâmetros válidos, foi recusada com
HTTP 401 e código `42501`. O mesmo ocorreu nas leituras de produtos, termos,
revisões editoriais e revisões de produto, usando colunas reais. Não houve
mutação nem criação de ator. No Chrome operacional, o catálogo permaneceu
fechado pela flag, sem controles de criação e sem alerta. Essas sete recusas
não substituem os casos autenticados entre atores e escopos distintos.

## Promoção anterior e validação canônica reprovada

O [bridge 38580934706, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38580934706)
promoveu o SHA `110d4e319a094a1c1c49b1ea71dd4ac719936c70` com o pacote
original listado abaixo, sem rebuild. A implantação canônica é
`b40a10ba-f2a7-4d3d-a0b1-b2ebaf2c18e8`, criada em
`2026-10-14T14:41:10.761Z`, com marcador `g12-staging-bridge-run-38580934706-1`.
Os validadores oficiais passaram. O ZIP da evidência `11903288680` foi
verificado com SHA256 `f7cb7a563f7a29d6c6732ccb7c82ccbd9a5bc44640be809eec37195af0e282f0`.

O [canônico 38583490582, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38583490582)
falhou no gate de acessibilidade da página inicial `/`, em desktop e mobile,
porque o documento retornou HTTP 503. Os gates anteriores de preflight,
origem e baseline passaram. Nenhum challenge, convite QA humano ou prova
positiva de Chrome foi emitido nesse ciclo. Os gates posteriores não passaram.

O finalizador e o [watchdog 38586776143](https://github.com/Vnd93/gaiatec-cms/actions/runs/38586776143)
passaram. O ZIP terminal `11904943693` foi verificado com SHA256
`c86253d5f9033804c3c81048db9223af709ebaf6f56d71860df41365d8510a5c`.
O probe terminal passou sem violações; banco, Auth e as 34 funções
reconvergiram. A fotografia posterior, com relógio cliente
`2026-10-14T15:59:02.360Z`, confirmou health 200, header e ambiente do SHA
exato, migrations até 0121, zero QA ativo, recovery aberto ou override ativo
e flag OFF. O scan completo de 772 implantações confirmou zero deploy ativo;
GitHub confirmou zero runs nos cinco estados ativos em ambos os repositórios
e zero fences. Recuperação comprovada não converte o canônico em aprovado.

## Correlação do HTTP 503

No intervalo do provedor `2026-10-14T15:01:25Z` a `15:01:55Z`, o Worker
recebeu HTTP 503 do `cms-public`; não foi timeout local do navegador nem
resposta de Service Worker. A função iniciou e executou a consulta primária.
Cada uma das duas tentativas de leitura REST expirou em aproximadamente
900 ms, antes dos headers, e o handler devolveu 503 em cerca de 1.812–1.823 ms.
A sondagem DNS independente resolveu dois registros em 3–4 ms; ela não
mede a resolução usada pelo fetch nativo. Os logs do gateway contêm leituras
200, mas não demonstram a fase DNS, TCP ou TLS dos requests expirados.

O EXPLAIN ANALYZE isolado da consulta primária encontrou a página inicial
em 10,602 ms, com planejamento de 19,021 ms. Essa leitura pelo plano de
gerenciamento não mede o transporte nem prova a latência SQL durante o
incidente. Não houve alteração de índice, schema, RLS ou região.

Uma comparação somente leitura de oito pares de invocações explícitas
teve sete respostas 200 e uma 503 em `us-west-1`, e oito respostas 200 em
`us-east-1`. Os p95 de parede, incluindo a amostra inicial, foram 2.874 ms
e 3.147 ms, respectivamente. Trata-se de diagnóstico, não evidência elegível
de release ou justificativa para fixar região. A correlação posterior dos
traces iniciais confirmou duas expirações no oeste; no leste, a segunda
tentativa recebeu resposta. A causa interna do transporte permanece pendente.

O relógio cliente marcou o diagnóstico em `15:22:35.952Z` a `15:22:45.311Z`.
As observações de HTTP Date do Cloudflare e do GitHub autenticado ficaram
cerca de 89 s à frente desse relógio; a correlação usou a janela do provedor
`15:24:00Z` a `15:26:00Z`. Essa diferença deve ser respeitada nos timestamps
e verificada antes de um challenge real, sem falsificar horários ou ampliar
validade e antirreplay. Nenhuma configuração de relógio foi alterada.

Como `/` também falhou, a condição para remover apenas Instrumentação e
Proteção Catódica não foi demonstrada. Não foram removidas páginas, aumentados
timeouts ou tolerados erros para obter verde. A continuidade segura consiste
nos casos funcionais independentes e na correlação técnica do suporte,
mantendo a validação canônica reprovada até uma correção comprovada.

## Fotografia anterior à promoção

Em `2026-10-14T14:21:59Z`, staging serve
`cbb373663f1cdafcff4f7dc13c1a9a5e98dfdf8d`, na implantação
`2b7fb8a0-5bc0-4ad2-9257-f5c770af92ad`, com health 200 e ambiente exato.
As migrations 0120 e 0121 estão aplicadas; seus históricos não foram reescritos.
O scan completo de 768 implantações Cloudflare confirmou zero operação ativa.
GitHub confirmou ausência de runs ativos nos cinco estados consultados, nos
dois repositórios, e ausência de fences. O banco confirmou zero QA ativo,
recovery de catálogo aberto ou override ativo do catálogo.

O próximo candidato é `110d4e319a094a1c1c49b1ea71dd4ac719936c70`, publicado em
`main`. O [CI 38578642654, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38578642654)
passou nos sete jobs. Os validadores oficiais de origem e seleção retornaram
válidos. A promoção e a validação canônica desse SHA ainda estão pendentes.
O perfil é `full-release`, com seleção fail-closed e sem reutilização de gates
de mutação. CI verde não substitui homologação real em staging.

| Artefato do candidato      | ID ou SHA256                                                       |
| -------------------------- | ------------------------------------------------------------------ |
| Pacote original            | `11900824973`                                                      |
| ZIP do pacote              | `0b9e0dcbea50aebdfe2d10b4feb27e436f5e29e85bc3a9dd741b080afb8043cf` |
| Seleção original           | `11902755532`                                                      |
| ZIP da seleção verificado  | `7d728b610bd5b702e32fcedda1f5f13540775c95132fda72f573820dda5dfb2b` |
| Archive do dist            | `e3e6d51c81cbeef81ed8e4f5108255798cb2fb7a04392aead576a466f402a11e` |
| Árvore do dist             | `b31b4e95c661c65ac3b83f00a2b40f2ccc947fbd1c4883aad61a0efb98813809` |
| Payload de banco           | `11900329631`                                                      |
| Runtime das Edge Functions | `11902092679`                                                      |

## Operação manual sem provedor de IA

O commit `91188a8942b9ccb83ecc7ecee3e2b41791a30042` implementou a política
imutável `cms-manual-only-v1`. Geração e execução assistida são recusadas antes
da leitura de credenciais ou chamada externa. Flags individuais não reativam
o provedor. A configuração gerenciada de staging mantém o switch externo
desligado, preservando credenciais existentes e secrets não gerenciados.
Nenhuma contratação de provedor ou mudança em produção foi realizada.

O canário autenticado do SHA `cbb3736` comprovou as recusas e a ausência de
chamadas ao provedor. No Chrome real, a sessão operacional abriu o assistente
e a execução com avisos de modo manual, zero controles de geração/execução
e zero alertas. A conta não foi convertida em QA nem recebeu permissões extras.

## Falhas comprovadas e recuperação

O canônico `38500963463/1`, SHA `91188a8`, falhou no preparador de vocabulário:
dois códigos de erro não atendiam ao prefixo obrigatório do transporte.
A recusa ocorreu localmente, antes de HTTP. O commit `cbb3736` corrigiu apenas
esses códigos e vinculou a regressão ao guard real, sem alterar schema,
envelope, MFA ou autorização. O preparador passou no ciclo posterior.

O [canônico 38571333154, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38571333154)
passou em preflight, fonte, baseline, deploy e ambos os gates pós-deploy
somente leitura. O convite, senha e MFA sintéticos passaram em 50,6 s.
O bootstrap editorial falhou ao criar a campanha: o botão Salvar estava
desabilitado. O helper não preenchia o título do Hero nem o texto do bloco
Texto, obrigatórios no schema real. Nenhum challenge ou attestation real foi
emitido. Essa falha não é HTTP 503.

O commit `110d4e3` preenche esses dois blocos pela UI e exige Salvar habilitado
antes de esperar a resposta. A regressão usa o editor, a fábrica real de blocos
vazios e o schema estrito: ambos os blocos vazios são recusados e os preenchidos
são aceitos. Os seis testes passaram em desktop e os seis em mobile, sem
backend ou autenticação nessa regressão local. A validação completa passou
com 244 arquivos Vitest, 1.716 testes, demais suites e build em 25,64 s.
O editor, o backend, o schema e os timeouts não foram relaxados.

O finalizador e o [watchdog 38577330506](https://github.com/Vnd93/gaiatec-cms/actions/runs/38577330506)
terminaram com sucesso. O artefato terminal `11902475349` teve ZIP SHA256
`ae5993280e184cf2ddec55f48239dcb6b728bbf82875f9fb2d34c44472d8c330`
verificado. O probe terminal passou sem violações e a recuperação de navegador
constatou estado já terminal. A fotografia posterior de banco e ambientes
comprovou ausência de efeitos ativos; revisões e auditoria permanecem.

## Autenticação humana e encerramento automático do acesso QA

No candidato `5187b2eb2d3dd99e90f8f704425dc18c5ae7b672`, o backend de
staging confirmou um fator MFA verificado e uma sessão AAL2 em
`2026-10-14T17:47:43.036217Z`. O Chrome real conectado abriu Diagnósticos
com todos os cartões numéricos, zero alertas e “Nenhuma falha aberta”.
Senha, códigos MFA, tokens e cookies não foram lidos nem registrados.

O lease desse acesso havia sido encurtado para 40 minutos e terminava em
`2026-10-14T17:49:06.526228Z`. O intervalo restante não comportava os casos
mutantes com recuperação e limpeza; nenhum manifesto, override, produto ou
termo de catálogo foi criado. Essa prova cobre autenticação e leitura,
não a homologação funcional restante do catálogo.

O sweeper periódico encerrou o acesso sem intervenção ou extensão. A leitura
de `2026-10-14T17:50:17.437344Z` confirmou todos os três leases históricos
do grupo terminais, zero lease ativo, falha de limpeza, sessão ou papel.
A leitura dirigida ao ator humano em `2026-10-14T17:50:39.165772Z` confirmou
banimento, zero perfil ativo, override, produto ou termo, com onze eventos
QA de auditoria preservados. A flag global permanece OFF; produção intacta.

Para o próximo ciclo, os atores e o plano de recuperação devem estar
preparados antes do convite. A janela padrão já instalada e aprovada é de
240 minutos, conforme a migration 0091; não será alterado nem reaberto o
lease encerrado. O próximo endereço QA precisa ser novo e ter recebimento
confirmado. Os casos de atores, escopos, referências e formulários continuam
pendentes, assim como a causa do 503 e os gates integrais do candidato.

## Inventário de entrega

| Área                          | Implementado e evidência disponível                                                                                | Pendência para entrega integral                                                       |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| Catálogo manual e revisões    | Fatias 1–4 implementadas; cadastro, restauração e CAS entre abas passaram em ciclos focados anteriores             | Revalidar os casos dependentes no candidato final; atores e escopos distintos         |
| Termos, hierarquia e relações | Herança e composição testadas com recuperação durável em ciclo focado                                              | Referências externas ao escopo e demais entradas inválidas no candidato final         |
| Editorial e prévia privada    | Prévias de indústria, tecnologia e aplicação validadas em Chrome em ciclo anterior; canário editorial atual passou | Concluir o bootstrap canônico corrigido e as provas reais restantes                   |
| Indicadores administrativos   | Quatro cartões numéricos carregaram em Chrome no SHA `cbb3736`, sem alerta                                         | Consolidar a evidência junto dos demais gates do mesmo candidato                      |
| Convite, senha e MFA          | Ciclo sintético canônico passou; conta operacional preservada                                                      | Homologação humana QA isolada dos casos restantes, sem reabrir identidades encerradas |
| Recuperação, RLS e auditoria  | Recuperação durável 0118 e complemento QA 0121 aplicados; finalização terminal comprovada                          | Concluir rollback, revogação e limpeza no ciclo final aprovado                        |
| Acessibilidade e mobile       | Regressões automáticas públicas passaram; Instrumentação carregou em Chrome a 390 × 844 sem overflow               | Homologação integral de acessibilidade e compatibilidade no candidato final           |
| IA externa                    | Desativada por política do candidato e decisão do responsável                                                      | Não é requisito de ativação desta entrega manual                                      |

As evidências focadas anteriores continuam vinculadas aos respectivos SHAs,
como no [registro de 12 de outubro](registro-indicadores-e-evidencia-staging-2026-10-12.md).
Elas não transformam os runs canônicos reprovados em aprovados. Nenhuma lista
comercial de produtos é necessária para concluir os testes do sistema vazio.

## Limitações e critérios restantes

A causa do 503 histórico de navegação mobile continua sem comprovação.
Instrumentação carregou em Chrome desktop e mobile nesta observação; isso não
prova a causa nem a ausência de intermitência. Não houve remoção de páginas
porque a condição de exclusividade às páginas não foi demonstrada. O 503 do
provedor de IA é um incidente distinto; não é evidência da causa do documento.

O p95 administrativo aceito permanece 2.147 ms em staging e no futuro
candidato de produção, sem alterar os limites de comandos. Segurança,
MFA/AAL2, RLS, auditoria, acessibilidade, rollback e limpeza continuam gates.
A proteção de senhas vazadas continua indisponível por restrição do plano
Supabase, conforme o [registro de política e Auth](registro-politica-leitura-e-auth-2026-10-13.md).

O [painel de staging](https://ev2-g17-canary.gaiatec-cms-staging.pages.dev/admin)
exige login e MFA próprios. Com flag OFF, a conta operacional vê o Núcleo de
Catálogo em preparação, sem controles de criação. O
[guia de operação manual](../../30-cms/manual-do-usuario/operacao-catalogo-manual.md)
continua preparado, com liberação pendente. A entrega não está homologada
integralmente em staging nem liberada em produção.
