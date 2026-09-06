---
id: gaiatec-ev2-f12-pre-requisitos-infraestrutura-atual-2026-09-06
titulo: Leitura consolidada dos pre-requisitos de infraestrutura EV2.12
status: em-revisao
tipo: sintese-aditiva
area: operacao-entrega
fase: ev2-fase-12
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - PRE_REQUISITOS_INFRAESTRUTURA.md
relacionados:
  - PRE_REQUISITOS_INFRAESTRUTURA.md
  - MIGRACAO_REPOSITORIO_EXECUTAVEL_2026-09-04.md
  - ../fase-16/evidencias-controles-2026-09-06.md
  - ../../../00-indice/status-atual.md
---

# Leitura consolidada dos pre-requisitos de infraestrutura EV2.12

Este documento resolve aditivamente a divergencia entre os snapshots documental e executavel de
`PRE_REQUISITOS_INFRAESTRUTURA.md`. Os dois blobs anteriores permanecem recuperaveis nos commits
`641889875e8d425f7902474e9f5e0700a4e8b5dc` e
`123a15e6680e048dc29d176076149f01cf0830dc`; nenhum deles e reescrito para parecer atual.

## Estado verificado para esta reorganizacao

- os repositorios `Vnd93/gaiatec-documentacao` e `Vnd93/gaiatec-cms` sao publicos;
- `main` possui protecao nos dois repositorios;
- a branch padrao do CMS ainda e `ev2/desenvolvimento-fases-1-a-12`, portanto a mudanca para
  `main` depende de reconciliar primeiro a fase 17 e confirmar workflows e protecoes;
- a fase 17 esta em PR proprio e nao foi sobrescrita por esta reorganizacao;
- nenhum deploy, migration, publicacao, staging ou producao integra esta reorganizacao;
- a condicao de GitHub Pro descrita no snapshot antigo nao foi inferida a partir da protecao de
  branch; a confirmacao do plano da conta permanece uma verificacao administrativa separada;
- `Vnd93` permanece a unica identidade administrativa humana declarada. Ferramentas de IA atuam
  como apoio tecnico e nao constituem segunda identidade GitHub ou aprovacao humana independente.

## Controles executaveis

Autorizacoes, evidencias pinadas e templates consumidos pelo release sao controles do CMS em
`.github/release-controls`, nao documentacao narrativa. A especificacao humana, as decisoes e o
estado presente permanecem neste repositorio documental.

## Contribuicao preservada do snapshot executavel

O snapshot do CMS em `123a15e6680e048dc29d176076149f01cf0830dc` acrescentava ao baseline
documental os seguintes elementos. Eles sao registrados aqui como proveniencia daquele snapshot,
nao como nova verificacao de credenciais ou autorizacao operacional:

- nomes de controles esperados para Supabase, Resend, Cloudflare, release guard, sais operacionais
  e Turnstile, sem copiar valores;
- exigencia de rotacao do par Turnstile antes de eventual disparo produtivo;
- contrato fail-closed para aplicar migrations imutaveis ate `0054` no projeto exato;
- inventario esperado de 32 Edge Functions e verificacao explicita do modo JWT;
- verificacoes de Auth, RLS, cron e Vault antes de promover o frontend;
- flags EV2 compiladas como desligadas no candidato descrito;
- registro de `Vnd93` como unico responsavel humano e do aceite formal desse risco.

O documento de estado atual prevalece quando qualquer uma dessas afirmacoes temporais entrar em
conflito com configuracao remota posteriormente verificada.

## Regra de leitura

Para estado atual, consultar [status-atual](../../../00-indice/status-atual.md). Para rastrear o que
cada snapshot afirmava, consultar o arquivo historico no commit correspondente. Qualquer ativacao ou
mudanca de infraestrutura exige autorizacao propria e nao decorre deste documento.
