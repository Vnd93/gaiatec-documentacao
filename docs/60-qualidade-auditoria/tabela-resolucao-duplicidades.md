---
id: gaiatec-doc-tabela-duplicidades-2026-09-06
titulo: Resolucao das duplicidades documentais entre os repositorios
status: ativo
tipo: tabela-de-decisao
area: qualidade-auditoria
fase: reorganizacao-documental
ambiente: local
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - ../00-indice/manifesto-migracao-documental.md
  - ../00-indice/catalogo-documentos.md
---

# Resolucao das duplicidades documentais entre os repositorios

Esta tabela decide os 24 caminhos cujo SHA-256 do checkout diferia entre `gaiatec-documentacao` e `gaiatec-cms`. A decisao considera o historico Git, o conteudo, a finalidade e os vinculos a gates, runs e SHAs. Data de modificacao nao foi usada como criterio decisivo.

As referencias `D` e `C` indicam, respectivamente, os snapshots `bee751b10d696b0c9d101b1283741b1ae9d0ee9f` do repositorio documental e `123a15e6680e048dc29d176076149f01cf0830dc` do CMS com a fase 17.

## Divergencias de conteudo

|   # | Caminho anterior                                                          | Decisao canonica              | Fundamento e tratamento                                                                                                                                                                                                             |
| --: | ------------------------------------------------------------------------- | ----------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|   1 | `docs/ev2/DECISOES_E_ACOES_NECESSARIAS.md`                                | D                             | D incorpora a aprovacao G14 e o fechamento de lint; C regride o estado. Mover D para a taxonomia EV2 e retirar o espelho.                                                                                                           |
|   2 | `docs/ev2/ESPECIFICACAO_TECNICA_FUNCIONAL_E_PLANO_DE_IMPLEMENTACAO.md`    | D                             | D registra G11, G14 e EV2.15. Preservar o baseline no historico Git e manter D como especificacao vigente.                                                                                                                          |
|   3 | `docs/ev2/fase-12/EVIDENCIAS_INFRAESTRUTURA_PRODUCAO_2026-09-04.md`       | D imutavel                    | D registra a migracao para `Vnd93/gaiatec-cms`; C ainda descreve o bloqueio no repositorio legado. Preservar nome e bytes de D.                                                                                                     |
|   4 | `docs/ev2/fase-12/GATE_G12.md`                                            | Sucessor aditivo D mais C     | D contem o encerramento e o run `34039654304`; C contem UUIDs, janela e criterios executados. Criar registro final separado, sem reescrever os dois blobs historicos.                                                               |
|   5 | `docs/ev2/fase-12/PRE_REQUISITOS_INFRAESTRUTURA.md`                       | Sucessor aditivo D mais C     | D contem governanca e migracao; C descreve o backend efetivamente entregue, ate a migration `0054` e 32 funcoes. Preservar os snapshots no Git e usar `pre-requisitos-infraestrutura-atual-2026-09-06.md` como leitura consolidada. |
|   6 | `docs/ev2/fase-12/README.md`                                              | Indice consolidado            | Remover estados contraditorios e delegar o presente a `status-atual.md`. Preservar links para canary, aprovacao e producao.                                                                                                         |
|   7 | `docs/ev2/fase-12/RUNBOOK_GO_LIVE_E_ROLLBACK.md`                          | C                             | O fluxo de C acompanha o workflow e os scripts executaveis do commit `f5a4bff`. Importar esse conteudo com proveniencia e manter a versao D no historico.                                                                           |
|   8 | `docs/ev2/fase-14/evidencias/README.md`                                   | D                             | D cataloga o canary e o HTTP probe aprovados do SHA `64cea11`; C termina na tentativa interrompida.                                                                                                                                 |
|   9 | `docs/ev2/fase-14/GATE_G14.md`                                            | D imutavel                    | D registra 35 de 35 verificacoes e aprovacao G14. Nao reescrever a evidencia.                                                                                                                                                       |
|  10 | `docs/ev2/fase-14/README.md`                                              | D                             | D relaciona a tentativa fail-closed e o relatorio aprovado; C ainda indica proximo passo pendente.                                                                                                                                  |
|  11 | `docs/ev2/fase-14/RELATORIO_CANARY_G14_2026-09-05.md`                     | D imutavel                    | D preserva a tentativa interrompida e registra a correcao e os runs posteriores sem converter a tentativa em aprovacao.                                                                                                             |
|  12 | `docs/ev2/fase-16/ANALISE_CSP.md`                                         | D                             | D registra o canary `ced95e61` e suas evidencias. Relacionar, sem alterar o registro, ao canary final `e52b25d`.                                                                                                                    |
|  13 | `docs/ev2/fase-16/EVIDENCIAS_CONTROLES_2026-09-05.md`                     | Sucessor aditivo baseado em C | C inclui a autorizacao `84ab23c` e o deploy `49a748a`; D omite a etapa intermediaria. Preservar os dois blobs e criar uma sintese final.                                                                                            |
|  14 | `docs/ev2/fase-16/README.md`                                              | Indice consolidado            | D e C ficaram desatualizados em pontos distintos. O novo indice aponta para as evidencias e para `status-atual.md`.                                                                                                                 |
|  15 | `docs/ev2/fase-16/REGISTRO_DECLARACAO_GOVERNANCA_DPO_RISCO_2026-09-05.md` | D historico mais sucessor C   | D registra intencao; C registra a autorizacao literal confirmada pelo approval. Preservar D e importar C como registro final separado de 2026-09-06.                                                                                |
|  16 | `docs/ev2/README.md`                                                      | Indice consolidado            | D ja se declara fonte canonica e C aponta para D, mas ambos continham estado G12 obsoleto. Manter um unico indice canonico e um redirecionamento curto no CMS.                                                                      |

## Diferencas de materializacao

Os oito pares abaixo possuem blob Git identico. A diferenca de SHA-256 ocorreu na materializacao LF ou CRLF, agravada por `core.autocrlf=true`. Nao existe conflito de conteudo e nao sera feita renormalizacao em massa sobre evidencias.

|   # | Caminho anterior                                                 | Decisao canonica                          | Tratamento                                                                                                                                                                |
| --: | ---------------------------------------------------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|  17 | `docs/ev2/fase-12/evidencias/G12_CANARY_E52B25D_2026-09-05.json` | D como evidencia e C como controle pinado | Preservar o nome em maiusculas em D. No CMS, preservar bytes e o nome minusculo exigido pelo approval e pelo validador, reclassificando a copia como controle executavel. |
|  18 | `docs/ev2/fase-16/BACKUP_EXTERNO_E_RESTORE_DRILL.md`             | D                                         | Mover D sem alterar conteudo e retirar a copia narrativa do CMS.                                                                                                          |
|  19 | `docs/ev2/fase-16/ESCOPO_DPO_LEGAL_PADRAO.md`                    | D mais snapshot de controle em C          | D permanece canonico. O CMS retem uma copia pinada fora de `docs/` enquanto o teste e o approval exigirem o SHA-256 legal `39fd74f2...`.                                  |
|  20 | `docs/ev2/fase-16/evidencias/G16_CSP_BROWSER_e52b25d.json`       | D mais copia operacional em C             | Preservar a evidencia imutavel em D e a copia pinada no conjunto de controles do CMS porque o approval a referencia.                                                      |
|  21 | `docs/ev2/fase-16/evidencias/G16_CSP_HTTP_e52b25d.json`          | D                                         | Preservar imutavel em D e retirar a copia do CMS depois da verificacao de hash e links.                                                                                   |
|  22 | `docs/ev2/fase-16/GITHUB_PROTECAO_E_REVISORES.md`                | D                                         | O controle real e a configuracao do GitHub; remover a narrativa duplicada do CMS.                                                                                         |
|  23 | `docs/ev2/fase-16/PROVEDOR_EMAIL_PRODUCAO.md`                    | D                                         | O controle real e o verifier/workflow; remover a narrativa duplicada do CMS.                                                                                              |
|  24 | `docs/ev2/fase-16/RESPONSAVEIS_E_APROVACOES.md`                  | D                                         | O approval JSON e o controle executavel; remover a narrativa duplicada do CMS.                                                                                            |

## Regras obrigatorias de execucao

1. O approval `G12_<sha>.json`, o canary G12 associado, o snapshot legal e a evidencia CSP referenciada serao reclassificados no CMS sem alterar seus bytes.
2. As referencias internas do approval permanecerao como identificadores historicos. O validador resolvera esses identificadores para o diretorio de controles sem modificar a evidencia imutavel.
3. Os testes que leem frases narrativas serao substituidos por verificacoes de schema, contrato ou comportamento antes da remocao dos caminhos antigos.
4. Os registros G12, G14 e G16 com valor probatorio permanecerao imutaveis. Correcoes e consolidacoes usarao documentos sucessores.
5. O manifesto registra SHA-256 bruto e commit de origem; o historico Git preserva os blobs anteriores.
