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

## Regra de separação

O mesmo ator que cadastra ou altera uma proposta não pode revisá-la como aprovador. O sistema deve
recusar auto-revisão; portanto, não são inventados nomes, identidades ou aprovações para liberar o
gate nominal.

## Próximo gate

Nomear um aprovador funcional independente para cada item, anexar a evidência de recaptura e UAT, e
então reavaliar CAT-D009 em uma execução separada. Até lá, o leitor legado permanece como única fonte
pública.
