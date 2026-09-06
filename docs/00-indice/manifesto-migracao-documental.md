---
id: gaiatec-doc-manifesto-migracao-2026-09-06
titulo: Manifesto da reorganizacao documental do GAIATEC CMS
status: em-revisao
tipo: manifesto
area: governanca-documental
fase: reorganizacao-documental
ambiente: local
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - catalogo-documentos.md
  - mapa-documental.md
  - ../60-qualidade-auditoria/tabela-resolucao-duplicidades.md
  - ../60-qualidade-auditoria/relatorio-final-reorganizacao-documental-2026-09-06.md
---

# Manifesto da reorganizacao documental do GAIATEC CMS

Este manifesto controla a migracao da documentacao do CMS para uma unica fonte canonica. O inventario foi fechado antes de qualquer movimentacao. Cada arquivo possui origem logica, SHA-256, tamanho, procedencia Git quando aplicavel, classificacao, destino, acao proposta, justificativa e dependencias conhecidas.

A relacao integral inicial, com uma linha por arquivo, esta em [manifesto-migracao-documental.csv](./manifesto-migracao-documental.csv). A execucao e a validacao item a item estao em [manifesto-migracao-documental-final.csv](./manifesto-migracao-documental-final.csv). Os CSVs sao parte inseparavel deste manifesto e constituem o registro adequado para validacao automatizada. Este documento registra o escopo, as decisoes e os controles de seguranca.

## Snapshot de origem

| Fonte                                                     | Referencia imutavel                                    |                                          Registros |                    Tamanho inventariado |
| --------------------------------------------------------- | ------------------------------------------------------ | -------------------------------------------------: | --------------------------------------: |
| `Vnd93/gaiatec-documentacao`                              | `641889875e8d425f7902474e9f5e0700a4e8b5dc`             |                                                179 |                         1.074.371 bytes |
| `Vnd93/gaiatec-cms` com fase 17                           | `123a15e6680e048dc29d176076149f01cf0830dc`             |                                                292 |                        11.412.195 bytes |
| Repositorio legado `pedronishida/website_gaiatecsistemas` | `63da59443701fc1045575d511b026a609a7cd2b3`             | 22 tipos documentais, alem do repositorio integral | 7.431.001 bytes nos tipos inventariados |
| Documentos e pacote soltos na pasta `Site`                | fora do Git                                            |                                                  9 |                       153.028.748 bytes |
| `.codex-artifacts`                                        | fora do Git e nao canonico                             |                                                488 |                       594.953.918 bytes |
| `.g6-homologation-aab55f7`                                | worktree em `aab55f72563b25d81a22a041ee1c6b1bfccceb16` |                                                110 |                        15.982.118 bytes |
| Pasta literal `%SystemDrive%`                             | fora do Git                                            |                                                  4 |                           989.728 bytes |
| **Total**                                                 |                                                        |                                          **1.104** |                   **784.872.079 bytes** |

O inventario inclui Markdown, DOCX, PDF, JSON, PNG de evidencia, ZIP e os repositorios ou worktrees auxiliares explicitamente solicitados. Os quatro arquivos da pasta `%SystemDrive%` sao bancos de cache do Windows; foram incluidos por serem uma anomalia conhecida, embora nao sejam documentos.

## Comparacao entre os repositorios ativos

A comparacao usa caminhos sob `docs/` e os blobs Git, sem escolher versoes por data de modificacao.

| Grupo                             | Quantidade | Tratamento                                                                                                     |
| --------------------------------- | ---------: | -------------------------------------------------------------------------------------------------------------- |
| Caminhos comuns                   |        150 | A copia humana sera mantida apenas no repositorio documental.                                                  |
| Conteudo identico                 |        126 | Remocao da duplicata do CMS, com historico preservado pelo Git.                                                |
| Divergencias registradas          |         24 | Dezesseis exigem decisao de conteudo; oito diferem somente na representacao de checkout ou fim de linha.       |
| Somente no repositorio documental |         12 | Manter e enquadrar na taxonomia canonica.                                                                      |
| Somente no CMS em `origin/main`   |        107 | Migrar narrativa e evidencias humanas; reter ou reclassificar controles e fixtures consumidos pelo executavel. |
| Acrescimos da fase 17 no CMS      |          3 | Incorporar na fonte documental sem alterar os nove commits funcionais do PR 35.                                |

A decisao individual dos 24 caminhos precede qualquer remocao e esta registrada em [tabela-resolucao-duplicidades.md](../60-qualidade-auditoria/tabela-resolucao-duplicidades.md).

## Acoes propostas no inventario inicial

| Acao       | Registros |           Tamanho | Condicao de execucao                                                                                  |
| ---------- | --------: | ----------------: | ----------------------------------------------------------------------------------------------------- |
| Arquivar   |        50 | 644.266.006 bytes | Copiar ou clonar, validar hash e somente entao retirar da pasta ativa.                                |
| Consolidar |        68 |   2.103.927 bytes | Resolver fonte canonica, preservar original quando necessario e atualizar dependencias.               |
| Ignorar    |       585 | 127.178.436 bytes | Preservar no local; inclui intermediarios nao canonicos, caches em quarentena e o worktree protegido. |
| Manter     |        23 |   7.347.506 bytes | Arquivo tecnico, controle executavel, fixture ou indice necessario.                                   |
| Mover      |       155 |     575.611 bytes | Usar `git mv` para arquivos versionados e copia validada para origens externas.                       |
| Substituir |       223 |   3.400.593 bytes | Remover espelho documental do CMS depois de criar indice ou compatibilidade.                          |

Essas quantidades representam o primeiro fechamento do inventario. O manifesto final registra os destinos executados e eventuais mudancas justificadas de classificacao.

## Resultado item a item

O manifesto final contem as mesmas 1.104 origens e acrescenta `status_execucao`, `destino_efetivo`,
`sha256_destino`, `validacao_origem`, `validacao_destino` e `recuperacao`. A segunda verificacao
obteve:

- zero divergencia de hash ou tamanho nas origens;
- zero destino nao resolvido;
- 933 linhas com ao menos um destino de hash identico;
- 215 linhas com sucessor transformado e origem preservada fisicamente e, quando aplicavel, no
  commit Git registrado;
- 58 linhas com destino no arquivo historico e hash identico, incluindo 50 classificadas como
  `arquivar` e oito consolidadas com copia historica, sem retirada das origens externas;
- zero caminho protegido processado.

As categorias finais sao 50 copias arquivadas, 68 consolidacoes, 585 preservacoes fora da migracao,
23 itens mantidos, 155 movimentos ou migracoes e 223 substituicoes por fonte canonica. Uma linha
pode registrar simultaneamente um sucessor transformado e uma copia byte a byte, por isso as
contagens de tipos de validacao nao sao mutuamente exclusivas.

## Controles de ausencia de perda

Na data deste snapshot, nenhuma origem foi movida, apagada ou sobrescrita. A ausencia de perda esta sustentada pelos seguintes controles:

1. Todos os 1.104 arquivos inventariados possuem SHA-256 e tamanho no CSV.
2. Os arquivos versionados permanecem recuperaveis pelos commits de origem e serao movimentados com `git mv`.
3. As 24 divergencias possuem uma decisao explicita antes da retirada de qualquer copia.
4. Evidencias ligadas a SHA nao serao reescritas; qualquer correcao sera aditiva.
5. Arquivos externos serao copiados ou clonados para o arquivo historico, comparados por hash e mantidos na origem ate a validacao.
6. O worktree `.g6-homologation-aab55f7` tem alteracoes locais exclusivas e esta fora de qualquer acao de migracao.
7. `.codex-worktrees` esta fora do escopo de leitura e movimentacao.
8. O conteudo de `.secrets` nao foi lido, inventariado, copiado ou versionado.
9. Nenhum workflow, deploy, migration, staging ou producao foi executado ou alterado durante o inventario.

Com esses controles, o plano nao descarta nenhum conteudo canonico, historico ou operacional. A retirada de origens externas permanece condicionada a uma segunda comparacao de hashes no destino.

## Dependencias operacionais encontradas

O CMS ainda possui consumidores de arquivos sob `docs/`. O caso mais sensivel e a autorizacao de producao em `docs/ev2/fase-12/approvals/G12_<sha>.json`, validada por workflow, scripts de release e `CODEOWNERS`. Esses arquivos nao serao tratados como narrativa. Eles serao reclassificados como controles de release no repositorio executavel e os consumidores serao atualizados em conjunto.

Testes de fases anteriores tambem leem gates, relatorios e frases documentais. Cada dependencia esta listada na coluna `dependencias` do CSV. Os testes deverao validar comportamento, contratos ou fixtures dedicadas; quando uma mudanca imediata nao for segura, sera mantido um indice de compatibilidade.

## Itens externos especiais

- O repositorio `pedronishida/website_gaiatecsistemas` permanece referencia historica. O remoto original nao sera alterado nem excluido; apenas a capacidade de push da copia local sera desabilitada.
- `.codex-artifacts` nao e fonte canonica. Resultados finais e evidencias vinculadas a SHA podem ser arquivados; imagens de renderizacao e outros intermediarios permanecem classificados como `ignorar`.
- O pacote `website_gaiatecsistemas-main.zip` sera preservado em `pacotes-zip` com o hash `b0a6660e5fdb3b216577320e34a536d4c6a7365a0253ab2274c06593ad9432cc`.
- A pasta literal `%SystemDrive%` nao possui referencia operacional conhecida. Seus quatro arquivos foram identificados por hash, classificados como `ignorar` e mantidos em quarentena local; nao foram arquivados nem removidos.

## Colunas do registro integral

O CSV usa as colunas `caminho_origem`, `sha256`, `tamanho_bytes`, `repositorio_origem`, `commit_origem`, `categoria_documental`, `status_proposto`, `documento_canonico`, `destino_recomendado`, `acao`, `justificativa` e `dependencias`.

Os caminhos sao logicos e nao incluem o nome do usuario do Windows. O manifesto nao inclui conteudo de arquivos, credenciais ou valores sensiveis.
