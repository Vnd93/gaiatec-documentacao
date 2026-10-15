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

Revalidar o histórico afetado no Chrome autenticado e concluir acessibilidade e
os demais gates do mesmo candidato. A promoção de compatibilidade já passou.
O diagnóstico do 503 segue o
[registro técnico anterior](registro-entrega-manual-e-gates-2026-10-14.md), sem
repetição cega do release, aumento de timeout ou remoção não justificada de páginas.

O [painel de staging](https://ev2-g17-canary.gaiatec-cms-staging.pages.dev/admin)
e o [guia de operação manual](../../30-cms/manual-do-usuario/operacao-catalogo-manual.md)
continuam separados de liberação em produção. A identidade temporária deste
ciclo foi encerrada; contas operacionais não foram convertidas em QA.
