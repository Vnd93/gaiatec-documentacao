---
id: gaiatec-origem-documentacao
titulo: Origem e proveniencia da documentacao
status: ativo
tipo: registro-de-proveniencia
area: governanca-documental
fase: transversal
ambiente: local-e-github
responsavel: Vnd93
data_criacao: 2026-09-04
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - ORIGEM.md
relacionados:
  - ../00-indice/manifesto-migracao-documental.md
  - ../00-indice/mapa-repositorios.md
  - ../60-qualidade-auditoria/tabela-resolucao-duplicidades.md
---

# Origem e proveniência da documentação

## Origem histórica inicial

- Repositório: <https://github.com/pedronishida/website_gaiatecsistemas>
- Branch: `main`
- Commit: `63da59443701fc1045575d511b026a609a7cd2b3`
- Data do commit: `2026-08-27T22:59:02-03:00`
- Primeira transferência: `2026-09-04`
- Conta administradora do destino: `Vnd93`

O commit continha dez arquivos Markdown. Eles foram inicialmente preservados em
`documentacao-original/`; na reorganização de 6 de setembro, as versões canônicas foram
consolidadas na taxonomia e os originais byte a byte foram retirados da árvore ativa após cópia e
validação no arquivo histórico. `atribuicoes.md` permanece ativo por obrigação de atribuição; o
README original permanece histórico.

O repositório remoto `pedronishida` não foi alterado nem excluído. O checkout histórico separado usa
esse remoto como `origin`, com fetch preservado e URL de push local definida como `DISABLED`. Os
checkouts ativos de documentação e CMS possuem somente `origin` em `Vnd93/*`; não mantêm um remoto
`legacy-source`.

## Importação EV2 original

- Repositório de origem: `pedronishida/website_gaiatecsistemas`
- Branch: `ev2/desenvolvimento-fases-1-a-12`
- Commit qualificado: `5c3e00f3ca5d5be6754c130c75cc01745e30e03e`
- Data da transferência: `2026-09-04`
- Escopo registrado: 85 arquivos EV2, 21 ADRs, 2 arquivos de auditoria-base e 7 evidências da fase 1

Os destinos atuais são `docs/80-evolucao/ev2`, `docs/20-arquitetura-seguranca/adr`,
`docs/60-qualidade-auditoria/auditoria-cms-2026-09-01` e `docs/90-historico/fase-1`.

## Reorganização de 2026-09-06

| Fonte                        | Commit/base                                                 | Conteúdo incorporado                                                                                        |
| ---------------------------- | ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `Vnd93/gaiatec-documentacao` | `origin/main` em `bee751b10d696b0c9d101b1283741b1ae9d0ee9f` | Taxonomia anterior, EV2, ADRs, governança e auditorias                                                      |
| `Vnd93/gaiatec-cms`          | fase 17 em `123a15e6680e048dc29d176076149f01cf0830dc`       | 107 arquivos exclusivos do snapshot comum, 3 arquivos adicionais da fase 17 e versões divergentes avaliadas |
| pasta `Site`                 | sem commit                                                  | documentos soltos, Manual do Usuário, pacotes e artefatos classificados                                     |
| `.codex-artifacts`           | por tarefa/SHA                                              | somente resultados encerrados selecionados e evidências únicas G16                                          |

A branch documental `docs/g12-production-release` estava um commit à frente e um atrás de `main`,
mas as duas pontas possuíam a mesma árvore Git. A comparação por árvore confirmou ausência de
conteúdo exclusivo a reconciliar.

Os 24 caminhos comuns com conteúdo divergente foram decididos individualmente na
[tabela de resolução](../60-qualidade-auditoria/tabela-resolucao-duplicidades.md). A data de
modificação não foi usada como critério único. Runbooks e registros com novos fatos receberam
consolidação ou sucessores aditivos; evidências imutáveis foram mantidas.

## Registros posteriores preservados

O histórico EV2 inclui, entre outros:

- candidato G13 `518e8e5df605264013d94a16998d00168d4d03c7` e documentação de origem
  `8740d1cb776f76953d16b6c23ac94d960a8192f6`;
- candidato G12 `8250db0ddb221306a2621aa9c6004f45823ec532` e evidências posteriores vinculadas a
  `e52b25d`;
- fase 17 no commit `123a15e6680e048dc29d176076149f01cf0830dc`, ainda proposta ao `main` pelo PR nº 35
  na fotografia de 6 de setembro.

Esses registros documentam o estado observado em suas datas e não são reescritos para parecer
atuais. O presente é mantido em [status-atual.md](../00-indice/status-atual.md).

## Integridade e exclusões

O [manifesto de migração](../00-indice/manifesto-migracao-documental.md) registra origem, SHA-256,
tamanho, ação, destino e dependências. O manifesto de arquivamento no arquivo histórico valida as
cópias por hash e o clone legado por HEAD, tree e `git fsck`.

`.secrets` não foi lido, copiado, movido, arquivado ou versionado. `.codex-worktrees` e worktrees
registrados não foram movidos manualmente.
