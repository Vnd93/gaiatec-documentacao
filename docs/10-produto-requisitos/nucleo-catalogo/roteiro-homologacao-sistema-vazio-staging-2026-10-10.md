---
id: gaiatec-catalogo-roteiro-homologacao-vazio-staging-2026-10-10
titulo: Homologação do catálogo manual vazio em staging
status: preparado-nao-executado
tipo: roteiro-homologacao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-10
ultima_revisao: 2026-10-10
fonte_canonica: gaiatec-documentacao
---

# Homologação do catálogo manual vazio em staging

O sistema deve permitir que o responsável opere e cadastre manualmente depois da
entrega. Este roteiro prepara a prova funcional, sem carregar produtos, SKUs ou
dados comerciais, ativar a flag global, publicar ou alterar produção. **Preparado
não significa homologado.** Nesta sessão não executar fixtures de produto.

## Estado confirmado e trabalho restante

Em 10 de outubro, `main` do CMS está em
`7ed72cc9cf277b57569149495a04d116a905b727`; CI `38093863981/1` passou nos sete
jobs. É um ajuste de observação dos testes, não uma correção causal do 503.
Staging preserva `46d4fef53d5c3bd728898f31d909ea0219e29e77`, bridge
`38090950737/1`. O canônico `38091738439/1` reprovou na navegação mobile;
finalizador e watchdog `38093214688` concluíram com sucesso.

O 503 posterior foi reproduzido em Chrome real. As duas tentativas da projeção
expiraram antes dos headers, em 902 e 903 ms. A fase interna do transporte ainda
depende de correlação do suporte. O chamado sanitizado foi enviado para staging,
sem habilitar acesso humano/IA ao projeto. Não repetir release para obter verde.

O preflight versionado `catalogRecoveryPreflightSql`, executado somente em leitura
no backend de staging, retornou `catalog_qa_recovery_0118_exact=true`: controles
privados, RLS, permissões, fences e hook terminal presentes. Contagens: zero leases
QA ativos, manifests abertos e produtos; flag global `false`. Essa leitura não
comprova compensação após interrupção nem um ciclo funcional no Chrome.

| Entrega     | Já existe                                    | Prova restante                                                 |
| ----------- | -------------------------------------------- | -------------------------------------------------------------- |
| CAT-001–009 | Administração, catálogo manual e contratos   | Sete fluxos positivos e negativos abaixo no Chrome autenticado |
| CAT-010     | Editorial e rotas fechadas por padrão        | Preview autenticado isolado e controles editoriais             |
| CAT-011     | Lista comercial excluída desta entrega       | Nenhuma carga ou lista nominal exigida agora                   |
| CAT-012     | Recuperação 0118 e contrato do sistema vazio | Transações separadas, recuperação terminal e nove gates        |
| Transporte  | Observação sanitizada e 503 correlacionado   | Causa interna e correção comprovada, sem aumentar limites      |

## Entrada da execução real

1. Confirmar holder e handoff no lease, GitHub `Vnd93`, `main` limpas e fetch com
   sincronização somente por fast-forward. Zero workflows ativos, fences,
   migrations, promoções, deploys e manifests pendentes. TTL não autoriza escrita.
2. Conferir gates automáticos do candidato exato antes de iniciar a homologação.
   Um canônico reprovado não é substituído por um teste focado posterior aprovado.
3. Vincular candidato, digest do artefato selado, deployment ID e digest do snapshot
   do backend. Não combinar provas do `main` 7ed72cc com o staging 46d4fef.
4. Usar Google Chrome instalado, sessão real de staging e MFA/AAL2. Nunca converter
   o usuário corporativo em ator QA, simular JWT ou copiar credenciais para logs,
   arquivos de evidência ou clipboard. Entrada de credenciais deve usar um caminho
   seguro, sem registro; se indisponível, a etapa permanece bloqueada.
5. Caso a execução isolada venha a usar fixtures sintéticas dentro do escopo
   autorizado, preparar a recuperação antes de qualquer override ou mutação.
   Não executar agora. A flag global permanece OFF; nenhum override de ambiente,
   site ou produção é permitido. Não modificar permissões para liberar testes.

## Sequência de recuperação durável

Esta sequência descreve os controles existentes em 0118; não é SQL de provisionamento
e não concede nova autorização de mutação.

1. Preparar os atores QA exatos por mecanismo existente, com leases privados,
   ambiente staging, run tag e SHA coerentes. Incluir todos os atores ativos do
   grupo; não aceitar atores preexistentes ou relações com dados corporativos.
2. Em uma transação independente, preparar `cms_catalog_prepare_qa_recovery` com
   o binding exato e digest de recuperação verificado. **COMMIT antes de qualquer
   override ou escrita.** Guardar somente referência técnica e digest sanitizados.
3. Em outra transação, comprovar que o manifest é visível, está `prepared`, possui
   todos os atores esperados e foi preparado em uma transação anterior. Não falsificar
   `prepared_xid`, claims, PID ou configurações de sessão para satisfazer o fence.
4. Executar somente os casos isolados permitidos. Registrar propriedade inicial
   no ledger, revisões esperadas e referências internas ao grupo. Uma falha encerra
   novas mutações e preserva a evidência primária antes da recuperação.
5. Encerrar os leases pelo mecanismo existente. A transição do último ator ativo
   dispara `zzy_catalog_durable_terminal_recovery` antes dos validadores terminais.
   Não chamar o compensador diretamente com identidade ou seletor forjados.
6. Conferir manifest `cleaned`, zero entidades próprias ativas, snapshots atuais,
   relações/hierarquias ativas, editorial publicado, outbox pendente, overrides e
   sessões QA ativas. Preservar revisões, auditoria e histórico imutáveis. Resíduo
   zero significa ausência de estado **ativo**, não apagar histórico.
7. Se houver estado estrangeiro, lease incoerente ou limpeza reprovada, manter falha
   fechada e diagnosticar. Não marcar `cleaned` manualmente, apagar manifests ou
   repetir compensações às cegas. Uma prova de interrupção deve terminar pelo mesmo
   caminho durável; falhar intencionalmente sem esse caminho pronto é proibido.

## Casos funcionais e resultados esperados

Todos continuam pendentes de execução real. Casos que exigem criar registros são
somente preparação nesta sessão. Não substituir o backend por mocks para homologar.

| Fluxo do contrato      | Casos mínimos                                                           | Resultado esperado                                                                             |
| ---------------------- | ----------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `manualRegistration`   | Abrir workspace, iniciar cadastro, salvar e reabrir rascunho isolado    | Campos preservados, revisão correta, sem publicação ou importação                              |
| `permissions`          | Operador autorizado e usuário sem escopo; tentativa direta de acesso    | UI e backend recusam acesso indevido; não basta ocultar botão                                  |
| `formValidation`       | Obrigatórios ausentes, slug inválido/duplicado, texto inseguro, limites | Erro por campo, foco acessível, nenhuma escrita parcial ou payload inseguro                    |
| `reviewsAndConflicts`  | Revisão, edição obsoleta e decisão pelo mesmo papel autorizado          | CAS rejeita revisão antiga; trilha preservada; não exigir outra pessoa além da decisão vigente |
| `taxonomyAndRelations` | Termos, relações/hierarquia e referência/ciclo inválido                 | Sem fonte mista, referências estrangeiras ou estado parcial                                    |
| `editorial`            | Tecnologia, indústria e aplicação; revisão e preview autenticado        | Preview restrito, conteúdo seguro e rotas públicas fechadas/noindex com global OFF             |
| `emptyStatesAndErrors` | Catálogo vazio, acesso negado, falha real de leitura e navegação mobile | Mensagem útil, sem falso sucesso, quebra de layout ou exposição de dados                       |

Acesso de staging: `https://ev2-g17-canary.gaiatec-cms-staging.pages.dev`.
Workspace: `/admin/nucleo-catalogo`. Rotas editoriais existentes:
`/catalogo/tecnologia/:slug`, `/catalogo/industria/:slug` e
`/catalogo/aplicacao/:slug`. O workspace fechado para o usuário normal com a flag
OFF é esperado; não é prova positiva dos formulários internos.

## Gates e evidências de saída

Os nove gates de `CatalogManualSystemUatSchema` são `security`, `mfaAal2`, `rls`,
`audit`, `accessibility`, `mobile`, `compatibility`, `rollback` e `zeroActiveResidue`.
Cada um exige referência de evidência, digest e binding coerente. Testar teclado,
foco/erros, viewport mobile, negativa RLS no backend e revisão/auditoria; CI ou
schema parseados não autenticam a prova de Chrome.

Challenge de Chrome apenas depois dos gates automáticos prévios e com watcher
pronto. Preservar validade e antirreplay existentes; não emitir agora nem renovar
para contornar falha. Mudança de SHA, bytes, deployment ou estado invalida provas
dependentes. Medir duração por etapa e diferenciar relógio do banco e do computador;
o desvio observado anteriormente não autoriza relaxar validade de autenticação.

O registro do sistema vazio só passa quando os sete fluxos, nove gates, browser e
recovery passam. Enquanto pendente, `proof=null`; nunca fabricar digest ou preencher
`passed` a partir de implementação. Não anexar HAR bruto, cookies, contatos,
credenciais, TOTP ou conteúdo comercial. A conclusão futura é **homologado em
staging**, não liberado em produção.

## Referências canônicas

- [Backlog das Fatias 1–4](backlog-executavel-fatias-1-a-4-2026-09-24.md).
- [Matriz de rastreabilidade](matriz-rastreabilidade-ondas-1-a-4-2026-09-24.md).
- No CMS: `src/shared/contracts/catalog-system-uat.ts`,
  `supabase/migrations/0118_cms_catalog_qa_durable_recovery.sql`,
  `scripts/ev2/phase12/catalog-recovery-preflight.mjs` e testes correspondentes.
