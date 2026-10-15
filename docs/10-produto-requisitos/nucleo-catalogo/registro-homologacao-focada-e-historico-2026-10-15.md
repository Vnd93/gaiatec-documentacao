---
id: gaiatec-registro-homologacao-focada-e-historico-2026-10-15
titulo: Homologação focada do catálogo e correção do histórico
status: homologacao-pendente
tipo: registro-de-evidencia
area: cms
fase: homologacao
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-15
ultima_revisao: 2026-10-15
fonte_canonica: gaiatec-documentacao
---

# Homologação focada do catálogo e correção do histórico

Os casos funcionais abaixo passaram no Chrome real autenticado e no backend
de staging. A entrega integral permanece pendente: foi encontrado um histórico
obsoleto na interface, a acessibilidade integral ainda não foi concluída e a
causa do 503 de transporte continua aberta. A flag global permaneceu OFF;
não houve produto comercial, importação, publicação ou alteração em produção.

## Vínculo da prova

- SHA: `5187b2eb2d3dd99e90f8f704425dc18c5ae7b672`.
- CI produtor: `38595985790/1`; bridge: `38597503867/1`.
- Pacote original: `11909144529`.
- Digest ZIP: `cb77ab3cce4b1a5e3783a29ae01ba177b6a327721e57c8238855013f1555a074`.
- Deployment: `dc59f88a-62a3-442f-b14d-102cc57cb308`.
- Snapshot do manifesto: `e30fcf2bc5b35320bfa632cd909d2a4ce7b87d12f03172919f8e5fd61c31dce1`.
- Recovery: `241c6a3d6f9211061d2e21aab0b6d6a9418b3efaf3215061ed06860005411e2d`.

Antes dos efeitos, o manifesto comprometido em transação independente vinculava
os quatro atores aos leases originais. O preflight owner-only passou, os cinco
estados ativos de workflows estavam vazios e não havia fence nem deployment
concorrente. O health confirmou SHA e ambiente exatos. A identidade QA no
Chrome foi conferida por comparação booleana, sem registrar dados pessoais;
o backend confirmou fator MFA verificado e sessões AAL2. Somente overrides
individuais, limitados pelos leases originais, abriram o catálogo para QA.

## Casos executados

No backend real, passaram 22 casos: criação sintética pelos atores autorizados;
recusa de escrita por revisor e administração por editor; isolamento de produtos
por ator; recusa de atualização, classificação, relação e hierarquia de outro
escopo; slug, título, limites de conteúdo, campos desconhecidos, tipo, lista de
termos, autorreferência, justificativa, ação e revisão esperada inválidos.
A referência inacessível de relação/hierarquia retorna `P0002` no contrato
instalado, sem revelar o registro nem gravar vínculo. A tentativa editorial
cruzada também foi recusada.

No Chrome real, foram comprovados:

- Estado vazio e cadastro manual de rascunho sintético, com foco no campo
  obrigatório ou slug inválido e sem envio inválido.
- Proposta e ativação de termo de indústria, sem publicação editorial.
- Editorial em rascunho, prévia privada da revisão salva e escape de marcação:
  o texto com tags permaneceu literal, com zero elemento script na prévia.
- Bloqueio e ocultação da prévia quando há alteração não salva.
- Duas abas na mesma revisão: a primeira gravou a revisão 2; a segunda recebeu
  conflito, preservou a tentativa e mostrou base, edição e versão atual.
  Carregar a versão atual não sobrescreveu a gravação anterior.
- Consulta do histórico, restauração da revisão 1 como nova revisão 3,
  herança modelo-produto e relação de acessório com origem efetiva.
- Formulário a 390 × 844, documento de 375 px, sem overflow horizontal e sem
  campos sem nome acessível. Essa inspeção não substitui a avaliação integral
  de acessibilidade. O override de viewport foi removido ao terminar.

## Desvio reproduzido e regressão

Depois de consultar o histórico de um produto, iniciar um novo produto mantinha
a lista anterior visível. Também havia risco de uma resposta atrasada repovoar
o histórico após mudar a seleção. Três testes reproduziram os três cenários e
falharam antes da correção.

A correção limpa histórico e revisão de restauração ao trocar, iniciar
ou atualizar o produto e descarta respostas atrasadas por sequência de consulta.
Os 34 testes focados de componente, adaptador e contrato passaram. A validação
completa passou em 244 arquivos e 1.720 testes Vitest, além de lint, tipagem,
contratos QA/EV2, avaliações e build em 29,82 segundos. As provas do SHA
anterior não são automaticamente transferidas ao código corrigido.

## Correção promovida em staging

A correção foi revisada, commitada e publicada em `origin/main` como
`19ab3b22db810faea0073c60188d7fdb8aae9708`, alterando somente o componente e
seus testes. O CI `38665971683/1` passou nos sete jobs em 448 segundos.
O pacote original `11940943533` tem digest ZIP
`cc8e8a417c66fd6a031214e831c4d325e4f8ad6c67f52ab9baa055f2cc7da930`;
a seleção oficial passou com perfil fail-closed `full-release`, sem reutilizar
gates mutantes ou recompilar o pacote na ponte.

O bridge `38666798232/1` passou em 746 segundos; métricas também passaram.
O deployment canônico é `f2d38bb1-ce82-4342-9b92-4693ae561313`, criado em
`2026-10-15T01:48:38.606054Z`. O health retornou o mesmo SHA em staging.
O `cms-public` foi restaurado na versão 850, com três probes 200 consecutivos;
watchdog `38667935718` terminou `skipped`, sem recuperação adicional.
Os verificadores oficiais do run e da evidência passaram. A evidência bridge
`11943266559` tem digest ZIP
`1e9686bf725c7d4364d90acf4edbb76ad5ff6b5dd69fbdd5aaf02bf9458c8c2f`.

Antes da nova preparação, os cinco estados ativos de workflows estavam vazios,
os fences estavam vazios e o inventário completo de 776 deployments não tinha
operação ativa. Não havia QA ativo, recuperação aberta ou override. Isso prova
a promoção de compatibilidade; ainda exige a revalidação autenticada da área
corrigida, não constitui homologação integral do sistema.

## Preparação do próximo acesso humano

O plano foi persistido antes de criar três auxiliares novos, com contexto
explícito do SHA `19ab3b2`. Os papéis editor, reviewer e super admin receberam
MFA real e AAL2 antes do privilégio, sem isenção. Cada lease dura 240 minutos;
a primeira expiração é `2026-10-15T05:54:48.257405Z`, sem prorrogação.

O digest do plano é
`cf3b18c007b33a9fa60baca4169d7820a95a5aa6acb3ff07029f74e6f962f722`;
o snapshot inicial é
`22f4356338ec173099ae36ad003b75dc7fe53d6cc8c09bd84b5605cd4ef5cec8`.
Onze funções instaladas de recuperação foram vinculadas no digest
`5909d90621c3b0e97900d179ccd077b884967ed20a86b20ad97983a89682bb71`.
Uma assinatura inicialmente apontada ao schema público foi recusada antes de
criar atores; o schema privado instalado foi conferido, sem relaxar o preflight.

As três leituras autenticadas confirmaram catálogo desabilitado. Manifesto
ausente e grupo incompleto foram recusados; nenhum manifesto parcial foi criado.
O convite humano ainda não foi enviado. Após um novo endereço confirmado,
será necessário revalidar a fotografia e comprometer o manifesto completo dos
quatro atores antes de qualquer override ou gravação de catálogo. O link de
e-mail vale 60 minutos, separadamente do lease humano de 240 minutos.

## Recuperação e resíduo ativo zero

Os quatro atores foram bloqueados sem trocar suas senhas. O encerramento normal
dos quatro leases acionou a compensação durável do grupo e deixou o manifesto
`cleaned`. A fotografia final de `2026-10-15T01:23:13Z` confirmou zero sessões,
papéis, perfis ativos e overrides. Nova consulta confirmou zero produto, termo,
relação ou hierarquia ativos. O Chrome passou a exibir acesso não autorizado.

A compensação preservou quatro linhas de produto arquivadas e dois termos
inativos, dez revisões de produto, 21 eventos de auditoria de catálogo e duas
revisões editoriais. Não são resíduo ativo nem carga comercial. Uma consulta
inicial contou linhas físicas e recusou corretamente a afirmação de zero linhas;
o critério comprovado é zero efeito e acesso ativos, com histórico retido.

As evidências sanitizadas foram registradas em auditoria imutável, incluindo
`cms:qa.catalog_focused_chrome_results` e
`cms:qa.catalog_cycle_zero_active_residue`. Não houve reabertura de identidade
encerrada ou extensão de prazo.

## Próximos gates

### Fase independente concluída sem novos convites

O responsável determinou prosseguir sem fornecer mais endereços. Não houve
novo convite, criação de identidade humana ou reabertura de lease encerrado.
Os três auxiliares já preparados foram usados somente na fase de backend;
isso não substitui o gate de Chrome autenticado nem aprova a entrega integral.

Antes dos efeitos, o plano dessa fase foi registrado com digest
`6e738ea9ed346c49fd2e8149d153eb5bd9a3418b91c205dcf91798519ed66fb4` e snapshot
`7c940bbe1bdf0d8c96771a48dc6423841262343968e900c0ad0478c3e1b376e5`.
O manifesto comprometido em transação independente vinculou o grupo completo
dos três atores, sem membro humano pendente de inclusão. Só então foram
criados overrides individuais, limitados pelos leases originais. Flag global
OFF, SHA e deployment permaneceram inalterados.

Passaram 15 casos de comando no backend real: criação pelos papéis autorizados,
recusa de escrita por revisor e administração por editor, atualização versionada,
recusa de revisão obsoleta, alteração e referências externas ao escopo e payloads
inválidos. O histórico próprio retornou as revisões 2 e 1; o histórico de outro
ator retornou vazio. Leitura direta sem o contexto autorizado permaneceu
fechada, e o workspace autorizado mostrou somente o registro do próprio ator.
O RPC anônimo foi recusado com `42501`; as 13 tabelas de catálogo têm RLS ativo.

As verificações automatizadas remotas, com zero retries e os limites originais,
passaram em desktop e mobile: seis jornadas públicas sem violações axe sérias
ou críticas, atalho de teclado para o conteúdo e login com foco, contraste e
reduced motion. Desktop teve três testes aprovados e o caso mobile não aplicável;
no projeto mobile os quatro casos passaram, incluindo menu e Escape. Não são
prova de acessibilidade do workspace autenticado de catálogo.

No Chrome real, a página inicial renderizou e o atalho levou foco ao elemento
principal. Instrumentação e Proteção Catódica renderizaram a 390 × 844, com
documento de 375 px e sem overflow horizontal. O menu mobile abriu, fechou com
Escape, devolveu o foco ao botão e liberou a rolagem. O viewport foi restaurado.
Essas observações não comprovam a causa nem eliminam a intermitência do 503.

O login respondeu 200 com `no-store`, `noindex`, `nosniff`, `DENY`,
`no-referrer` e Permissions Policy. A CSP permanece em `Report-Only`, conforme
a política de implantação existente; não foi tratada como CSP em enforcement.
O health confirmou SHA e ambiente de staging exatos.

Às `2026-10-15T02:05:32Z`, o encerramento normal dos três leases e a compensação
durável comprovaram zero QA ativo, sessão, papel, perfil ativo, override ativo,
produto/termo ativo ou manifesto aberto. Os três atores estão bloqueados;
a sessão anteriormente válida já não acessa o catálogo. Foram preservadas cinco
revisões de produto e oito eventos de auditoria. Não houve snapshot publicado,
acesso RDO, alteração de senha ou produção. Os recibos imutáveis são
`cms:qa.catalog_independent_api_results` e
`cms:qa.catalog_independent_zero_active_residue`.

### Pendências preservadas

Revalidar o histórico afetado no Chrome autenticado e concluir acessibilidade e
os demais gates do mesmo candidato. A promoção de compatibilidade já passou.
O diagnóstico do 503 segue o
[registro técnico anterior](registro-entrega-manual-e-gates-2026-10-14.md), sem
repetição cega do release, aumento de timeout ou remoção não justificada de páginas.

O [painel de staging](https://ev2-g17-canary.gaiatec-cms-staging.pages.dev/admin)
e o [guia de operação manual](../../30-cms/manual-do-usuario/operacao-catalogo-manual.md)
continuam separados de liberação em produção. A identidade temporária deste
ciclo foi encerrada; contas operacionais não foram convertidas em QA.
Os três auxiliares da fase independente também foram encerrados. A próxima
fase é consolidação operacional e acompanhamento das pendências, sem abrir
outro ciclo de convites automaticamente ou dispensar os gates pendentes.

## Ciclos QA sucessivos sem novos endereços

O candidato `60b0efac868635e3d59b50e929052da497c6a473` corrige o impedimento de
preparar outro manifesto para o mesmo dia e SHA após compensação completa.
A migration `0122` mantém a unicidade dos manifestos não terminais e exige que
cada ator participe de um único manifesto em toda sua existência. O trigger de
encerramento seleciona o manifesto pelo ator e pelos horários exatos do lease,
não apenas pelo identificador do release. Manifestos encerrados, revisões e
auditoria permanecem preservados. Leases encerrados não são reabertos.

A revisão e o `npm run check` local passaram: 245 arquivos Vitest, 1.723 testes,
QA, contratos EV2, avaliações, lint, tipos e build em 19,58 s. O
[CI de banco e artefatos](https://github.com/Vnd93/gaiatec-cms/actions/runs/38671860280)
concluiu com sucesso nos sete jobs. A suíte de banco passou em 73 arquivos e
2.334 testes, incluindo os casos de ciclos sucessivos. A migration não
foi aplicada ao ambiente nesta etapa; o deployment servido continua no SHA
`19ab3b22db810faea0073c60188d7fdb8aae9708`.

O produtor original é o attempt 1 desse CI. O pacote frontend é
`11944583666`, digest
`7628c6d9fc9a03c203fa20c1dd3402d278d711b674ff3d989919d356b2fdc154`;
o payload de banco é `11943624772`, digest
`80f7171584edf02c15a7e38cae40490d70b5175ff7954d2a15726fefd8b88b2a`.
A seleção oficial passou em `full-release` e `bootstrap-full`, sem reduzir
gates ou substituir o produtor. O novo preflight SQL recusou corretamente o
banco de staging ainda sem `0122`.

A caixa já indicada tem uma única identidade QA terminal e bloqueada, sem lease
ativo. A estratégia de reutilização preserva essa identidade e seu histórico:
arquivar somente seu endereço de login, criar outro UUID com novo lease padrão
de 240 minutos e enviar o convite à mesma caixa. Nenhuma conta operacional será
convertida em QA. O próximo convite depende da preparação durável e da
disponibilidade do responsável para definir senha e concluir MFA; não foi
enviado antecipadamente.

## Correlação adicional do incidente HTTP 503

Na janela do provedor entre `2026-10-14T15:01:20Z` e `15:02:05Z`, os logs da
função registram 25 términos de tentativa por deadline e seis respostas
upstream, enquanto o gateway expõe somente cinco registros com o trace de
página. Os traces `a56644ac-540c-4611-81d5-ec84e4aba445.2` e
`373a46f2-43e1-4778-b21c-62904630ef4d.1` falham na consulta primária antes dos
headers, com duas tentativas de aproximadamente 903–904 ms e documento 503 em
1.815–1.816 ms.

O trace `a56644ac-540c-4611-81d5-ec84e4aba445.1.1` recebeu 200 na função em
622 ms, mas não consta no extrato do gateway da mesma janela. Portanto, a
ausência de um trace no gateway não comprova que a requisição não chegou ao
serviço. DNS independente resolvido em poucos milissegundos também não mede
DNS, TCP ou TLS do fetch que falhou. A causa permanece sem comprovação; não
houve aumento de timeout, remoção de páginas, nova tentativa cega de release
ou duplicação do chamado de suporte. Flag global OFF e produção intocada.

## Aplicação controlada da recuperação em staging

A [ponte 38672871668](https://github.com/Vnd93/gaiatec-cms/actions/runs/38672871668),
attempt 1, passou em 530 s, com métricas aprovadas. Os verificadores oficiais de
run e evidência passaram; o watchdog `38673667178` terminou como não aplicável.
O deployment canônico é `b7a8b9ca-fc41-43d6-86c8-09c1e2c045d8`, criado em
`2026-10-15T02:54:16.426Z`, com o pacote e produtor originais. A evidência é
`11944877632`, digest
`9455e5c109a8ed71ba93cb278d535e05b55ac218aee20a991bedd30be9130631`.
O arquivo frontend tem digest
`0e72f38e11cfb917887e8217dadeceac2dd4c99378bd8d76b0a41a887ca5120d`
e a árvore
`65f6e5719be99a2e3e88bd5a9dd5ec72a82cd80fbb3c6cb7259c2a30419aefbf`.

A [execução canônica 38673962450](https://github.com/Vnd93/gaiatec-cms/actions/runs/38673962450)
aplicou `0122` por meio do payload selado. O preflight novo passou no backend
real, com os dois índices exclusivos e os vínculos exatos de ator e lease.
O digest das 11 funções de recuperação é
`17f3aa40cbb4091ea379b7ec1ca362ea42d7663a58eb745f4cb897aaae4f812f`;
o dos dois índices é
`3a5e53ea3a788eced855dc50a7d7b363e507add407c1ef7963ae4d8cb70934c8`.
Flag global permaneceu OFF. Passaram o deploy principal e os dois jobs
pós-deploy somente leitura, mas a etapa autenticada não passou.

## Falha comprovada no contrato do teste editorial

O primeiro teste de ciclo de autenticação passou. No bootstrap editorial, a
asserção em `expectEditorialState` exigia o código `draft`, enquanto o editor
exibia corretamente `Rascunho`. A limpeza do mesmo cenário também procurava
`published` e `archived` no texto humano para escolher a ação; esse contrato
precisava ser corrigido. Houve ainda um timeout secundário de espera da resposta
de arquivamento, cuja causa não foi isolada: no estado inicial de rascunho,
ambas as comparações escolhem a mesma ação. O handler de confirmação nativa
já existe no teste; ausência desse handler foi descartada como hipótese.
Não é evidência de falha do login nem comprovação da causa do 503.

O finalizador passou, e o
[watchdog 38677323890](https://github.com/Vnd93/gaiatec-cms/actions/runs/38677323890)
passou sem nova mutação. A evidência terminal é `11946389122`, digest
`39b95976593d5d7e19985b932e9b34cfff985ae0c79708b6e88e3730fba82747`.
O probe terminal mediu 82 respostas, 100% na janela medida e p95 de 633,65 ms.
A migration `0122` foi preservada. Depois da recuperação, o inventário completo
contou 781 deployments, nenhum ativo; health e deployment continuavam no SHA
`60b0efac868635e3d59b50e929052da497c6a473`, sem QA ativo, manifesto aberto,
override ativo ou fence de recuperação. Não houve novo convite humano nem
challenge de Chrome publicado. O watcher local foi encerrado.

A correção local do teste exige os rótulos exatos de cada superfície e decodifica
o texto antes da limpeza. As duas regressões falharam antes da correção; os 25
testes focados passaram depois. O backend continua validando os códigos
canônicos. Não houve mudança na interface, em permissões, em timeout ou remoção
de gate. O check completo passou: 246 arquivos Vitest, 1.730 testes, contratos,
avaliações, lint, tipos e build em 17,98 s. A correção foi revisada e publicada
como `c2045ab4d380c99986eea790af80624173bdd825`, em três arquivos somente de
testes. O [CI 38678037524](https://github.com/Vnd93/gaiatec-cms/actions/runs/38678037524)
passou nos sete jobs. Naquele momento o novo candidato ainda não havia sido
implantado em staging e não substituía o vínculo das evidências anteriores.
A promoção e a falha subsequentes estão registradas abaixo. Seu pacote original é
`11946731919`, digest
`87540b60521e13996344ef1fc002410e203e249ea453658d083f49c91b80e77e`,
produzido uma única vez no attempt 1.

## Novos 503 fora da janela medida

Entre `2026-10-15T03:23:30Z` e `03:23:42Z`, a telemetria de aplicação registra
seis documentos 503, vinculados aos traces
`7b5e68e0-77e3-4f0e-acbf-30c8ed4b2d95`,
`829f05a7-48dc-461a-96ad-125387f93362` e
`d01665ef-011b-4f87-8808-c914f51390c4`, com tentativas de Worker `.1` e `.2`.
Os logs de acesso de Funções mostram três 503 nas rotas `/`, `/contato` e
`/produtos`, na versão 855. Os fetches primários encerraram duas vezes por
deadline de 902–905 ms, antes dos headers; os documentos terminaram em
1.808–1.816 ms. A consulta ao gateway REST pelos traces não retornou registros.
Não se interpreta ausência de log como prova de ausência da requisição.

Na mesma janela, os registros de Funções mostram 12 respostas 200 e três 503
em `us-east-2`, a região do próprio projeto. A causa não está limitada às
páginas de Instrumentação ou Proteção Catódica, nem foi atribuída a uma região
remota. O código de `cms-public` e seus compartilhados não mudou entre
`110d4e319a094a1c1c49b1ea71dd4ac719936c70` e este candidato.

O probe pós-deploy passou com 82 respostas medidas, 100% e p95 de 555,90 ms.
Seu readiness e aquecimento precedem a janela contabilizada; essa métrica não
representa todas as requisições da preparação. A passagem da janela estável
não elimina os 503 observados. Permanecem pendentes a comprovação da causa e
a homologação autenticada integral. Não houve repetição do release para obter
verde, aumento de timeout, remoção de páginas ou alteração de produção.

## Promoção de c2045ab e nova falha pública, sem convite humano

A ponte `38678981652/1` passou, assim como os verificadores oficiais de run e
evidência. O produtor continua `38678037524/1` e o pacote `11946731919`, sem
rebuild. A evidência da ponte é `11947284518`, digest
`bda269521e87bebd8b12abf3ebbfff85fb7245e6003a544b2b5d21cd64e405bf`;
o arquivo frontend tem digest
`63c47191c66c61582fc5f31361375377a8ccde4bd322a2f01ab03f6577a2e0ae`
e a árvore
`1bf7934646f85ee0d4c400b41f35149d05cb99ab023c4c3f7fe57d89f5a13463`.
Deployment canônico `a245e2a6-2ddc-4052-95cf-8d580b115bbe`, criado em
`2026-10-15T04:08:12.790Z`; o health confirmou o SHA exato em staging.

A execução canônica `38680469214/1` passou no preflight, origem, baseline,
compatibilidade de rollback e janelas de saúde, mas falhou no gate público.
O smoke desktop de `/industrias` e a projeção mobile de
`/industrias/instrumentacao` receberam documento 200, mas não encontraram o
título no prazo original de 5 s. A projeção registrou lista vazia de eventos e
nenhum estado ocupado ou de erro detectado pelos seletores existentes.
Isso não comprova ausência de atividade nem causa do 503 anterior.

Na janela `04:30:30Z–04:32:10Z`, o extrato observado de acesso de Funções
registrou 570 respostas 200, com execução máxima de 1.745 ms, e quatro 404,
em `us-east-1`. Não se interpreta a amostra sem 503 como prova de disponibilidade
integral. No Chrome real, a primeira árvore mostrou o shell com main vazio;
a observação posterior mostrou Instrumentação Industrial e nenhum erro de
console. A passagem posterior não substitui o gate que falhou.

Finalizador e watchdog `38682260968` passaram. Evidência terminal `11948158428`,
digest `c5292968002af9dcbe39e9d2973aa3d2ba640a17b55fe63d5a79d749f5632dae`.
Às `2026-10-15T04:34:18.423Z`, a fotografia confirmou DB `0122`, 786 deployments
sem operação ativa, o mesmo deployment canônico e health 200 no SHA `c2045ab`.
Depois do watchdog, os cinco estados ativos de workflows em ambos os
repositórios e os fences estavam vazios. QA ativo, manifesto aberto e override
ativo eram zero; flag global OFF. Não houve challenge publicado, convite humano,
produto comercial ou produção. O observador local do challenge foi encerrado.

Foi comprovada uma lacuna independente: o fallback de rota lazy contém somente
spinner visual, sem estado acessível; o smoke também não preservava diagnóstico
de fase de renderização. A correção mínima em validação anuncia o carregamento
e registra somente estados booleanos e contagens de módulos pendentes,
sem payloads, HTML, campos, URLs ou credenciais. Não aumenta prazo ou retry,
não cria título artificial e não converte falha em sucesso. A causa dos 503 e
a homologação autenticada integral permanecem abertas.

A correção foi revisada e publicada em `origin/main` como
`135a14274a39aa8367e9d226a64f4900fd470979`, em seis arquivos próprios.
O componente anterior, extraído sem mudança de comportamento, falhou por não
oferecer estado acessível; duas regressões também falharam para a observação de
coleção e de módulo pendente. Após a correção, os 15 testes focados passaram.
O check completo passou em 247 arquivos e 1.734 testes Vitest, além dos
contratos QA/EV2, avaliações, lint, tipagem e build de 18,19 s.
O CI `38682879078/1` passou nos sete jobs; a promoção desse SHA ainda está pendente.

Uma execução focada somente leitura dos dois cenários públicos, em desktop e
mobile, passou nos quatro testes em 35,1 s, com dois workers e zero retries,
contra o frontend ainda em `c2045ab`. Essa execução usou o diagnóstico local
ampliado; não promoveu bytes, não substitui o gate vermelho da execução canônica
e não constitui homologação autenticada no Chrome real.

## Dois ciclos comprometidos na recuperação hospedada, sem novo e-mail

Após ambos os repositórios ficarem sem workflows ativos, fences vazios e o
inventário completo confirmar 786 deployments sem operação ativa, foi executada
uma prova de recuperação no backend real `0122`, vinculado ao frontend ainda
em `c2045ab`, deployment `a245e2a6-2ddc-4052-95cf-8d580b115bbe` e arquivo selado
`63c47191c66c61582fc5f31361375377a8ccde4bd322a2f01ab03f6577a2e0ae`.

O plano foi persistido em auditoria antes de criar atores, digest
`457d3b62563e80e6a0af41d73d3b6eb82c7455fbcaa647c6ec08f544d39e4cf0`.
O snapshot tem digest
`79b9a9a7d151038241986edb0c409b44af749420128a243adaac78491642d94e`.
O inventário de 11 definições de função e dois índices, serializado como JSON
ordenado, tem digest
`621758c1517a985cdf8488ae48fe325374d1caa9755dfc4dcf61734dfeb45107`.
Esse digest inclui índices e não usa o mesmo formato dos digests SQL anteriores.

Foram criados dois atores sintéticos novos, sequencialmente, sem senha usada,
sessão, perfil, papel, acesso RDO, produto, termo ou override. Não houve convite
nem entrega de e-mail. Cada ciclo preparou seu manifesto e, em outra transação,
confirmou o vínculo comprometido do ator. O bloqueio normal no Auth e a RPC
canônica de encerramento acionaram a recuperação terminal de cada ciclo.

Ambos usaram o mesmo SHA e run tag UTC real. A conferência final encontrou
dois vínculos vitalícios de ator, dois manifestos distintos `cleaned`, dois
leases `cleaned` com os 14.400 segundos originais e dois atores bloqueados.
Sessões, papéis, perfis, QA ativo, manifesto aberto e override ativo eram zero;
flag global OFF. Os históricos não foram apagados nem os leases reabertos.
Plano e resultado estão em auditoria imutável, nas ações
`cms:qa.catalog_repeat_recovery_proof_plan` e
`cms:qa.catalog_repeat_recovery_proof_completed`.

Essa é prova de recuperação comprometida no ambiente hospedado, não apenas
pgTAP com rollback. Não substitui os casos de interface autenticada, a
acessibilidade integral, o gate público que falhou ou a causa ainda aberta do 503. A preparação do acesso humano poderá reutilizar a caixa já confirmada,
arquivando somente o endereço da identidade QA terminal e criando outra UUID,
sem converter a conta operacional ou exigir nova caixa postal. Produção intocada.

## Ponte da correção de carregamento e diagnóstico

A ponte `38683706626/1` e suas métricas passaram, com verificadores oficiais de
run e evidência aprovados. O watchdog `38684505509` terminou `skipped`. O
frontend servido é `135a14274a39aa8367e9d226a64f4900fd470979`, deployment
`4bc0a8dc-20de-4aff-badb-e2aee2fdce53`, criado em `2026-10-15T04:58:34.888Z`.
O produtor original continua `38682879078/1`, pacote `11949275577`, digest ZIP
`1e3eeb69a95679f802576489444df6a7f2f70efb22eede36a9c5f127aadb2572`.
Arquivo frontend `b31b8ddf05dc588ed7b3b4376c72d819a993fa4692c69c74cf1500c616c8e389`,
árvore `8277d54e60a95e89c433d95a42ffe64bdc1ded4dfaf63ed1217cfd0a79e414b1`.

A evidência da ponte é `11949657241`, digest
`a93d7e831e2e4d4083d9669a7504be196f741701562856b06736eb2c6061f000`.
O backend público foi restaurado na versão 866, com três probes 200 consecutivos
e bundle exato `83f2f7f1e2f483511f71b3768a9b998dc95babc0a2e4301574da80825b6d63f9`.
O artefato de restauração `11949467492` tem digest
`f569941406c297ed6c1c00e9215ed57430293dccdc19717e9f018e7b9060796c`.
A limpeza das fixtures passou; flag OFF, sem convite humano ou produção.
Essa prova continua limitada à compatibilidade da ponte, sem captação positiva,
backend completo do candidato ou homologação autenticada integral.

## Novo incidente após a consulta principal

A execução canônica `38684843545/1`, no SHA `135a142`, passou pelos gates de
fonte, baseline, migrations, compatibilidade de rollback, três janelas de saúde,
50 regressões públicas de navegador, CSP, G12, G17 manual-only e ciclo editorial.
Falhou no primeiro probe `public_collection_available`, com HTTP 503. Os demais
checks desse script não foram executados pelo run após a falha; 14 verificações
independentes de recusa anônima e origens hostis passaram posteriormente, sem
converter o gate de disponibilidade em verde.

O pedido foi direto ao Supabase, sem o Worker do site no caminho. A correlação
usa o trace técnico `9aabd141-07b7-4ebc-985f-356449728011.1`, execução
`9901b16e-9fe8-4a91-b519-5db430d3dc47`, região `us-east-2`, versão 869, em
`2026-10-15T05:26:10.626Z–05:26:13.478Z`.

- A consulta principal recebeu headers REST 200 em 227 ms, completou o body em
  1 ms e registrou sucesso em 231 ms. O gateway registrou 196 ms, Envoy 165 ms.
- As leituras subsequentes de replacements, assets e variants tiveram respostas
  200 próximas, respectivamente com 83, 130 e 62 ms de origem. A associação
  temporal dessas leituras não equivale a um trace completo de cada dependência.
- A função registrou `upstream_timeout` às `05:26:13.445Z`, encerrando o documento
  com 503 em 2.374 ms. O cliente mediu 2.851 ms.
- O Storage registrou POST de assinatura iniciado às `05:26:12.615Z`, concluído
  200 às `05:26:13.493Z`, com 860 ms de execução: 48 ms depois do encerramento
  da função. Isso localiza uma dependência tardia de mídia; não comprova a causa
  de todos os incidentes anteriores, que também incluíram timeout da consulta principal.

Os campos de caminho diferem entre fontes: `request.pathname` em acesso de
Funções, `request.path` em REST e `req.url` em Storage. Uma consulta inicial ao
REST com o campo inadequado foi corrigida; seu resultado vazio não foi usado
como prova de que o pedido não chegou. Nenhum header, body, segredo ou dado
pessoal integra esta evidência. Não se removeu assinatura, verificação de
direitos ou disponibilidade de mídia para obter sucesso.

Finalizador e watchdog `38687054474` terminaram com sucesso. O artefato terminal
`11949907887` tem digest ZIP
`8a1fc7096305ee34043fcd59b1c995e786aefe11746a49596ac414fd0184bf60`.
O probe terminal mediu 82 respostas, 100% de sucesso e p95 de 531,679 ms;
essa janela não apaga a falha de disponibilidade anterior. Às
`2026-10-15T05:41:04.850Z`, o inventário completo confirmou 791 deployments,
nenhum ativo, identidade canônica `4bc0a8dc-20de-4aff-badb-e2aee2fdce53`, health
200 no SHA exato, DB `0122`, fences vazios e nenhuma operação de workflow ativa
nos dois repositórios. QA, manifesto aberto e override eram zero antes da
preparação seguinte. Não houve challenge Chrome nem novo release às cegas.

## Preparação autenticada sem nova caixa postal

O plano `cms:qa.catalog_cycle_plan_prepared` foi persistido antes de criar os
três auxiliares do novo ciclo, digest
`4fbf9343c4adcb02f6e8bf3ac48ad8395518c1d315babb60824176ada07beaab`.
Snapshot `882501e209982dc66329284d9182ee6a0f1c618e8ec3763f6139ee7eca794ece`;
recovery `621758c1517a985cdf8488ae48fe325374d1caa9755dfc4dcf61734dfeb45107`.
O vínculo é com o SHA completo `135a14274a39aa8367e9d226a64f4900fd470979`
e os bytes originais promovidos pela ponte.

A conferência encontrou três leases ativos com exatamente 14.400 segundos,
três fatores MFA verificados, três atores AAL2 e três perfis/papéis preparados.
Os vencimentos originais ficam entre `2026-10-15T09:44:26.730759Z` e
`2026-10-15T09:44:54.217722Z`. Não há exceção de MFA, RDO ativo, override ou
manifesto de catálogo aberto; nenhum produto foi criado. A recuperação do Auth
permanece vinculada a cada lease. O manifesto completo dos quatro atores será
comprometido antes da entrega do convite e de qualquer efeito de catálogo.

O ator humano ainda não foi criado e não houve convite. A caixa já confirmada
pode ser reutilizada arquivando somente o endereço de login da identidade QA
terminal bloqueada e criando uma identidade nova, sem alterar conta operacional,
reabrir lease ou perder histórico. A disponibilidade humana deve ser confirmada
antes do envio; senha e MFA continuam exclusivos do responsável. A homologação
autenticada do candidato permanece pendente, com flag global OFF e produção intocada.

## Homologação autenticada com reutilização da caixa confirmada

Os três auxiliares da preparação anterior venceram sem convite humano. A
revalidação encontrou os três bloqueados, sem sessão, papel ou perfil ativo.
Nenhum prazo foi prorrogado nem lease reaberto. Com a disponibilidade do
responsável confirmada, um novo plano foi persistido antes dos efeitos:

- Plano: `fabc539b8ac4f03bd814561e388d92edfed7a4d44c4e803567b3ba4b47bbc8f6`.
- Snapshot: `5e38527cd86dd24375ff424e46170ff113e5449b33a2831f734a1b99ca719b17`.
- Recovery: `e9d524c9d615403f3a923636bc1aead9e20644815ff4362979ce06de63ee4b67`.

O vínculo permaneceu no SHA `135a14274a39aa8367e9d226a64f4900fd470979`, arquivo
selado `b31b8ddf05dc588ed7b3b4376c72d819a993fa4692c69c74cf1500c616c8e389` e
deployment `4bc0a8dc-20de-4aff-badb-e2aee2fdce53`. O inventário completo
posterior tinha 793 deployments, nenhum ativo; os dois acréscimos não alteraram
o alias canônico. Workflows ativos e fences ativos estavam vazios, health 200
no SHA exato e preflight da recuperação aprovado.

Somente o endereço de login da antiga identidade QA terminal foi arquivado.
Lease, bloqueio, senha, fatores e histórico permaneceram idênticos na comparação
privada. Foram criados quatro atores novos e o manifesto completo foi
comprometido, com quatro vínculos comprovados em transação posterior, antes do
convite e de qualquer efeito de catálogo. Os três auxiliares concluíram MFA/AAL2
antes dos papéis. Os leases originais continuaram com 14.400 segundos, vencendo
entre `17:59:56.471443Z` e `17:59:57.26109Z`.

O envio inicial às `14:00:48Z` e o único reenvio às `17:01:50Z` tiveram `/invite`
HTTP 200 e evento `mail.send`. Esses eventos confirmam processamento, não
entrega na caixa. O reenvio preservou a mesma identidade, os quatro vínculos e
os prazos. Depois, o responsável concluiu senha e MFA. O backend confirmou fator
verificado, duas sessões AAL2 e perfil MFA ativo; o perfil visível no Chrome
normal correspondeu à identidade esperada por comparação booleana. Nenhuma
senha, link, TOTP, cookie ou token humano foi extraído.

Com quatro overrides somente `user` em staging, limitados aos leases originais,
passaram no Chrome real:

- Nome vazio, slug inválido e quantidade não positiva foram recusados pelo formulário.
- Cadastro de rascunho sintético, duas revisões e consulta do histórico imutável.
- Histórico removido em Novo produto e invalidado após salvar nova revisão.
- Conflito CAS entre duas abas: alerta, autoria própria em outra edição, comparação
  base/tentativa/atual, tentativa preservada e salvamento bloqueado até resolução.
- Descarte da tentativa concorrente e restauração da revisão 1 como nova revisão 4,
  com conteúdo original recuperado e nenhum snapshot público.
- Proposta e ativação de termo sintético, rascunho editorial e prévia privada da
  revisão gravada. Marcação de teste permaneceu texto literal, com zero scripts.
- Prévia removida com alteração não gravada, troca de contexto bloqueada e
  descarte explícito restabelecendo os controles sem gravação adicional.
- Relação acessória e herança modelo–produto entre os dois rascunhos QA próprios.
- Mobile a 390 × 844, documento de 375 px sem overflow; zero controles habilitados
  sem nome, zero IDs duplicados, menu modal com Escape e retorno de foco.

No backend real, 18 recusas cobriram reviewer sem escrita, editor sem ação
administrativa, produto e termo fora do escopo, relação e herança externas,
autorrelacionamento, revisão obrigatória, slug, título vazio ou longo, resumo
longo, conteúdo extra, tipo inválido, termos duplicados, campo inesperado,
comando desconhecido e comando anônimo. O workspace mostrou somente o produto
do ator editor ou administrador QA; reviewer viu zero e o histórico humano
ficou vazio para os três auxiliares. A leitura direta das tabelas retornou zero
linhas fora do contexto da RPC, como exige o fence de ambiente; isso não é
falha de visibilidade do workspace autorizado. As 13 tabelas de catálogo têm RLS.

O atalho para conteúdo mudou a âncora para `#admin-main`, mas o foco observado
permaneceu no `body`; o destino não tinha `tabindex`. Esse caso ficou pendente,
sem declaração de acessibilidade integral. A correção mínima do shell e sua
regressão são uma entrega posterior, não bytes já homologados neste ciclo.

## Limpeza terminal do ciclo autenticado

Após auditoria de intenção, os quatro atores foram bloqueados, seus acessos
temporários removidos e as sessões revogadas. A RPC canônica encerrou os quatro
leases e o último encerramento acionou a compensação do manifesto exato.
Resultado comprovado: zero QA ativo, sessão, papel, perfil ativo, override,
produto ativo, termo ativo ou manifesto aberto; quatro atores bloqueados e
quatro leases `cleaned`, preservando seus prazos originais de 14.400 segundos.
Onze revisões de produto e 22 eventos de auditoria de catálogo ficaram retidos.
Os registros arquivados/inativos não foram apagados para alegar resíduo zero.

O Chrome recarregado mostrou acesso administrativo não autorizado. O viewport
foi restaurado e a segunda aba criada para CAS foi fechada. As ações
`cms:qa.catalog_authenticated_checks_completed` e
`cms:qa.catalog_cycle_cleanup_completed` preservam os resultados sanitizados.
Flag global OFF, IA externa desativada, nenhum produto comercial, publicação,
importação, cutover ou alteração em produção. A causa do 503 e o foco do atalho
impedem declarar homologação integral do sistema.

## Correção restrita ao foco do atalho administrativo

A correção em `473602e3dcd751c2d3df2c710cb538daa294f162` torna o main focável
somente por programa, com `tabIndex=-1`, e transfere o foco ao acionar o atalho,
preservando sua âncora. Não adiciona tab stop, permissão, exceção de MFA, chamada
de backend, timeout ou mudança de workflow. O teste por teclado falhou no
código anterior e os seis testes do shell passaram após a correção.

O diff de dois arquivos próprios foi revisado. O check completo passou,
incluindo 247 arquivos e 1.735 testes Vitest, contratos QA/EV2, avaliações,
lint, tipagem e build de 29,25 s. Commit e push em `origin/main` concluídos;
CI e promoção controlada em staging ainda pendentes. O frontend servido
continua no SHA anterior, e a homologação autenticada acima não foi atribuída
aos novos bytes. A causa do 503 permanece aberta.

## Promoção controlada da correção de foco

O CI `38777455743/1` terminou com os sete jobs verdes, incluindo 73 arquivos e
2.334 testes de banco. O plano permaneceu fail-closed em `full-release`, modo
`bootstrap-full`, sem reutilização de gate mutante. O verificador oficial da
seleção passou. Produtor original attempt 1, pacote `11993664484`, digest ZIP
`aac4773dfddcdd441891c6c08369026634f0ab6107757da944af9db5daf76cfa`.
Arquivo frontend `e2ec7f18fbb3dd5a501b1e114eda5fcd7405c7882ca9c83c26a61cdc654a07f3`;
árvore `57d7b210b0a683633d6570e9f883eefe16f4c291f1eb5a8befbb39744d69b0f6`.

A ponte `38778727842/1` e suas métricas passaram, preservando esses mesmos bytes.
Watchdog `38780642552` terminou skipped. Os verificadores oficiais de run e
evidência passaram. O primeiro comando local do verificador de run recusou a
ausência do arquivo de saída obrigatório; fornecido o contexto exigido, passou
sem alterar o guard. Um download local também recusou a sessão CLI sem
credencial; a transferência foi feita pelo terminal autenticado como Vnd93,
sem nova tentativa de workflow nem exposição de token.

Frontend canônico `f0719f81-8689-4940-aaef-7ad685dd8853`, criado em
`2026-10-15T17:47:31.395Z`, SHA `473602e3dcd751c2d3df2c710cb538daa294f162`,
marker `g12-staging-bridge-run-38778727842-1`.
Evidência `11995103619`, digest ZIP
`17df187b23a12c91b1ca8df8f7bb372907273694de1fce542c450a5751d2b57f`.
Restauração `11995152056`, digest ZIP
`419d1e53d2f153d72a7cae083f58a20aa78a42fd91a8a98202f7f6899770c536`.
O backend público capturado na versão 871 foi restaurado na versão 873, com
bundle exato `89add82e9db167dfb4b7807e44a1a22c92ec2834ffc3abce3066bf12ec5f5de6`
e três probes 200 consecutivos. Os números de versão mudam na restauração;
a equivalência exigida é dos bytes capturados, não da numeração anterior.

Às `2026-10-15T17:53:02.456541Z`, a conferência confirmou DB `0122`, 795
deployments sem operação ativa, alias e marker exatos, health 200 no novo SHA,
zero QA ativo, manifesto aberto, fence ativo ou override de catálogo; flag OFF.
Os cinco estados ativos de workflows estavam vazios nos dois repositórios.
O CI durou 7 min 18 s, e a ponte, 13 min 59 s, conforme timestamps do GitHub.
Esses tempos não representam o pipeline integral de homologação.

A prova da ponte é de compatibilidade com o contrato legado e controles
negativos, com limpeza comprovada. Não testa captação positiva, backend
integral ou sessão humana do novo SHA; não transforma o 503 anterior em
aprovado. A conta operacional existente está ativa, com MFA, sem lease QA ou
bloqueio e pode concluir somente leitura/teclado para a correção do foco,
sem novo convite, e-mail ou mudança de permissão. Essa interação ainda não foi
confirmada no Chrome. Produção permaneceu intocada.

## Revalidação do foco no Chrome real

Após a confirmação do responsável, a conta operacional existente foi conferida
por comparação booleana do perfil, sem registrar sua identidade. O painel
mostrou MFA verificado e acesso concedido; o backend de staging confirmou um
perfil ativo com MFA, um fator verificado e uma sessão AAL2. A conta não foi
convertida em QA, e nenhuma permissão ou configuração foi alterada.

A aba ainda tinha o frontend anterior carregado. Sem formulário em edição,
foi recarregada e passou a apresentar `tabindex=-1` no destino. O `/healthz`
canônico retornou 200, ambiente staging e o SHA
`473602e3dcd751c2d3df2c710cb538daa294f162` no corpo e no header `x-release`.
O inventário completo confirmou 795 deployments, nenhum ativo, e o mesmo
deployment canônico `f0719f81-8689-4940-aaef-7ad685dd8853`.

No Chrome autenticado, passaram os seguintes casos:

- Na página de perfil, Enter no atalho transferiu o foco ao `main#admin-main`;
  o Tab seguinte levou a um link dentro do conteúdo, sem retornar ao menu.
- No Núcleo de Catálogo, Enter também focou o main. A mensagem de preparação
  permaneceu visível, sem campos para criar registros com a flag desligada.
- A 390 × 844, o documento ficou com largura de 375 px e scroll de 375 px,
  sem overflow horizontal. O menu abriu como modal, focou seu conteúdo e deixou
  o main inerte. Escape fechou o modal, removeu o estado inerte e devolveu o
  foco ao botão de abertura. O atalho mobile também focou o main.

O override de viewport foi removido. A leitura agregada do backend em
`2026-10-15T18:34:56.561488Z` confirmou zero QA ativo, recuperação aberta ou
override de catálogo e flag global OFF. Os cinco estados ativos de workflows
estavam vazios nos dois repositórios. Não houve convite, produto, publicação,
mutação de catálogo ou alteração em produção. A consulta inicial do inventário
Cloudflare foi recusada por paginação inválida; a paginação suportada de 25
registros confirmou o inventário completo, sem disparar deployment.

Esta prova encerra o desvio específico de foco no SHA promovido. Não atribui
aos novos bytes toda a homologação funcional do SHA anterior nem aprova a
disponibilidade pública: a causa do 503 continua aberta. A chamada exploratória
a `/api/health` não é o health canônico e retornou HTML 503; não foi usada como
prova de saúde ou como reprodução conclusiva da causa. A entrega permanece
restrita a staging. Este registro documental não exige deploy da aplicação.

## Correlação da camada compartilhada de mídia

O candidato `b19b06b149b1dc3dd84f452ff320889dec3ccad0` acrescenta correlação
somente às dependências de mídia de pedidos GET explicitamente rastreados em
staging. A origem exata e quatro operações são permitidas: leitura de
replacements, assets e variants e assinatura em lote do bucket privado.
Cada chamada recebe uma sequência técnica; eventos distinguem início,
headers, corpo, expiração, cancelamento e headers tardios. Não registram
seletores, caminhos de objetos, conteúdo, credenciais ou mensagens de erro.
O limite é de 64 chamadas observadas por pedido, sem acrescentar I/O ou retries.
Fora de staging ou sem trace e SHA válidos, o transporte original é preservado.

A lacuna foi reproduzida antes da implementação: sete testes falharam com
o transporte sem observação. Após a correção, 15 testes específicos passaram,
incluindo transporte que ignora abort, consumo único de corpo, erro original,
recusa HTTP, logger indisponível e preservação dos prazos de 900 ms. Duas
asserções estáticas de contratos foram atualizadas para a composição adicional
do observer, mantendo todos os limites e regras de retry. Os 31 testes focados
e o check completo passaram: 248 arquivos, 1.750 testes Vitest, contratos QA/EV2,
avaliações, lint, tipagem e build de 21,32 s. O diff próprio de cinco arquivos
foi revisado, commitado e publicado em `origin/main`. CI e promoção pendentes.

Uma leitura diagnóstica única, anterior à promoção, consultou diretamente a
coleção pública do Supabase de staging. Trace técnico
`71f0a025-c57a-4bed-b966-f52eea6e1016.1`, relógio cliente
`2026-10-15T18:51:49.905Z–18:51:54.157Z`, HTTP 200 e 4.252 ms totais.
O backend respondeu ainda como `135a142`, conforme a restauração da ponte;
não se atribui essa observação ao novo candidato. O relógio do provedor
registrou o handler entre `18:53:21.615Z` e `18:53:25.093Z`, em 3.478 ms.
A primeira leitura primária expirou em 903 ms; a segunda recebeu 200 em
324 ms, com body de 1 ms e consulta total de 1.230 ms. O gateway confirmou
somente a segunda tentativa, com origem de 306 ms e Envoy de 131 ms.
Ausência da primeira tentativa no extrato não prova ausência de chegada.
O intervalo posterior à consulta foi de aproximadamente 2,2 s, ainda sem
correlação individual completa da mídia nesta versão do backend.

O pedido direto não passou pelo domínio oficial, CMS de produção ou Worker
do site. Portanto, conectar staging ao domínio de produção não é uma correção
demonstrada e não será feito. Páginas e controles de mídia permanecem intactos.
O diagnóstico novo fecha a lacuna de observabilidade; ainda não comprova nem
corrige a causa de todos os 503. Antes das alterações, os cinco estados de
workflows estavam vazios nos dois repositórios, o inventário completo tinha
795 deployments sem operação ativa e não havia QA ativo, recuperação aberta
ou override de catálogo. Flag global OFF e produção intocada.
