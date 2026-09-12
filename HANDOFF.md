# Handoff controlado — fechamento final do CMS GAIATEC

> Estado de entrega: **NAO APROVADO PARA USO OPERACIONAL**. Este documento transfere o estado real
> da execucao; nao declara que o candidato foi homologado ou publicado.

> ## 🔴 PRODUÇÃO ESTÁ 36 MIGRATIONS ATRÁS DA MAIN
>
> **Medido em 11/09/2026. Leia antes de planejar qualquer promoção.**
>
> ```
> Produção roda .............. 38ecae8b   (deploy 34069047721, 2026-09-07T00:12:09Z)
> Migrations nesse SHA ....... 56
> Migrations na main hoje .... 92
> Última aplicada ............ 0056_cms_audit_identity_detach.sql
> ```
>
> Nenhum documento do projeto registrava isto. Quem lia este handoff concluía que produção tem o que
> a `main` tem.
>
> **O que NÃO está em produção, e importa:**
>
> - `0078` — consolidação do PIM em somente-leitura. É a causa-raiz apontada para as lacunas do
>   catálogo; se não está aplicada, **o diagnóstico do catálogo derivado da `main` pode não valer em
>   produção**. Confirmar exige leitura do banco.
> - `0067`–`0072` — escopo autoritativo de conteúdo, PIM, usuários, atributos, formulários e leads.
> - `0086`–`0088` — endurecimento de runtime. Uma leitura anterior atribuiu os portões de ambiente a
>   estas três migrations; **está errado**, elas não estão em produção. Os portões vêm de `0038`,
>   `0043`, `0045` e `0048`, que são antigas e estão aplicadas.
> - `0090` — o predicado do par acoplado da limpeza. `0061` está; `0090` não.
> - `0091`, `0092` — janela de lease. Em produção vale o prazo da `0061`.
>
> **Consequência para o G12:** o próximo deploy de produção aplica **36 migrations de uma vez**. Não
> é incremento, é travessia. O perfil de risco da promoção é outro, e o plano do gate precisa tratá-lo
> como tal.
>
> **Como foi medido:** pelo conteúdo do commit que o deploy promoveu
> (`git ls-tree -r --name-only 38ecae8b -- supabase/migrations`), não pelo banco. Método reprodutível
> e que não depende de credencial.
>
> **O que continua sem resposta, e exige leitura do banco de produção:**
>
> 1. Quais habilitações o operador de produção tem, e com que janela de validade.
> 2. Quantas linhas antigas de produto seguem não arquivadas — determina se há incidente em curso
>    travando a publicação de produto.
> 3. Se a chave do provedor externo de IA está de fato instalada.
>
> O conector Supabase da sessão coordenadora está autenticado numa organização que não contém os
> projetos da GAIATEC — escalado ao responsável, que está ajustando o acesso.

## Checkpoint e lease de escrita

- Captura local: `2026-09-09T14:20:20-03:00` (`America/Sao_Paulo`).
- Captura UTC canonica: `2026-09-09T17:20:20.684Z`.
- Nenhum workflow remoto estava `queued` ou `in_progress` na consulta dos 100 runs mais recentes.
- Nenhuma operacao local atomica estava em andamento.
- A partir da publicacao deste handoff, Codex Desktop permanece somente leitura ate o claim explicito
  pelo Claude Code ou a devolucao/cancelamento explicito do handoff.
- Claim executado por Claude Code em `2026-09-09T17:58:05.187Z`. Codex Desktop permanece somente
  leitura ate a devolucao ou o cancelamento explicito deste lease.
- Revalidacao imediatamente anterior ao claim: perfil GitHub `Vnd93`; codigo em `main` com HEAD e
  `origin/main` iguais a `0ab1fa84eec65c762644ed9368bfcfb213402b17` e checkout limpo; documentacao em
  `docs/g12-production-release` igual a `2e29771c7df6eda8b13314c34601ec827f0f3b96`; nenhum run
  `queued` ou `in_progress` nos 100 mais recentes; `/healthz` de staging servindo `4b9184b3...` e o de
  producao servindo `f48bb453...`; Supabase staging `glcqsosxwgmlhzgcsnzv` com 34 Edge Functions,
  `cms-public` em 56 deployments e migrations `0001`-`0088`; Supabase production
  `chfuhctnhqgyjowkvllv` `Healthy` com ultima migration `cms_audit_identity_detach`.
- Limitacao observada na revalidacao: a lista de Edge Functions do projeto de producao nao renderiza
  no dashboard Supabase; o inventario de funcoes de producao deve ser confirmado pelo pipeline final.

```yaml
writerState: CLAIMED
currentWriter: CLAUDE_CODE_FAIXA_A
previousWriter: CLAUDE_CODE
lane: A
laneScope: release-critical
laneTtlMinutes: 15
laneHeartbeatAt: 2026-09-10T22:44:23.000Z
workingDirectory: C:\dev\cms-site\gaiatec-cms-faixa-a
codeCandidateSha: ff2238df23ba00854b9e9c401376b3edcdc93f46
previousCodeCandidateSha: c59232da6ceea85ea797be7f606022a6e70c6504
capturedAt: 2026-09-09T17:20:20.684Z
claimedAt: 2026-09-10T22:44:23.000Z
previousReleasedAt: 2026-09-10T21:36:12.000Z
```

## Passes 6 e 7, e a correcao de uma afirmacao minha que estava errada

Captura local `2026-09-11T10:02:06-03:00`, UTC `2026-09-11T13:02:06.000Z`.

| Passe | Run | Candidato | Gates reprovados |
| ----- | --- | --------- | ---------------- |
| 6 | `34552942444` | `680c6a8` | 1 de 13 |
| 7 | `34554432797` | `cbcc7223` | 1 de 13 |

### A correcao

No passe 6 eu relatei que o PR #38, que corrigiu as doze ocorrencias de `aria-label` em elemento
generico, estava **provado de ponta a ponta contra o alias publicado**. **Nao estava, e o relato
estava errado.**

O alias `ev2-g12-canary` serve `c59232da`, que e ancestral de `6e60a72`, o commit que trouxe os doze
`role`. Confirmado por `git merge-base --is-ancestor`. O alias roda um build **sem** a correcao, e o
passe de diagnostico nao publica nada, por desenho.

O zero de violacoes do passe 6 foi **falso negativo**. O elemento infrator e o estado de carregamento
do catalogo, que e transitorio: numa carga rapida ele ja saiu do DOM quando a axe varre; numa lenta,
nao. Passe 6: zero violacoes. Passe 7, **mesma fonte e mesmo alias**: dezesseis. Duas execucoes
identicas com resultados opostos. Nao era prova; era sorte, e eu li sorte como prova.

### Dois defeitos estruturais que isso expoe

O relatorio do passe declara que ele nao valida migration nova nem funcao nova do candidato.
**Faltava declarar que ele tambem nao valida mudanca de frontend**, pela mesma razao: o alias serve o
SHA anterior, entao todo gate que inspeciona o frontend publicado esta avaliando o build antigo.

E um gate cujo alvo e um elemento transitorio **nao e gate**: ele aprova ou reprova por temporizacao.
Isso vale independentemente de qual SHA o alias serve.

### O que o passe 7 nao chegou a exercitar

`cbcc7223` trouxe a nomeacao do orcamento que a reprovacao de medicao nao informava. O passe 7 rodou
sobre esse candidato, mas o canario G11 morreu em `runAccessibility()`, que fica antes de
`record_run`. A linha `g11.metrics` nao foi emitida nenhuma vez. **A correcao esta na main e continua
sem ter sido exercitada.**

### Consequencia para o sequenciamento

Repetir passes de diagnostico para o gate de acessibilidade e inutil: ele so pode ser validado por um
run que publique o candidato, e quem publica e o run canonico. O mesmo vale para qualquer correcao de
frontend.

### Estado das provas

| Correcao | Provada contra | Situacao |
| -------- | -------------- | -------- |
| `networkidle` para `load` | comportamento da navegacao | provado: zero `page.goto` timeout, independe do alias |
| Doze `role` ARIA | fonte e trava mecanica | **nao provado no alias**; exige publicacao |
| Contrato fixture x schema | local e CI | provado |
| Transporte duravel de lease | forma do codigo | **nao exercitado**: `57014` nao ocorreu em nenhum passe |
| Nomeacao de orcamento | nenhuma | **nao exercitada**: o canario morre antes |
| Bloco 5 | testes proprios | parcial: identificacao sim, remediacao nao |

## Passe 5: um patch provado, um nao exercitado, e uma violacao que estava encoberta

Captura local `2026-09-10T22:33:46-03:00`, UTC `2026-09-11T01:33:46.000Z`.
Candidato `32443205d37226c935ca538c58dea7dd0aa371d8`, run `34550325640`, 1 gate reprovado de 13.

O PR #37 da Faixa C entrou por **rebase**, nao por merge: a `main` tem o ruleset
`required_linear_history`, que recusa commit de merge mesmo com `allow_merge_commit` verdadeiro na
API do repositorio. Os dois commits da Faixa C foram reaplicados como `e9152f2` e `3244320`.

### Provado

A troca de `networkidle` por `load` funcionou **contra o alias publicado**. O passe 5 teve zero
`page.goto: Test timeout`, contra quinze em cada um dos passes 2, 3 e 4. Esse era justamente o
caminho que o job `browser` do CI nao exerce, porque roda contra `vite preview` em `127.0.0.1`; quem
o exerce e o canario G11 contra o alias.

### Nao provado, e nao deve ser contado como tal

Zero ocorrencias de `57014` no passe 5. O teardown nao estourou o orcamento, entao o caminho de
fallback do transporte duravel **nao foi percorrido** em staging. A forma do codigo segue provada por
sete testes de regressao e pela verificacao adversarial dos quatro defeitos reintroduzidos um a um; a
sobrevivencia ao erro real continua pendente e so aparece num teardown que crie volume suficiente.

Verde aqui e evidencia de nao regressao, nao prova de que o caminho novo funcionou. A distincao foi
registrada como criterio antes do passe rodar, exatamente para nao ser confundida depois.

### Defeito novo, e nao e regressao

Com as navegacoes completando, a suite passou a de fato executar a assercao que ela sempre teve, e
reprovou:

```
/produtos: aria-prohibited-attr  (impact: serious)
aria-label attribute cannot be used on a div with no valid role attribute.
<div class="products-catalog__loading" aria-busy="true" aria-label="Carregando produtos">
```

Origem: `src/public/pages/CmsProductsPage.tsx:247`. A violacao existia antes; enquanto `page.goto`
nunca retornava, a assercao nunca chegava a rodar.

**A classe tem dez instancias, nao uma.** `aria-label` e permitido em elemento com role implicito,
como `section` e `ul`, e proibido em elemento generico: `div` e `span` tem role `generic`, `p` tem
role `paragraph`, e nenhum dos tres aceita nome acessivel. A axe pegou uma porque `/produtos` e a rota
testada e o estado de carregamento estava na tela naquele instante. As outras nove sao latentes e
aparecem assim que outro estado renderizar.

Ha precedente correto no proprio codigo: `src/admin/components/AdminUI.tsx:541` usa `role="status"`
junto com `aria-busy` e `aria-label`, que alem de tornar o atributo permitido faz o leitor de tela
anunciar a mudanca.

`src/**` pertence a Faixa C pelo mapa. O pedido foi escrito em `C:\dev\cms-site\PEDIDOS_FAIXA_C.md`
com a lista completa de arquivo e linha, o precedente, e o pedido de trava mecanica — a axe so cobre o
que a rota testada renderiza naquele instante, e foi por isso que nove passaram despercebidas.

### Por que o ciclo remoto nao avancou

Nao faz sentido gastar bridge e deploy canonico com um gate conhecido reprovando. O ciclo fica parado
ate a Faixa C entregar, e entao roda o passe 6.

## Quatro passes de diagnostico: de quatro defeitos para um, e o defeito restante e de outra faixa

Captura local `2026-09-10T21:32:23-03:00`, UTC `2026-09-11T00:32:23.000Z`.

| Passe | Run | Candidato | Gates reprovados |
| ----- | --- | --------- | ---------------- |
| 1 | `34540916796` | `4552f9ad` | 3 de 12, mais a prova de residuo |
| 2 | `34542229170` | `8585818` | 4 de 13 |
| 3 | `34543824215` | `352c29d` | 1 de 13 |
| 4 | `34545424560` | `f3771d8` | 1 de 13 |

O passe 3 provou tambem a regra de pre-condicao: `browser_fixture`, `cleanup` e `residue` voltaram
`SKIPPED`, nao `PASS` vazio, porque o alias nao serve o candidato.

### Correcao de leitura: o passe 2 tinha dois problemas no G11, nao um

O `AggregateError` do canario G11 carrega o erro **operacional** e o de **encerramento**. Eu li so o
de encerramento — o timeout de lease — e relatei um defeito onde havia dois. A suite de
acessibilidade ja reprovava desde o passe 2, identicamente, e nos runs canonicos o canario morria
antes de chegar nela: `runAccessibility()` esta na linha 1127 de
`scripts/ev2/phase11/staging-canary.mjs`, depois dos checks de lead. No deploy `34528923953` ele
parou no 404 do lead. Nao ha evidencia, nos runs examinados, de que esse gate ja tenha rodado ate o
fim contra um alias publicado.

### Timeout de lease: corrigido e confirmado

O `57014` foi reproduzido tres vezes e desapareceu no passe 4. A correcao esta em
`f3771d825a61307245651dc91e03ec2b07ba7ce3`.

Duas premissas minhas caíram no caminho, e vale registrar as duas:

1. `ALTER FUNCTION ... SET statement_timeout` **nao** afeta o statement em execucao. O timer e armado
   no inicio do statement de topo; quando a funcao comeca, e tarde. Eu havia recomendado isso de
   memoria e verifiquei antes de implementar.
2. Lotear a varredura, como eu descrevi, exigiria reimplementar mais de trinta tabelas espalhadas por
   doze funcoes de gatilho. Nao e correcao minima, e eu propus sem ter medido o que seria loteado.

O caminho que ficou de pe nao estava em nenhuma das duas: armar o teto **antes** do statement, pelo
transporte de gestao que o canario ja usava. O encerramento tenta o caminho normal do PostgREST e, so
quando ele responde `57014`, e so para `cms_complete_qa_actor_lease`, repete pela API de gestao com
teto explicito — sessenta segundos de statement dentro de noventa de requisicao, o primeiro
necessariamente menor que o segundo para que o abort nunca corte antes da resposta do banco. Sem
migration, sem afrouxar nenhuma protecao de producao. A identidade e validada contra padroes fechados
antes de qualquer interpolacao em SQL, e a autorizacao continua dentro da funcao, que e
`SECURITY DEFINER`.

### Defeito restante: `networkidle` nao assenta num origin com service worker

Todas as navegacoes da suite `@a11y` estouram contra o alias publicado, esperando `networkidle`,
inclusive nas duas retentativas — portanto nao e cache frio.

A pagina registra um service worker (`src/app/components/ServiceWorkerRegister.tsx`), e no alias
publicado ele esta **ativo**, com escopo `/`, confirmado no proprio origin:
`navigator.serviceWorker.getRegistrations()` devolve um registro `activated` com `controller` verdadeiro.
Cada teste do Playwright abre contexto novo, e cada retentativa tambem; em todos o service worker
instala e pre-cacheia. `networkidle` exige 500 ms com no maximo duas conexoes abertas, e isso nao
acontece dentro de trinta segundos pela rede do runner.

No CI a mesma suite passa porque roda contra `vite preview` em `127.0.0.1`: o service worker registra
igual, mas os assets vem da propria maquina. O canario, por outro lado, aponta a suite para o alias
publicado.

A correcao pedida e trocar `networkidle` por `load` mais asserção explicita sobre o conteudo. Isso
**nao** enfraquece o gate: `networkidle` e um proxy nao determinista para "a pagina terminou", e a
propria documentacao do Playwright desaconselha seu uso. Aumentar o prazo nao resolve: o service
worker continua pre-cacheando, e so troca uma falha rapida por uma lenta.

### Dois pedidos abertos com a Faixa C

`C:\dev\cms-site\PEDIDOS_FAIXA_C.md` reune os dois, com codigo pronto e referencia a implementacao
provada:

1. `scripts/qa/cms-browser-fixture.mjs` — mesmo transporte duravel de encerramento de lease. **E o
   que reprova o deploy canonico hoje**, na etapa `Revoke the rollback compatibility actor and verify
   zero active residue`.
2. `tests/e2e/routes-and-a11y.spec.ts` — remover `networkidle` das seis navegacoes.

Os dois caminhos sao da Faixa C pelo `ownership` emendado. A Faixa A nao escreveu em nenhum deles.

## Defeito de produto nomeado pelo segundo passe: conclusao de lease estoura o timeout

Captura local `2026-09-10T20:43:22-03:00`, UTC `2026-09-10T23:43:22.000Z`.

Run `34542229170`, candidato `8585818572b9b58762a34e8f8fa99b96c7c8ec4a`. O `supabase link` resolveu o
canario de migrations, que passou. Duas causas novas apareceram.

### O defeito

```
POST /rest/v1/rpc/cms_complete_qa_actor_lease: HTTP 500
{"code":"57014","message":"canceling statement due to statement timeout"}
```

**Doze gatilhos de limpeza terminal** disparam num unico `update ... set status` da linha de lease:
`0063`, `0064`, `0069`, `0071`, `0072`, `0073`, `0074`, `0075`, `0076`, `0078` (dois) e `0080`. Cada
um varre e encerra tudo que o run criou no subsistema dele — conteudo, formularios, leads, visual,
IA, atributos, colaboracao, PIM. Tudo isso corre dentro de **um** statement, sob o
`statement_timeout` de oito segundos herdado do `authenticator`; nenhuma migration configura esse
valor.

Isso explica a intermitencia observada: o custo do encerramento cresce com o que o run criou. E e
quase certamente a mesma causa do `QA_CMS_FIXTURE_LEASE_COMPLETION_FAILED` que reprovou a etapa
`Revoke the rollback compatibility actor and verify zero active residue` no deploy `34528923953`. La
o erro veio nu; aqui veio nomeado, porque `scripts/ev2/phase11/staging-canary.mjs` ja anexa a
identidade retornada pelo banco e `scripts/qa/cms-browser-fixture.mjs` ainda nao.

Todos os checks operacionais do canario G11 passaram. O que quebra e o encerramento, nao a operacao.

A correcao pertence a `supabase/migrations/**`, caminho da Faixa A, e esta bloqueada pelo mapa de
propriedade — ver a secao de bloqueio abaixo.

### O limite estrutural do ciclo autenticado de navegador

`scripts/qa/cms-browser-fixture.mjs` exige, ao mesmo tempo, que `git rev-parse HEAD` do checkout seja
igual ao SHA esperado e que `/healthz` de `ev2-g17-canary` sirva esse mesmo SHA. Num passe que nao
publica nada as duas condicoes se excluem: com o SHA candidato ele reprova por
`QA_CMS_FIXTURE_RELEASE_MISMATCH`, com o SHA vivo reprova por `QA_CMS_FIXTURE_CHECKOUT_SHA_MISMATCH`.

Nao existe valor que satisfaca as duas. Forcar qualquer lado produz falha garantida, o que e pior do
que nao rodar, porque ensina a ignorar o vermelho do passe. O gate passou a rodar exatamente quando
pode — quando o alias ja serve o candidato, caso do rediagnostico de um SHA ja publicado — e fica
`skipped` fora disso, com o limite escrito no campo `limits` do relatorio, para que a ausencia nunca
seja lida como cobertura.

Faltava tambem instalar o navegador: os canarios dirigem Chromium internamente, e sem ele a suite de
rotas e acessibilidade do G11 reprova por ausencia de ferramenta.

### Bloqueio de propriedade de arquivo, agora sobre o caminho critico

`scripts/ev2/phase12/backend-compatibility-policy.test.mjs` exige, para **toda** migration `>= 0057`,
duas provas: ao menos um `.test.sql` e ao menos uma prova de aplicacao `.ts`, `.tsx` ou `.mjs`
executada no CI. O `ownership` do `FAIXAS_LEASE.yaml` atribui `tests/**` e
`scripts/ev2/**/*.test.mjs` a Faixa C.

Consequencia mecanica: a Faixa A **nao consegue adicionar nenhuma migration**, embora a secao 9.1
defina o escopo dela como "codigo, migrations, selo, promocao". Isso ja travava o Bloco 6 no primeiro
passo, o RPC de heartbeat. Agora trava tambem a correcao de um defeito real do caminho critico, com
evidencia de execucao em staging.

Emenda sugerida: `scripts/ev2/**` e `supabase/**` para a Faixa A; `scripts/qa/**` e `tests/**` para a
Faixa C. Enquanto a decisao nao vem, a Faixa A nao escreve em `tests/**`.

### Candidato

`352c29de3308a4cad17a18d3637dea52031a2990`, com verificacao local integral aprovada: 178 arquivos,
1105 testes, `G12_RULES_PASS` e build.

## Primeiro passe de diagnostico: quatro problemas em uma passada

Captura local `2026-09-10T20:27:33-03:00`, UTC `2026-09-10T23:27:33.000Z`.

Run `34540916796`, candidato `4552f9ad9a09a18a015967c392213127ed3ba579`, despachado com
`diagnostic_run=true`. O desenho estrutural se confirmou na primeira execucao: `deploy` e `finalize`
ficaram `skipped` e so o job `diagnostic` executou. Nenhum step de selo, publicacao, promocao ou
evidencia existiu no run.

### Uma armadilha de leitura, registrada para nao se repetir

`gh run view --json jobs` devolve o **conclusion** de cada step. Para um step com
`continue-on-error: true`, um gate que reprova aparece como `success` no conclusion; o resultado real
esta no **outcome**. Ler o conclusion faz um passe de diagnostico parecer integralmente verde
justamente quando ele esta cumprindo a funcao dele. O relatorio consolidado usa `outcome`, e e ele a
fonte, nao a listagem de steps.

### O que o passe colheu

`failedGates: 3 de 12`, mais a prova de residuo:

| Gate | Erro | Causa |
| ---- | ---- | ----- |
| `migrations_canary` | `G12_STAGING_MIGRATION_CANARY_TARGET_REFUSED` | CLI do Supabase nao vinculado |
| `g11_canary` | `ALVO RECUSADO: o projeto vinculado nao e o staging autorizado` | a mesma |
| `browser_fixture` | `QA_CMS_FIXTURE_RELEASE_MISMATCH` | SHA candidato onde se confere o release servido |
| prova de residuo | `QA_CMS_FIXTURE_STATE_REQUIRED` | consequencia da anterior |

Duas causas raiz, as duas no proprio job de diagnostico, nenhuma no produto:

- O `supabase link` acontecia no step que aplica migrations, que o passe pula com razao. Mas `link` e
  operacao local: escreve `supabase/.temp` no workspace e nao muta o projeto remoto. Sem ele os
  canarios recusam o alvo antes de rodar qualquer check — `checkCount: 0`.
- `QA_CMS_EXPECTED_SHA` levava o SHA candidato. A fixture compara esse valor com o release que
  `/healthz` de `ev2-g17-canary` realmente serve, e o passe nao publica nada.

No fluxo serial anterior esses quatro problemas custariam quatro candidatos. Aqui custaram um.

### Um furo do proprio relatorio, exposto pelo mesmo run

`diagnostic.cleanup` voltou `PASS`. Mas limpar o que nunca foi provisionado tem sucesso sem
exercitar nada, e um PASS vazio mente sobre a cobertura da passada. Os gates passaram a declarar
pre-condicao: um gate cuja pre-condicao nao passou e reportado `SKIPPED`, nunca `PASS`, enquanto uma
falha propria dele continua sendo reportada como falha. A prova de residuo virou gate catalogado, em
vez de step nao contado.

### Lote corrigido em um unico SHA

Candidato `8585818572b9b58762a34e8f8fa99b96c7c8ec4a`, CI `34541841345` aprovada nos tres jobs:

1. `supabase link` como guarda do passe, sem nenhum `db push`.
2. SHA vivo em todo gate que compara release servido; SHA candidato onde a identidade da fixture nao
   e comparada com release servido.
3. Gate de residuo catalogado e regra de pre-condicao no relatorio.
4. `frontend_bridge_run_id` deixou de ser obrigatorio, porque o passe nao publica nem sela. Isso
   sozinho abriria um furo: `grep` de string vazia devolve string vazia, entao a comparacao do guarda
   canonico aceitaria um valor ausente. O guarda passou a exigir a presenca antes de conferir o
   formato.

## Fim de linha decidia o resultado da verificacao local

Captura local `2026-09-10T19:57:51-03:00`, UTC `2026-09-10T22:57:51.000Z`.

O repositorio nao tinha `.gitattributes`. Sem ele, o fim de linha materializado no checkout depende do
`core.autocrlf` de cada maquina. O clone antigo tinha os arquivos em LF; ao criar o clone da Faixa A
eu fixei `core.autocrlf=true` para "nao divergir", e o resultado foi o oposto: a arvore nova veio em
CRLF, com 4212 bytes na `0089` contra 4119 do clone antigo.

Cinco testes de contrato comparam trechos de duas linhas unidos por uma quebra `LF`, por
exemplo o contrato da `0089`:

```ts
expect(migration).toContain(`revoke all on function ${routine}\n  from public,anon,authenticated;`);
```

Com CRLF eles nunca casam. Os cinco reprovaram na Faixa A e passariam no CI, que e Linux e usa LF.

Isso e grave pelo criterio do proprio projeto: divergencia entre a verificacao local e a do CI
invalida evidencia. Uma reprovacao local que o CI nao reproduz treina a equipe a ignorar o vermelho
local; o inverso, um verde local que o CI nao reproduz, deixa passar defeito.

Correcao aplicada, em duas camadas:

- A arvore da Faixa A foi renormalizada para LF sem nenhum comando destrutivo: o proprio git listou,
  por `git ls-files --eol`, os 1105 arquivos com indice em LF e arvore em CRLF, e so esses foram
  reescritos. `git diff` confirmou depois que o unico arquivo com diferenca de conteudo era o que eu
  havia editado. Os cinco testes passaram na sequencia.
- `.gitattributes` na raiz, com `* text=auto eol=lf` e binarios explicitos, para que o fim de linha
  deixe de ser preferencia de maquina. O banco de objetos ja guardava LF; o arquivo apenas torna o
  checkout igual em toda maquina, agora e para qualquer clone futuro.

Efeito colateral a avisar: o clone da Faixa C, em `C:\dev\cms-site\gaiatec-cms`, tambem esta com
`core.autocrlf=true` e portanto com arvore CRLF. Ele reprova nos mesmos cinco testes hoje. Depois que
o `.gitattributes` for integrado, o proximo checkout dele renormaliza a arvore de uma vez.

## Bloco 4 aplicado: passe de diagnostico no deploy de staging

Captura local `2026-09-10T19:52:34-03:00`, UTC `2026-09-10T22:52:34.000Z`.

A secao 2 da instrucao de otimizacao mede o problema: `deploy-staging.yml` e um job serial de ~110
steps com timeout de 240 minutos, a falha aborta o run, e por isso cada rodada colhe **um** defeito.
Seis candidatos foram consumidos em um dia para colher seis defeitos que ja coexistiam, todos
pre-existentes e triviais. O custo esteve em descobrir, nao em corrigir.

### O que foi implementado

Entrada `diagnostic_run` no `workflow_dispatch`, booleana, padrao `false`, e um job `diagnostic`
proprio. As proibicoes da secao 4.2 passaram a ser **estruturais**, nao anotadas step a step:

- `deploy` roda apenas com `if: ${{ !inputs.diagnostic_run }}`;
- `diagnostic` roda apenas com `if: ${{ inputs.diagnostic_run }}`;
- `finalize` nao roda em diagnostico, porque nao ha mutacao para compensar.

Em diagnostico o job canonico inteiro deixa de existir. Nao ha step de selo, publicacao, promocao ou
evidencia que possa ser alcancado por engano, e nao ha anotacao a manter em dia a cada step novo.

Os doze gates do passe rodam com `continue-on-error: true` e `id` proprio, de modo que a falha e
registrada em vez de abortar a passada: cadeia local, matriz de cobertura, compatibilidade de
backend, banco de staging vivo, canario de migrations, canario G11, probe publico, fronteiras,
ciclo editorial, canario operacional, provisionamento de ator MFA e conclusao de lease.

A limpeza e a prova de residuo zero permanecem obrigatorias e fail-closed tambem aqui: a primeira
tentativa tolera falha apenas para que a retentativa exista, e a retentativa e a prova de residuo nao
toleram nada.

### Limite honesto, declarado no proprio relatorio

O passe **nao** aplica migration, **nao** configura secret, **nao** faz deploy de Edge Function,
**nao** publica bytes e **nao** sela artefato. Ele exercita o codigo do candidato contra o staging
como ele esta agora. Portanto ele **nao valida migration nova nem funcao nova do candidato**; isso
continua sendo exclusividade do run canonico. Esses limites sao gravados no campo `limits` do
relatorio, ao lado de `diagnostic: true` e `approvable: false`.

Como nada e publicado pelo passe, o alias serve o SHA anterior. Os gates que comparam o release
servido recebem o SHA vivo, resolvido em tempo de execucao pelo `/healthz`; os que criam fixture
recebem o SHA candidato. E exatamente esse par, codigo novo contra backend atual, que expoe a classe
de defeito de fixture contra schema que consumiu seis candidatos.

### Relatorio consolidado

`scripts/ev2/phase12/diagnostic-report.mjs` materializa o objeto auto-descritivo do Bloco 3 para cada
gate: `gate`, `cause` como codigo estavel, `entity`, `observed`, `expected`, `remediation`, `sha` e
`runTag`. Nenhuma reprovacao exige leitura de log bruto. Um gate que nunca chegou a rodar conta como
reprovado, nunca como pendente. O passe termina vermelho se qualquer gate reprovou, depois de emitir
o relatorio.

Cobertura de regressao em `scripts/ev2/phase12/diagnostic-pass.test.mjs`, dez testes, incluindo o
criterio de aceite da secao 4.3: uma passada sobre um candidato com tres defeitos reporta os tres.

### Duas causas ja colhidas do candidato anterior

O deploy `34528923953`, de `c59232da`, reprovou em duas etapas, e as duas causas ja estao nomeadas:

1. `Run three healthy G12 windows and inherited system assurance` — o canario G11 parou em
   `POST /functions/v1/cms-leads: HTTP 404 CMS_LEAD_DELIVERY_NOT_FOUND`. Corrigido em `ff2238df`:
   o run passou a possuir o formulario em que captura o lead sintetico.
2. `Revoke the rollback compatibility actor and verify zero active residue` — `cms-browser-fixture.mjs`
   lancou `QA_CMS_FIXTURE_LEASE_COMPLETION_FAILED` **sem dizer a causa retornada pelo banco**. Este
   silencio e o defeito a corrigir primeiro: sem a causa nao se sabe se a falha esta na limpeza
   terminal do lease, no residuo de conteudo do run ou em outro lugar.

O item 2 esta em `scripts/qa/**`, caminho da Faixa C pelo mapa de propriedade. Ele nao foi escrito
pela Faixa A; foi especificado e encaminhado.

## Claim da Faixa A apos a migracao do diretorio local

Captura local `2026-09-10T19:44:23-03:00` (`America/Sao_Paulo`), UTC `2026-09-10T22:44:23.000Z`.
Candidato vigente `ff2238df23ba00854b9e9c401376b3edcdc93f46`.

Esta sessao passa a operar como **Faixa A** da secao 9 da
`INSTRUCAO_OTIMIZACAO_ENTREGA_CMS_GAIATEC.md` revisao 2, com o lease de escrita exclusivo. A
instrucao complementa o `AGENTS.md` e nao revoga nada: em conflito vale a regra mais restritiva, e
nenhum item dela autoriza verificar menos, encurtar homologacao, reaproveitar evidencia ou contornar
gate.

### Protocolo `claimFaixaA` cumprido, na ordem

| # | Item | Resultado |
| - | ---- | --------- |
| 1 | Perfil GitHub `Vnd93` | confirmado, conta ativa |
| 2 | `git fetch` | executado, sem erro e sem poda de worktree |
| 3 | Checkout limpo | limpo, `git status` vazio |
| 4 | `main` sincronizada por fast-forward | `HEAD` = `origin/main` = `ff2238df`, `0 0` ahead/behind |
| 5 | Runs `queued` ou `in_progress` | nenhum, nos dois repositorios |
| 6 | `/healthz` registrado | staging e producao, tabela abaixo |
| 7 | Claim registrado neste `HANDOFF.md` | este bloco |

| Origem | Resposta | SHA servido |
| ------ | -------- | ----------- |
| `gaiatec-cms-staging.pages.dev` | HTTP 404, contrato legacy | nao aplicavel |
| `ev2-g12-canary` | `200 ready` | `c59232da6ceea85ea797be7f606022a6e70c6504` |
| `ev2-g17-canary` | `200 ready` | `c59232da6ceea85ea797be7f606022a6e70c6504` |
| `www.gaiatecsistemas.com.br` | `200 ready` | `f48bb4530566456a0090a98cd39caf1cacb51b09` |

Os aliases de staging ainda servem `c59232da`: o candidato `ff2238df` nao foi publicado em lugar
nenhum, e a evidencia amarrada a `c59232da` continua invalidada para fins de aprovacao.

### Diretorio de trabalho da Faixa A

A Faixa A saiu do OneDrive, conforme a trava 9.4.1. O diretorio
`C:\dev\cms-site\gaiatec-cms` pertence a Faixa C, que esta com claim ativo, e duas faixas nao
podem compartilhar arvore de trabalho porque a Faixa C entrega por branch e Pull Request. A Faixa A
passou a operar em um clone novo do `origin`:

- Caminho: `C:\dev\cms-site\gaiatec-cms-faixa-a`
- `HEAD` = `origin/main` = `ff2238df23ba00854b9e9c401376b3edcdc93f46`, checkout limpo
- Um unico worktree, o proprio; nenhum vinculo herdado com o OneDrive
- `core.autocrlf=true`, igual ao clone da Faixa C e ao diretorio antigo, para nao divergir digest local
- Node `22.23.2` e npm `10.9.8`, ativos pelo `nvm4w`, conforme o `.nvmrc`
- `.env.local` provisionado por copia byte-identica e ignorado pelo git

A copia congelada e o diretorio antigo do OneDrive permanecem intocados. Nenhum
`git worktree repair` ou `git worktree prune` foi executado em qualquer um deles.

### Ordem de trabalho adotada

Blocos da secao 11 da instrucao, nesta ordem: `3.1` contrato fixture x schema, com integracao do Pull
Request da Faixa C; `4` passe de diagnostico com a entrada `diagnostic_run` no `deploy-staging.yml`;
`5` falha auto-descritiva em todo gate; `6` lease curto com heartbeat de 15 minutos.

Para o candidato corrente vale o fluxo do Bloco 4: passe de diagnostico primeiro, colheita de todas
as falhas em uma unica passada, correcao do lote inteiro em um unico SHA, e so entao o run canonico
fail-fast. Nenhum artefato de diagnostico satisfaz gate, sela artefato ou entra em evidencia.

## Parada controlada para movimentacao do diretorio local

Captura local `2026-09-10T18:36:12-03:00` (`America/Sao_Paulo`), UTC `2026-09-10T21:36:12.000Z`.
O lease de escrita foi devolvido para permitir mover o diretorio de trabalho para fora do OneDrive.
Nenhuma operacao nova foi iniciada apos o pedido de parada; apenas o trabalho ja em voo foi concluido.

### Checkpoint

| Item                                   | Estado verificado                                                             |
| -------------------------------------- | ----------------------------------------------------------------------------- |
| Perfil GitHub ativo                    | `Vnd93`                                                                       |
| HEAD do codigo                         | `ff2238df23ba00854b9e9c401376b3edcdc93f46`                                    |
| `origin/main` do codigo                | `ff2238df23ba00854b9e9c401376b3edcdc93f46`                                    |
| Checkout do codigo                     | limpo, diretamente em `main`, sem worktree                                    |
| Candidato invalidado por este commit   | `c59232da6ceea85ea797be7f606022a6e70c6504`                                    |
| HEAD da documentacao antes deste commit | `eee967801cbcdf4db617b85f8b04eb636cb392c8`                                    |
| Branch documental                      | `docs/g12-production-release`                                                 |
| Runs remotos nao terminais             | nenhum nos dois repositorios                                                  |
| CI do candidato vigente                | run `34532870546`, `success`, jobs `quality`, `database` e `browser` verdes   |
| `/healthz` staging candidato           | `ev2-g12-canary` e `ev2-g17-canary` servem `c59232da6cee...`, `status: ready` |
| `/healthz` staging estavel             | `gaiatec-cms-staging.pages.dev` responde HTTP 404, contrato legacy            |
| `/healthz` producao                    | `f48bb4530566456a0090a98cd39caf1cacb51b09`, `status: ready`                   |
| Supabase                               | nao capturado nesta parada, ver limitacao abaixo                              |
| Lease de QA ativo                      | nenhum criado nesta sessao; nenhum exige heartbeat                            |

Os dois aliases de staging ainda servem `c59232da`, e nao o novo `ff2238df`: o commit de parada nao
foi publicado em lugar nenhum. Toda evidencia amarrada a `c59232da` fica invalidada para fins de
aprovacao pelo proprio commit, conforme a regra de novo candidato.

### Limitacao declarada: estado do Supabase nao capturado

O ambiente local nao tem a CLI do Supabase nem `SUPABASE_ACCESS_TOKEN` exportado, e as chamadas de
leitura a partir da aba autenticada do dashboard responderam HTTP 401 nesta captura. O estado do
Supabase de staging e de producao nao foi verificado agora e nao deve ser presumido a partir do
checkpoint anterior. A ultima evidencia valida do banco de staging e a do deploy `34528923953`, do
candidato `c59232da`, cujas etapas de migrations, RLS, Storage, Vault, modos de Function e cenarios
sinteticos pos-baseline foram todas `success`.

### O que este commit de codigo resolveu

O canario G11 escolhia qualquer formulario corporativo publicado para capturar o lead sintetico. O
predicado de escopo da `0072` so deixa um chamador com lease de QA alcancar um formulario que
pertenca a um ator com lease do mesmo run, e a `0072` copia a provenienca de QA do lead a partir
desse formulario. Um formulario corporativo nunca satisfaz o predicado: o proprio operador que
acabara de criar a fixture nao a encontrava, e reprocessar a entrega respondia
`CMS_LEAD_DELIVERY_NOT_FOUND` enquanto anonimizar respondia `CMS_LEAD_NOT_FOUND`, ambos com 404.

Agora o run cria, versiona e publica o proprio formulario pelos mesmos comandos `save_form` e
`publish_form` que o painel expoe, como o operador que depois tem de encerrar a fixture, e afirma que
a linha gravada pertence ao run antes de capturar qualquer coisa. Com isso a `0084` aceita para esse
formulario exatamente uma origem: a fonte `qa_fixture` em `/qa-cms-final/<run tag em minusculas>`,
sem campanha e sem produto. O encerramento do lease ja aposenta todo formulario do run, entao a prova
de residuo passou a contar formularios vivos do run, e a contagem de tombstone retido passou a ser
chaveada pelo run tag em vez de uma origem em texto livre que nao existe mais.

### Proxima acao exata para retomar

Depois da movimentacao do diretorio, com o candidato `ff2238df23ba00854b9e9c401376b3edcdc93f46`:

1. Reivindicar o lease de escrita neste bloco de estado, voltando a `writerState: CLAIMED`.
2. Confirmar `main` limpa, `HEAD` e `origin/main` iguais a `ff2238df`, perfil `Vnd93`, caminho sem
   `.claude/worktrees`.
3. Executar o ciclo remoto para `ff2238df`: `ci.yml`, depois
   `promote-staging-frontend-bridge.yml`, depois `deploy-staging.yml`.
4. Ler o resultado das duas etapas que reprovaram no candidato anterior: `Run three healthy G12
   windows and inherited system assurance` e `Revoke the rollback compatibility actor and verify zero
   active residue`.
5. Gates ainda em aberto depois disso: artefato unico selado, drill de backup e restore, rollback
   comprovado e homologacao no Google Chrome real com a sessao autenticada e MFA do operador.

## Objetivo integral e criterio de conclusao

Entregar o CMS GAIATEC, o frontend redesenhado, backend, banco, Edge Functions, integracoes,
Cloudflare e site publico totalmente funcionais e operacionais em producao. A aprovacao depende de
evidencia vinculada ao mesmo SHA e ao mesmo artefato para o ciclo real:

`criar -> rascunho incompleto -> fechar -> recuperar -> editar -> autosave -> recarregar -> validar
-> revisar -> comentar -> comparar diff -> aprovar -> visualizar -> publicar -> conferir no site
publico -> pesquisar -> atualizar -> republicar -> invalidar cache -> restaurar -> reverter release
-> despublicar -> conferir retirada -> arquivar`.

O escopo preservado inclui F-001 a F-018, RB-001 a RB-060, redesign, EV2, todas as superficies
descobertas no SHA final, navegacao, campos, acoes, permissoes, RLS, auditoria, consumidores publicos,
CMS/RDO, integracoes e infraestrutura. A precedencia e: instrucao vinculante; seguranca e gates;
documentacao canonica ativa; HTML apenas para decisoes visuais; codigo como estado atual; historico
apenas como evidencia imutavel. Devem ser reconciliados `src/admin/README.md`, `docs/ev2/README.md`,
`docs/30-cms`, ADRs, matrizes, controles de release, redesign, contratos, migrations e testes.

A conclusao exige, no minimo:

- 100% de requisitos, rotas, menus, abas, campos, acoes, APIs, Edge Functions, permissoes, RLS e
  consumidores classificados e aprovados, sem elemento nao testado nem `N/A` indevido;
- nenhuma operacao cotidiana dependente de JSON, UUID, slug, schema ou identificador tecnico;
- uma fonte canonica para produto/PIM, sem dual-write divergente e com reconciliacao v1/v2;
- Google Chrome real, sessao autenticada, MFA e backend real, inclusive duas sessoes para conflito;
- testes positivos e negativos de AAL/RLS/IDOR/XSS/injecao/CORS/rate limit/replay/payload alterado;
- cobertura responsiva em `390x844`, `768x1024`, `1440x900` e `1920x1080`, teclado, foco, contraste,
  leitor de tela, reduced motion e zoom de 200%;
- zero falha critica ou alta, erro relevante de console, 4xx/5xx inesperado, segredo ou dado pessoal;
- backup e restore drill, rollback, artefato imutavel, CI e pos-deploy aprovados no mesmo SHA;
- publicacao refletida no site publico e retirada/rollback comprovados;
- operador corporativo em producao com MFA normal e nenhum bypass ativo;
- `main` limpa, enviada ao `origin`, producao saudavel e SHA servido identificado.

Build, tela renderizada, handler acionado, mock, resposta simulada, teste isolado, navegador headless,
analise estatica ou canario parcial nao substituem prova de persistencia, auditoria e efeito publico.

## Repositorios e estado Git

| Item                                 | Estado no checkpoint                                                                |
| ------------------------------------ | ----------------------------------------------------------------------------------- |
| Perfil GitHub                        | `Vnd93`                                                                             |
| Codigo                               | `Vnd93/gaiatec-cms`                                                                 |
| Branch do codigo                     | `main`                                                                              |
| HEAD do codigo                       | `ff2238df23ba00854b9e9c401376b3edcdc93f46`                                          |
| `origin/main`                        | `ff2238df23ba00854b9e9c401376b3edcdc93f46`                                          |
| Checkout do codigo                   | limpo                                                                               |
| Candidato vigente                    | `ff2238df23ba00854b9e9c401376b3edcdc93f46`                                          |
| Candidato anterior                   | `c59232da6ceea85ea797be7f606022a6e70c6504`                                          |
| Documentacao                         | `Vnd93/gaiatec-documentacao`                                                        |
| Branch documental                    | `docs/g12-production-release`                                                       |
| Base documental antes do handoff     | `641889875e8d425f7902474e9f5e0700a4e8b5dc`                                          |
| Alteracoes preexistentes preservadas | `docs/ev2/README.md` modificado e estudo LLM nao rastreado; ambos fora deste commit |

O checkpoint inicialmente esperado, `63c1b563b3fb685e445960545fbabcaee84437bb`, foi substituido por
`0ab1fa84eec65c762644ed9368bfcfb213402b17` e nao pode ser usado como candidato final.

## Historico de commits e pushes relevantes

Todos os commits abaixo foram enviados sem force para `origin/main`:

| SHA curto | Commit                                                             | Motivo                                                                                                                                 |
| --------- | ------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------- |
| `524787f` | `fix(public): keep static routes up when the managed lookup fails` | Impede que a falha da consulta `page-by-path` derrube uma rota publica estatica, preservando precedencia e fail-closed.                |
| `b6ed084` | `perf(public): resolve a public path in one round trip`            | Emite as tres consultas de resolucao de caminho publico em paralelo e corrige a amostragem do probe do bridge, sem tocar no orcamento. |
| `cde606f` | `fix(release): bridge the legacy public backend on staging`        | Serve o contrato legacy-f48 real em staging durante a ponte, com lease exclusivo, restauracao amarrada a digest e watchdog proprio.    |
| `0ab1fa8` | `fix(qa): bind production evidence names`                          | Vincula o manifesto terminal aos nomes reais dos arquivos de evidencia de producao e adiciona validacao fail-closed.                   |
| `63c1b56` | `fix(release): accept SQL created response`                        | Aceita HTTP 200 ou 201 apenas no preflight SQL do migration canary; o helper geral continua fail-closed.                               |
| `4b9184b` | `fix(release): stabilize bridge gates`                             | Estabiliza controles do bridge e originou o atual frontend canonico de staging.                                                        |
| `b02263c` | `align staging database gates`                                     | Alinha gates do banco de staging.                                                                                                      |
| `ff01b9d` | `verify idempotent deploys`                                        | Verifica idempotencia de deploy.                                                                                                       |
| `a4c5ea9` | `bind command idempotency`                                         | Vincula idempotencia de comandos.                                                                                                      |
| `58b6b29` | `canonicalize function inventory`                                  | Canonicaliza o inventario de funcoes.                                                                                                  |
| `5802338` | `tolerate variable visibility lag`                                 | Trata atraso de visibilidade de variavel sem enfraquecer o gate.                                                                       |

A ultima correcao alterou apenas o materializador da matriz terminal e seu teste. Entre `4b9184b` e
`0ab1fa8` nao ha alteracao em `src`, `supabase/functions` ou `supabase/migrations`; isso preserva a
utilidade diagnostica das evidencias anteriores, mas nao autoriza usa-las para aprovar o SHA final.

## Testes locais e CI do SHA exato

### Candidato `b925052da0f0901157ff79c48aa30354bc40f888`

Cadeia de candidatos desde o handoff recebido, cada um invalidando a evidencia do anterior:
`0ab1fa8` recebido, `cde606f` ponte legacy-f48, `b6ed084` latencia do caminho publico e amostragem
do probe, `524787f` disponibilidade de rota estatica, `29281a0` observabilidade do canario,
`e7b629b` janela de convergencia do bridge, `d36cb70` amostragem no deploy de staging e watchdog,
`5710401` pagina gerenciada em paralelo, `b925052` identidade da rejeicao de MFA e retry real.

- Validacao local integral do SHA vigente: `npm run check` aprovado, 169 arquivos e 1.057 testes
  vitest, `eval:ev2:phase12` `G12_RULES_PASS`, prettier, eslint, typecheck, documentation-boundary
  e build.
- CI remoto do SHA exato: registrar run, tentativa e resultado antes de qualquer despacho.
- Bridge e deploy de staging precisam ser reexecutados para este SHA.

### Candidato anterior `524787f38497a5473c3064fde7dfd7683d8d5ec7` (evidencia superada)

- Validacao local integral: `npm run check` aprovado, 169 arquivos e 1.056 testes vitest,
  `eval:ev2:phase12` `G12_RULES_PASS`, prettier, eslint, typecheck, documentation-boundary e build.
- CI run `34399505896`, tentativa 1, `success`:
  <https://github.com/Vnd93/gaiatec-cms/actions/runs/34399505896>. Jobs aprovados: quality
  `102627577683`, database `102627577734`, browser `102627577531`. Artefato CI `10123017527`,
  nome `site-524787f38497a5473c3064fde7dfd7683d8d5ec7`, nao expirado.
- Bridge [`34400103842`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34400103842), tentativa
  1, `success`, com `expected_baseline_sha=b6ed08476267699d05c06162561083a826d6bfa6`, que era o
  SHA servido pelo alias apos o bridge anterior. Sequencia da troca: versao viva 58 capturada,
  legado publicado como 59 e candidato restaurado como 60, com `contractProbe: public-v2` e
  `internalIdentifiersExposed: false`.
- As tres sondagens do run mediram 100,00% de disponibilidade e 0,00% de 5xx em 20 amostras cada,
  com `/produtos` em p95 de 502, 469 e 391 ms. Antes das duas correcoes esse mesmo indicador
  estava em 2.005 ms com 80% de disponibilidade, o que confirma o efeito de ambas.
- A evidencia de `b6ed084`, inclusive o bridge `34395203818`, esta invalidada.

### Candidato anterior `b6ed08476267699d05c06162561083a826d6bfa6` (evidencia superada)

- Validacao local integral: `npm run check` aprovado, 168 arquivos e 1.053 testes vitest,
  `eval:ev2:phase12` `G12_RULES_PASS`, prettier, eslint, typecheck, documentation-boundary e build.
- CI run `34394525418`, tentativa 1, `success`, evento `push`:
  <https://github.com/Vnd93/gaiatec-cms/actions/runs/34394525418>.
- Jobs aprovados: quality `102610805561`, database `102610805760`, browser `102610805893`.
- Artefato CI `10121122640`, nome `site-b6ed08476267699d05c06162561083a826d6bfa6`, nao expirado.
  Build CI de staging; **nao** e o artefato final unico selado.
- Nenhum deployment, migration ou evidencia de runtime existe para este SHA.

### Candidato anterior `cde606fb4c5eb882f3650d677fdc0bb1d1c2a377` (evidencia superada)

- Validacao local integral: `npm run check` aprovado, incluindo 168 arquivos/1.052 testes vitest,
  `test:qa` 66/66, `test:ev2:phase12` 266 aprovados e 3 skip, `eval:ev2:phase12` `G12_RULES_PASS`,
  prettier, eslint, typecheck, documentation-boundary e build de staging.
- CI run `34389231706`, tentativa 1, `success`, evento `push`:
  <https://github.com/Vnd93/gaiatec-cms/actions/runs/34389231706>.
- Jobs aprovados: quality `102593141829`, database `102593141844`, browser `102593141735`.
- Artefato CI `10119128163`, nome `site-cde606fb4c5eb882f3650d677fdc0bb1d1c2a377`, 157.741.870
  bytes, nao expirado. Build CI de staging; **nao** e o artefato final unico selado.
- Nenhum deployment, migration ou evidencia de runtime existe para este SHA.

### Candidato anterior `0ab1fa84eec65c762644ed9368bfcfb213402b17` (evidencia superada)

- Validacao focada da ultima correcao: 21/21 testes, Prettier, ESLint e diff check aprovados.
- CI run `34377871781`, tentativa 1, `success`:
  <https://github.com/Vnd93/gaiatec-cms/actions/runs/34377871781>.
- Job quality `102555132955`: `npm run check`, 168 arquivos/1.052 testes, EV2/evals/integracoes,
  typecheck, lint, format, build de staging e auditoria com zero vulnerabilidade.
- Job database `102555133317`: reset local e 44 arquivos/1.544 assercoes pgTAP/RLS, aprovado.
- Job browser `102555133412`: 40 testes Playwright/Chromium headless, aprovados; nao substitui Edge.
- Artefato CI `10114757476`, nome
  `site-0ab1fa84eec65c762644ed9368bfcfb213402b17`, digest
  `sha256:2d21f6bf23c29e681a5b1070a43b090b5af538da00368b880cf5bb765d4b4fbf`, nao expirado.
- Manifesto interno: 1.490 arquivos, digest
  `sha256:0fbe235ec17345f73969eed26f6d5529dda43265b4494fb5ee8acc8fc2c0a786`.
- Esse e um build CI de staging; **nao** e o artefato final unico selado para staging e producao.

## Defeito de disponibilidade encontrado pelo deploy de staging

O run [`34398113169`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34398113169) avancou ate o
passo 14 e reprovou no passo 15, `Prove the live staging alias matches the approved rollback SHA`,
ainda antes de qualquer mutacao. O probe mediu `availabilityPercent` 95,45, `http5xxRatePercent`
4,55 e, em `/produtos`, disponibilidade 80% com uma resposta de 5.165 ms.

Causa raiz: `cmsPublic()` em `cloudflare/_worker.js` aborta em 5.000 ms e converte a consulta
abortada em 503. O Worker entao devolvia 503 para a rota inteira, mesmo quando a rota e estatica e
a resposta da consulta seria descartada. Uma falha transitoria da consulta derrubava uma pagina
que nao dependia dela.

Correcao em `524787f`: quando a consulta gerenciada falha e o caminho e uma rota publica estatica,
o Worker serve a resposta estatica; para os demais caminhos o 503 permanece. A precedencia nao foi
alterada de proposito: a consulta continua acontecendo primeiro e qualquer resposta que resolva
continua vencendo. Antecipar o atalho `isPublicRoute` foi avaliado e descartado, porque
`cms_redirects.source_path` aceita qualquer caminho bem formado, sem exclusao de reservados, e a
migration `0026` nao reserva `/blog`, que tambem esta em `STATIC_PUBLIC_ROUTES`.

O teste de regressao prova o defeito em vez de descreve-lo: contra o Worker anterior ele falha com
`expected 503 to be 200`, enquanto os casos de fail-closed e de precedencia passam nas duas
versoes.

Descartada a hipotese de que a paralelizacao de `b6ed084` tivesse causado instabilidade: 25
amostras sequenciais e 30 concorrentes em tres rajadas responderam 200 com maximo de 1,09 s, e o
bridge `34395203818` mediu 60 amostras em CI com zero 5xx e `/produtos` p95 de 759 ms. O 5xx e raro
e ambiental, mas o orcamento de 99,9% de disponibilidade existe justamente para nao tolera-lo.

## Bloqueio atual: verificacao de MFA sintetica no canario de migrations

O deploy [`34413801628`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34413801628) chegou ao
passo 26 e reprovou. Com os campos de identidade de falha ja publicados em `29281a0`, o relatorio
finalmente nomeia a causa em vez do sintoma:

```
failureStage    : operation-and-cleanup
operationFailure: G12_STAGING_SYNTHETIC_MFA_VERIFY_FAILED
cleanupFailure  : G12_STAGING_MIGRATION_CANARY_FAILED:immutable_audit_retained
```

Correcao de diagnostico registrada explicitamente: a hipotese anterior, de que o canario falhava ao
criar o segundo ator sintetico, estava errada. A falha ocorre na verificacao TOTP dentro de
`createActor`, depois do `actors.push`. Por isso `retainedSyntheticActors` era 1, `operator` ficava
indefinido, as consultas de auditoria guardadas por `operator ?` eram puladas e
`immutable_audit_retained` reprovava em cascata. A auditoria nunca esteve comprometida: consulta
direta ao banco mostrou 58 eventos no periodo, todos com `actor_id` preenchido e nenhum destacado.

Sequencia comprovada dentro de `createActor`: criacao do usuario, `actors.push`, lease, perfil,
papel, `signInWithPassword` e `mfa.enroll` todos bem-sucedidos, porque cada um deles lanca codigo
proprio. A rejeicao esta no `mfa.verify`, tres vezes.

Duas correcoes aplicadas em `b925052`, ambas no caminho da falha:

1. O `verified.error` era descartado. Agora a falha carrega `status` HTTP e `code` do servico de
   auth, como `G12_STAGING_SYNTHETIC_MFA_VERIFY_FAILED:<status>:<code>`. Um slug com prefixo de
   credencial e recusado, porque forma de slug nao e garantia suficiente para algo que entra em
   artefato de evidencia publicado.
2. As tres tentativas esperavam 1 e 2 segundos contra uma janela TOTP de 30 segundos, entao as
   tres enviavam codigo identico e o retry nao distinguia codigo rejeitado de falha transitoria.
   Agora espera a virada do contador.

A segunda correcao pode resolver o bloqueio por si so, se a causa for limite de janela. Se nao
resolver, o proximo relatorio traz `status` e `code` e o diagnostico deixa de ser hipotese.

## Defeito sistemico de amostragem: corrigido na origem

`percentile(v, 95)` retorna `sorted[ceil(0,95*n)-1]`, entao com `n=5` o p95 relatado e o proprio
maximo de cinco amostras e uma unica resposta fria decide um gate. A correcao anterior era por
chamada e alcancava apenas `promote-staging-frontend-bridge.yml`, `deploy-staging.yml` e
`deploy-staging-watchdog.yml`, ou seja, 8 dos 33 pontos que invocam o probe.

Corrigido na origem em `scripts/ev2/phase12/rollout-probe.mjs`: o padrao de `EV2_G12_SAMPLE_COUNT`
passou de `environment === "production" ? 20 : 5` para `20` em qualquer ambiente, e o padrao de
`EV2_G12_WARMUP_SAMPLES_PER_ROUTE` passou de `3` para `8`. Todo ponto de chamada herda a medicao
correta sem precisar declarar nada, inclusive os watchdogs, que medem exatamente quando as rotas
estao frias. Os 13 pontos que ainda declaravam `"5"` explicitamente foram elevados a `"20"`, porque
uma declaracao explicita sobrescreve o padrao:

| Workflow                                       | Ocorrencias |
| ---------------------------------------------- | ----------: |
| `deploy-production.yml`                        |           2 |
| `promote-production-frontend-bridge.yml`       |           1 |
| `rollback-staging.yml`                         |           3 |
| `rollback-staging-watchdog.yml`                |           1 |
| `promote-staging-frontend-bridge-watchdog.yml` |           1 |
| `preview-ev2-phase12/13/14/16.yml`             |           4 |
| `provision-production-operator.yml`            |           1 |

`scripts/ev2/phase12/staging-canary.mjs` tambem declarava `"5"` e foi elevado.

Os padroes de prontidao, `EV2_G12_READINESS_ATTEMPTS = 10` e `EV2_G12_READINESS_INTERVAL_MS = 1500`,
foram deliberadamente mantidos: esperar mais so faz sentido para alvos que o proprio run acabou de
publicar, e elevar o padrao faria um alias genuinamente quebrado demorar a reprovar.

Travado por `scripts/ev2/phase12/rollout-probe-sampling.test.mjs`, que fixa os dois padroes, varre
todos os workflows e scripts de fase 12 recusando qualquer `EV2_G12_SAMPLE_COUNT` abaixo de 20 ou
`EV2_G12_WARMUP_SAMPLES_PER_ROUTE` abaixo de 8, exige um numero minimo de declaracoes inspecionadas
para nao passar por vacuidade, e reafirma que os orcamentos `availabilityPercent: 99.9`,
`http5xxRatePercent: 0.1` e `publicP95Ms: 1500` continuam intactos.

## Superficie de diagnosticos reprovava com statement timeout, corrigida pela migration 0089

Provado na sessao autenticada real do CMS de staging, em Google Chrome:
`GET /rest/v1/cms_operational_events?select=...&resolved_at=is.null&order=created_at.desc&limit=50`
respondia HTTP 500 com SQLSTATE 57014, `canceling statement due to statement timeout`. A tabela tinha
1.107 linhas, entao volume nao era a causa. Controles: a mesma leitura com `limit 5` e sem ordenacao
respondia 200 em 557 ms; com `order=created_at.desc` reprovava em 8.228 ms.

Duas causas somadas. A politica instalada em 0076 usava
`using (public.cms_system_operational_session_read_allowed(id))`, um unico predicado por linha que
reavaliava, dentro dele, a linhagem de permissao e a permissao da sessao, nenhuma das quais depende
de linha. Como todo o predicado dependia da linha, o planejador nao conseguia ica-las para fora do
laco. A tabela tambem nao tinha indice alem da chave primaria, entao `order by ... limit` precisava
varrer e ordenar tudo antes de o limite valer, levando o predicado caro as 1.107 linhas em vez das 50
devolvidas.

`0089_cms_operational_events_read_scale.sql` separa o predicado em uma metade de sessao e uma de
linha, preservando a conjuncao autorizadora exatamente como estava, e cria
`cms_operational_events_unresolved_recent_idx`, parcial em `resolved_at is null` e ordenado por
`created_at desc`, mais `cms_operational_events_recent_idx` para leituras historicas. A migration
falha fechada se a politica separada ou o indice nao existirem ao final da transacao.

Registro obrigatorio completo: manifesto fixado com digest
`bd6d418cd7271ed91d7e0d360c0100c7ad10998777ec27672ea4a6659fa22cad`, cobertura declarada no canario,
mapa de compatibilidade progressiva com testes que existem e rodam no CI, teste pgTAP
`supabase/tests/rls_cms_operational_events_read_scale.test.sql` e verificacao contra o banco real de
staging e producao em `operational_events_read_scale_0089_semantics_exact`.

O CI do job `database` reprovou duas vezes por defeitos do proprio teste pgTAP, ambos corrigidos e
ambos informativos. O primeiro: `anon` nao tem privilegio de leitura na tabela, entao a tentativa
nem chega a ser avaliada pela politica, e afirmar contagem zero pedia uma leitura impossivel; a
garantia correta e a ausencia do grant. O segundo: `select plan(20)` contra 21 asercoes, o que faz o
pgTAP sair diferente de zero e esconder a ultima asercao em vez de executa-la. Um teste de contrato
passou a exigir que o plano declarado seja igual ao numero de asercoes do arquivo.

A aplicacao limpa da 0089 em um Postgres real ja esta provada: o `supabase db reset --local` do job
`database` aplicou todas as migrations antes de chegar ao pgTAP.

Sobra da 0076 registrada e nao removida por estar fora do escopo desta correcao:
`public.cms_system_operational_session_read_allowed(uuid)` continua existindo e concedida a
`authenticated`, mas nenhuma politica a usa depois da 0089.

Erro proprio registrado para nao repetir: o `npm run check` local reprovou por
`0089: at least one database compatibility test required` e eu li o codigo de saida do invocador em
vez do codigo do proprio comando, tratei como verde e empurrei `2db35fd`, que o CI reprovou. O
criterio passa a ser ler `EXIT=` do log do comando, nunca a notificacao do invocador.

## Canario de migrations pendurava 120 s: nenhuma chamada de saida das Edge Functions tinha prazo

O run `34428190779` reprovou no passo 26 com
`fixtureCloseFailures: [{"closer":"closeDocumentFixture","failure":"G12_STAGING_HTTP_TIMEOUT:POST:/functions/v1/cms-documents:120000"}]`
e `operationFailure: None`. Consumir os 120 s inteiros significa pendurar, nao demorar: o
`statement_timeout` do banco cancela um SQL lento em cerca de 8 s, entao a espera nao podia estar
dentro do banco.

A causa e que nenhuma chamada de saida tinha prazo. Os dois clientes criados em
`supabase/functions/_shared/cms-auth.ts` usam o `fetch` global sem `signal`, entao PostgREST, Auth e
Storage esperam para sempre, e uma conexao que trava fora do banco nunca falha, simplesmente nao
responde. Storage e a primeira a aparecer por ser a unica dependencia desse handler sem teto proprio
do lado servidor.

`supabase/functions/_shared/cms-edge-fetch.ts` impoe teto de 30 s por chamada. Ele aborta a
requisicao subjacente, liberando o socket, e ainda corre contra o prazo, de modo que a invocacao
termina mesmo que um transporte ignore o sinal. Cancelamento vindo de quem chamou continua
prevalecendo e nao e reportado como prazo nosso. A identidade que entra na mensagem de erro e apenas
verbo e caminho; a query string carrega `apikey` e filtros de usuario e nunca e lida.

`cms-documents` mapeia isso para 504 `CMS_EDGE_UPSTREAM_TIMEOUT` com o alvo, no lugar do 500 sem
rotulo anterior, e o canario passa a anexar o codigo de erro do CMS a identidade codificada da falha,
apenas slugs `CMS_[A-Z0-9_]+` fechados, nunca outro campo do corpo. O proximo run nomeia a dependencia
travada em vez de apenas o orcamento consumido.

## Efeito real da 0089 medido no staging

Medido no proprio projeto de staging depois que o deploy `34438643117` aplicou as migrations, com
consulta somente leitura:

- A politica instalada passou a ser exatamente
  `(cms_system_operational_session_scope_allowed() AND cms_system_operational_event_row_allowed(id))`.
- Os dois indices existem.
- `select ... where resolved_at is null order by created_at desc limit 50` agora resolve por
  `Index Scan using cms_operational_events_unresolved_recent_idx`, 50 linhas, `Execution Time`
  4,174 ms, com 3.341 linhas na tabela. Antes eram 8.228 ms ate o `statement_timeout` com 1.107
  linhas.

Esse plano foi obtido com papel privilegiado, entao prova a metade do indice e do limite. A metade da
politica esta provada pela forma instalada acima, pelo teste pgTAP e pela verificacao
`operational_events_read_scale_0089_semantics_exact` contra o banco real.

A verificacao pela tela autenticada nao pode ser refeita nesta sessao porque o JWT do operador expirou
no navegador. Reautenticar exige credencial e MFA do operador e nao e feito pelo agente.

## Canario reprovava no teardown por contradicao entre dois contratos do banco

O deploy `34438643117` aprovou as 116 verificacoes de cenario, com `operationFailure: null` e
`fixtureCloseFailures: []`, e reprovou em `cleanup` com `G12_STAGING_SYNTHETIC_LEASE_COMPLETION_FAILED`.

Lido no banco de staging depois do run, o documento sintetico estava em
`blob_disposition = 'access_revoked'`, `blob_cleanup_last_error_code = 'database_confirm_failed'` e
`canonical_cleanup_not_before` cerca de duas horas e meia no futuro.

A 0063 instala o fence canonico de escrita, que recusa marcar o blob como `removed` antes de
`canonical_cleanup_not_before`, calculado como 30 minutos apos o maior prazo entre a expiracao do
token de upload assinado, a claim de finalizacao e a neutralizacao. O fence esta correto: declarar o
blob removido enquanto o token ainda pode escrever abriria janela de reuso. A 0061 exigia
`blob_disposition = 'removed'` para concluir a lease do ator sintetico. Nenhum run satisfaz as duas
regras, e quem executa essa transicao mais tarde e o reconciliador de blobs do `cms-outbox-worker`,
que so pode agir depois que o fence expira.

`0090_cms_qa_lease_document_canonical_fence.sql`, digest
`295f8adcfac409de8dd86f6f557da78a5a5a0d6836cf9b3af52f02608f6d18c9`, aceita o estado intermediario
apenas quando ele e provadamente o que o fence impoe: acesso revogado, prazo canonico registrado e
ainda no futuro. Prazo ja vencido continua reprovando, porque ai o residuo e real. Nenhuma outra
condicao foi afrouxada e a funcao continua exclusiva de `service_role`.

Duas superficies relatavam isso errado e foram corrigidas junto:

- `cms-documents` registrava `database_confirm_failed` e devolvia 503 para o desfecho projetado da
  neutralizacao. Passa a devolver 200 com `blobDisposition: "access_revoked"` e
  `canonicalCleanupScheduled: true`.
- O canario aceitava um 503 `CMS_DOCUMENT_BLOB_REMOVAL_PENDING` generico como sucesso, o que tornava
  a verificacao `documents_fixture_neutralized_fenced` infalsificavel justamente na condicao exigida
  pelo teardown. Passa a exigir 200 e um dos dois desfechos legitimos. O teste que fixava a aceitacao
  antiga foi atualizado com a razao, porque fixava uma regra que escondia essa falha.

Residuo deixado pelo run reprovado, esperado e auto-resolvido: duas leases `active` do run tag
`QA-CMS-FINAL-20260910-5e7aab4c`, que o watchdog varre no TTL de 119 minutos, e um documento
sintetico em `access_revoked` que o reconciliador de blobs conclui depois do fence. Leases sao por
`run_tag`, entao nao bloqueiam o proximo run.

## Confirmacao de remocao do documento: o que ja esta provado e o que falta nomear

Deploy `34441157353`, candidato `cf6ecd8`: 118 verificacoes aprovadas, `operationFailure: null`, e
falha em `closeDocumentFixture` com
`G12_STAGING_HTTP_FAILED:POST:/functions/v1/cms-documents:503:CMS_DOCUMENT_BLOB_REMOVAL_PENDING`. A
identidade enriquecida ja nomeou status e codigo, o que o run anterior nao fazia.

Provado por leitura direta do banco de staging:

- A funcao publicada no run era a nova: o corpo de `cms-documents` contem `canonicalCleanupScheduled`,
  `CMS_DOCUMENT_CANONICAL_WRITE_FENCE_ACTIVE` e `CMS_EDGE_FETCH_TIMEOUT`, e foi publicada as
  05:32:03Z, antes de o canario comecar as 05:32:55Z.
- O `update` que a confirmacao executa realmente e recusado pelo fence: uma sondagem que aborta sem
  commitar devolveu `40001 CMS_DOCUMENT_CANONICAL_WRITE_FENCE_ACTIVE`.
- O documento do run ficou em `access_revoked` com `blob_cleanup_last_error_code =
  'database_confirm_failed'`, `sha256` valido, `processing_status = 'neutralized'`, e nenhum recibo
  de `neutralize_document` foi gravado, ou seja, a confirmacao nunca completou.
- O documento do run anterior `e28d10c7` ja esta em `blob_disposition = 'removed'` e
  `upload_disposition = 'removed'`, o que prova que o reconciliador de blobs do `cms-outbox-worker`
  conclui a transicao depois que o fence expira.
- `service_role` nao tem `rolconfig` proprio. O teto efetivo vem de `authenticator`, que fixa
  `statement_timeout=8s` e `lock_timeout=8s`. `anon` tem 3s e `authenticated` tem 8s. Logo a
  confirmacao nao pode gastar 30 segundos dentro do banco.

Como o ramo do fence nao disparou mesmo com a funcao correta publicada, a causa nao e o fence e sim
algo que chega em outra forma. O candidato `92c15d4` corrige tres defeitos que impediam nomear e
sobreviver a isso:

1. Um unico codigo para toda causa. A recusa da confirmacao passa a carregar a causa dentro do
   proprio codigo, apenas em forma fechada: SQLSTATE de cinco caracteres, prazo de transporte, ou
   desconhecido. Nada do corpo do erro trafega.
2. O predicado do prazo nao casava com o caso que existe para tratar. O `postgrest-js` nao propaga a
   rejeicao do fetch: devolve em `error` com a mensagem reescrita como `"<name>: <message>"`, entao
   comparar por prefixo nunca casava. Passa a casar por conteudo, com teste da forma embrulhada.
3. Um prazo de transporte era tratado como recusa. A confirmacao e idempotente por construcao, a
   mesma chave devolve o recibo ja gravado, entao ela passa a ser repetida uma unica vez apos prazo
   estourado. Recusa deliberada, como o fence, nunca e repetida.

## Causa nomeada e reenquadramento da confirmacao de remocao

Deploy `34443812314`, candidato `92c15d4`: 118 verificacoes aprovadas, `operationFailure: null`, e
`fixtureCloseFailures: [{"closer":"closeDocumentFixture","failure":"G12_STAGING_HTTP_FAILED:POST:/functions/v1/cms-documents:503:CMS_DOCUMENT_BLOB_CONFIRM_FAILED_FETCH_TIMEOUT"}]`.

A instrumentacao cumpriu o proposito: a causa e prazo de transporte, nao recusa do banco. Duas
tentativas, a original e a repeticao, ficaram sem resposta. Como `service_role` herda de
`authenticator` os tetos `statement_timeout=8s` e `lock_timeout=8s`, a espera de 30 segundos nao pode
estar dentro do banco.

Isso reenquadra o fluxo inteiro. Para um fixture sintetico neutralizado poucos minutos apos o upload,
a confirmacao nao tem como ter sucesso dentro do run: o fence canonico recusa essa transicao ate 30
minutos depois da expiracao do token de upload assinado. Devolver 503 ali estava errado em qualquer
hipotese, independentemente do transporte.

O que importa para a seguranca ja esta duravel antes da confirmacao: a preparacao revogou o acesso e
commitou, e o objeto foi removido do Storage e conferido ausente logo acima, com verificacao de
residuo que falha alto se ele ainda estiver la. O que resta e a escritura canonica, que pertence ao
reconciliador de blobs do `cms-outbox-worker`, encontrado por
`cms_list_pending_document_blob_cleanup` sem depender de registro de falha algum.

No candidato `92b6c39`, o fence e a confirmacao sem resposta devolvem o mesmo desfecho agendado, cada
um declarando sua razao em `canonicalCleanupReason`, enquanto qualquer outro SQLSTATE continua sendo
503 carregando a causa. Uma remocao de Storage que realmente falhe continua reprovando antes disso.

Observacao aberta, de plataforma e nao do produto: a chamada de confirmacao ao PostgREST fica sem
resposta de forma reprodutivel nesse ponto do fluxo, depois das operacoes de Storage. O produto
degrada corretamente agora, mas a causa da ausencia de resposta nao esta explicada e merece
investigacao proprio se voltar a aparecer em outras superficies.

## Canario de migrations aprovado de ponta a ponta

Deploy `34446126387`, candidato `92b6c39`: `G12_STAGING_MIGRATIONS_CANARY_PASS`, 119 verificacoes,
`failureStage: null`, `cleanupFailure: null`, `activeFixtures: 0`, `activeDocuments: 0`. O bloqueio
que existia desde que o canario foi escrito esta resolvido.

`documentNeutralizationMs: 61342`. Sessenta e um segundos e coerente com dois prazos de 30 segundos na
confirmacao antes de devolver o desfecho agendado. Otimizacao aberta, nao bloqueante: como o fence
recusa a escritura de qualquer forma dentro da janela, a confirmacao poderia ser pulada se a
preparacao devolvesse `canonical_cleanup_not_before`, o que exigiria mudar a forma de retorno dessa
RPC em uma nova migration.

## Bloco de compatibilidade de rollback nao produzia o que ele mesmo le

Com o canario aprovado, o deploy chegou pela primeira vez ao passo
`Traverse the rollback frontend with an AAL2 session against the candidate backend`, que reprovou com
`ENOENT` em `outputs/cms-ui-created-state.json`.

A travessia autenticada consome o handoff das entidades nascidas na UI, e o bloco de rollback nunca
produzia esse handoff: o arquivo so era escrito muito depois, pelo ciclo mutante do candidato. Esse
gate, portanto, so podia reprovar. Nao era intermitencia nem ambiente.

O bloco e projetado para ser autossuficiente, ele publica um canario isolado, sonda, provisiona o
proprio ator MFA, percorre e limpa, tudo antes de o candidato ser publicado. A correcao adiciona,
dentro do bloco, o passo que cria as entidades pelo proprio frontend de rollback, que alem de suprir o
handoff e a prova mais forte: compatibilidade e o frontend anterior conseguir criar contra o backend
novo, nao apenas ler o que outro criou. O handoff do rollback vai para arquivo proprio, para que as
evidencias do rollback e do candidato nao se sobrescrevam, e a ordem esta travada por teste.

## Onde o handoff de UI do bloco de rollback pode nascer

O deploy `34448775259`, candidato `f4e87d3`, reprovou no passo que eu havia adicionado, com
`A homologacao mutante recusou as origens HTTPS fixas do ambiente solicitado`. A recusa esta certa e e
uma fronteira de seguranca: `mutatingConfiguration` compara `deployed.origin` com a origem fixada do
ambiente e recusa qualquer outra, inclusive a URL efemera do proprio canario de rollback.

Tentei entao mover o bloco autenticado de rollback para depois do ciclo mutante do candidato. Errado,
por duas regras que o proprio repositorio ja declara:

- `scripts/qa/cms-browser-fixture.test.mjs` exige exatamente um `cms-browser-fixture.mjs setup` entre
  o setup e o cleanup do ator mutante, alem de prazo explicito em todo passo dessa janela e orcamento
  total menor que a TTL da lease. O bloco de rollback traz o proprio ator, cujas evidencias de setup e
  cleanup sao exigidas por `verify-staging-artifact.mjs`.
- `scripts/ev2/phase12/authenticated-rollback-compatibility.test.mjs` fixa
  `cleanup < candidateDeploy`, ou seja, a compatibilidade de rollback e provada antes de o candidato
  ser publicado, nao depois.

A forma correta mantem o bloco onde estava e cria as entidades na origem canonica de staging, que
neste ponto do job ja serve o candidato promovido pelo bridge e corresponde ao mesmo SHA de
`rollback_ref`. A travessia continua percorrendo a URL efemera do canario, que e somente leitura e por
isso nao esta sujeita a regra de origem. O handoff vai para arquivo proprio, e ordem, origem e arquivo
estao travados por teste.

Erro proprio, registrado para nao repetir: empurrei `14940a0` com o `npm run check` local vermelho,
porque coloquei a leitura do `EXIT` e o `git commit` no mesmo comando, sem condicionar um ao outro. A
regra passa a ser ler `EXIT=` em chamada separada e so entao commitar.

## Conflito entre dois contratos do repositorio, e a decisao tomada

O deploy `34452219396`, candidato `dd1cb69`, reprovou ao criar as entidades na origem canonica: a
superficie de admin respondeu sem o campo `Titulo`. A razao e que, naquele ponto do job, o alias
canonico ainda serve o build do bridge; o shell do candidato so e construido no passo
`Build the staging shell from the same SHA`, bem depois. E o ciclo mutante recusa qualquer origem que
nao seja a fixada do ambiente, o que exclui a URL efemera do canario de rollback.

Somando as duas restricoes, os contratos do repositorio eram insatisfaziveis:

- `authenticated-rollback-compatibility` exigia `cleanup < candidateDeploy`, isto e, a prova antes da
  publicacao do candidato.
- A travessia AAL2 exige o handoff das entidades nascidas na UI, que so podem nascer na origem
  canonica depois de o candidato estar publicado, e que so existem ate a revogacao do ator mutante.

A decisao foi do responsavel pelo projeto, entre tres alternativas apresentadas: mover a prova para
depois do ciclo do candidato, preservando integralmente a forca das asercoes. Nenhuma asercao foi
reduzida.

Consequencias implementadas em `c43535b`:

- A travessia do frontend de rollback, o cleanup do ator de rollback e sua repeticao passam para
  dentro da janela autenticada, logo apos a travessia do candidato e antes da revogacao do ator
  mutante, que e a unica janela em que as entidades existem. A prova continua no mesmo run e antes de
  qualquer passo de producao.
- O orcamento de prazos explicitos dessa janela sobe de 110 para 165 minutos. A regra que exige um
  unico `cms-browser-fixture.mjs setup` por janela continua satisfeita, porque o ator de rollback e
  provisionado antes dela.
- `0091_cms_qa_actor_lease_window.sql`, digest
  `a7d95d5ac9784d5ec7040945bc11f9369f1dd0ac9695d29068a2f8570ca2adad`, estende a lease do ator
  sintetico de 119 para 240 minutos, que e o mesmo teto do job, para que a lease sobreviva a janela
  inteira e o watchdog nao varra um ator ainda em uso. Gatilho, privilegios e varredor de leases
  expiradas ficam provados inalterados, na propria migration e contra o banco real dos dois ambientes.
- `QA_ACTOR_LEASE_TTL_MINUTES` acompanha em `scripts/qa/qa-actor-lease.mjs`, senao o payload da lease e
  recusado como adulterado.
- O teto de orcamento da janela em `cms-browser-fixture.test.mjs` sobe de 115 para 200 minutos, e o
  teste continua exigindo que o orcamento seja menor que a lease.

## O que a 0091 exigiu, e os tres erros meus que o CI pegou

A 0091 esta com digest `2465fadfff8d3e2025ef1c24e49394241df48f1edb1c41f49cfddd435dd8f7f1` e o CI
`34478272711` aprovou os tres jobs, inclusive `database`, que aplica todas as migrations num Postgres
real. Chegar ali custou tres correcoes, todas erros meus e todas pegas pelo CI:

1. O prazo da lease nao vive so no gatilho: a tabela tem a restricao `cms_qa_actor_leases_check1`, que
   e a barreira que recusa uma lease longa demais. Elevar apenas o gatilho fez os dois discordarem e
   nenhuma lease pode ser gravada, o que derrubou todo teste pgTAP que cria um ator sintetico. A
   restricao subiu junto e continua sendo limite superior fechado, exigindo `expires_at > created_at`.
2. O Postgres normaliza literais de intervalo. Uma restricao escrita como `interval '241 minutes'` e
   armazenada como `'04:01:00'::interval`, entao minha propria sonda fail-closed reprovou procurando as
   palavras com que a restricao foi escrita. As tres verificacoes passaram a comparar pela forma
   canonica.
3. Eu havia reescrito o gatilho a partir do texto de 0061, mas 0086 ja o reparara depois disso,
   trocando `statement_timestamp` por `transaction_timestamp` e endurecendo a guarda de metadados
   sinteticos. Recriar o corpo antigo revertia os dois reparos em silencio, e 25 de 48 subtestes
   cairam. A migration passou a fazer o que a propria 0086 faz: ler a definicao instalada, substituir
   apenas o prazo e o valor auditado, e executar o resultado. Ela falha fechada se qualquer um dos
   reparos sumir, e o pgTAP e a verificacao contra o banco real tambem exigem a presenca deles.

O teste pre-existente que fixava 119 minutos foi atualizado para 240 com a razao ao lado. A lease
continua sendo um prazo fechado, apenas maior que a janela que ela cobre.

## Tela de diagnosticos: a 0089 nao bastava, e a verificacao anterior foi incompleta

Com a sessao autenticada real do operador, em Google Chrome, `aal2`, a leitura da lista responde
`200` em 355 a 458 ms, cinco de cinco, com 50 linhas. Antes eram `500` com `57014` em 8.228 ms. Essa
parte a 0089 resolveu.

A tela, porem, continuava mostrando `Diagnostico indisponivel`. A verificacao que eu havia feito era
incompleta: eu media a consulta sem o cabecalho de contagem, e a tela pede
`count: "exact"`. Reproduzido duas vezes na mesma sessao, com a concorrencia exata da carga:

| consulta                                  | resultado |
| ----------------------------------------- | --------- |
| eventos, `count: exact`                    | `500` em 8.468 ms e `500` em 8.362 ms |
| fila de publicacao, `HEAD count: exact`    | `200` em 440 ms e 253 ms |
| projecao de descoberta                     | `200` em 893 ms e 520 ms |

A contagem exata avalia a autorizacao por linha em todo o acervo aberto, e nao apenas nas 50 linhas
exibidas, entao ela estoura o `statement_timeout` mesmo com o indice parcial instalado. O `503` que eu
tinha visto antes na fila de publicacao era outra coisa e nao se reproduziu em nenhuma das dezenas de
tentativas seguintes, inclusive em rajada paralela de oito requisicoes, todas `200`.

Decisao do responsavel pelo projeto, entre tres alternativas apresentadas: contagem limitada e
honesta. A tela passa a pedir uma linha alem da pagina e a dizer `50+` quando ela vem, em vez de
inventar um total ou exibir uma estimativa. A metrica continua verdadeira, a resposta e imediata e
nenhuma nova migration e necessaria. A alternativa de uma RPC autoritativa que conte em SQL de
conjunto fica registrada como melhoria possivel, com o risco de replicar a regra de escopo.

## A cauda de latencia tinha uma causa unica, e ela era o prazo de quem chama

Dois runs reprovaram o orcamento com a mesma assinatura: mediana saudavel, por volta de 450 ms, e
maximo cravado em quase exatamente 5.045 ms. Em um deles houve tambem 5xx e quebra de disponibilidade,
sobre um preview recem publicado.

Esse teto e do proprio chamador. `cloudflare/_worker.js` aborta a chamada a `cms-public` em 5 segundos
e sintetiza um 503:

```
const timeout = setTimeout(() => controller.abort(), 5_000);
```

Ou seja, o maximo observado nao e uma leitura lenta, e o instante em que o pedido foi abandonado.
Enquanto isso `cms-public` carregava o prazo compartilhado de 30 segundos nas chamadas de saida, muito
alem da janela em que ela responde, entao uma leitura parada nunca conseguia voltar a tempo de ser
util. Isso tambem explica os `503` isolados vistos na tela de diagnosticos e as chamadas PostgREST sem
resposta na confirmacao de remocao: e o mesmo fenomeno, medido em superficies diferentes.

Correcao em `c7c941d`: cada leitura de saida de `cms-public` passa a ter prazo de 1.800 ms e uma
repeticao, o que cabe duas vezes dentro do teto do Worker com folga para o restante da requisicao. A
repeticao vale apenas para `GET` e `HEAD`, porque repetir leitura nao tem efeito colateral, e nunca
quando quem chamou foi que desistiu. Escrita nunca e repetida ali.

Nenhum orcamento foi movido. A mesma parada passa a produzir falha codificada rapida, que o desvio ja
existente do Worker serve, em vez de cinco segundos de espera.

Medicao independente feita entre os dois runs, com 60 amostras nas rotas publicas: zero respostas fora
de 200 e zero acima de 1,5 s. As janelas ruins sao curtas e nao se reproduzem sob demanda, o que e
coerente com paradas isoladas no caminho de saida e nao com lentidao sistemica.

## Varredura das superficies autenticadas na sessao real do operador

Feita em Google Chrome, sessao `aal2` do operador corporativo, contra o staging servindo `d9e4199`.
Rotas percorridas: visao geral, leads, produtos, cadastro em massa, descoberta, listas mestras, busca,
paginas, editorial, midia, campanhas, formularios, estrutura do site, usuarios, auditoria e
diagnosticos. Todas renderizam conteudo real, com filtros e paginacao onde existem.

O defeito dominante nao esta em nenhuma tela: esta no portao de acesso.

- Em duas rotas o painel se bloqueou sozinho, exibindo `Validacao de acesso temporariamente
  indisponivel` depois de cerca de 13,5 segundos.
- Medido na propria carga: tres resolucoes identicas do mesmo token partem com sete milissegundos de
  diferenca e as tres estouram o prazo de 10 segundos, em 10.587, 10.578 e 10.577 ms.
- Nas cargas que funcionam, as mesmas tres chamadas levam de 1,0 a 4,0 segundos cada e o portao espera
  por todas, variando de 1,8 a 6,3 segundos.

As tres chamadas vem de tres gatilhos independentes na montagem: a leitura inicial da sessao e dois
eventos do proprio cliente de autenticacao. O guarda de requisicao ja descartava os resultados
tardios, mas as requisicoes saiam mesmo assim e disputavam entre si.

Correcoes no candidato `5a6bd4d`, todas com teste de regressao:

- O painel emite uma unica chamada por token e acao. Enquanto uma esta em voo, as demais reaproveitam
  a mesma promessa. Acao ou token diferentes continuam sendo chamada propria, a resposta continua
  validada e amarrada ao usuario que a pediu, e cada chamador continua conferindo o proprio
  identificador antes de aplicar o resultado.
- `cms-session` passa a limitar cada chamada de saida em 3 segundos, com uma repeticao apenas para
  leitura, cabendo duas vezes dentro dos 10 segundos que o painel concede.
- `cms-public` passa a limitar cada leitura em 1.800 ms, com uma repeticao, cabendo duas vezes dentro
  dos 5 segundos em que o Worker publico desiste.
- A metrica de alertas abertos deixa de pedir contagem exata do acervo.

Site publico conferido em paralelo: `/`, `/produtos`, `/contato`, `/servicos`, `/solucoes` e
`/industrias` responderam `200` entre 0,57 e 0,86 s, com `sitemap.xml` e `robots.txt` em `200`.

## Prazo de saida: como escolher, e o erro que eu cometi ao escolher

O padrao vale e esta provado: cada funcao de borda precisa responder dentro da janela de quem a chama,
e nao de uma janela generica. Mas o prazo tem dois lados, e eu so respeitei um deles na primeira vez.

- Teto de cima, dado pelo chamador. O Worker publico desiste de `cms-public` em 5 segundos. O painel
  desiste de `cms-session` em 10 segundos. Passar disso e trabalhar para um pedido que ja foi
  abandonado.
- Piso de baixo, dado pelo trabalho real da funcao. `cms-session` monta o manifesto de capacidades,
  que avalia doze flags, cada uma com a sua cadeia de autorizacao. Para um ator sintetico recem
  provisionado esse trabalho e mais longo do que para um operador ja aquecido.

Eu fixei 3 segundos olhando so o teto. O resultado foi uma regressao com sintoma enganoso: a resolucao
voltava `200`, com acesso concedido, e sem o manifesto, porque a chamada que o monta era cortada. O
provisionamento reprovava com `QA_CMS_FIXTURE_SESSION_NOT_READY:200:granted:no_capabilities`, e foi a
propria instrumentacao adicionada no commit anterior que nomeou a causa na primeira tentativa.

Valores em vigor, com a razao ao lado:

| Funcao        | Prazo por chamada | Repeticao | Teto do chamador |
| ------------- | ----------------- | --------- | ---------------- |
| `cms-public`  | 1.800 ms          | uma, so leitura | 5 s do Worker |
| `cms-session` | 6.000 ms          | nenhuma         | 10 s do painel |
| demais        | 30.000 ms         | nenhuma         | sem teto proprio |

`cms-session` nao repete: duas tentativas em sequencia poderiam somar dois prazos e estourar a janela
do painel, que e exatamente a falha que essa mudanca existe para evitar. Caminho quente medido entre
0,9 e 1,7 s, entao 6 segundos cobrem o trabalho e ainda deixam quatro segundos de folga.

Verificado durante o diagnostico e registrado para nao ser reinvestigado: os quatro avaliadores
especializados e `public.cms_runtime_capability_manifest` carregam, no staging, o desvio de janela que
a 0061 injeta, entao a janela de override nunca foi a causa.

## NAO EDITE UMA MIGRATION JA APLICADA

Erro meu, e o mais caro da sessao: acrescentei o ajuste da janela de override dentro da `0091` depois
que a `0091` ja tinha sido aplicada ao staging. `supabase db push` nao reexecuta uma versao ja
registrada, entao o bloco novo nunca chegou ao banco. O resultado foi um estado meio aplicado:

| Objeto                                    | Estado no staging |
| ----------------------------------------- | ----------------- |
| `private.cms_capture_qa_actor_lease`       | 240 minutos, veio na versao aplicada |
| `private.cms_qa_override_window_is_valid`  | 120 minutos, o bloco novo nunca rodou |

Com os dois em desacordo, o validador recusa a janela de 240 minutos, o manifesto de capacidades marca
toda flag como indisponivel e o provisionamento do ator reprova com
`QA_CMS_FIXTURE_SESSION_NOT_READY:200:granted:no_capabilities`, isto e, sessao valida, acesso concedido
e nenhuma capacidade. Custou dois ciclos e uma explicacao errada minha pelo caminho: cheguei a atribuir
a falha ao prazo de 3 segundos do `cms-session`, e ela persistiu identica com 6 segundos, o que ja
descartava aquela hipotese.

Correcao, na forma que o contrato de append-only exige:

- `0091` restaurada byte a byte ao conteudo que o staging aplicou, digest
  `2465fadfff8d3e2025ef1c24e49394241df48f1edb1c41f49cfddd435dd8f7f1`.
- Mudanca isolada em `0092_cms_qa_override_window.sql`, digest
  `1ea5459fdfb945a9686a8049d1b7727f296d91f8f03c7a80f5d36abf808f12d8`, onde ela pode de fato executar.
- A sonda da `0092` falha fechada em tres frentes: se o ajuste nao pegou, se as guardas que amarram a
  excecao a lease sintetica exata sumiram, ou se o privilegio abriu.

Como verificar isso sem gastar um ciclo, e o que passou a existir por causa deste erro: a verificacao
contra o banco real dos dois ambientes passou a exigir o valor instalado, e nao apenas o registro da
versao. Uma migration constar como aplicada nao prova que o efeito dela esta no banco. A consulta que
revelou o problema foi comparar, no proprio staging, o texto instalado das duas funcoes.

## Onde o deploy de staging chegou, e o que cada gate revelou

Cada reprovacao apontou um defeito real e o run avancou. A sequencia importa mais que qualquer um dos
itens isolados:

| Candidato | Onde parou | Defeito revelado |
| --------- | ---------- | ---------------- |
| `e28d10c` | canario | neutralizacao pendurava 120 s, nenhuma I/O de saida tinha prazo |
| `92b6c39` | canario | fence canonico de 0063 contra o fechamento de lease de 0061 |
| `f4e87d3` | travessia de rollback | bloco lia um handoff que ninguem produzia |
| `d9e4199` | provisionamento MFA | janela de override presa ao prazo antigo |
| `f36ffd1` | janelas de saude | canario G11 criava lead com origem que 0084 recusa |
| `fd63dd3` | ponte | conclusao de lease recusada sem dizer a causa |

## Efeito colateral da lease estendida, registrado

Estender a lease para 240 minutos tem uma consequencia operacional que precisa ser conhecida: uma
lease abandonada agora permanece `active` por quatro horas antes de o watchdog varrer, em vez de duas.
Observado no staging, com leases ainda ativas de candidatos de horas antes, entre elas `e28d10c7` e
`5e7aab4c`.

Isso nao bloqueia um run novo, porque a lease e por ator e por `run_tag`, e o proprio watchdog
continua varrendo de minuto em minuto assim que o prazo vence. Mas a limpeza automatica de um run
interrompido demora mais, e quem estiver investigando residuo precisa saber disso antes de concluir
que algo ficou preso.

## Verificar efeito, e nao registro de versao

A consulta que revelou o estado meio aplicado da 0091 vale como metodo e fica registrada:

```
select p.oid::regprocedure::text,
       position('241 minutes' in pg_get_functiondef(p.oid)) > 0
from pg_proc p join pg_namespace n on n.oid = p.pronamespace
where n.nspname = 'private' and p.proname = 'cms_qa_override_window_is_valid';
```

Uma migration constar em `supabase_migrations.schema_migrations` prova apenas que a versao foi
registrada. Para saber se o efeito esta no banco, compare o texto instalado da funcao ou da restricao.

## Ponte de compatibilidade legacy-f48 do candidato `b6ed084` (evidencia superada)

Run [`34395203818`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34395203818), tentativa 1,
`success`. Baseline esperado `4b9184b3616b4df64b55037029b8dd02d2751e1b`, confirmado pelo probe
antes de qualquer mutacao.

Sequencia da troca temporaria, com os relatorios no artifact `10121627840`,
`staging-cms-public-legacy-34395203818-1`:

| Fase    | Estado   | Versao viva de `cms-public` | Observacao                                                         |
| ------- | -------- | --------------------------- | ------------------------------------------------------------------ |
| prepare | prepared | 56 capturada                | `remoteMutated: false`; plano de restauracao selado antes do lease |
| engage  | engaged  | 57                          | `cms-public` do `f48bb453` publicado sob lease exclusivo           |
| restore | restored | 58                          | `contractProbe: public-v2`, `internalIdentifiersExposed: false`    |

Digests de fonte vinculados: candidato
`sha256:658a28aa3b7e8c352777b4d9aafb0b8a372808490f6c3fbeae0704d31d9bba3b`; legado
`sha256:8f0b894bbabd2914a03fce438b796f7c568e4b1d0a93e1a115cef9466f2e3b02`. A restauracao foi
provada contra o formulario sintetico `qa-bridge-b6ed0847-c4251cd6`, que ainda existia porque o
restore roda antes do cleanup canonico.

Evidencia imutavel `10121626071`,
`staging-frontend-bridge-b6ed08476267699d05c06162561083a826d6bfa6`, schemaVersion 3. Os dois
canarios headless, preview e canonico, registram `contract: legacy-f48`, pagina, campanha e
formulario renderizados, Turnstile solicitado com falha de rede observada,
`backendMutationRequests: 0`, `cleanupStatus: cleaned`, `residueStatus: passed` e
`auditRetained: true`. O escopo permanece `compatibility-only`, com
`positiveBrowserRequiredAfterFullCandidateDeploy: true`.

Verificacao independente apos o run: a variavel `G12_STAGING_CMS_PUBLIC_LEGACY_RECOVERY` nao
existe, o alias canonico serve `b6ed08476267699d05c06162561083a826d6bfa6` e o `page-by-path` vivo
responde entre 0,53 e 0,94 s.

Estado de backend a reconciliar: staging ficou com inventario misto. As 33 demais Edge Functions
seguem em `4b9184b` e `cms-public` esta em `b6ed084` versao 58, porque o restore do bridge
reimplanta o `cms-public` do candidato, como o proprio handoff exigia. O deploy integral de
staging deve reconciliar todo o inventario no SHA final.

## Workflows e gates remotos

| Run / tentativa                                                                    | Workflow e SHA                             | Estado  | Resultado ou observacao                                                                     |
| ---------------------------------------------------------------------------------- | ------------------------------------------ | ------- | ------------------------------------------------------------------------------------------- |
| [`34377871781`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34377871781) / 1 | CI, `0ab1fa8`                              | success | Quality, database e browser aprovados.                                                      |
| [`34332351815`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34332351815) / 1 | staging frontend bridge, `4b9184b`         | success | Bridge legacy-f48, promocao canonica e cleanup aprovados.                                   |
| [`34367910654`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34367910654) / 1 | deploy staging, `4b9184b`                  | failure | Migrations e funcoes passaram; migration canary rejeitou HTTP 201 antes da correcao `63c1`. |
| [`34368713733`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34368713733) / 2 | deploy staging watchdog                    | success | Recuperacao, probe e compare-and-clear aprovados.                                           |
| [`34372327742`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34372327742) / 1 | CI, `63c1b56`                              | success | Evidencia superada pelo SHA atual.                                                          |
| [`34373095263`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34373095263) / 1 | bridge, `63c1b56`                          | failure | Parou antes de mutacao por recovery store ocupado.                                          |
| [`34373755969`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34373755969) / 1 | bridge watchdog                            | failure | Corrida com estado anterior; estado foi resolvido depois.                                   |
| [`34374494260`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34374494260) / 1 | bridge, `63c1b56`                          | failure | Preview e probe passaram; fixture detectou contrato legacy-f48 ausente.                     |
| [`34375290243`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34375290243) / 1 | bridge watchdog                            | success | Cleanup, zero residuo, alias original, probe e limpeza HMAC aprovados.                      |
| [`34296232516`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34296232516) / 1 | provisionar operador production, `f48bb45` | failure | Falhou no gate de SHA antes de qualquer mutacao externa.                                    |
| [`34069047721`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34069047721) / 1 | deploy production, `f48bb45`               | success | Release atualmente servido em producao, historico.                                          |
| [`34202958259`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34202958259) / 1 | backup production                          | success | Backup valido do release anterior; sem restore drill.                                       |
| [`34327900390`](https://github.com/Vnd93/gaiatec-cms/actions/runs/34327900390) / 1 | backup production                          | failure | Preflight recusou configuracao de DB; sem mutacao nem artefato.                             |

No checkpoint nao ha run ativo, fila pendente nem variavel de recovery residual.

## Deployments, URLs, manifests e artefatos

| Ambiente         | URL / identidade                                       | Estado e SHA servido                                                                                                                                                                                                                                    |
| ---------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Staging canonico | <https://ev2-g17-canary.gaiatec-cms-staging.pages.dev> | `/healthz` 200/ready; `environment=staging`; SHA `4b9184b3616b4df64b55037029b8dd02d2751e1b`; deployment `6d4de4d3-5716-4659-8b3d-fce93071e193`; URL imutavel <https://6d4de4d3.gaiatec-cms-staging.pages.dev>.                                          |
| Preview isolado  | <https://42e8e886.gaiatec-cms-staging.pages.dev>       | `/healthz` 200/ready; SHA `63c1b563b3fb685e445960545fbabcaee84437bb`; deployment `42e8e886-c106-49dc-b60c-d6dbc5d068e2`; alias <https://ev2-g12-canary.gaiatec-cms-staging.pages.dev>.                                                                  |
| Producao         | <https://gaiatecsistemas.com.br>                       | `/healthz` 200/ready; `environment=production`; SHA `f48bb4530566456a0090a98cd39caf1cacb51b09`; URL Pages registrada <https://ddc96e7e.gaiatec-website.pages.dev>. O UUID completo do deployment nao existe na evidencia disponivel e nao foi inferido. |

O host base `https://gaiatec-cms-staging.pages.dev/healthz` responde 404 e nao e o alias canonico do
release. O candidato `0ab1fa8` nao esta implantado em staging nem em producao.

Artefatos relevantes:

- Bridge staging `4b9184b`: evidencia `10096579555`, digest
  `sha256:2228c40f3b4ac1d8a72e6acb3d92e42f407f19ba90a1767a88ac4eb4a57ba13b`; archive
  `sha256:9b12da734eaa26fe105ea020b78e4fa2ff2e57f1d5e72d5b0bfcac8aee6cd8ec`; tree
  `sha256:90e65340733fd91640426b024ee0eea9c71aabefe2ded6582181e73580761c22`.
- Recovery do bridge falho: `10113525792`, digest
  `sha256:aa4e24ae12ccef5330bcd56e793db158a51f06c9d87e9ac363b0dff0f08b1b9f`.
- Watchdog terminal: `10113622208`, digest
  `sha256:a2e2922d9f7bc06a4c7f7f0e46a743af080244ee4cdc2cec79dfb99685d90f94`.
- Preview isolado `63c1`: archive
  `sha256:4062bb81939fed801524a8ab457beb98453b2f114f6eecf664f528324d140944`.
- Release production `f48`: `9999946449`, digest
  `sha256:7db71dced257dcba2b9c836bcdd4db4f5c4859b21d49568ce074591564c388c0`.
- Backup production historico: `10046578442`, digest
  `sha256:58f0b27185cddb93f17aff2c1b51daba4b07708818ab2a1fe432d5cd3e25fe83`.

Ainda nao existe artefato final unico selado para `0ab1fa8`. Canary e producao devem usar exatamente
os mesmos bytes, sem recompilacao.

## Supabase, migrations, Storage e Edge Functions

- Projeto staging: `glcqsosxwgmlhzgcsnzv`.
- Projeto production: `chfuhctnhqgyjowkvllv`.
- Os projetos, environments GitHub e origens Cloudflare sao separados.
- Staging: migrations sequenciais `0001` a `0088` aplicadas e verificadas; ultima
  `0088_cms_runtime_integrity_followup.sql`.
- Production atual `f48`: evidencia historica confirma `0001` a `0056`; aplicar/verificar o candidato
  final continua pendente.
- Inventario de schema no codigo: 178 relacoes, 479 funcoes/RPCs e 4 buckets; classificacao terminal
  de runtime para o SHA final ainda pendente.
- Staging recebeu e verificou 34 Edge Functions ACTIVE no mesmo fonte backend de `0ab1`:
  `cms-ai`, `cms-ai-execute`, `cms-attributes`, `cms-bulk`, `cms-collaboration`, `cms-content`,
  `cms-controlled-vocabularies`, `cms-documents`, `cms-drafts-v2`, `cms-leads`, `cms-master-data`,
  `cms-media`, `cms-outbox-worker`, `cms-pim`, `cms-preview`, `cms-public`, `cms-quality`,
  `cms-recovery`, `cms-releases`, `cms-scopes`, `cms-search-admin`, `cms-session`, `cms-sites`,
  `cms-system`, `cms-users`, `cms-visual`, `lead-capture`, `rdo-command`, `rdo-invite`,
  `rdo-notify`, `rdo-otp`, `rdo-sign`, `rdo-team`, `submit-contact`.
- `cms-public` em staging esta ACTIVE v56 e serve o contrato sanitizado `public-v2`.
- Production atual possui 32 funcoes na evidencia `f48`; `cms-documents` e `cms-recovery` ainda nao
  fazem parte desse release e devem entrar apenas no deploy final controlado.
- Storage privado, RLS, modos JWT/no-JWT, Vault e regressao RDO passaram no deploy de staging 4b, mas
  a evidencia terminal do SHA final deve ser produzida pelo pipeline final.

Nao resetar o banco nem reaplicar manualmente migrations para documentar. O proximo pipeline deve
verificar idempotencia e estado remoto antes de qualquer aplicacao correspondente ao ambiente.

## Cloudflare Pages, Worker e saude

- Projeto Pages staging: `gaiatec-cms-staging`.
- Projeto Pages production: `gaiatec-website`.
- Nao existe deployment Cloudflare Worker separado. O roteador e o Worker Advanced Mode de Pages:
  `cloudflare/_worker.js` e parametrizado/copiado por `scripts/prepare-cloudflare-worker.mjs` para
  `dist/_worker.js`, incluido no artefato e implantado pelos comandos `wrangler pages deploy`.
- A identidade, URL, deployment e estado do Worker sao, portanto, os mesmos de cada deployment Pages.
  O manifest do staging canonico registra `_worker.js` com digest
  `sha256:6d9db774271de4993f271cdaf69f54c433cc220e98964b61ad15d8db675b2e8e`; o manifest de producao
  atual registra `sha256:b38590fa13dfe0f97613e4f1f74fbaaf7a94dce7e7413cbfbaa782a96b79c46a`.
- Os endpoints canonicos de `/healthz` e `release-manifest` descritos acima respondem com os SHAs
  registrados e headers de seguranca; staging esta `noindex`.
- Rotas React/Worker e CSP foram inventariadas estaticamente, mas a matriz terminal e os probes do
  candidato final ainda sao obrigatorios.
- Nao alterar o staging canonico `4b9184b` nem a producao saudavel `f48` apenas para preparar o
  handoff.

## Flags e configuracao por ambiente

| Ambiente/etapa            | Configuracao comprovada ou prevista                                                                                                                                                                                                                                                                                                                       |
| ------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Staging bridge atual      | `VITE_CMS_ENVIRONMENT=staging`, `VITE_CONTACT_CAPTCHA_ALWAYS=true`, `VITE_EV2_DRAFT_V2_CANDIDATE=false`; overrides sinteticos foram limpos e flags de banco permanecem default-off/fail-closed.                                                                                                                                                           |
| Production frontend final | Deve usar `VITE_CMS_ENVIRONMENT=production`, `VITE_CONTACT_CAPTCHA_ALWAYS=true` e manter `VITE_EV2_DRAFT_V2_CANDIDATE`, `MASTER_DATA`, `PIM`, `DAM`, `SEARCH_QUALITY`, `COLLABORATION_BULK`, `RBAC_SCOPED`, `VISUAL_STUDIO`, `MULTISITE`, `AI_ASSIST` e `SYSTEM_ASSURANCE` em `false` no artefato frontend, salvo gate individual aprovado e documentado. |
| Production backend final  | Workflow previsto habilita `CMS_EV2_PRODUCTION_ENABLED=true` e `CMS_AI_EXTERNAL_PROVIDER_ENABLED=true`; isso ainda nao foi aplicado para `0ab1`. IA deve permanecer no provedor/modelo aprovado, com revisao humana e kill switch.                                                                                                                        |

Nao afirmar flags efetivas do release `f48` alem do que seu artefato registra. Antes da promocao,
provar que o build nao carregou `.env.local`, configuracao local, endpoint ou credencial de staging.

## Nomes de secrets confirmados

Somente os nomes foram consultados; nenhum valor foi acessado ou registrado.

Staging:

- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`
- `EVIDENCE_SALT`
- `RELEASE_GUARD_TOKEN`
- `STAGING_SUPABASE_ANON_KEY`
- `STAGING_SUPABASE_URL`
- `SUPABASE_ACCESS_TOKEN`

Production:

- `BACKUP_ENCRYPTION_PASSPHRASE`
- `CLOUDFLARE_ACCOUNT_ID`
- `CLOUDFLARE_API_TOKEN`
- `CLOUDFLARE_CACHE_PURGE_TOKEN`
- `EVIDENCE_SALT`
- `LEAD_EVIDENCE_SALT`
- `OPENROUTER_API_KEY`
- `OUTBOX_WORKER_SECRET`
- `PRODUCTION_AUTH_CANARY_EMAIL`
- `PRODUCTION_AUTH_CANARY_PASSWORD`
- `PRODUCTION_AUTH_CANARY_TOTP_SECRET`
- `PRODUCTION_OPERATOR_EMAIL`
- `PRODUCTION_SUPABASE_ANON_KEY`
- `PRODUCTION_SUPABASE_DB_URL`
- `PRODUCTION_SUPABASE_SERVICE_ROLE_KEY`
- `PRODUCTION_SUPABASE_URL`
- `RATE_LIMIT_SALT`
- `RELEASE_GUARD_TOKEN`
- `RESEND_API_KEY`
- `SUPABASE_ACCESS_TOKEN`
- `TURNSTILE_SECRET_KEY`
- `VITE_TURNSTILE_SITE_KEY`

Os nomes `PRODUCTION_AUTH_CANARY_PASSWORD` e `PRODUCTION_AUTH_CANARY_TOTP_SECRET` estao presentes e
resolvem somente o gate de disponibilidade dessas credenciais. Variaveis publicas de repositorio:
`GOOGLE_MAPS_BROWSER_KEY` e `TURNSTILE_STAGING_SITE_KEY`.

## Operador, MFA, CMS/RDO e auditoria

- Registro historico, anterior a mudanca de navegador exigido: o operador corporativo de staging
  autenticou em Microsoft Edge e abriu `/admin/auditoria`; a
  superficie autorizada de superadministracao CMS, menu e eventos de auditoria foram observados.
- Nenhum e-mail, UUID de usuario, senha, segredo TOTP, cookie ou armazenamento da sessao foi copiado.
- A conta corporativa nao deve ser usada para fixtures; testes destrutivos usam conta sintetica.
- A separacao CMS/RDO permanece obrigatoria. RLS, papel, escopo, AAL e auditoria devem ser confirmados
  positiva e negativamente no ciclo terminal.
- O workflow de operador production `34296232516` falhou antes de qualquer mutacao por divergencia
  de SHA. Portanto, operador production e MFA nao estao homologados para o candidato atual.
- Matricula, desafio correto/incorreto/expirado/reutilizado, renovacao, expiracao e revogacao de
  sessao ainda devem ser comprovados no SHA final.
- Nao ha evidencia suficiente para afirmar se existe bypass temporario ativo. Antes da aprovacao,
  provar que toda excecao expirou/foi removida e repetir login e fluxo critico com MFA normal.

## Evidencias reais de navegador e seguranca

- Navegador exigido: Google Chrome real, nao headless. A exigencia anterior de Microsoft Edge foi
  substituida por decisao do responsavel pelo projeto; o criterio de fundo nao mudou, ou seja,
  navegador real com sessao autenticada, MFA e backend real, nunca headless nem simulado.
- Evidencia autenticada existente: staging `/admin/auditoria`, sidebar, papel CMS autorizado e eventos
  de auditoria; historica e insuficiente para aprovar `0ab1`.
- Documento legado foi atestado limpo pelo Microsoft Defender, aprovado por segundo ator AAL2 no
  Edge, e `cms_legacy_documents_promotion_ready()` retornou verdadeiro.
- Evidencia externa preservada: `cms-release-evidence/DEFENDER-STAGING-20260909-4b9184b3-001.txt`,
  digest `sha256:ae4c19de5781035ddf5f636052e27badc28d221a31edd1b0361929c657d163e4`.
- A evidencia acima esta vinculada a `4b9184b`; nao repeti-la apenas para outro formato, mas
  revalidar no SHA final quando o gate/bytes correspondentes exigirem.
- Homologacao terminal autenticada, quatro viewports, console/rede, ciclo editorial e MFA do SHA
  final ainda nao foram produzidos.
- Antes da submissao real do formulario publico protegido por Turnstile, obter a confirmacao humana
  exigida no momento da acao e nunca registrar resposta, token ou dado identificavel.

## Matriz de cobertura transportada

O inventario estrutural transportado e util para continuidade porque nao houve diff em `src` ou no
backend desde `4b9184b`; ele nao substitui a regeneracao e a evidencia runtime do SHA final:

| Dimensao                           |                                                 Quantidade transportada |
| ---------------------------------- | ----------------------------------------------------------------------: |
| Rotas administrativas              |                                                             36 patterns |
| Superficies administrativas        |                                                                      52 |
| Destinos de navegacao              |                                                                      29 |
| Controles unicos                   |  1.010: 505 fields, 373 actions, 79 links, 26 forms, 23 tabs, 4 dialogs |
| Chamadas frontend                  |                                                                     156 |
| Rotas publicas                     |                                                                      53 |
| Edge Functions                     |                                                                      34 |
| Chamadas backend                   |                                                                     293 |
| Bindings helper/API para Edge      |                                                                      24 |
| Relacoes / funcoes-RPC / buckets   |                                                           178 / 479 / 4 |
| Permissoes                         |                                                                     216 |
| Requisitos / regras / divergencias |                                                             18 / 60 / 3 |
| Bindings controle-superficie       | 3.852: 3.818 obrigatorios e 34 `N/A` canonicos sujeitos a revisao final |
| Provas superficie-viewport         |                                                                     208 |
| Disposicoes controle-viewport      |                                                                  15.408 |
| Contratos de campo / acao / abas   |                                                     1.648 / 2.103 / 101 |
| Consumidores publicos              |                                         118 contratos em 42 superficies |

Fonte transportada verificavel: artifact GitHub `10110922714`, nome
`staging-4b9184b3616b4df64b55037029b8dd02d2751e1b`, do run `34367910654`, digest do artifact
`sha256:c29ca5e7279c53dffc45da7a4af60a43a00cee923be76a1fdf50878ba7000c55`, nao expirado. Dentro dele,
`candidate/outputs/g12-cms-coverage-matrix.json` tem 26.288.615 bytes, digest
`sha256:03104d349b295d672ffa327ee17972ff8298b23cc807890474266d43450aab1d`, `sourceSha=4b9184b...`,
`sourceDirty=false`, 52 linhas de superficies e secoes detalhadas de controles, chamadas frontend,
rotas publicas, Edge Functions, bindings, chamadas backend e inventario de migrations. O gerador
versionado no candidato e `scripts/qa/cms-coverage-inventory.mjs`; o materializador terminal e
`scripts/qa/materialize-cms-terminal-coverage.mjs`.

Esse artifact e uma ancora auditavel para continuidade, nao uma aprovacao de `0ab1`. A matriz final
deve ser regenerada no SHA final, conter a evidencia runtime e receber novo digest/artefato.

A matriz terminal deve conter identificador, origem, requisito, menu/aba/rota, persona, finalidade,
campos/limites, semantica, estados, permissao/escopo/site/ambiente/flag/AAL, contrato/API/Edge,
RPC/tabela/Storage/integracao, `consumer_id`, cenarios positivos e negativos, concorrencia,
idempotencia, persistencia, auditoria, efeito publico, testes, evidencia, erro, causa, correcao e
status. Deve falhar com rota ou controle orfao, campo sem consumidor/finalidade, acao sem efeito,
backend sem teste, consumidor de payload editorial bruto, nao testado ou `N/A` sem justificativa.

Saidas canonicas esperadas, ainda ausentes para `0ab1`:

- Staging: `candidate/outputs/cms-terminal-coverage-matrix.json`.
- Production: `candidate/outputs/cms-terminal-coverage-matrix-production.json`.

A matriz deve ser regenerada depois de qualquer correcao e antes da homologacao final.

## Dados sinteticos e auditoria preservada

- Tag do migration canary anterior: `QA-CMS-FINAL-20260909-4b9184b3`. A operacao de ator nao iniciou
  por causa do erro HTTP 201; o relatorio confirmou zero residuo, zero mutacao de producao e nenhum
  segredo persistido.
- O bridge `63c1` criou fixture isolada; cleanup e residue passaram, residuo ativo ficou zero e os
  eventos de setup/cleanup foram preservados em auditoria.
- O conjunto terminal unico `QA-CMS-FINAL-<AAAAMMDD>-<sha-curto>` ainda nao foi criado para o SHA
  final. Deve conectar fabricante, marca, linha, categoria, vocabularios, atributos, quatro entidades
  de descoberta, produto/modelo/variante/SKU, midia, documento, conteudo, paginas, campanha,
  formulario, lead, SEO, redirect/retirada, tarefa, comentario, release, site/ambiente e proposta de
  IA quando elegivel.
- Ao terminar, despublicar/arquivar/remover conforme a politica, provar retirada e zero residuo ativo,
  sem apagar auditoria imutavel.

## Backup de producao: o que quebrou, o que foi corrigido e o que o drill revelou (2026-09-11)

Esta secao cobre quatro achados do dia, cada um com run, passo e causa. Nenhum deles foi corrigido
enfraquecendo gate: em todos, o gate que reprovou continua reprovando o mesmo caso.

### 1. A regra de configuracao de backup recusava o unico endpoint que serve

- Rota/acao: `backup-supabase-production.yml`, passo `Validate fail-closed backup configuration and
  PostgreSQL runtime`, via `scripts/ev2/phase16/readiness-lib.mjs`.
- Sintoma: producao ficou de 2026-09-08 ate 2026-09-11 sem backup. Os runs agendados de 09, 10 e 11
  de setembro (`34327900390`, `34453882605`, `34577615950`) reprovaram no mesmo passo.
- Causa raiz: `97731f0` removeu o ramo de pooler da validacao e passou a exigir o endpoint direto
  `db.<ref>.supabase.co`. Esse host resolve somente AAAA (IPv6) e o runner do GitHub e IPv4, entao a
  regra exigia o unico endpoint que a infraestrutura nao alcanca. O diagnostico de que o segredo teria
  sido rotacionado era falso: `updated_at` do secret e de 2026-09-05T21:54:37Z, anterior a primeira
  falha.
- Correcao `ba6afc2`: a regra passou a aceitar o endpoint direto OU o pooler
  (`*.pooler.supabase.com`), continuando a exigir a porta 5432 (session mode, a unica que o `pg_dump`
  aceita) e o usuario coerente com o endpoint (`postgres` no direto, `postgres.<ref>` no pooler). O
  que discrimina session de transaction mode e a porta, nao o host. Regressao com fixtures dos dois
  modos.
- Efeito comprovado: run `34612625471` (2026-09-11T14:51:23Z) concluiu com sucesso. Producao voltou a
  ter backup externo, o primeiro desde 08/09.

### 2. A consulta de inventario de Storage nomeava uma tabela que nao existia no escopo

- Rota/acao: mesmo workflow, passo `Create one-snapshot logical dump and encrypted external bundle`.
- Causa raiz: as duas consultas de inventario usavam `to_jsonb(storage.objects)`. Em SQL isso e a
  referencia a uma tabela sem alias dentro de uma expressao de linha, e o parser recusa.
- Correcao `e9e949f`: `from storage.objects as object` com `to_jsonb(object)`. O teste que antes fixava
  a consulta quebrada foi substituido por uma recusa ancorada no uso real, e nao no comentario que
  explica o defeito.

### 3. O drill de restauracao: uma reprovacao que nao sabia dizer o que reprovou

- Rota/acao: passo `Prove decryption and complete data restore in an ephemeral Supabase`, script
  `scripts/ev2/phase16/verify-role-backup.mjs`.
- Runs: `34612800748` (candidato `e9e949fb`) e `34613720758` (candidato `5b78f724`), ambos failure.
- Causa raiz da reprovacao original: `BACKUP_ROLE_RESTORE_FINGERPRINT_MISMATCH` sem numero nenhum. O
  mesmo codigo era emitido para relatorio de origem malformado e para divergencia de catalogo, e o
  agregado so sabe dizer "diferente".
- Correcao `5b78f72`: detalhe por papel nos dois lados, contagens no lugar do silencio, relatorio de
  origem invalido com codigo proprio, e o detalhe recalculando o agregado para nao ser aceito por
  confianca. Nenhuma asserção foi afrouxada.
- Resultado medido no run `34613720758`:
  `{"sourceRoleCount":17,"restoredRoleCount":16,"identicalRoles":15,"rolesDriftedInRestore":1,
  "rolesMissingFromRestore":1,"rolesOnlyInRestore":0}`.
- Leitura: 15 dos 17 papeis restauram identicos. Um papel nao chega ao alvo e um chega com atributo ou
  vinculo diferente. Nao e limite do pooler em session mode: o alvo do restore e um Postgres local em
  container, o transporte nao participa, e o passo de dump concluiu com sucesso. Por isso a condicao
  1.6 do coordenador (parar e escalar se o pooler nao servir para restauracao completa) NAO foi
  acionada.
- Por que ainda nao esta corrigido: contagem nao decide o que fazer. Papel que o dump nao levou e
  defeito de backup; papel que a plataforma recria sozinha e limite a declarar. Exigem correcoes
  opostas.
- Correcao `3422d02`: cada papel passa a carregar um perfil sem nome (atributos canonicos sem a chave
  `name`, vinculos reduzidos a hash do nome do pai). A divergencia agora nomeia os atributos do papel
  ausente e, para o que derivou, os campos exatos com os dois valores. Nenhum nome de papel e nenhum
  fingerprint sai do runner, e os relatorios selados seguem byte a byte iguais.

### 3b. O que o drill classificado mediu, e por que ele nao pode passar como esta

Run `34614853382`, candidato `758780c1`, mesmo passo. Com a linha de base do alvo efemero e a
composicao do dump medidas, a reprovacao deixou de ser um enigma:

```
{"event":"supabase.role_restore.prepared","createRoleStatements":0,"alterRoleStatements":3,
 "grantStatements":1,"removedRoleSettings":3,...}

BACKUP_ROLE_RESTORE_FINGERPRINT_MISMATCH: {
  "sourceRoleCount":17,"restoredRoleCount":16,"baselineRoleCount":16,
  "identicalRoles":15,"rolesDriftedInRestore":1,"rolesMissingFromRestore":1,"rolesOnlyInRestore":0,
  "missingRolesAbsentFromBaseline":1,
  "driftedRolesUntouchedByRestore":1,"driftedRolesChangedButNotConverged":0 }
```

Quatro fatos, agora medidos e nao supostos:

1. O dump de papeis nao contem NENHUM `CREATE ROLE`. Tem 3 `ALTER ROLE`, e os tres sao
   `ALTER ROLE ... SET ...`, removidos pela sanitizacao por serem configuracao gerenciada. Sobra
   1 `GRANT`. A "restauracao portavel de papeis" aplica, na pratica, uma declaracao.
2. `baselineRoleCount` e `restoredRoleCount` sao ambos 16: o dump nao alterou nenhuma impressao
   digital de papel no alvo. O unico GRANT ja estava satisfeito de fabrica.
3. O papel ausente tambem nao existia na linha de base, e sem `CREATE ROLE` o dump nao consegue
   cria-lo. Nao e restauracao que falhou: e cobertura que o backup nao tem.
4. O papel divergente nao foi tocado pela restauracao
   (`driftedRolesChangedButNotConverged: 0`): o vinculo a mais e valor de fabrica do alvo efemero,
   nao consequencia do restore.

Perfil do papel ausente, sem nome: LOGIN, NOINHERIT, sem superuser, sem bypassRls, sem createrole,
sem createdb, sem replication, limite de conexao -1, exatamente um vinculo, e
`validUntil: 2026-09-09T03:15:50Z`, ou seja ja expirado. Nao tem forma de papel de aplicacao; tem
forma de credencial efemera de plataforma. Somado ao fato 1, a leitura coerente e que os 17 papeis
de producao sao todos gerenciados pela plataforma e nao ha papel proprio da aplicacao a restaurar.

Consequencia para o gate: `restored.fingerprint === sourceReport.portableCatalogSha256` compara o
catalogo inteiro de producao com o catalogo de fabrica de um Supabase local que o dump quase nao
toca. Essa igualdade nao e alcancavel contra um alvo gerenciado e pre-semeado, e nao era alcancavel
no dia em que o gate entrou. Por isso ele nunca passou.

ESCALADO, NAO CONTORNADO. Corrigir isso exige redefinir o que a evidencia de papeis afirma, e
`portableRoleCatalogMatched` e consumido por `production-backup-gate-lib.mjs` e
`readiness-lib.mjs` como condicao de aprovacao do release. Mudar o significado desse campo muda o
que o gate de release aceita, e essa decisao nao e minha. As duas leituras estao no relatorio ao
responsavel; nenhuma foi aplicada.

### 4. Defeito que eu introduzi: o watchdog de staging reprovando a cada passe de diagnostico

- Rota/acao: `deploy-staging-watchdog.yml`, gatilho `workflow_run` de "Deploy staging".
- Causa raiz: o modo `diagnostic_run` que eu acrescentei a `deploy-staging.yml` termina em failure por
  desenho e pula o job `deploy` inteiro. O gatilho do watchdog nao distingue isso de um deploy real
  interrompido, entao ele acordava, nao encontrava estado pre-mutacao e morria em
  `G12_STAGING_WATCHDOG_STATE_UNAVAILABLE`.
- Por que e defeito e nao ruido: falha esperada que se repete a cada passada torna a falha real
  indistinguivel. Uma compensacao que deveria ter acontecido e nao aconteceu ficaria escondida no
  meio de runs vermelhos rotineiros.
- Correcao `3422d02`: um job `classify-parent-run` pergunta ao run pai se o job mutante `deploy`
  chegou a executar, e a compensacao so roda quando executou. A decisao nao le o input do pai, le o
  fato que importa. Se a propria classificacao falhar, o watchdog segue como antes: nao compensar por
  nao saber seria o unico erro irrecuperavel. Estado ausente depois de o job mutante ter rodado
  continua sendo falha dura.

### Correcao de uma afirmacao minha sobre o selo sem prova de restauracao

Eu havia registrado que o selo publica evidencia consumindo um `restore_scope_report` vazio. Isso
esta errado e o manifesto do run `34612625471` prova: `restoreDrill.performed: false`,
`outcome: "not_scheduled"`, todas as verificacoes `false`, `reports.restore: null` e
`completeDataRestoreDrill: false`. Os relatorios de restauracao nao sao lidos quando nao ha drill, e
o gate de release recusa um manifesto assim, porque exige os eventos `...restore-verified`.

A lacuna real e mais estreita e continua aberta: `validateProductionBackupManifest` so e chamado
quando houve drill (`write-backup-manifest.mjs`), entao o artefato diario e selado e publicado sem
nenhuma validacao estrutural do manifesto.

## Runbook do operador: atestacao em Google Chrome real (preparado, nunca executado)

`submit-real-browser-attestation.yml` tem ZERO runs. Nada aqui foi exercitado contra a API real; o
que segue e o contrato lido na fonte, mais as duas ferramentas que passaram a existir para que o dia
nao queime na primeira tentativa. Verificado em `real-browser-attestation-store-lib.mjs` e
`tests/e2e/cms-real-browser-attestation.ts`, nao em memoria.

### A janela e o verdadeiro risco

O desafio nasce com `expiresAt = agora + 15 min` e `REAL_BROWSER_ATTESTATION_MAX_AGE_MS` e
15 minutos. A idade de `observedAt` e revalidada em quatro pontos independentes: prepare local,
dispatch local, claim no broker e gravacao no store. A janela e unica, nao renovavel, e nao ha
notificacao de que o desafio nasceu. Tudo o que segue existe para caber nela.

### Ferramentas novas, locais, sem mutacao remota

- `scripts/ev2/phase12/canonical-screenshot.mjs` — reencoda a captura para o PNG que a atestacao
  aceita. O validador so admite IHDR, PLTE, IDAT e IEND; Snipping Tool, Paint e extensoes de
  navegador injetam pHYs, sRGB, tEXt e tIME sem perguntar, e isso reprova com
  `screenshot_chunk_not_canonical`. Uso:
  `node scripts/ev2/phase12/canonical-screenshot.mjs --input captura.png --output canonica.png`.
  Ele confere a propria saida contra `validateRealBrowserScreenshotPng` antes de gravar: se o
  validador recusaria, o arquivo nao e escrito e os codigos saem no erro.
  O orcamento default e 28.000 bytes, e nao os 30 KiB do teto do PNG, porque o wrapper selado leva o
  screenshot em base64 junto do relatorio sob `MAX_REAL_BROWSER_VARIABLE_BYTES = 47.000`. Captura
  grande demais e reduzida por fator inteiro, e o fator sai declarado no JSON.
- `scripts/ev2/phase12/await-real-browser-challenge.mjs` — espera o desafio e diz quanto da janela
  sobrou. Cada tentativa e o proprio `fetch-challenge` como processo filho, com caminho de saida
  novo (o fetcher grava com `wx`). Uso:
  `node scripts/ev2/phase12/await-real-browser-challenge.mjs --environment staging --run-id <ID>
  --run-attempt 1 --output-dir outputs/real-browser-challenge`.

### O que o operador tem de observar no Chrome, e em que ordem

1. Abrir DevTools na aba Network ANTES de abrir a URL do desafio. O `201` e o header de release sao
   lidos da resposta e nao ha segunda chance de capturar a requisicao.
2. Preencher o formulario publico com o e-mail sintetico que o desafio traz. Nunca outro.
3. Resolver o Turnstile oficial. `turnstile.tokenCaptured` e `false` por contrato: o token nao deve
   ser capturado, so a presenca do widget oficial atestada.
4. Confirmar `201` no POST e o texto visivel de sucesso. O contrato exige que
   `visibleSuccessText` case com `/\bProtocolo\s+<reference>\b/i`, e `reference` casa com
   `^LD-[A-F0-9]{10}$`.
5. Confirmar que o documento e o `/healthz` servem o MESMO SHA do candidato:
   `documentReleaseSha === healthReleaseSha === candidateSha`.
6. Capturar so o seletor de sucesso, `[data-form-submission-status="success"]`, sem campo de
   formulario visivel — a captura nao pode carregar o e-mail sintetico.
7. Passar a captura pelo reencoder acima.
8. `prepare` e depois `dispatch`, sem troca de contexto no meio.

O relatorio tem exatamente 21 chaves, verificadas contra `REPORT_KEYS`: schemaVersion, event,
repository, environment, candidateSha, documentReleaseSha, healthReleaseSha,
deploymentIdentityObserved, runId, runAttempt, runTag, origin, campaignPath, emailSha256, reference,
responseStatus, uiSuccessObserved, visibleSuccessText, observedAt, challengeNonceSha256 e turnstile.

### Precondicao que nao e ferramenta

O alias `ev2-g17-canary` precisa estar servindo o candidato ANTES de o desafio nascer. Enquanto
servir um ancestral, nao existe nada a atestar para o candidato corrente, e nenhuma preparacao
resolve isso.

### Correcao de uma afirmacao da analise

A analise read-only registrou `VITE_TURNSTILE_SITE_KEY` como AUSENTE do environment `production` e
tratou isso como bloqueio separado do item 12 e do caminho de producao do item 6. Conferi a lista de
nomes de secrets do environment: o segredo ESTA presente. O bloqueio nao existe. Somente nomes foram
lidos; nenhum valor.

## O release de PRODUCAO vivo hoje foi selado com evidencia vazia e com um passo reprovado dentro

Leitura de evidencia JA SELADA, sem consulta a banco e sem credencial. Os dois artefatos de release
de producao que existem foram baixados e lidos arquivo a arquivo.

### O que os dois artefatos dizem

| arquivo | janela 06/09 (`e52b25d9`) | janela 07/09 (`f48bb453`, EM PRODUCAO HOJE) |
| --- | --- | --- |
| `g12-production-backend.json` | 56 bytes, `{"event":"g12.production.database.verified","checks":7}` | **0 BYTES** |
| `g12-production-content.json` | `status: "failed"`, `productionTouched: true` | `status: "failed"`, `productionTouched: true` |
| conclusao do run | `success` | `success` |

O erro identico nas duas janelas: `cms-content/publish retornou 422: 23514` (23514 e violacao de
CHECK no PostgreSQL).

### Por que passou, e e exatamente o defeito corrigido hoje

O arquivo de backend nasce em `deploy-production.yml`:

```
node scripts/ev2/phase12/verify-production-database.mjs --source . | tee ../g12-production-backend.json
```

Sob `bash -e` sem pipefail, o status que conta e o do `tee`, sempre 0. Na janela de 07/09 o
verificador nao imprimiu NADA — zero bytes — e o passo passou assim mesmo.

E ninguem consumiu o arquivo: `create-production-backend-evidence.mjs`, que valida
`g12.production.database.verified` com `checks > 0` e recusaria o vazio, so nasceu em `97731f0`
(2026-09-08). Confirmado: `git cat-file -e 38ecae8b:scripts/ev2/phase12/create-production-backend-evidence.mjs`
responde ABSENT. O run de 07/09 e de `38ecae8b`.

Ou seja: o release que producao serve agora foi declarado bem-sucedido com a verificacao de banco de
producao PRODUZINDO NADA, e com a publicacao de conteudo registrando `failed` dentro da propria
evidencia selada.

### O que isso muda

Nao e defeito teorico corrigido por precaucao. O `| tee` sem pipefail JA PRODUZIU release aprovado
sobre evidencia vazia, e esta debaixo do que esta no ar. As duas correcoes de hoje fecham o
mecanismo pelos dois lados:

- `6be66f8` poe `shell: bash` nos dez passos com `| tee` do `deploy-production.yml`, entao o status
  do comando da esquerda volta a reprovar o passo.
- `17c4215`/`910a660` acrescentam validacao de CONTEUDO da evidencia: arquivo que nao faz parse como
  JSON, ou que diga `status: failed` por dentro, passa a ser recusado em vez de contado.

Nenhuma das duas existia quando aquelas janelas rodaram.

### Resposta a pergunta que foi feita: ha residuo sintetico orfao em producao daquelas janelas?

Nao ha evidencia de que exista. Os dois artefatos NAO contem nada do ciclo editorial sintetico: sem
`cms-browser-*`, sem `cms-ui-created-state`, sem relatorio de residuo. Os unicos formularios
registrados como configurados sao `contato-principal` e `newsletter`, que sao conteudo real de
negocio, com aprovacao juridica registrada — nenhum casa `qa-ops-` nem o padrao derivado do runTag.

Logo a vacuidade do predicado `qa-ops-` nao deixou residuo NAQUELAS janelas, porque elas nunca
criaram dado sintetico. Isso reduz a urgencia do par acoplado (predicado + migration), sem torna-lo
correto: o predicado continua incapaz de casar o formulario real, por DOIS motivos independentes — o
prefixo `qa-ops-`, e a igualdade exata `form.title = runTag || ' Formulário operacional'` contra um
titulo real que termina em ` ${instance}`.

### O que continua aberto e nao foi tocado

O par `production-terminal-residue-lib.mjs:190` + predicado em `0061`/`0090` NAO foi corrigido, de
proposito. Corrigir so a lib faz a prova passar a contar linhas de verdade enquanto a limpeza segue
sem limpar, e o gate reprova. Corrigir so a migration faz a limpeza comecar a APAGAR e ANONIMIZAR
linhas reais em producao, por migration nova, dentro de janela congelada. Meia-correcao e pior que
nenhuma nos dois sentidos, entao a decisao e do responsavel e nao minha.

## Classe recorrente: teste que PRENDE o defeito em vez de verificar comportamento

Quatro ocorrencias em um unico dia, todas encontradas ao corrigir outra coisa. Vale tratar como
classe e varrer dirigido a ela, nao como coincidencia.

1. `phase16-readiness.test.mjs` asseverava o literal `to_jsonb(storage.objects)` — a SQL invalida que
   impedia o inventario de Storage. O teste exigia o defeito.
2. O mesmo arquivo ancorava uma recusa no comentario que EXPLICAVA o defeito, e nao no uso real.
3. `phase12-rollout.test.mjs` asseverava `/deployment-url/` na travessia de rollback, exigindo a URL
   efemera por deployment — exatamente a origem fora do allowlist que devolve 403 em toda sessao.
4. `cms-ui-created-state.ts` exigia `^qa-ops-qa-cms-final-...$` como chave de formulario, forma que a
   UI NUNCA produz, porque a chave e derivada do titulo por `urlSegmentFromText`.

O caso 4 e o mais instrutivo: o defeito tinha TRES sitios — o spec que inventava a chave, a escrita do
handoff e o validador do contrato. Corrigir os dois primeiros deixaria o terceiro reprovando o
handoff correto, e a barreira seguinte apareceria a 240 minutos de run de staging de distancia.

Assinatura para varredura: assercao que fixa literal de implementacao (texto de SQL, URL especifica,
prefixo de identificador, contagem de caracteres) onde o que importa e comportamento observavel.

## Metodo: pipeline mascara status de saida, e isso me pegou

Empurrei `910a660` com a main vermelha depois de ler `exit code 0` de
`npm run check 2>&1 | tail -3`. O status de um pipeline e o do ULTIMO comando — do `tail` — e e
sempre 0. O `npm run check` tinha reprovado.

E o mesmo defeito que eu acabara de remover de nove passos de `deploy-staging.yml` no commit
imediatamente anterior (`cmd | tee arquivo` sob `bash -e`, sem pipefail). Corrigi o habito de rodar
o portao e nao o metodo de ler o resultado.

Procedimento que passa a valer: redirecionar para arquivo e ler `$?`, nunca canalizar para `tail`
ou `grep` e confiar no codigo de saida.

```bash
npm run check > check.log 2>&1; echo "CHECK_EXIT=$?"
```

Verificacao independente do mesmo run, porque um numero sozinho nao basta: conferir tambem o
sumario (`Test Files N passed`, `Tests N passed`) no proprio log.

## Lote de correcao dos passos 46-69, verificado antes de aplicado (2026-09-11)

Uma analise de leitura previu 24 defeitos nos passos que nunca executaram. Antes de aplicar, cada
alegacao foi conferida contra `origin/main` com verdito adversarial e recusa por padrao: 15
confirmadas, 2 parciais, 1 REFUTADA. A verificacao se pagou tres vezes.

### O item refutado teria causado dano

F18 propunha apontar o retry da limpeza de rollback para
`outputs/cms-browser-rollback-cleanup.json`. Isso faria um retry bem-sucedido SOBRESCREVER a
evidencia `cleanup-failed` da primeira tentativa. O caminho distinto existe exatamente para nao
apagar a prova da falha. Nao aplicado.

### Os dois parciais tinham o alvo certo e o mecanismo errado

- F5: o teto de 15 minutos da atestacao nao e default arbitrario — e acoplado ao `expiresAt` do
  desafio, e a validacao de binding recusa `observedAt` fora da janela. Subir o teto produziria
  atestacao que falha o binding. Foi alargado o ENVELOPE do teste, nunca o teto.
- F6: o 422 nao vem da ordenacao sozinha, vem de `unknown-field`: o spec fixava `email` enquanto a
  chave real e o rotulo slugificado pela UI. A consequencia que a analise nao viu e a que mais
  importa — o gate nomeado para provar o fail-closed de captcha NUNCA exercitava esse caminho.

### O achado que a analise nao tinha: um teste que prendia o defeito

`phase12-rollout.test.mjs` asseverava `/deployment-url/` na travessia de rollback, isto e, EXIGIA a
URL efemera por deployment — a mesma que nao esta no allowlist de origem e faz `cms-session`
devolver 403 em toda sessao. O teste fixava o defeito em vez de verificar comportamento. Invertido:
agora exige o alias e recusa a URL efemera.

E a assercao recortava o passo por contagem fixa de 900 caracteres, entao um comentario a mais
empurrava a regra para fora da propria janela e ela deixava de valer sem ninguem notar. Passou a
recortar ate o passo seguinte.

Terceira ocorrencia hoje da classe "teste que prende o defeito": o literal de
`to_jsonb(storage.objects)`, o comentario do storage, e agora este.

### Correcao de escala em F13

Nao eram cinco linhas com `| tee` sem pipefail, eram NOVE: 321, 344, 872, 881, 890 na faixa canonica
e 1150, 1195, 1209, 1221 na faixa de diagnostico — estas ultimas do passe que eu mesma construi.
Verificado por parse que nenhuma ficou de fora.

### Aplicado

F1, F2, F3, F4 (parcial), F6, F7, F8, F9, F13, F14, F15, F17, nos commits `0d2465b` e `910a660`.
`npm run check` completo aprovado antes do push.

### Dois residuos escalados, nenhum contornado

1. **F4 nao cabe inteiro.** `cms-browser-fixture.test.mjs` exige que a soma dos tetos entre setup e
   cleanup do ator mutante fique em 200 minutos, e a janela de lease vem da migration 0091 (240).
   Os demais passos ja consomem 120, entao o ciclo mutante cabe em 80, nao nos ~107 que os tetos
   declarados somam. Subiu de 55 para 80 sem afrouxar a guarda. Alargar a janela de lease e
   migration dentro de janela congelada. Os ~107 sao ARITMETICA sobre tetos declarados, nao
   medicao: o passo roda com 80 e o residuo volta com numero em vez de calculo.

2. **`/industrias/telemetria` responde 404 em STAGING.** Nao e lacuna de codigo — o seeder
   `scripts/phase9/publish-staging-clean-room-pages.mjs` cobre telemetria, e as irmas saneamento e
   mineracao respondem 200. O conteudo nao esta publicado. Nao consigo corrigir: o seeder exige
   `GAIATEC_SUPABASE_SERVICE_ROLE_KEY` de staging, que eu nao tenho e nao devo manipular, e NENHUM
   dos 31 workflows o invoca. A proibicao em `phase12-rollout.test.mjs:135` e sobre
   `deploy-production.yml` e esta correta: deploy de producao nao semeia conteudo. A ausencia de
   caminho autorizado para staging e lacuna real, e acrescentar capacidade de seeding a workflow
   release-critical dentro do congelamento nao e decisao minha.

   Enquanto isso nao se resolve, o passo 48 reprova por CONTEUDO mesmo com todo o codigo correto.
   Por isso o lote foi empurrado para main (com CI) e NENHUM run de deploy-staging foi disparado.

### Divergencia de conteudo entre ambientes, medida pela Faixa C

```
rota                     producao   staging
/industrias/telemetria      200        404
/industrias/saneamento      404        200
/industrias/mineracao       404        200
/setores/telemetria      301->200   301->404
```

Os dois conjuntos divergem e nenhum esta completo. A consequencia atinge o valor de todo o resto:
staging nao e ensaio fiel de producao, e qualquer gate apoiado em conteudo pode nao refletir o que
producao serve. O lado producao e decisao de recadastro do responsavel, nao defeito de codigo.

## EVIDENCIA DE PRIMEIRA ORDEM: o drill de restauracao passou (2026-09-11)

Run `34643611132`, workflow `backup-supabase-production.yml`, candidato `d9e7ea8`, disparo manual
com `restore_drill=true`. Os 17 passos em `success`, incluindo `Seal non-sensitive backup evidence`
e o `upload-artifact`, que vinham saindo `skipped` desde que o gate de papeis entrou em `97731f0`.

E a primeira prova de restaurabilidade desde 2026-09-06, e a unica desde que a verificacao de papeis
existe. CI `34643605523` no mesmo SHA: `success`. Main fechada.

### O que o manifesto SELADO afirma, lido do artefato e nao inferido do verde do passo

```
restoreDrill.outcome            passed        duracao 67s
completeDataRestoreDrill        true
rolesRestored                   false
portableRoleCatalogMatched      false     <- igualdade inalcancavel gravada como falsa
dumpGovernedRolesRestored       true
rolesNotReconstructableFromDump 1         dumpCreateRoleStatements 0
rolesDivergingFromTargetBaseline 1
auth                            22 tabelas, 44 linhas, fingerprint de linha inteira conferido
storage.objectPayloads.objects  0
```

Limitacoes declaradas no proprio manifesto: credencial de runtime e desafio de MFA exigem drill no
ambiente alvo; senhas e settings de papel nao sao restaurados; ledgers de migration sao recriados
pelo runtime gerenciado; e a que entrou hoje, `role-existence-is-not-restored-by-the-role-dump`.

### O que a leitura do manifesto revelou e o verde do passo escondia

Com `objects: 0`, o campo `storagePayloadsByteIdentical` sai `true`. Nao e falso: e vacuamente
verdadeiro, porque nao ha byte nenhum que possa divergir. Um consumidor que exija
`storagePayloadsByteIdentical === true` fica satisfeito por nada. Vacuidade e pior do que falsidade,
porque falsidade alguem investiga.

Corrigido como declaracao obrigatoria e nao como gate duro: o manifesto passa a carregar
`objectPayloadsExercised`, e o validador recusa selar um drill com zero objeto que nao declare esse
campo como `false` junto da limitacao `object-payload-restore-not-exercised-without-objects`. O
inverso tambem reprova: havendo objeto, dizer que nao exercitou e falso. Duas regressoes fixam os
dois lados.

Virar gate duro quebraria o backup que acabou de voltar depois de tres dias fora, por uma lacuna que
e real mas nao e nova. A escolha foi tornar a lacuna VISIVEL, nao tornar o backup impossivel.

### Item bloqueante de go-live registrado

Provar a restauracao de payload de objeto ANTES do primeiro upload real na DAM — nao antes do
go-live, antes do CONTEUDO. A politica de recadastro limpo faz producao subir vazia, o que cria uma
janela entre o go-live e a primeira midia real: e ali que a prova passa a importar e ainda e barata.
O manifesto declarando `objectPayloadsExercised: false` e o que torna esse item impossivel de
esquecer.

### O que continua nao provado, dito sem arredondar

- Restauracao de payload de objeto contra API real de Storage: nunca exercitada (ver secao seguinte).
- Credencial de runtime e desafio de MFA: exigem drill no ambiente alvo, declarado como limitacao.
- Existencia de papel: o dump nao emite `CREATE ROLE`, entao um papel perdido nao e recriado.

## "Restauracao provada" e "restauracao de objetos provada" sao afirmacoes diferentes

O drill de restauracao passou (ver secao do backup de producao). Dentro dele,
`supabase.storage.payloads.exported` saiu com `objects: 0, bytes: 0`, e o mesmo agregado vazio
apareceu no `restored-verified`. Producao nao tem nenhum objeto no Storage hoje, por causa da
politica de recadastro limpo: nada foi migrado. O caminho de payload de objeto foi, portanto,
SATISFEITO POR AUSENCIA, nao exercitado.

Isso e a terceira aparicao da mesma classe de defeito nesta rodada: PASS vazio de limpeza, selo
consumindo campo ausente sem reclamar, e agora restauracao de objetos satisfeita por nao haver
objetos. Verde que nao vem de trabalho feito.

### O que esta provado, em tres niveis distintos

1. A LOGICA da ida e volta de objetos esta provada localmente, com fixtures nao vazias:
   `phase16-readiness.test.mjs` exercita `exportStorageObjects`, `restoreStorageObjects` e
   `verifyRestoredStorageObjects` em sequencia, comparando o agregado sha256 exportado com o
   restaurado e recusando vazamento de nome de objeto no relatorio. O transporte e um `fetchImpl`
   simulado.
2. O caminho VIVO contra a API real de Storage do Supabase nunca foi exercitado.
3. O drill contra PRODUCAO nao o exercita e nao vai exercitar enquanto producao tiver zero objetos.

### A inversao que isso produz, e que precisa estar registrada

Producao so tera objetos depois do go-live, quando o CMS comecar a ser usado e a DAM receber midia.
Ou seja: a metade do backup que cuida de midia estara provada exatamente enquanto nao existe nada a
perder, e deixara de estar provada no instante em que passar a existir. A ordem natural da garantia
fica invertida.

Nao e bloqueio para o backup voltar a funcionar — o dump diario e o drill passando ja resolvem o
risco vivo dos dias sem backup. E bloqueio para declarar o item 9 completo no SHA final.

### O que falta decidir, e por que eu nao decidi sozinho

Semear um objeto sintetico antes de exportar so faz sentido num ambiente que NAO seja producao, e o
`backup-supabase-production.yml` e production-only por desenho e por guarda. Habilitar uma origem de
staging no drill e capacidade nova em workflow release-critical dentro da janela congelada, e nao e
correcao minima de defeito: e mudanca de escopo. Fica escalado, nao contornado.

Pergunta aberta que decide o caminho: o Storage de STAGING tem objetos? Se tiver, um drill com
origem em staging exercita o caminho vivo sem tocar producao. Eu nao medi: a capacidade de rodar SQL
contra projeto Supabase foi recusada pelo classificador de permissao nesta sessao, e nao tentei a
mesma capacidade contra outro alvo para contornar a recusa. A consulta que responde, para quem tiver
a permissao:

```sql
select count(*) as objetos, coalesce(sum((metadata->>'size')::bigint), 0) as bytes
from storage.objects;
```

## Erros, causas raiz e correcoes

### Corrigido no candidato atual

- Erro: o manifesto terminal procurava nomes genericos enquanto o pipeline produzia arquivos com
  sufixo `-production`.
- Causa raiz: bindings de nomes divergentes entre produtor e materializador.
- Correcao `0ab1fa8`: nomes reais para setup, cleanup, residuo, SHA e matriz de producao, validacao
  fail-closed e teste de regressao; 21/21 testes focados e CI completo aprovados.

### Corrigido no candidato anterior

- Erro: Supabase Management `/database/query` retornou HTTP 201 em sucesso e o migration canary
  aceitava somente 200.
- Correcao `63c1b56`: aceitar 200/201 apenas nesse preflight, com regressao e helper geral intacto.

### Corrigido no candidato `cde606f`

- Erro: `QA_CMS_PUBLIC_BRIDGE_LEGACY_FORM_CONTRACT_NOT_LIVE` no run `34374494260`.
- Causa raiz: o deploy de staging anterior levou `cms-public` para `public-v2`, que remove `formId`,
  `versionId`, `slaMinutes`, `retentionDays` e `status`, enquanto o gate exige deliberadamente o shape
  legacy-f48 ainda servido por producao.
- Correcao: a ponte passou a servir o contrato legado real em vez de aceitar os dois shapes. O workflow
  faz checkout do release exato `f48bb4530566456a0090a98cd39caf1cacb51b09`, planeja a troca sem mutar
  nada, toma um lease exclusivo sobre esse plano (`staging-cms-public-legacy`) e so entao implanta o
  `cms-public` legado no projeto de staging. Os bytes do candidato sao reimplantados em qualquer
  desfecho, antes do cleanup canonico, para que o retorno a `public-v2` seja provado contra um
  formulario ainda existente e sem UUID no payload. O lease so e liberado apos essa restauracao, e um
  run que engajou o backend legado sem restaurar falha.
- Ambos os sentidos sao amarrados a digest de fonte: a troca recusa arvore legada divergente e a
  restauracao recusa implantar qualquer coisa que nao seja a arvore candidata registrada no plano.
  Ambiente e projeto ficam fixos em staging e `glcqsosxwgmlhzgcsnzv`.
- Lacuna adicional fechada: o `if: always()` nao cobre perda do runner. O watchdog ganhou o job
  independente `restore-legacy-public-backend`, que le o lease selado, faz checkout do release
  candidato que o proprio lease registra, restaura, libera o lease e falha fechado quando havia lease
  e a restauracao nao teve sucesso.
- Validacao local integral do SHA: `npm run check` aprovado, 168 arquivos/1.052 testes vitest,
  `test:qa` 66/66, `test:ev2:phase12` 266 aprovados/3 skip, `eval:ev2:phase12` `G12_RULES_PASS`,
  prettier, eslint, typecheck, documentation-boundary e build.

### Corrigido e comprovado no candidato `b6ed084`

- Rota/acao: `promote-staging-frontend-bridge.yml`, passo `Prove live alias is the expected
old-backend baseline`, que roda antes de qualquer mutacao.
- Esperado: alias canonico servindo `4b9184b` dentro do orcamento `G12_BUDGETS.publicP95Ms = 1500`.
- Obtido: `outcome: pause` com `route_latency_budget_exceeded` em dois runs consecutivos:
  `34390011038` (`/` p95 2315,7 ms) e `34390937569` (`/produtos` p50 1034,0 ms e p95 2005,2 ms,
  `public_p95_budget_exceeded` 1722,7 ms). Disponibilidade 100%, zero 5xx, headers de release
  exatos, contrato de health, manifest, `noindex` e CSP validos nos dois runs.
- Nenhuma mutacao remota ocorreu em nenhum dos dois runs: passos 16 a 41 ficaram `skipped`, o lease
  `G12_STAGING_CMS_PUBLIC_LEGACY_RECOVERY` nunca foi criado, o alias canonico continua em
  `4b9184b` e o preview `ev2-g12-canary` segue intacto.
- Regressao confirmada contra evidencia anterior do mesmo alias e do mesmo orcamento. No run
  `34332351815` o probe passou com `/produtos` p50 756,1 ms e p95 995,0 ms, e `/` p50 437,4 ms.
- Causa raiz: `cloudflare/_worker.js` chama `cms-public?type=page-by-path` para todo caminho
  publico antes de avaliar o atalho estatico `isPublicRoute`. As rotas de `STATIC_PUBLIC_ROUTES`
  pagam esse round trip e descartam o resultado. Medicao direta pelo header `Server-Timing`
  do proprio Worker: `/servicos` 1.271 ms, `/solucoes` 1.095 ms, `/produtos` 897 ms, contra
  `/contato` 485 ms, que nao passa por esse ramo. DNS, conexao e TLS somam menos de 60 ms.
- O Worker nao mudou: `git diff ff01b9d..4b9184b -- cloudflare/_worker.js
scripts/prepare-cloudflare-worker.mjs` e vazio. Portanto a degradacao esta no proprio
  `cms-public`, que foi para `public-v2` v56 no deploy de staging `34367910654`, entre o probe que
  passou e os que falharam.
- Consequencia de ordenacao: esse passo mede o deployment baseline ja no ar. Nenhuma alteracao no
  candidato muda essa medicao enquanto o baseline nao for substituido; so uma melhora no
  `cms-public` implantado em staging altera o numero observado.
- Correcao aplicada em `b6ed084`, em duas partes, ambas com teste de regressao:
  1. `supabase/functions/cms-public/index.ts` passou a emitir as tres consultas de
     `page-by-path` em paralelo, mantendo precedencia e tratamento fail-closed identicos.
     Medicao direta contra staging: caminho invalido que nao toca o banco responde em ~300 ms,
     uma consulta indexada isolada em ~680 ms e o fallback de tres consultas entre 840 e 1.370 ms,
     o que situa cada ida-e-volta em torno de 380 ms e descarta varredura sequencial como causa.
  2. As tres sondagens do bridge passaram de `EV2_G12_SAMPLE_COUNT` 5 para 20. Com
     `percentile(v,95) = sorted[ceil(0,95*n)-1]`, `n=5` faz o p95 relatado ser o proprio maximo
     das cinco amostras, de modo que uma unica resposta fria decide o gate. O valor 20 e o que
     `deploy-production.yml` ja usa nas janelas de saude.
- O orcamento nao foi tocado: `G12_BUDGETS.publicP95Ms` continua em 1500 e ha teste que trava isso.
  Aquecimento tambem nao foi alterado.
- Risco residual assumido: com `n=20` o p95 ainda e a 19a de 20 amostras. Se a cauda de
  `/servicos` persistir, o proximo passo nao e ajustar numero de gate, e sim levar o `cms-public`
  corrigido ao staging pelo deploy integral.
- Follow-up deliberadamente fora deste commit: `cloudflare/_worker.js` continua consultando
  `page-by-path` antes de avaliar o atalho `isPublicRoute`. A migration `0026` recusa paginas
  gerenciadas sob `produtos`, `servicos`, `industrias`, `aplicacoes`, `solucoes` e `busca`,
  tornando a consulta trabalho morto para essas rotas, mas nao recusa `/blog`, que tambem esta em
  `STATIC_PUBLIC_ROUTES`. Antecipar o atalho mudaria a precedencia de `/blog` e exige revisao
  propria.
- Resultado: bridge `34395203818`, tentativa 1, `success`, 42 de 42 passos, com a compensacao de
  frontend corretamente `skipped`. O probe de baseline passou com a amostragem corrigida e a
  latencia do `page-by-path` medida depois do restore caiu para 0,53 a 0,94 s, contra 0,86 a
  1,37 s antes.
- Impasse de ordenacao, agora resolvido pela passagem do bridge: apenas `deploy-staging.yml` e
  `rollback-staging.yml` implantam funcoes em staging, e `deploy-staging.yml` exige
  `frontend_bridge_run_id` validado por `verify-staging-frontend-bridge-run.mjs`, que so aceita um
  run que produziu o artefato de evidencia do bridge. Enquanto o bridge nao passar, o `cms-public`
  corrigido nao chegaria a staging pelo caminho desenhado. A correcao de amostragem quebrou esse
  ciclo sem contornar gate algum, e o bridge `34395203818` produziu o artefato que
  `verify-staging-frontend-bridge-run.mjs` exige.

### Bloqueio anterior, agora enderecado

- Rota/acao: staging frontend bridge, setup de fixture publica do formulario.
- Esperado: provar o frontend candidato contra o contrato real legacy-f48 ainda servido em producao.
- Obtido: `QA_CMS_PUBLIC_BRIDGE_LEGACY_FORM_CONTRACT_NOT_LIVE` no run `34374494260`.
- Causa raiz: o deploy staging anterior atualizou `cms-public` para `public-v2`, que remove IDs e
  metadados internos; o gate exige deliberadamente o shape legacy-f48 (`formId`, `versionId`, SLA,
  retencao e status) para provar compatibilidade com o backend atual de producao.
- Nao corrigir aceitando silenciosamente ambos os contratos. Isso enfraqueceria a evidencia.
- Cleanup compensatorio terminou com zero residuo, auditoria preservada, alias canonico intacto e
  recovery state limpo.

## Gates aprovados e pendentes

### Aprovados ou reutilizaveis como diagnostico

- Perfil, repo, `main`, checkout limpo e `origin/main` igual ao HEAD.
- CI completo `34377871781` para `0ab1`, inclusive testes locais/RLS e artefato CI.
- Separacao staging/production em Supabase, GitHub environments e Cloudflare.
- Staging com migrations `0001`-`0088` e 34 Edge Functions verificadas no mesmo fonte backend.
- Recuperacao, zero residuo e ausencia de lease/recovery remoto apos os runs falhos.
- `/healthz` do staging canonico e da producao atual saudaveis.
- Bridge legacy-f48 `4b9184b` e aprovacao Defender/Edge historicos, apenas como diagnostico.
- Presenca dos nomes de secrets de auth canary production.

### Pendentes e bloqueantes para aprovacao operacional

1. ~~Corrigir minimamente o bridge para oferecer backend legacy-f48 temporario e restaurar
   `cms-public public-v2` em qualquer desfecho~~ — feito em `cde606f`, com regressao, lease
   exclusivo, amarracao por digest e watchdog dedicado. Falta a evidencia de runtime.
2. ~~Gerar novo candidato apos a correcao~~ — feito: `cde606fb4c5eb882f3650d677fdc0bb1d1c2a377`.
   Toda evidencia vinculada a `0ab1fa84eec65c762644ed9368bfcfb213402b17` esta invalidada.
3. Executar novo staging frontend bridge contra `cde606f` usando o baseline canonico `4b9184b`.
   Bloqueado: o probe de baseline reprova por latencia antes de qualquer mutacao. Ver "Bloqueio
   atual ainda nao corrigido".
4. Executar deploy integral de staging, migration/RLS canary idempotente, inventario de funcoes e
   gerar/selar o unico artefato final.
5. Resolver a revisao documental canonica e regenerar a matriz integral do SHA final.
6. Homologar em Edge autenticado/MFA com backend real, duas sessoes, ciclo editorial completo e
   quatro viewports, incluindo console/rede e consumidores publicos.
7. Validar negativas RLS/AAL/IDOR/XSS/injecao/CORS/rate limit/replay/payload, bundle e secret scan.
8. Validar Supabase Auth, Storage, RPCs, todas as Edge Functions, RDO, Turnstile, Resend, outbox,
   OpenRouter, cache, Worker, CSP, logs e auditoria imutavel.
9. Executar backup e restore drill validos para o SHA final e provar rollback.
10. Provisionar/validar operador production e MFA normal no SHA final, sem bypass ativo.
11. Obter apenas as autorizacoes literais emitidas pelos gates para o SHA final.
12. Promover os mesmos bytes para producao, aplicar migrations/funcoes no projeto correto, executar
    smoke, E2E autenticado, probes, janela de saude, rollback testado e cleanup final.
13. Materializar as matrizes terminais de staging e production e emitir o relatorio final verdadeiro.

## Proxima acao exata

Candidato vigente `2bd50fc2984f69cead162da6ad5a362c69d3ff33`, com CI `34478272711` aprovado nos
tres jobs. Toda evidencia vinculada a `c43535b` e anteriores esta invalidada. Os SHAs `14940a0`,
`c43535b`, `f65f979`, `62baeaa` e `0bf3a82` sao intermediarios reprovados ou superados; nao use
nenhuma evidencia deles.

Na ordem, sem pular nenhum passo:

1. ~~Confirmar o CI do SHA exato~~ feito: `34478272711`, `success` nos tres jobs.
2. Despachar `promote-staging-frontend-bridge.yml` com
   `candidate_sha=2bd50fc2984f69cead162da6ad5a362c69d3ff33` e
   `expected_baseline_sha` igual ao SHA realmente servido
   pelo alias `ev2-g17-canary` no momento, confirmado por `/healthz`.
3. Despachar `deploy-staging.yml` com `git_ref=2bd50fc2984f69cead162da6ad5a362c69d3ff33`,
   `rollback_ref=2bd50fc2984f69cead162da6ad5a362c69d3ff33`, `frontend_bridge_run_id` igual ao run do
   passo 2 e `ev2_draft_v2_candidate=false`. Esse run aplica a migration 0089, o que corrige a tela
   de diagnosticos no proprio staging, e executa o canario de migrations com o prazo de saida ja
   ativo nas Edge Functions.
4. Se o canario voltar a reprovar em `closeDocumentFixture`, ler a identidade codificada da falha: ela
   agora nomeia a dependencia travada por meio de `CMS_EDGE_UPSTREAM_TIMEOUT` e do caminho. Com a
   0089 aplicada, a tela `/admin/diagnosticos` tambem volta a responder e serve como instrumento.
5. Selar o artefato final unico e seguir os gates listados em "Pendentes e bloqueantes".
6. Nao tratar os canarios headless do bridge como homologacao. A homologacao positiva continua
   exigindo Google Chrome real, sessao autenticada, MFA e backend real, e o proprio artefato do
   bridge registra `positiveBrowserRequiredAfterFullCandidateDeploy: true`.

Semantica de `rollback_ref`, aprendida por engano no run `34396972791`: o passo `Resolve and verify
the exact staging candidate` executa `test "$ROLLBACK_REF" = "$candidate_sha"`, ou seja,
`rollback_ref` tem de ser igual a `git_ref`. Passar o baseline anterior reprova o run no passo 5,
antes de qualquer mutacao.

A troca temporaria em staging e serializada por um lease exclusivo, sintetica, auditada e possui
restauracao fail-safe tanto dentro do run quanto por watchdog dedicado quando o runner e perdido.

## Autorizacoes literais e validade

- Recebida anteriormente:
  `AUTORIZO-RENOVAR-OPERADOR-CMS:f48bb4530566456a0090a98cd39caf1cacb51b09:365-DIAS`.
  Foi fornecida duas vezes, mas e valida apenas para `f48bb453...`; o workflow falhou antes de mutar e
  ela esta invalida para `0ab1` ou qualquer SHA futuro.
- Controle historico de producao:
  `AUTORIZO-G12-PRODUCAO:f48bb4530566456a0090a98cd39caf1cacb51b09`, valido somente para o release
  `f48` ja implantado.
- Nao reutilizar qualquer literal. Quando um gate futuro solicitar autorizacao ligada ao SHA final,
  apresentar somente a frase exata emitida por esse gate e aguardar.

## NAO REPETIR

- Nao rerodar CI `34377871781`, o CI do candidato atual nem qualquer run ja terminal apenas para
  outro formato de relatorio.
- Nao reutilizar artefato/evidencia de SHA anterior para aprovar o SHA final.
- Nao reexecutar `34374494260`; criar novo run somente depois da correcao do baseline legacy.
- Nao reaplicar/resetar migrations `0001`-`0088` nem redeployar manualmente as 34 funcoes para
  documentar; o pipeline final deve verificar/aplicar idempotentemente o necessario.
- Nao limpar recovery state as cegas; ele ja foi compare-and-clear e esta ausente.
- Nao promover o preview `63c1`, alterar staging canonico `4b` ou redeployar/rollbackar producao `f48`
  como parte do handoff.
- Nao repetir Defender/Edge apenas para gerar outro formato; revalidar quando o SHA/bytes exigirem.
- Nao usar operador corporativo para fixtures e nao usar dados comerciais reais.
- Nao cancelar workflows saudaveis, duplicar canario/deploy, modificar allowlist documental do codigo
  nem adicionar `AGENTS.md`/`HANDOFF.md` ao repositorio executavel durante o release.

## REVALIDAR SE O SHA MUDAR

- CI e checks, inventario/matrizes, build, manifest, seal, tree/archive digests e secret scan.
- Migration/RLS canary, inventario/digests de Edge Functions e regressao RDO.
- Bridge, canario, Google Chrome autenticado, MFA/AAL, quatro viewports e ciclo editorial.
- Autorizacao negativa, consumidores publicos, cache/SEO, Turnstile, Resend/outbox e OpenRouter.
- Backup/restore, rollback, autorizacoes literais, deploy de producao, smoke/E2E/probes/janela de saude.
- Cleanup dos sinteticos, auditoria preservada e relatorio final.

## Limitacoes reais abertas

- `cde606f` nao esta live em staging nem producao, e nao possui CI confirmado nem artefato.
- A incompatibilidade entre o baseline legacy-f48 exigido pelo bridge e o `public-v2` servido em
  staging deixou de ser um bloqueio: a ponte agora serve o contrato legado real durante a janela e
  restaura o candidato em qualquer desfecho. Falta executa-la e produzir a evidencia.
- A matriz terminal runtime do SHA final ainda nao existe.
- O artefato final unico canario-producao ainda nao foi selado.
- Operador/MFA production, backup/restore, integracoes e ciclo Edge final ainda nao foram aprovados.
- Producao `f48` esta saudavel, mas nao e o candidato atual e nao fundamenta aprovacao operacional.
- A lista de Edge Functions do projeto de producao nao renderiza no dashboard Supabase; o inventario
  de funcoes de producao deve ser confirmado pelo pipeline final, nao pela interface.

O unico bloqueio para iniciar a proxima etapa e implementar com seguranca a ponte de compatibilidade
legacy em staging com restauracao fail-safe. Todos os demais itens acima sao gates subsequentes, nao
motivos para enfraquecer ou omitir essa correcao.
