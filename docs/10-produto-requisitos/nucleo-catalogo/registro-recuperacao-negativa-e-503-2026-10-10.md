---
id: gaiatec-recuperacao-negativa-503-2026-10-10
titulo: Gates negativos da recuperação e investigação do 503 em staging
status: validacao-parcial
tipo: registro-validacao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-10
ultima_revisao: 2026-10-10
fonte_canonica: gaiatec-documentacao
---

# Gates negativos da recuperação e investigação do 503 em staging

Quatro recusas de segurança da recuperação durável passaram no backend real de
staging, sem criar atores ou produtos, habilitar a flag ou persistir alterações.
A recuperação positiva de dados após interrupção continua não homologada.
O 503 histórico foi novamente correlacionado; sua causa interna no transporte
ainda não está comprovada. A rota funcionou na observação atual em Chrome real,
o que não encerra a investigação de uma falha intermitente.

As verificações ocorreram em 11 de outubro UTC, ainda 10 de outubro local.
O candidato permanece `a6c2c2e2a3004cea8c0d51084b9a16a606a12939`, deployment
`f7761b44-4816-44cc-ae4b-9cd833daf89b`, pacote original `11687154595`, digest
`sha256:f0b4581a01287ec23910b46f32dc5b92c596cdfe43ef2e2439fc194804f7b6fe`.
Não houve novo build, workflow, migration, release ou deploy. Consulte o
[registro da promoção](registro-promocao-e-buscas-staging-2026-10-10.md).

## Recusas exercitadas no banco real

| Verificação                            | Resultado esperado e observado                  |
| -------------------------------------- | ----------------------------------------------- |
| Preparação sem atores                  | `22023 CMS_CATALOG_RECOVERY_ACTORS_INVALID`     |
| Manifest confirmado ausente            | `42501 CMS_CATALOG_COMMITTED_RECOVERY_REQUIRED` |
| Atribuição interna sem ator autorizado | `42501 CMS_CATALOG_ACTOR_REQUIRED`              |
| Compensação com manifest inexistente   | `42501 CMS_CATALOG_RECOVERY_MANIFEST_REQUIRED`  |

Os três primeiros casos foram executados em `BEGIN READ ONLY`, com blocos que
rejeitam qualquer exceção diferente da esperada, resultado `PASS` e `ROLLBACK`.
Usaram somente identificadores aleatórios sem vínculo com pessoas ou registros
existentes. Não houve alteração de claims, PID, `prepared_xid`, permissões,
triggers, estado de manifest ou configuração de compensação.

A primeira tentativa de incluir o compensador na mesma transação somente leitura
foi recusada com `25006`: o mecanismo executa `SELECT FOR UPDATE` antes de conferir
o manifest. Esse resultado não foi contado como gate aprovado. O quarto caso foi
isolado em uma transação normal com `ROLLBACK`; a referência inexistente provocou
a recusa esperada antes de qualquer escrita. O lock de proteção foi preservado.

O preflight versionado `catalogRecoveryPreflightSql` retornou
`catalog_qa_recovery_0118_exact=true`. Consulta adicional confirmou sete funções
internas sem EXECUTE para `anon`, `authenticated` ou `service_role`, três tabelas
privadas com RLS, seis fences ativos e o hook terminal instalado. O estado após
os testes permaneceu: zero produtos em `cms_catalog_products`, zero leases QA
ativos, zero manifests abertos e `ev2.catalog_v1=false`.

Essas provas validam recusas e a instalação dos controles. Não demonstram COMMIT
de um manifest real seguido de mutação, interrupção e compensação terminal.
Também não substituem MFA/AAL2, revisão, auditoria e Chrome autenticado dos
comandos positivos. O teste local pgTAP contém fixtures de produto e ajuste de
`prepared_xid` próprio de uma transação descartável: não foi executado em staging
nem reutilizado como evidência de durabilidade remota.

## Correlação do 503

O evento histórico de `2026-10-10T23:03:34.675Z` corresponde à execução
`fc1652af-9cb4-4afd-9326-9b4bd84bfef7`, versão 782, região `sa-east-1`.
O stream unificado confirmou `Boot` de 44 ms, seguido dos eventos do handler,
e resposta 503 às `23:03:36.568Z`, com 2.071 ms na borda e
`sb_error_code=EDGE_FUNCTION_ERROR`. Para essa execução, há inicialização e
execução do handler, não uma recusa de boot.

A [documentação atual de status de Edge Functions](https://supabase.com/docs/guides/functions/status-codes)
descreve `BOOT_ERROR` como uma causa de 503 da plataforma. Não aplicar esse
diagnóstico genericamente a este evento: a evidência anterior registrou duas
leituras da projeção expirando antes dos headers, em 902 e 903 ms, e a aplicação
possui retorno fail-closed de indisponibilidade. O resolver independente de 2 ms
não mede DNS, TCP ou TLS internos do `fetch`. Ausência de linhas da projeção no
gateway, inclusive na nova janela consultada, não prova que a requisição não chegou.

O changelog atual foi consultado. A investigação usou `supabase_query_logs`
sobre o stream unificado, com janela de 30 segundos e campos sanitizados; não
introduziu dependência nos endpoints removidos de logs, nem mudanças de timeout,
retries, Node, CLI, Auth, RLS ou Edge Functions.

Duas observações HTTP atuais da rota `/industrias/protecao-catodica` retornaram
200, em 3.362 e 1.812 ms. A segunda enviou `Accept: text/html` e confirmou
`X-Release` do candidato atual; não apresentou H1 no HTML inicial nem trace de
documento. Esses resultados não são gates de renderização aprovados ou prova
de correção. Em seguida, Chrome real renderizou o H1 e as seções da rota pública.
Nenhum produto foi criado ou conteúdo publicado. A observação de Chrome não
constitui o ciclo autenticado de recuperação do catálogo.

A consulta de logs da janela atual não retornou linhas; esse resultado não
permite correlacionar essa navegação nem afirmar ausência de falhas. Nenhuma
resposta do suporte foi verificada nesta rodada. A fase nativa do transporte
continua sendo a lacuna causal, sem novo release para tentar obter verde.

## Limites da homologação

O sistema permanece no escopo de staging, flag OFF, sem carga de produtos e
sem alteração de produção. Perfil GitHub, árvores limpas, fetch e fast-forward
foram confirmados; os cinco estados ativos do GitHub estavam vazios nos dois
repositórios e a paginação completa de Cloudflare terminou sem operação ativa.

A prova positiva descrita no
[roteiro do sistema vazio](roteiro-homologacao-sistema-vazio-staging-2026-10-10.md)
continua pendente. Não criar produtos ou overrides para satisfazer o gate dentro
da restrição vigente, nem certificar um ciclo vazio como recuperação de dados.
Preservar o chamado sanitizado já enviado e obter a correlação interna do
transporte antes de propor uma correção causal. Produção não está liberada.
