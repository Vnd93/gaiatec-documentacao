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

## Prévia editorial privada promovida em staging

Estado confirmado em 12 de outubro, com timestamps dos provedores já em 13 de
outubro UTC. SHA atual: `15290b5bfa65124669756ed4c5277ee857e6d93f`.
Os registros abaixo desta seção continuam históricos; o avanço não resolve o
503 nem transforma testes focados em entrega integral homologada.

A tela editorial não possuía prévia privada da revisão salva. A correção altera
somente `CatalogEditorialWorkspace.tsx` e seu teste de componente. A prévia usa
a resposta já autorizada do workspace, sem chamada adicional ou nova permissão.
Não abre rota pública, iframe, indexação ou publicação. Renderiza texto escapado
pelo React e fecha ao trocar termo ou iniciar operação; alterações não salvas,
operação em curso ou conflito ocultam e desabilitam a prévia. O controle possui
`aria-expanded` e alvo existente de `aria-controls`. O leitor autorizado sem
permissão de edição pode visualizar a revisão carregada.

Validação local integral: 240 arquivos Vitest e 1.692 testes aprovados, além dos
contratos QA, segurança, release, avaliações e build de 25,37 s. Os seis testes
focados incluem conteúdo salvo sem mutação, bloqueio de conteúdo não salvo,
troca de termo, leitor sem edição e escape de markup. A validação final de
formatação, lint e diff passou. Esses testes não são prova de Chrome/backend.

### Artefatos e finalização da promoção

CI [38333159253/1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38333159253)
concluiu os sete jobs com sucesso em 443 s. O perfil continuou `full-release`
com confiança `bootstrap-full`; nenhum gate foi reduzido. A ponte
[38333868864/1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38333868864)
concluiu em 583 s, em modo forward, sobre baseline `7951ed3`.

| Vínculo                              | Valor exato                                                                              |
| ------------------------------------ | ---------------------------------------------------------------------------------------- |
| Pacote original, produtor 1 e gate 1 | `11784106712`; `sha256:2668041358aa61c604103837151d86a4d6247db05c0926e4c225de54015a0f26` |
| Seleção CI                           | `11783926940`; `sha256:02186ad48dd0308d0cbf30024af4b47839a0307eb40274984d5ac0214d6ea204` |
| Plano de release                     | `11783188486`; `sha256:b47838f2f9f0ffa389981f925d77b49ba4c8a842e2376e1878a48da8381a833a` |
| Arquivo dist                         | `60ba71c98a21c6a8cff19266399fbc6e6c802bed97702cc934bf8fa83ce80c83`                       |
| Árvore dist                          | `454206239d2cb050800b7dc376b40007f6c2b837b8345c92053d88b9fc4978c2`                       |
| Evidência da ponte                   | `11783798779`; `sha256:abcb5eb0d2952cada228a9957cb86d53a0abe276b59c63e19c9716f1c36a4d96` |
| Deployment canônico                  | `8685579a-4208-4c6b-8d88-f4ce4b0c7189`; criado `2026-10-13T01:55:21.001741Z`             |
| Restauração de backend               | `11783968536`; `sha256:84d03b4145a31ab842dd539f3354dafd2e81317312950db961c397add5c9c805` |

Os ZIPs pequenos de seleção, plano, evidência e restauração tiveram digest
verificado. O pacote grande não foi baixado novamente para validação local;
a ponte verificou e promoveu o pacote original, sem recompilação. Os validadores
oficiais de run e evidência retornaram `valid: true`, sem violações, com vínculos
externos da seleção CI e do deployment Cloudflare, não apenas autodeclaração.
O dist contém 1.493 arquivos e 167.661.511 bytes; o archive possui 168.837.120 bytes.

A restauração registrou versão capturada 800, temporária 801 e restaurada 802,
bundle `83f2f7f1e2f483511f71b3768a9b998dc95babc0a2e4301574da80825b6d63f9`,
com três respostas consecutivas 200 do contrato `public-v2`. O watchdog
[38334629031](https://github.com/Vnd93/gaiatec-cms/actions/runs/38334629031)
terminou `skipped`, pois não havia recuperação a executar. A ponte prova
compatibilidade com `legacy-f48` e limpeza de suas fixtures; explicitamente
não prova submissão positiva, persistência de lead ou backend integral candidato.

Depois da finalização, os cinco estados ativos consultados do GitHub estavam
zerados nos dois repositórios e não havia fence. A varredura completa Cloudflare
abrangeu 742 deployments, nenhum ativo. `/healthz` retornou 200, ambiente
`staging`, release e header `x-release` exatos do SHA atual. O preflight de
recovery 0118 permaneceu válido; 13 de 13 tabelas públicas de catálogo tinham
RLS, com zero QA ativo, recovery aberto ou override ativo e flag global false.
Não foi criada fixture de catálogo neste avanço, nem alterada produção.

### Verificações independentes no navegador e backend

Antes da promoção, no baseline `7951ed3`, as quatro RPCs de workspace e comando,
manual e editorial, recusaram chamadas anônimas com HTTP 401 / SQLSTATE `42501`.
Leituras anônimas de produtos, termos e revisões editoriais também foram
recusadas. A sondagem editorial usou as colunas reais `term_id,revision`; uma
sondagem anterior de coluna inexistente não foi contada como prova de segurança.
O acesso direto sem sessão ao catálogo redirecionou para login. O teclado passou
por e-mail, senha, entrar e recuperação; submit vazio focou o e-mail obrigatório.
A rota editorial sintética retirada retornou 404 e `no-store`, sem seu conteúdo
temporário, e mostrou a mensagem de conteúdo indisponível no Chrome real.

Após a promoção, a aba operacional foi recarregada e autorizada com suas
permissões existentes. O catálogo mostrou que permanece em preparação, sem
controles de cadastro ou prévia expostos pela flag OFF. O painel mostrou
indicadores carregados, fila vazia e atividade recente, sem aviso de
indisponibilidade. A 412 × 915 px, não houve rolagem horizontal; o viewport foi
restaurado ao final. Não foram lidos senha, TOTP, cookies ou storage, nem
alterados papel, MFA, metadata ou flag da conta. Esses checks são somente
leitura e não cobrem casos positivos de QA ou todos os gates de acessibilidade.

### Pendências que impedem a entrega integral

O canônico `38303496333` continua reprovado por p95 administrativo de 2.147 ms
contra 2.000 ms. O diagnóstico posterior mais rápido não anula essa janela.
A causa interna do 503 histórico continua sem comprovação; o chamado sanitizado
já enviado ao suporte permanece a via de correlação técnica. Nenhum timeout,
limite, região ou tratamento de erro foi relaxado, nem foi repetido o release.

Para concluir conflitos entre duas sessões, hierarquia, referências negativas e
prévia privada, falta um ator QA dedicado novo, com MFA humano e recovery
durável preparado antes de qualquer efeito. A conta operacional fornecida não
é QA e não será convertida ou usada para fixtures. As provas positivas do ciclo
`7951ed3` permanecem históricas e parciais; bytes e estado dependentes devem ser
revalidados em `15290b5`. O contrato de entrega exige sete fluxos e nove gates
coerentes com SHA, digest, deployment e snapshot. Não há aprovação de produção.

## Registro histórico anterior à prévia privada

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
continua fatal, sem retry. Dez testes focados e a validação integral passaram:
240 arquivos Vitest, 1.688 testes, suites de segurança/release e build em
18,07 segundos. A correção foi commitada em
`7951ed36753581466803a976f27be57ae26aef97`, com três arquivos próprios e checkout
limpo. CI, selagem e promoção desse novo SHA continuam pendentes; a evidência do
candidato anterior não os substitui.

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

## Promoção da correção e reprovação de desempenho

A correção `7951ed36753581466803a976f27be57ae26aef97` passou no
[CI 38301399256](https://github.com/Vnd93/gaiatec-cms/actions/runs/38301399256):
sete jobs verdes em 370 segundos. O verificador canônico aceitou a seleção sem
violações; os ZIPs de seleção, plano e migrations foram verificados em memória.

- Pacote original `11771081446`, digest
  `43f7769dfa764f40db0f9eeca0d5cbd8b70537a458943df4067e1a2cefd574b1`.
- Seleção `11770581878`, digest
  `af7b2fea2ebed0cf2fe4389d3a4c9315b0e4feb255e6f0809b830448f6ae1590`.
- Payload de migrations `11770616399`, digest
  `665e77f53c781b188a752874c057ff58fdbfe586d7150272ca8e0c4b056a6444`.
- Perfil `full-release`, confiança `bootstrap-full`, sem redução de gates.
- [Bridge 38302262780](https://github.com/Vnd93/gaiatec-cms/actions/runs/38302262780)
  aprovado, com restauração obrigatória e watchdog `38303292385` skipped.
- Evidência v5 `11770613779`, digest
  `d2edc91474d3ec178d44730385c397f94882a3d2ee6f4e54405774556ba4e4da`,
  validada com pacote, SHA, perfil e digests exatos.
- Deployment canônico `97e680a4-f645-4708-baa6-a695e43e34df`.

O [canônico 38303496333](https://github.com/Vnd93/gaiatec-cms/actions/runs/38303496333)
passou preflight, fonte, baseline, migrations e compatibilidade, mas G11 reprovou
a medição administrativa. Entre `20:31:24Z` e `20:33:25Z`, uma janela serial de
20 amostras, precedida de 20 aquecimentos, produziu:

| Medida                                 | p95 observado                |
| -------------------------------------- | ---------------------------- |
| Leitura administrativa no servidor     | 2.147 ms, limite de 2.000 ms |
| Parcela RPC                            | 2.140 ms                     |
| Parcela do núcleo de snapshot no banco | 1.691 ms                     |
| Leitura administrativa no aquecimento  | 545 ms                       |
| Parede da chamada administrativa       | 2.411,07 ms                  |

As cinco primeiras amostras medidas foram inferiores a 226 ms; as seguintes
aumentaram, chegando a 3.080 ms no servidor. Isso localiza a variação em
servidor/RPC, incluindo banco, mas não comprova CPU, I/O, lock, transporte ou
defeito SQL específico como causa. As consultas sanitizadas de logs não
forneceram registros do endpoint administrativo nem erros PostgreSQL nessa
janela; isso não prova ausência de entrega ou de erro.

O resultado permaneceu reprovado, sem elevar limites, mudar estimador, aumentar
aquecimento, escolher outra janela ou repetir release. Os três checks de revisão
da medição não chegaram à aprovação. Chrome foi skipped, sem challenge. O gate
do JSON não foi alcançado após essa reprovação anterior.

A limpeza G11 confirmou zero atores, credenciais, sessões, permissões,
overrides e conteúdo sintético ativo. Finalizador e
[watchdog 38305298324](https://github.com/Vnd93/gaiatec-cms/actions/runs/38305298324)
terminaram com sucesso. Evidência terminal `11772750566`, digest
`5456ce09947e2bcb8643448c4afd48c18826a760015892fca82d0e139905a81a`,
verificada em memória: probe aprovado, 100% de disponibilidade e zero 5xx no SHA
`7951ed3`.

Depois da recuperação: zero operações GitHub nos cinco estados consultados nos
dois repositórios, zero fences, QA ativo ou manifesto aberto. Os 740 deployments
Cloudflare foram paginados até a página vazia; os estados terminais eram
sucesso. Health, ambiente e header `x-release` correspondiam ao candidato; flag
global desligada e nenhum convite QA adicional emitido.

O advisor de segurança Supabase retornou um INFO e três WARN, não um inventário
sem avisos. Funções `SECURITY DEFINER` expostas exigem avaliação dos controles de
sessão, escopo e privilégios, conforme os avisos de
[acesso anônimo](https://supabase.com/docs/guides/database/database-linter?lint=0028_anon_security_definer_function_executable)
e [acesso autenticado](https://supabase.com/docs/guides/database/database-linter?lint=0029_authenticated_security_definer_function_executable).
A função 0119 é executável por authenticated para a política RLS, com verificação
de sessão e escopo; anon e service_role não recebem EXECUTE. Também permanece o
warning de [proteção contra senhas vazadas](https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection).
A inspeção não encerra os gates integrais de segurança.

O próximo passo seguro é a homologação funcional isolada no Chrome com uma nova
identidade QA e recuperação preparada, sem nova promoção cega. O p95 reprovado
e a causa do 503 histórico continuam pendentes, independentemente do resultado
dessa homologação.

## Homologação funcional autenticada e recuperação concluída

No mesmo SHA `7951ed36753581466803a976f27be57ae26aef97` e deployment
`97e680a4-f645-4708-baa6-a695e43e34df`, o responsável concluiu senha e MFA.
O backend confirmou uma identidade QA ativa, fator verificado, sessão AAL2 e
perfil ativo. A sessão anônima não estava acessível à automação; após login
humano na janela normal, a homologação ocorreu no Google Chrome real conectado.

O painel carregou os quatro indicadores sem o aviso de indisponibilidade e
exibiu a atividade recente. Antes do acesso isolado, o Núcleo de Catálogo
mostrou a mensagem de preparação. A flag global permaneceu `false`; somente
essa identidade recebeu um override de usuário por 20 minutos, limitado pelo
prazo original do lease. O manifesto 0118 estava preparado e comprometido em
transação anterior à permissão e às mutações. Nenhum prazo foi ampliado.

| Fluxo no Chrome e backend real | Resultado observado                                                                      |
| ------------------------------ | ---------------------------------------------------------------------------------------- |
| Formulário vazio de produto    | Nome obrigatório recusado por validação nativa; nenhum cadastro criado                   |
| Taxonomia                      | Proposta e ativação de uma categoria e uma indústria sintéticas                          |
| Cadastro manual                | Um produto e um kit sintéticos, apenas rascunhos                                         |
| Revisões                       | Edição e restauração da revisão inicial como nova revisão; histórico anterior preservado |
| Composição                     | Kit contém produto com quantidade 2 e unidade un; relação direta registrada              |
| Editorial                      | Rascunho com bloco e parágrafos, revisão 1; sem publicação ou indexação                  |
| Mobile                         | Editorial a 412 por 915 px, sem rolagem horizontal; viewport restaurado após o teste     |
| Revogação                      | Após limpeza e recarga, Chrome mostrou acesso administrativo não autorizado              |

Antes da limpeza, o ledger privado registrava dois produtos, dois termos e uma
relação próprios, quatro revisões de produto, um editorial draft e zero
snapshots públicos. O encerramento usou `cms_complete_qa_actor_lease` pelo fluxo
normal, depois de remover overrides e papéis, suspender o perfil, revogar
sessões e bloquear a identidade QA. O trigger terminal executou a compensação
durável: manifesto `cleaned`, lease `cleaned`, failureCount zero, sem sweeper
prévio e sem chamada direta ao compensador privado.

A verificação posterior confirmou zero leases ativos, sessões, papéis CMS,
overrides, perfis ativos, produtos não arquivados, termos ativos, relações
ativas, editoriais não retirados, snapshots atuais e mapeamentos ativos nesse
coorte. A identidade temporária ficou bloqueada. Foram preservadas seis
revisões de produto, duas de relação e duas editoriais. Nenhum produto
comercial, SKU, importação, publicação ou mutação de produção ocorreu.

Esta é homologação funcional focada, não a aprovação Chrome do pipeline
canônico: nenhum challenge foi criado e o run `38303496333` continua reprovado.
A causa do 503 histórico e a cauda administrativa de 2.147 ms contra 2.000 ms
continuam pendentes. Na janela histórica de 20:31 a 20:34 UTC, os logs de
funções disponíveis contêm oito Boot (máximo 72 ms), dezoito Log e dois
Shutdown EarlyDrop (máximo cpu_time_used 109 e memory_used.total 24.259.111).
Esses agregados do projeto não atribuem recurso a uma chamada específica nem
comprovam a causa. Os crons de 20:30 a 20:35 UTC terminaram com sucesso em 7 a
273 ms, também sem comprovação causal. Não houve nova execução de release,
alteração de limite ou seleção de outra janela para obter verde.

## Diagnóstico de recursos e transporte sem nova promoção

Uma única execução do modo existente `--snapshot-diagnostic-with-fixture`,
no mesmo SHA `7951ed3`, conservou 20 aquecimentos e 20 amostras medidas seriais.
O relatório [sanitizado e versionado](evidencia-latencia-7951-2026-10-12.json)
tem digest SHA256
`0721d83192866b8630c884d64402150d772edfd1d574614d5e3a3ee1de26a2d5`.
O resultado é `G11_SNAPSHOT_DIAGNOSTIC`, `releaseEligible: false`; não representa
retry de release nem substitui o canônico reprovado.

| Parcela medida              | p95 diagnóstico |
| --------------------------- | --------------- |
| Servidor administrativo     | 667 ms          |
| RPC                         | 661 ms          |
| Núcleo de snapshot no banco | 70 ms           |
| Rate limit                  | 2 ms            |
| Parede                      | 963,28 ms       |

A soma de 40 chamadas foi 27.898 ms na parcela RPC, contra 8.174,61 ms de
execução agregada em `pg_stat_statements`; o delta contou exatamente 40 chamadas,
68.439 shared hits e zero shared reads. A diferença entre camadas não atribui
automaticamente todo o custo a rede, pool ou autenticação. O núcleo de snapshot
somou 6.641 ms; rate limit somou 828 ms. Sem mudança de código, o resultado
diferente confirma variação temporal, não uma correção.

Oito observações de recursos não registraram lock, I/O wait, conexão bloqueada
ou transação idle; uma observação registrou uma conexão ativa. Os gauges de
infraestrutura vieram de um único scrape, reutilizado conforme a cadência de
um minuto: load1 0,32, duas CPUs e `pgrst_db_pool_waiting` 1. Não há delta de CPU
nesse scrape, e contagens pontuais não descartam esperas entre observações.

O relógio local marcou 00:06:33,835 a 00:07:12,398 UTC de 13 de outubro; os
snapshots do banco marcaram 00:07:57,973 a 00:08:34,855 UTC. Todos correspondem
à noite de 12 de outubro em São Paulo. A correlação não mistura esses relógios
como se fossem sincronizados. Na janela do provedor, logs REST disponíveis
registraram 32 respostas 200 do RPC, origin_time de 194 a 2.418 ms e upstream
service time de 33 a 1.876 ms. Essa cobertura não é a coleção completa de 40
amostras. As consultas à janela histórica do run não retornaram chamadas
`cms-system`, mesmo na fonte correta `function_edge_logs`; ausência não prova
nondelivery nem a causa histórica.

A fixture usou somente atores sintéticos com lease durável e um lead sintético
resolvido sem entrega externa. A limpeza normal confirmou zero atores,
credenciais, overrides, papéis legados e com escopo, RDO, conteúdo, sessões,
formulários e payloads pessoais ativos, com dois leases `cleaned`. Histórico
anônimo e auditoria foram preservados. O catálogo global continuou OFF,
nenhum produto foi criado e produção permaneceu intocada.

Uma comparação separada de apenas duas chamadas públicas, sem configuração
persistente ou deploy, utilizou a invocação regional documentada. Ambas
retornaram HTTP 200 e contrato de coleção válido:

| Região efetiva       | Trace técnico                          | Projeção até headers | Corpo | Documento no handler | Parede local |
| -------------------- | -------------------------------------- | -------------------- | ----- | -------------------- | ------------ |
| sa-east-1 automática | 7c200068-0d20-4d4c-a485-b6ed8e73e107.1 | 828 ms               | 1 ms  | 2.548 ms             | 3.066 ms     |
| us-east-1 solicitada | a226295c-687c-4252-8527-7b4b0af0ab67.1 | 218 ms               | 1 ms  | 634 ms               | 1.314 ms     |

Os logs sanitizados confirmaram somente uma tentativa upstream em cada chamada,
sem deadline nem 503. O trace REST disponível de us-east-1 registrou 184 ms
origin_time e 33 ms upstream service time. O resolvedor separado respondeu em
2 e 7 ms, respectivamente; esses números não medem DNS/TCP/TLS internos do
fetch. A diferença regional é indício de custo de transporte, mas duas chamadas
sequenciais, sem contrabalanceamento ou igualdade comprovada de cache, não
estabelecem causalidade histórica. Não foi fixada região nem removido failover
automático, conforme a cautela da
[documentação de invocação regional](https://supabase.com/docs/guides/functions/regional-invocation).

O changelog vigente e a documentação de logs foram consultados. As consultas
usaram o endpoint ClickHouse atual, `event_message` e `log_attributes`; não foi
introduzida dependência em `logs.all`. `EarlyDrop` dos agregados históricos não
equivale a uma interrupção por CPU ou wall clock, conforme a
[documentação de supervisão](https://supabase.com/docs/guides/troubleshooting/edge-functions-worker-timeouts-and-websocket-drops).
Os prazos upstream de 900 ms e do Worker de cinco segundos continuam iguais.
Nenhuma causa adicional de código foi comprovada para justificar patch.
O gate canônico continua reprovado; ainda falta correlacionar a falha histórica
com transporte/gateway/backend antes de corrigir ou promover novamente.
