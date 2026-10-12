---
id: gaiatec-catalogo-correcao-mensagens-staging-2026-10-12
titulo: Correções de mensagens do catálogo promovidas em staging
status: promovido-homologacao-autenticada-pendente
tipo: evidencia-release
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-12
ultima_revisao: 2026-10-12
fonte_canonica: gaiatec-documentacao
---

# Correções de mensagens do catálogo promovidas em staging

As duas falhas de comunicação encontradas no
[ciclo real de Chrome e recuperação](registro-chrome-qa-recuperacao-2026-10-12.md)
foram corrigidas com mudanças mínimas, testes de regressão e promoção controlada
do pacote original da CI. Staging serve `0dd17227`; a flag global continua OFF,
produção está intocada e não houve carga comercial ou importação.

Esta promoção não conclui a homologação integral. A prova autenticada anterior
pertence ao SHA `a6c2c2e2`. As mensagens alteradas precisam de nova verificação
autenticada no Chrome; a causa do 503 e os indicadores parcialmente indisponíveis
continuam pendentes.

## Correções e validações

O erro PostgreSQL `23505` agora apresenta duplicidade de slug ou vínculo, mantém
o formulário editável e não inicia uma comparação de revisões. Conflitos reais
`PT409` e `40001` continuam no fluxo CAS, sem retry automático. Nenhum detalhe
bruto do banco é exibido ao operador.

O editorial limpa o aviso de sucesso anterior ao mudar de termo ou recusar uma
tentativa inválida. Também limpa a comparação/proveniência do termo anterior ao
selecionar outro. Não foram alterados comandos RPC, autenticação, MFA, RLS,
permissões, migrations, workflows ou limites de transporte.

Quatro novos testes falharam antes da correção e passaram depois. O conjunto
focado teve 14 testes aprovados. A primeira execução completa encontrou um uso
indevido de uma opção do Playwright em um teste Testing Library; apenas o teste
foi ajustado. A execução completa posterior de `npm run check` passou: formatação,
lint, tipagem, 239 arquivos/1.685 testes Vitest, QA, contratos/evals de segurança e
release e build. Build local: 24,90 s. O artefato local não foi usado no deploy.

O commit próprio alterou seis arquivos, com 124 inserções e quatro remoções.
Foi revisado e publicado em `main`, sem incluir mudanças preexistentes.

## Binding da promoção

| Campo                         | Valor confirmado                                                                                  |
| ----------------------------- | ------------------------------------------------------------------------------------------------- |
| SHA do CMS                    | `0dd17227a4fca773913f14b32b5ce51ba3ef78e8`                                                        |
| Baseline recuperável          | `a6c2c2e2a3004cea8c0d51084b9a16a606a12939`                                                        |
| CI e produtor original        | `38193383120/1`, sete jobs com sucesso                                                            |
| Pacote original               | `11722612754`, ambiente staging, não expirado                                                     |
| Digest GitHub do pacote       | `243d1d3068ecce4457aba148c7b56fe680abbe83f16baa15177238f8a92037b2`                                |
| Digest do arquivo dist selado | `911ade609cdbbbd0058b5c4ccf321d32cf875f23951d1033b27f33a6d7c62ddb`                                |
| Digest da árvore dist         | `daa3204e3eae5329e430876bc96eb5ebebdc8b617f62718b65c4ef5c68b80aa9`                                |
| Perfil selecionado            | `full-release`, sem forçar seleção reduzida                                                       |
| Bridge                        | `38194011137/1`, promoção e métricas com sucesso                                                  |
| Preview                       | `5942573b-5f5e-4a74-ac75-15c79f61556b`                                                            |
| Deployment canônico           | `1639a263-9724-490e-931c-7db7d1fe4f68`                                                            |
| Evidência v5 da bridge        | Artefato `11723235475`, digest `93719bd7649079fc1c81af47dc334fdb8d55cf27ec37f27d9e936b39f62f1265` |
| Restauração do backend        | Artefato `11722384795`, digest `d0b79cd44020e602cf8f62079eb90b6c3e5b64947a16fd1938cd20b344f269bb` |
| Watchdog                      | `38194755204`, terminal `skipped` após bridge bem-sucedida                                        |

O arquivo da evidência foi lido em memória: seu digest GitHub e os bindings de
SHA, run/attempt, produtor, pacote/digest e deployments foram conferidos. A mesma
dist selada foi promovida no preview e no canônico; não houve rebuild equivalente.
Na conferência final, `/healthz` devolveu SHA, ambiente e header exatos; a consulta
completa de 731 deployments Cloudflare encontrou zero ativos. Os cinco estados
ativos de workflows nos dois repositórios estavam zerados; não havia variáveis
de recovery/fence/lease pendentes. Banco: QA ativo 0, recuperação aberta 0 e flag
global `false`.

## Escopo da evidência e tempos reais

A bridge é explicitamente `compatibility-only`: leitura legada, renderização de
página/campanha/formulário, widget Turnstile, recusa sem token e zero envio de lead.
Seu contrato não prova submissão positiva, persistência de lead ou backend
completo do candidato. `positiveBrowserRequiredAfterFullCandidateDeploy=true`
permanece obrigatório. Não substituir o canônico reprovado do 503 por esta bridge.

Horários UTC: CI de `01:49:32` a `01:56:45` (433 s de janela total); bridge de
`01:59:17` a `02:10:31` (674 s de janela total). O relatório de duração da bridge,
com digest `8d83da14f055302e8a9b97979310a5b3f3353ddd1bc446b58560ae33a09e04c9`,
registrou etapa `promote` de 655 s. Sua maior subetapa foi a prova isolada no
backend staging atual antes da troca legada, com 63 s. O SLO está
`component-only`, não é prova do caminho feliz integral de 40–60 minutos;
`gatesRelaxed=false`.

No Chrome real, após a promoção e sem sessão QA, as três rotas editoriais
sintéticas de tecnologia, indústria e aplicação permaneceram fechadas, com
`robots=noindex,follow`. Nenhum produto ou página editorial do Núcleo de Catálogo
foi publicado ou indexado.
Essa negativa não equivale à homologação autenticada das mensagens corrigidas.

## Próxima entrada segura

A identidade QA anterior foi encerrada e bloqueada pela recuperação durável.
Não reabrir seu lease, alterar datas ou reaproveitar credenciais. Uma nova execução
deve usar identidade dedicada disponível, convite, MFA/AAL2, manifest commitado
antes do override individual e bindings do novo SHA/pacote/deployment.

Foi solicitado ao responsável outro endereço de teste ou alias com recebimento
confirmado para esta revalidação. Nenhuma nova aprovação literal de SHA foi
inventada, e não é necessário fornecer senha, TOTP ou link de convite ao executor.
Os demais casos e gates pendentes seguem no inventário do ciclo real, incluindo
o diagnóstico do 503 e dos indicadores. O sistema não está declarado pronto nem
liberado em produção.
