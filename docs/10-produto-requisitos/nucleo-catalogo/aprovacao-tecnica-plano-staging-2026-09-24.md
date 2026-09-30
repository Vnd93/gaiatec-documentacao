---
id: gaiatec-nucleo-catalogo-aprovacao-tecnica-plano-staging-2026-09-24
titulo: Aprovação técnica do plano de staging do Núcleo de Catálogo
status: aprovado-staging-default-off
tipo: decisao-operacional
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging-e-local
responsavel: responsável da sessão, por autorização explícita do usuário
data: 2026-09-24
---

# Aprovação técnica do plano de staging

## Esclarecimento vigente — 30 de setembro de 2026

Este documento preserva abaixo a fotografia de 24/09. A exigência de aprovador independente nas
seções históricas não se aplica ao novo Núcleo de Catálogo: contraria
[CAT-D003 e CAT-D004](decisoes-funcionais-aprovadas-2026-09-13.md), que permitem ao Administrador
publicar o próprio conteúdo, com autorização granular, AAL2 nas operações críticas e auditoria.
O usuário confirmou que cadastro e aprovação pertencem ao mesmo papel funcional; não se exige
outra equipe nem uma segunda pessoa. Nenhuma aprovação nominal ou evidência de UAT é presumida.
Os controles de segregação dos demais fluxos do CMS e do release permanecem inalterados.

Migrations e deploy controlados foram autorizados posteriormente apenas em staging; não é
necessária nova autorização técnica genérica. Continuam proibidos produção, carga comercial,
publicação e cutover do catálogo. A [lista nominal vigente](lista-nominal-prioritaria-cat-d009-2026-09-24.md)
registra também Tmeasurement como fabricante informado do item 20, sem dispensar recaptura.

## Registro histórico de 24 de setembro de 2026

## Escopo aprovado

Ficam aprovados somente o planejamento versionado, os contratos fail-closed, os testes de seleção de
perfil e a validação do método de release em staging no SHA
`31432783d77c5d90800dbf0e605f133f71e0aff1`. A feature `catalog_v1` permanece default-off e a
produção não é alvo desta aprovação.

## Escopo expressamente não aprovado

Esta aprovação não autoriza migration remota, carga de produtos, cópia de legado, criação de SKU,
preço, estoque ou disponibilidade, publicação pública, ativação global de flag, cutover ou aprovação
de qualquer linha CAT-D009. A lista nominal continua exigindo recaptura, owner, aprovador funcional,
UAT em Chrome real e ensaio de rollback.

A confirmação do usuário para os itens 17 e 18 é registrada somente como
`user-confirmed-provisional`; ela não altera este escopo, não constitui aprovação funcional e não
autoriza carga, publicação ou cutover.

## Regra de separação

O mesmo ator que cadastra ou altera uma proposta não pode revisá-la como aprovador. O sistema deve
recusar auto-revisão; portanto, não são inventados nomes, identidades ou aprovações para liberar o
gate nominal.

## Próximo gate

Nomear um aprovador funcional independente para cada item, anexar a evidência de recaptura e UAT, e
então reavaliar CAT-D009 em uma execução separada. Até lá, o leitor legado permanece como única fonte
pública.
