---
id: gaiatec-catalogo-indicadores-e-evidencia-staging-2026-10-12
titulo: Diagnóstico dos indicadores e da evidência de staging
status: correcao-parcial-homologacao-pendente
tipo: evidencia-release
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-12
ultima_revisao: 2026-10-12
fonte_canonica: gaiatec-documentacao
---

# Diagnóstico dos indicadores e da evidência de staging

A indisponibilidade parcial do painel foi correlacionada ao timeout da leitura
de auditoria. A correção RLS foi aplicada e verificada em staging, mas ainda não
foi homologada no Chrome autenticado. A execução canônica parou posteriormente
por um relatório inválido, não por um novo 503. A recuperação terminou com
sucesso, a flag global continuou desligada e produção permaneceu intocada.

## Causa dos indicadores

Na janela de `18:23Z` a `18:28Z`, as consultas de conteúdo, mídia e eventos
operacionais retornaram HTTP 200. A leitura de `cms_audit_log`, ordenada por
`occurred_at` e limitada a seis eventos, retornou HTTP 500 com SQLSTATE `57014`.
Os logs PostgreSQL correlatos identificaram o contexto de
`cms_user_actor_target_scope_allowed`. A tabela continha 18.706 eventos de 1.267
atores; a política e o índice previstos pela migration 0098 estavam presentes.

A consulta QA avaliava o escopo de atores por evento e percorria o histórico
inelegível quando havia menos de seis eventos visíveis. A migration 0119 calcula
uma vez o conjunto de atores candidatos do mesmo run, SHA, ambiente e leases
ativos, acrescentando uma condição restritiva à política existente. Os guards
originais de sessão, escopo corporativo e autorização por linha permanecem.
Não houve aumento de timeout, autorização por `user_metadata`, remoção de MFA,
alteração de RLS para obter verde ou carga de estresse no banco hospedado.

Digest da migration: `8ac9da363120cfd751a7533ee83375c95b9b191316a7d0e17f762c3d7e04134a`.
Digest do corpo da função: `c8590a62ec362c8d4008c8369fc923c29de5f29470e4eb80b3f4c3462890f09f`.
Os testes PostgreSQL em CI incluem 20.000 eventos alheios em transação revertida,
sem ampliar o conjunto de linhas autorizado. A consulta semântica no banco real
confirmou a função e a política exatas, incluindo privilégios e assinatura.
Essa verificação não mede a experiência do painel no Chrome.

## Candidato e artefatos preservados

SHA de staging: `2ade633e3fa47a2bf57c5b14df30fd7a5b474d1a`.

- [CI 38294810983](https://github.com/Vnd93/gaiatec-cms/actions/runs/38294810983):
  sete jobs verdes, inclusive PostgreSQL, em 460 segundos.
- Pacote original `11767927226`, produtor e tentativa 1, digest
  `971f3ff3c4fe9ec0edf0907acd58d528a142406430301b747b58f0edbd0aeac1`.
- Payload selado de migrations `11767871643`, digest do ZIP
  `8aeaacdfce8140462c69e2b46f4203fda303290af91c2218f219e13e3d029777`.
- [Bridge 38295917049](https://github.com/Vnd93/gaiatec-cms/actions/runs/38295917049):
  sucesso em 603 segundos, mesmos bytes, sem rebuild.
- Deployment canônico `1ee52233-911d-4ac4-b08b-d532f64d7d5d`.
- Evidência v5 do bridge `11768813349`, digest
  `703d2763cdef8e4787898311215e4122df4f2f4e0384bb5e47911d8adc60f3df`.

A primeira entrada canônica, `38297353398`, usou incorretamente o frontend
anterior como `rollback_ref`. O protocolo pós-bridge exige o SHA atualmente
servido, igual ao candidato. O preflight recusou antes de qualquer mutação;
watchdog `38297501792` terminou com sucesso. Corrigiu-se somente esse parâmetro,
preservando produtor, pacote e bridge. Isso não foi uma repetição para procurar
um resultado verde de 503.

## Reprovação da evidência e recuperação

A [execução 38297942976](https://github.com/Vnd93/gaiatec-cms/actions/runs/38297942976)
passou preflight, validações de fonte e baseline, migrations, compatibilidade,
três janelas de saúde, regressões públicas/mobile/acessibilidade, CSP, canário
autenticado, ciclo editorial e os 17 controles de fronteira.

O probe de fronteira emitiu três objetos JSON no stdout: início do diagnóstico,
resposta HTTP 200 em 1.520 ms e relatório final aprovado. O `tee` gravou todos
em `g12-staging-boundary.json`. O gate recusou corretamente o arquivo com
`G12_STAGING_EVIDENCE_REFUSED` e `evidence_not_json`. Não faltou arquivo e não
houve nova falha HTTP 503 nessa etapa.

A correção mínima separa os dois diagnósticos no stderr, mantendo apenas o
relatório final no stdout. O gate continua recusando JSON misturado e um 503
continua fatal, sem retry. Dez testes focados passaram; a validação integral e
a entrega dessa correção seguem pendentes deste registro.

Finalizador e [watchdog 38300477200](https://github.com/Vnd93/gaiatec-cms/actions/runs/38300477200)
terminaram com sucesso. O backend convergiu para o candidato forward, em vez
de presumir rollback de migrations. A evidência terminal `11770288606`, digest
`7f14552bbe66453d135fd07b7d0d7dc23615cd28f1d19b376f476c625e0abc9c`,
foi verificada em memória e inclui o probe terminal aprovado e as verificações
de banco, funções, Auth e configuração.

Depois da recuperação: zero QA ativo, manifesto de catálogo aberto, fence e
operação GitHub nos cinco estados consultados nos dois repositórios. Os 736
deployments Cloudflare foram paginados até uma página vazia; todos os
`latest_stage` estavam em sucesso. Estados intermediários de deployments
históricos não representam operações concorrentes. `/healthz` retornou HTTP
200, ambiente staging, SHA e header `x-release` exatos. A flag global estava
`false` e nenhum convite adicional foi emitido durante a execução.

## Pendências de entrega

| Área                    | Estado comprovado                                                           | Próxima comprovação necessária                                                    |
| ----------------------- | --------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Indicadores             | Timeout correlacionado; 0119 aplicada com política exata e testes CI verdes | Painel real com QA autenticado e MFA/AAL2                                         |
| Evidência de fronteira  | Causa do JSON inválido comprovada; correção local com regressões verdes     | Validação integral, novo SHA e pipeline canônico completo                         |
| Recuperação do catálogo | Ciclos anteriores encerrados e zero manifesto aberto neste estado           | Evidência dependente do próximo SHA e estado, sem reabrir leases encerrados       |
| HTTP 503 público        | Diagnóstico de transporte anterior preservado; suporte acionado             | Correlação interna que prove a causa; não atribuir a correção de auditoria ao 503 |
| Entrega integral        | Gates automáticos deste run passaram até a recusa documental                | Gates pós-deploy, Chrome real, segurança e resíduo zero completos                 |

O gate Chrome foi skipped e nenhum challenge foi emitido. Não há declaração de
sistema pronto e homologado integralmente nem liberação em produção. A próxima
identidade QA deve ser nova, temporária e isolada; o responsável realiza senha
e MFA. O cadastro comercial fica a cargo do operador, sem importação ou carga
de produtos por esta execução.
