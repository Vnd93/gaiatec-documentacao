---
id: gaiatec-catalogo-resiliencia-editorial-seguranca-2026-09-30
titulo: Resiliência editorial, dependências e G17 canônico em staging
status: g11-latencia-reprovada-recuperacao-comprovada-pendente-chrome
tipo: registro-de-execucao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-09-30
ultima_revisao: 2026-10-05
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - registro-modelo-gratuito-zdr-2026-09-29.md
  - registro-integracao-fatias-1-a-4-2026-09-28.md
  - backlog-executavel-fatias-1-a-4-2026-09-24.md
  - lista-nominal-prioritaria-cat-d009-2026-09-24.md
  - ../../00-indice/status-atual.md
---

# Resiliência editorial e homologação controlada de staging

## Resultado vigente — retomada de 5 de outubro de 2026 no mesmo `7efbedb`

Não foram reiniciadas as Fatias 1–4 nem reconstruídos os artefatos. GitHub `Vnd93`, holder original
explicitamente registrado, ambos os repositórios canônicos limpos em `main`, fetch e fast-forward
confirmados. Os cinco estados não terminais de workflows estavam vazios em ambos os repositórios,
sem fences, leases QA ativos ou operação de banco concorrente. TTL não foi usado como autorização.

O fato novo que justificou uma única revalidação foi a
[mitigação de rede informada pelo Supabase](https://status.supabase.com/incidents/w91bvbjhqf0f)
em 01/10 às 20:23 UTC, posterior ao run anterior. A atualização de 02/10 às 21:06 UTC ainda
relata casos de latência elevada: não foi presumida resolução completa nem causa exclusiva.
Nenhum upgrade pago, mudança regional, mudança de runtime Node/CLI ou alteração de Auth/RLS
foi realizado. Após a nova reprovação, não houve segundo disparo.

### Checkpoints reutilizados e execução única

SHA de controle/candidato/rollback: `7efbedb41e7141a628ceab8fe03beeb17bb340ff`. Os validadores
do repositório aprovaram novamente CI `36794205281`, tentativa 1; pacote `11133348365`, ainda
válido; ponte `36794950630`, tentativa 1; prova `11134025233`; e deployment
`54fc78bb-8cde-461b-9fa9-ae67ac2c7907`. Os digests históricos abaixo continuam os mesmos.
Health de staging retornou 200 com SHA exato. O Chrome real estava autenticado e exibiu o estado
de preparação/default-off, mas essa observação não substitui o challenge ou UAT.

O [canônico 37350070838](https://github.com/Vnd93/gaiatec-cms/actions/runs/37350070838), tentativa 1,
foi disparado uma vez, usando o pacote original e a ponte existente. Perfil `full-release`,
snapshot live novo, CAS, faixa de mutação exclusiva e recovery durável antes de qualquer mutação
permaneceram obrigatórios. Não houve alteração de código ou rebuild.

| Etapa                             | Resultado                               | Duração               |
| --------------------------------- | --------------------------------------- | --------------------- |
| Preflight                         | verde                                   | 36 s                  |
| Validação de fonte                | verde, paralela à validação live        | 79 s                  |
| Validação do baseline live        | verde                                   | 124 s                 |
| Deploy serial                     | reprovado no G11                        | 686 s                 |
| G11/janelas G12, dentro do deploy | interrompido pelo orçamento de comandos | 130 s                 |
| Finalizer                         | recuperação e evidência terminal verdes | 187 s                 |
| Métricas                          | verde                                   | 11 s                  |
| Canônico até atualização terminal | 17:39:34–17:57:15 UTC                   | 1.061 s               |
| Watchdog `37352296308`            | verde; compensação adicional skipped    | 17:57:17–17:57:38 UTC |

O relatório de métricas foi capturado aos 1.056 s, antes de sua própria finalização. O run anterior
levou 904 s; a diferença de 157 s não mede melhora/regressão do caminho feliz, pois ambos pararam
antes de completar a cadeia. O SLO segue `component-only`/`non-happy-path`, sem comprovação de
release completo em 40–60 minutos. Jobs paralelos e etapas internas não devem ser somados novamente.
Pós-deploy, Chrome e evidência de aprovação ficaram skipped; o challenge não foi emitido.

### G11 e diagnóstico sanitizado

Leitura: p95 servidor **156 ms / limite 500 ms**, p95 externo 415 ms. Comandos: p95 servidor
**5.241 ms / limite 800 ms**, p95 externo 30.038 ms. Disponibilidade 100%, outbox lag 0,
auditoria 100%, RPO 0 e RTO 1 minuto. A reprovação `measurement_requires_independent_review`
foi preservada. Amostragem original: 20 warmups e 20 leituras medidas; dez comandos seriais,
uma mutação e nove replays idempotentes, todos HTTP 200, sem descarte ou retry.

Série completa dos comandos, em ms: `493, 449, 369, 364, 511, 564, 236, 194, 395, 5241`.
Na décima amostra: autenticação **4.984 ms**, RPC **241 ms**, rate limit **11 ms**, núcleo SQL
**35 ms**, duração externa **30.038,35 ms**. Diferentemente da oitava amostra do run anterior
(RPC 5.257 ms), a demora medida agora se concentra antes da operação de banco. Isso não prova
que as duas falhas tenham a mesma causa.

Revisão de `cms-leads`, `cms-auth` e `cms-edge-fetch` no candidato exato: o tempo de autenticação
inclui `getUser(token)` real; não há retry local nesse caminho. `boundedFetch()` usa deadline de
30 s, com repetição idempotente desabilitada por padrão; o canário também não repete a chamada.
Não substituir a validação remota por claims em cache, reduzir controles, descartar a amostra lenta
ou aumentar o orçamento para aprovar o gate.

Consultas somente leitura usaram exclusivamente o stream unificado `query_logs`, sem dependência
de endpoints de logs removidos. Janela 17:50–17:54 UTC: 27 registros Auth `/user`, todos HTTP 200,
maior duração do handler 123,780639 ms e p95 116,253994 ms. A unidade foi conferida no
[logger oficial do Auth](https://github.com/supabase/auth/blob/ce9a8eee0cc042be8c7a42981a7ddae631e41d91/internal/observability/request-logger.go),
que registra `elapsed.Nanoseconds()`. Isso é evidência agregada, não correlação individual com a
décima amostra nem confirmação da versão hospedada do Auth. Entre 17:51:30 e 17:53:10 UTC, os
34 logs Auth, 225 logs de funções e sete de Postgres consultados não continham menções a timeout,
limite de CPU ou memória. Ausência de mensagem não exclui fila/latência de infraestrutura.

**Causa exclusiva não demonstrada.** O tempo externo, a autenticação observada pela Edge e os
handlers registrados pelo provedor medem fronteiras diferentes. Não subtrair esses agregados para
afirmar tempo de rede exato. O próximo diagnóstico útil é a correlação do provedor na janela
17:51:30–17:53:10 UTC: gateway/PoP, encaminhamento Edge→Auth, fila/espera e duração do handler.
Fornecer somente SHA, run, janela UTC e métricas deste registro; nunca tokens, cookies, usuários
sintéticos, payloads ou logs brutos. Nenhum chamado externo foi enviado nesta sessão.

### Recuperação e custódia das evidências

Finalizer `111904400325`: 74 checks de banco, 114 migrations/última `0114`, configuração Auth e
signup público desabilitado verificados; inventário de funções reconciliado sem nova mutação nessa
reconciliação; secrets preservados sem valores divulgados. O
[watchdog 37352296308](https://github.com/Vnd93/gaiatec-cms/actions/runs/37352296308) confirmou
o estado terminal seguro e dispensou compensação adicional.

Sonda terminal: **82 respostas, 100% de disponibilidade, zero 5xx, p95 público 786,767 ms**;
todos os budgets por rota, SHA em headers/manifesto/health, CSP e noindex passaram, sem violações.
Após recovery: 114 migrations, flag global desligada, zero overrides/produtos/snapshots do catálogo,
leases QA ativos, queries concorrentes ou lock waits. Nova leitura às 18:08:13 UTC, conforme o
timestamp retornado pelo banco, confirmou os mesmos contadores. GitHub sem workflows não terminais
ou fences. Produção, carga/publicação comercial e cutover não foram tocados.

| Evidência                         | Artefato      | SHA-256 do arquivo verificado localmente                           |
| --------------------------------- | ------------- | ------------------------------------------------------------------ |
| Terminal/recovery                 | `11362602801` | `80fac1cac29ac1a9bd52231265f6eeef3693afadbea57bf83d5d06ac3506403b` |
| Preliminar, incluindo vetores G11 | `11363001127` | `72cf467a1dae2d7203fc56f782ccb119405923481f1bab9e44f3a8c1edd3f144` |
| Métricas por etapa                | `11363151718` | `3b4a93950dfd436fcbb36a9c831d90c207e34d4d2ca7e776a301f2c664fb1c9c` |

Os arquivos estão preservados no diretório ignorado
`gaiatec-cms/outputs/catalog-staging-7efbedb-37350070838-evidence`; nenhum payload bruto foi
adicionado ao Git. Recuperação verde não transforma o canônico reprovado em homologação.

### Continuidade sem reiniciar trabalho concluído

1. Obter correlação do provedor ou outra evidência material que sustente uma correção. Não repetir
   CI, ponte ou canônico apenas para encontrar uma janela favorável. Qualquer mudança de SHA/bytes
   invalida os gates dependentes; checkpoint independente só é reutilizável após nova verificação.
2. Depois de corrigir/comprovar estabilidade, revalidar holder, ausência de operações e fences,
   SHA/digests/deployment/snapshot. Só então executar uma nova validação canônica controlada.
3. Com gates automáticos verdes, executar challenge just-in-time, Chrome real autenticado,
   captação positiva e suas verificações, cleanup e evidência terminal. A sessão Chrome atual,
   sozinha, não satisfaz esse gate.
4. CAT-001–010 seguem `ready-for-gate`. CAT-011 depende dos originais/mídias autorizadas e da
   recaptura/aprovação nominal; CAT-012 depende de UAT e rollback reais, com fixture, recuperação
   e proveniência próprias. Não confundir o inventário de cobertura com execução de UAT.

Não há pendência genérica de permissão de staging, de um segundo papel de aprovação ou do
fabricante Tmeasurement. Itens 17/18 continuam provisórios; CAT-D010 permanece adiado.
A consulta da automação `cms-organiza-o-p-s-handoff` retornou somente o cartão, e seu registro
local não foi encontrado; pausa **não confirmada**, sem recriar agendamento ou sobrescrever campos
desconhecidos. Se ainda estiver ativa, deve ser pausada no cartão enquanto houver esse bloqueio.
O sistema continua sem homologação final; não foi declarado pronto para produção.

## Registro histórico preservado — `7efbedb` em 1º de outubro, G11 reprovado e recuperação comprovada

Checkpoint de 01/10/2026, 00:58 UTC, ainda 30/09 em São Paulo. As Fatias 1–4 e as correções
anteriores não foram reiniciadas. O código da aplicação não mudou durante este diagnóstico.

### Cadeia do candidato e tempos reais

SHA de controle/candidato: `7efbedb41e7141a628ceab8fe03beeb17bb340ff`.

| Etapa                  | Execução                                                                                  | Resultado                                                                                         | Duração                               |
| ---------------------- | ----------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------- |
| CI                     | [36794205281](https://github.com/Vnd93/gaiatec-cms/actions/runs/36794205281), tentativa 1 | Sete jobs verdes; 67 arquivos/2.154 testes pgTAP; browser 65 aprovados e 39 skips previstos       | 378 s                                 |
| Ponte de staging       | [36794950630](https://github.com/Vnd93/gaiatec-cms/actions/runs/36794950630), tentativa 1 | Pacote original promovido; backend restaurado; três provas public-v2 HTTP 200 e cleanup aprovados | 552 s                                 |
| Canônico               | [36795885719](https://github.com/Vnd93/gaiatec-cms/actions/runs/36795885719), tentativa 1 | G11 comandos reprovado; dependências/Chrome não executados                                        | 904 s, incluindo finalização/métricas |
| Job de deploy canônico | `110159751766`                                                                            | Reprovado antes de Chrome                                                                         | 594 s                                 |
| Finalizer              | `110162344931`                                                                            | Recuperação e prova terminal aprovadas                                                            | 145 s                                 |
| Watchdog               | [36797142872](https://github.com/Vnd93/gaiatec-cms/actions/runs/36797142872)              | Verde; compensação adicional dispensada pelo estado terminal                                      | Sem nova mutação                      |

CI: 00:03:14–00:09:32 UTC; ponte: 00:11:58–00:21:10 UTC; canônico:
00:22:51–00:37:55 UTC. A duração menor do canônico que os 2.076 s do run anterior **não é ganho
de desempenho**: ele parou antes. O SLO de caminho feliz 40–60 minutos continua sem comprovação
para esta entrega; a etapa limitante observada é G11 comandos, não o Chrome.

- Pacote `11133348365`, SHA-256
  `57a5bcbd4f214a4568517b63d4e663781de3b37b1004109e913d57b65e970cf4`.
- Seleção de perfil `full-release`, artefato `11133183636`, SHA-256
  `1d1daf07b4ea57176f4709674adb9586dc00faad7c8ca5e647b251b79adc4393`.
- Deployment de staging `54fc78bb-8cde-461b-9fa9-ae67ac2c7907`; nenhum rebuild equivalente.
- Prova da ponte `11134025233`, SHA-256
  `2bb5be70ab2f95f926b6940aefacc2fd88a5bbfbd40468979e9f858ec27870e4`.
- Restauração da ponte `11133856297`, SHA-256
  `53d8b34f26fe96c2e388bff33f143f19575d8cf2e421100ee1f56c4043a52910`.
- Evidência preliminar canônica `11133584246`, SHA-256
  `ec398d6ed90711c1a3661e5587ac25692acae734153ac56ed0638004fcd165f1`.
- Evidência terminal `11134650148`, SHA-256
  `bac2352646e1f25e42877c044d8f9728326ab5e3e0e701129899e3bd6b34cad3`.

Os arquivos locais de seleção, prova/restauração, preliminar e terminal tiveram seus digests
comparados com os artefatos remotos. Nenhuma aprovação dependente foi herdada de outro SHA.

### Falha e limites do diagnóstico

G11 leitura p95 **137 ms**, orçamento 500 ms. Comandos p95 **5.366 ms**, orçamento 800 ms.
A amostragem serial preservou uma mutação e nove replays idempotentes, sem retries ou exclusão
de observações. Série de comandos, em milissegundos:
`600, 405, 364, 201, 182, 436, 218, 5366, 2644, 1387`.

Na oitava amostra: servidor 5.366 ms, autenticação 104 ms, RPC 5.257 ms, rate limit 259 ms,
núcleo SQL 1.637 ms e duração externa 5.692,54 ms. Há tempo elevado dentro e fora do núcleo SQL;
não é correto atribuir tudo à rede do navegador. Checks funcionais/segurança e cleanup da fase
passaram; não houve nova tempestade SQLSTATE `40001` nem cron multissegundo no intervalo.
Leitura, cache cumulativo, ausência de locks após o run e os checks funcionais não aprovam o
orçamento reprovado de comandos.

O [incidente oficial do API Gateway no leste dos EUA](https://status.supabase.com/incidents/w91bvbjhqf0f)
continuava aberto, com última atualização em 30/09 às 21:26 UTC. O provedor descreve latência
intermitente para clientes nessa região. Há coincidência temporal, mas não prova de causa única.
O projeto de staging permanece em `us-east-2`; não houve migração de região ou upgrade de plano.

A mensagem `Thread killed by timeout manager` do PostgREST não prova falha de consulta:
o [registro primário do PostgREST](https://github.com/PostgREST/postgrest/issues/4799) explica
sua ocorrência em operação normal e a correção de logging. Métricas de infraestrutura consultadas
em Chrome real, somente leitura, não demonstraram saturação sustentada de CPU, IOPS ou conexões.
Swap/comprometimento de memória e estatísticas acumuladas são sinais para investigação, não
justificativa isolada para alterar recursos, descartar amostras ou otimizar uma query sem prova.

### Recuperação e próximo passo verificável

Finalizer: 74 checks de banco, 114 migrations/última `0114`, configuração Auth verificada,
signup público desligado, funções reconciliadas, secrets preservados e zero valores divulgados.
Prova terminal: 82 respostas, disponibilidade 100%, zero 5xx, p95 público **590,213 ms**,
headers/manifesto/SHA exatos, CSP/noindex válidos e nenhuma violação. Watchdog verde, sem
compensação adicional. O challenge Chrome não foi emitido e nenhum watcher novo foi iniciado.

Após a recuperação: GitHub `Vnd93`, mesmo holder, fetch/fast-forward, ambas as árvores canônicas
limpas e iguais a `origin/main`; zero workflows nos cinco estados não terminais e zero fences.
Consulta de staging às 00:58:17 UTC: `ev2.catalog_v1=false`, zero overrides, produtos, snapshots,
leases QA ativos, queries concorrentes e lock waits. Produção permanece intocada.

Não repetir CI, ponte ou canônico por tentativa e erro. Antes de um novo canônico, exigir mudança
material no diagnóstico ou recuperação comprovada do provedor, confirmar todo o estado remoto e
reavaliar a validade dos checkpoints por SHA/digest/deployment/snapshot. Só checkpoints independentes
ainda válidos podem ser reutilizados; conservar o pacote selado, um escritor, recovery prévio e
todos os budgets. Chrome real just-in-time continua obrigatório após os gates automáticos.

CAT-001–010: `ready-for-gate`; CAT-011: recaptura/aprovação nominal; CAT-012: UAT/rollback.
O [índice de fontes nominais](lista-nominal-prioritaria-cat-d009-2026-09-24.md) registra pesquisa
e ambiguidades sem carga, publicação, aprovação fictícia ou fonte mista. Não há nova pendência de
definir papel de aprovação ou fabricante Tmeasurement. Itens 17/18 seguem provisórios; CAT-D010
continua adiado até os ciclos manuais estáveis. **O sistema ainda não está homologado como concluído.**

## Registro histórico preservado — recuperação de `9719f52` e regressão no motor do navegador

### Execuções e artefatos exatos

- [CI 36786871713](https://github.com/Vnd93/gaiatec-cms/actions/runs/36786871713): verde,
  482 s; sete jobs, 67 arquivos/2.154 testes pgTAP, incluindo as sete regressões de recovery.
- Pacote único `11130611711`, SHA-256
  `5a2735c55d82b3974a4602c2bd5450010ad337f821ada541a413c54f6cec6265`, produzido pelo CI para
  `9719f52d756ba447751398238b2e9dab61df02dc`.
- [Ponte 36787751031](https://github.com/Vnd93/gaiatec-cms/actions/runs/36787751031): verde,
  610 s, sem rebuild, deployment `ca57dc36-6359-4c92-a8fb-5f65c7b7fb9b`. Backend restaurado na
  versão 535, três provas HTTP 200/public-v2, cleanup e resíduo aprovados.
- Prova da ponte `11130089504`, SHA-256
  `b786254013baa871db915ddc109de1efedc6767f134f0a1ee7ba15fbbb95934a`; restauração `11129999687`,
  SHA-256 `1dcaa9ef5d4e4d3d2b56fc930561f607a13a7c0fd0c57ad19e2cb0730ef13ea6`; arquivos locais verificados.
- [Canônico 36789268672](https://github.com/Vnd93/gaiatec-cms/actions/runs/36789268672):
  23:05:56–23:40:32 UTC, 2.076 s incluindo recuperação. Deploy verde em 1.137 s, G11 29/29
  (leitura 104/500 ms; comandos 355/800 ms), G7 aprovado, ambos os gates pós-deploy verdes.
  O gargalo terminal foi a localização de um campo no teste editorial; não houve challenge Chrome.

### Falha, diagnóstico e recuperação

`getByLabel("Valor", { exact: true })` encontra zero controles para o `select` booleano:
o Playwright inclui o texto das opções na busca por rótulo, diferentemente do React Testing Library.
O papel acessível `combobox` com nome exato `Valor` encontra um controle. Reprodução no componente
real em Chromium: quatro tipos passaram e o booleano falhou antes da correção.

O ciclo de autenticação passou. O cleanup de ambos os atores e do rendezvous passou sem reparação
manual; o finalizer marcou o recovery de navegador `already-terminal`. O watchdog `36792304154`
terminou verde, sem compensação adicional. Artefato terminal `11132346032`, SHA-256
`40ad42815919b34a52e12cf80ac1a57c5a51fecae6ff1077276db1bf0cb9dea9`, baixado e verificado:
82 respostas, 100% disponibilidade, zero 5xx, p95 649,283 ms, SHA/headers exatos e nenhuma violação.

Após o estado terminal: Vnd93, fetch, ambas as árvores limpas em main/origin, zero operações nos
cinco estados não terminais, zero fences, 114 migrations, catálogo default-off e vazio, zero leases
QA ativos, queries concorrentes e lock waits. O mesmo holder manteve o lease; não houve takeover.

### Correção restrita aos testes

O preenchimento de atributos foi extraído para um helper compartilhado entre o E2E de staging e
a regressão de navegador. Booleano usa papel/nome acessíveis; texto, decimal, enum e faixa conservam
a semântica original. Testes de componente continuam provando persistência do valor e preservação
do tipo, proveniência e homologação. A renderização local não substitui Chrome autenticado real.

A revisão da sequência ainda não alcançada encontrou e reproduziu quatro problemas de campanha:
rótulos antigos de modelo aprovado e indexação; busca exata por rótulo de formulário nativo; e
título ambíguo com campos homônimos dos blocos. Os seletores agora compartilham helpers e isolam
a identificação da campanha dos blocos. Também são conferidos os demais rótulos estáticos da criação.
Regressões desktop/mobile passaram sem retry. Nenhum runtime, migration, workflow, pin, timeout
de release, RLS, MFA/AAL2 ou gate foi alterado.

O candidato `7efbedb41e7141a628ceab8fe03beeb17bb340ff` contém seis arquivos de testes,
311 inserções/30 remoções, diff revisado. Check completo verde: 221 arquivos/1.418 testes Vitest,
demais suítes/contratos/evals, lint/tipos/format e build de 18,16 s (799.039 bytes iniciais).
Os 20 casos Chromium desktop/mobile passaram em 11,4 s, dois workers e zero retries. Os novos
harnesses usam cache isolado, não carregam variáveis da aplicação e não abrem HTTP/WebSocket.
CI e entrega remota do novo SHA ainda estão pendentes; nenhum resultado anterior foi transferido.

Novo SHA exige validação e evidências próprias; o run reprovado não será repetido cegamente.
Chrome positivo, dependências posteriores, evidência terminal de sucesso e CAT-011/012 continuam
pendentes. Não houve carga/publicação comercial, ativação global do catálogo, cutover ou produção.

## Registro histórico preservado — revisão dos seletores, candidato `9719f52`

O CI [36785393868](https://github.com/Vnd93/gaiatec-cms/actions/runs/36785393868), attempt 1 de
`aad5922c3efcf37c998d1280c4ad804c7896c593`, terminou verde em 454 s (22:24:33–22:32:07 UTC).
Sete jobs passaram, inclusive 67 arquivos/2.154 testes pgTAP e as sete regressões SQL novas;
auditoria sem vulnerabilidades. O pacote não foi promovido: revisão somente leitura durante o CI
identificou outro seletor ambíguo na mesma sequência editorial, antes de consumir novo deploy.

`attribute.getByLabel("Valor")` correspondia a quatro controles (tipo, valor, origem e homologação).
Após o CI terminal, zero concorrência/fences, Vnd93/fetch/árvore limpa e fast-forward confirmados,
três testes reproduziram a falha no componente real com os seletores extraídos do próprio E2E.
`9719f52d756ba447751398238b2e9dab61df02dc` acrescenta `exact: true` nas duas ramificações e prova
que booleano, número e texto alteram somente o valor, mantendo tipo controlado, origem manual e
homologação desligada. Nove testes focados passaram; check completo: 221 arquivos/1.418 testes
Vitest, demais suítes, build 18,31 s e 799.039 bytes iniciais. Nenhum runtime, migration ou gate mudou.

O candidato `9719f52` exige CI/pacote/ponte/canônico próprios. Staging segue `39a8216`, recuperado,
com 114 migrations e catálogo default-off/vazio. Chrome real autenticado exibiu a tela desativada;
captação positiva e homologação desse novo SHA ainda não ocorreram. Sem carga/publicação comercial,
cutover ou produção. As evidências anteriores abaixo são históricas, não aprovações transferidas.

## Registro histórico preservado — recuperação editorial e candidato `aad5922`

O canônico `36778600629`, SHA `39a82162574195a4bd778cf7d76cc70984bc144a`, passou G11
29/29 (leitura p95 227/500 ms; comandos 388/800 ms), G7 13/13, 47 testes públicos aplicáveis
(três skips preexistentes), canário autenticado/CSP e os dois gates pós-deploy somente leitura.
As três janelas G12 tiveram disponibilidade 100%, zero 5xx e p95 de
585,663/637,479/549,313 ms. Não houve challenge nem captação positiva em Chrome real.

A etapa editorial automatizada falhou porque `getByLabel('Modelo 1')` selecionava nove campos;
outros três rótulos da mesma sequência estavam desatualizados. O cleanup encontrou dois defeitos
independentes: o alias `provenance` resolvia para a coluna externa (array), não para seu elemento;
o recovery encurtava `expires_at` para `created_at + 1 microsecond`, invalidando a janela de
criação exigida pela limpeza de rascunhos e taxonomias. Marcadores de ator/run/SHA estavam exatos;
não se tratava de proveniência ausente ou autorização para relaxá-la.

### Recuperação e prova terminal

Após comprovar ausência de workflows concorrentes e existência do recovery durável original,
uma transação restrita ao único ator e post sintéticos ainda ativos executou a limpeza estrita
com referência qualificada ao elemento JSON e a função instalada de conclusão do lease.
Não alterou expiração, schema, permissões, auditoria ou fences manualmente. A tentativa anterior
que ainda usava o alias ambíguo foi integralmente revertida. O PostgreSQL real demonstrou a causa
e confirmou recusa de referências ausentes, de outro run ou de outro SHA.

Resultado: 19 leases `cleaned`, zero leases ativos, sessões, overrides, rascunhos progressivos,
conteúdo não arquivado, projeções públicas e taxonomia de blog da execução. Os 19 eventos de
auditoria de cleanup foram preservados. Somente o job de compensação do watchdog foi retomado
uma vez após a reparação comprovada; não se repetiu o release reprovado.

- [Watchdog 36781981846, tentativa 2](https://github.com/Vnd93/gaiatec-cms/actions/runs/36781981846):
  compensação verde em 186 s, classificação em 14 s; recovery `already-terminal`, zero restantes.
- Sonda terminal: SHA exato, 100% disponibilidade, zero 5xx, p95 614,661 ms, nenhuma violação.
- Upload imutável e remoção oficial HMAC/CAS dos fences passaram; zero operação ativa ou lock wait.
- Artefato da tentativa 1 `11127982827`, SHA-256
  `be23860b757e8d6fdd01a3e28c51c46a496edf40775ba25d31017bf37d08f7bf`, preservado.
- Artefato da tentativa 2 `11129420596`, SHA-256
  `5f58f48d955a88e2a35c9eddf523d73673ac54608042b5ff900bbb8d3a9d3d31`, baixado e verificado.
- Recovery durável original `11126179421`, SHA-256
  `dad1f22ccf7d2e1f12ddabf3abd48c4c67d6eb7476e909840368af2ca53b11b4`.

### Correção versionada e validação

`aad5922c3efcf37c998d1280c4ad804c7896c593` altera somente cinco arquivos de QA/testes:
seis seletores exatos com rótulos atuais; elemento JSON explicitamente qualificado; expiração
`least(expires_at, clock_timestamp())`, sem estender leases expirados nem destruir a janela
válida; regressões executáveis ligadas ao gerador SQL e ao componente real. Os testes reproduziram
os defeitos antes da correção e passaram depois. Limites, retries e controles não foram reduzidos.

Check completo local aprovado: 221 arquivos/1.415 testes Vitest, 133 testes QA, demais contratos,
evals, formato, lint, tipos e build (18,14 s; 799.039 bytes iniciais). Testes focados: 25 de fixture
e seis do componente, todos verdes. Sete testes pgTAP novos exercitam resolução de nomes e janela
temporal; sua execução está pendente no CI, pois Docker não está disponível localmente. Nenhuma
migration, configuração Auth/RLS, runtime da aplicação, dependência ou pin Node/CLI mudou.

### Cadeia do candidato anterior e tempos

| Run                                                                          | Escopo                   | Resultado                                                          | Duração                          |
| ---------------------------------------------------------------------------- | ------------------------ | ------------------------------------------------------------------ | -------------------------------- |
| [36775695014](https://github.com/Vnd93/gaiatec-cms/actions/runs/36775695014) | CI `39a8216`             | sete jobs verdes; perfil full-release                              | 539 s                            |
| [36777260148](https://github.com/Vnd93/gaiatec-cms/actions/runs/36777260148) | ponte do pacote original | verde; mesmos bytes e resíduo zero                                 | 614 s                            |
| [36778600629](https://github.com/Vnd93/gaiatec-cms/actions/runs/36778600629) | canônico `39a8216`       | G11/G12/G7/pós-deploy verdes; browser editorial/cleanup reprovados | 1.909 s até atualização terminal |

No canônico: preflight 39 s, source 63 s, baseline 116 s, deploy 1.263 s, pós-deploy frontend
82 s/backend 41 s, browser 311 s (teste mutante 119 s), finalizer 27 s e métricas 13 s. Jobs
paralelos e etapas internas não devem ser somados como caminho crítico. No CI, instalar Chromium
consumiu 330 s dos 418 s do job browser. O caminho feliz de 40–60 minutos **não foi homologado**.

Pacote `11124908964`, SHA-256
`4dd6a3807a5280d8f4a627b1bfe67547073a95a3c30bcd2f9c5a98846482fa4a`;
dist archive `888d43d41074a59525a9f84cb229d9e5b17c0379c12c5395e5e100f2a6e88353`;
deployment da ponte `2f8209f7-973f-48e7-a45f-595143e7ae6d`. Ponte e canônico consumiram esses mesmos
bytes, sem rebuild. Evidência da ponte `11126591324`, SHA-256
`ae337cf876d4438d3bc50395eea2ba219a045f4f349a07d82d281f781dd2f41b`; restore `11126736168`,
SHA-256 `dcb68b78df3dc73f64cc877817670249141aac9aeed570a76f2bf27e5588bf50`.

O novo SHA exige CI, pacote, ponte, gates automáticos e Chrome real próprios. Não herdar aprovação
do SHA anterior. Staging segue `39a8216`, catálogo desligado/vazio e 114 migrations. Não reabrir
Fatias 1–4, permissões de staging, mesmo papel de cadastro/aprovação ou Tmeasurement. Recaptura
nominal, UAT/rollback e evidência terminal continuam pendentes; nenhuma carga/publicação comercial,
cutover ou produção foi executada.

## Registro histórico preservado — conflitos, evidência Auth e diagnóstico de acessibilidade

O candidato servido em staging é `a516874d8d92748b137cce5981a51dc341311695`. O controle
`ae70f19e63982ddca1e8094da7499a1337f703b5` corrigiu o caminho de saída da evidência Auth,
sem alterar a política de autenticação ou reconstruir o pacote promovido. **G11 passou em dois
runs canônicos e G7 passou nos 13 checks do primeiro deles**. Esses resultados substituem as
pendências históricas de G11 e da fixture de produtos, mas não aprovam o release completo.

O último run, `36770201729`, reprovou uma asserção de heading visível em 5.000 ms no teste
automatizado de acessibilidade desktop: 46 testes passaram, três tiveram skips previstos e um
falhou. A versão executada não identificou a rota no erro; o contexto/trace não estava no artefato
retido. Não há base para atribuir uma causa definitiva ou afirmar uma correção de runtime.
G7, pós-deploy e Chrome não foram alcançados nesse run; não houve challenge nem captação positiva.

Finalizer e watchdog `36772833385` terminaram verdes. A sonda terminal confirmou SHA exato,
100% de disponibilidade, zero 5xx e p95 público de 636,084 ms. O estado recuperado tem 114 migrations,
última `0114`; `ev2.catalog_v1=false`; zero overrides, produtos/snapshots do novo catálogo,
leases QA ativas, consultas concorrentes ou lock waits. Nenhum workflow ativo ou fence permaneceu.
Produção, carga comercial, publicação do catálogo e cutover não foram tocados.

### Causa comprovada e correção de transporte dos conflitos

A janela anterior de 62 segundos continha 5.360 erros `40001` em dois backends, associados à
recusa sintética da fence canônica de remoção de documento. A documentação oficial do Supabase
explica o [retry infinito de erros customizados 40001 no PostgREST 14](https://supabase.com/docs/guides/troubleshooting/high-cpu-and-infinite-transaction-retries-when-using-custom-error-codes-in-rpc-functions-77326b).
Esse mecanismo foi comprovado; não foi presumido como causa exclusiva de toda latência ou HTTP 503.

A migration aditiva `0114_cms_business_conflict_transport.sql` muda somente 68 recusas de negócio
em 47 funções para `PT409`. Confere assinaturas, contagem, definições completas e metadados de
`pg_proc`, aborta em drift e preserva falhas reais de serialização. É atômica, com lock timeout
de 5 s e statement timeout de 30 s. Digest SHA-256:
`54c7999e4d6c16f5b715d5d38a98622c27d0a9e25013368807057b0457a64377`.
Edge e limpeza reconhecem a combinação exata de código/mensagem; as mesmas fences continuam
recusando escrita indevida com HTTP 409. RLS, AAL2, auditoria, rollback e cleanup não foram reduzidos.

Após a aplicação, a janela `19:15:41Z–19:44:00Z` teve zero erros `40001`, dois `PT409` e uma recusa
da fence documental, sem a tempestade de retries. O resumo dos advisors permaneceu igual ao
baseline: 51 INFO `rls_enabled_no_policy`, um WARN de execução anônima de função security-definer,
43 WARN de execução autenticada e um WARN de proteção de senha vazada. Não equivale a dívida
de segurança zero; não houve relaxamento dos controles para liberar o gate.

O check completo de `a516874` passou em 203,94 s: 221 arquivos/1.414 testes Vitest, 131 QA,
770 testes aprovados na fase 12 com 16 skips Windows existentes, demais contratos/evals/lint/tipos
e build de 25,94 s. CI aprovou 66 arquivos/2.147 testes pgTAP e runtime das 34 Edge Functions.
Node 22.23.2, pin Node 22, CLI Supabase 2.116.0 e locks foram preservados.

### Cadeia exata e tempos observados

| Run                                                                          | Escopo                          | Resultado                                            | Duração |
| ---------------------------------------------------------------------------- | ------------------------------- | ---------------------------------------------------- | ------- |
| [36761718743](https://github.com/Vnd93/gaiatec-cms/actions/runs/36761718743) | CI `a516874`                    | verde, attempt 1                                     | 449 s   |
| [36762840647](https://github.com/Vnd93/gaiatec-cms/actions/runs/36762840647) | ponte do pacote original        | verde; backend restaurado e resíduo zero             | 651 s   |
| [36764422820](https://github.com/Vnd93/gaiatec-cms/actions/runs/36764422820) | canônico `a516874`              | G11/G12/G7 verdes; montagem da evidência Auth falhou | 1.689 s |
| [36768904371](https://github.com/Vnd93/gaiatec-cms/actions/runs/36768904371) | CI do controle `ae70f19`        | verde, attempt 1                                     | 594 s   |
| [36770201729](https://github.com/Vnd93/gaiatec-cms/actions/runs/36770201729) | canônico com controle corrigido | G11/G12/Auth verdes; heading do teste a11y reprovado | 1.348 s |

As durações da tabela são da execução remota completa; os relatórios de métricas dos dois
canônicos capturaram 1.684 s e 1.343 s antes do fechamento do próprio job. Ambos são caminhos
incompletos, **não prova do SLO feliz de 40–60 minutos**. No último run, deploy levou 963 s,
G11/G12 dentro dele 274 s e regressões públicas 107 s; não somar etapas internas novamente.
No CI do controle, instalação de Chromium levou 367 s: gargalo de preparação, não tempo do CMS.

- Pacote original `11118493996`, SHA-256
  `74668b2dbe8ff866e51e9e24c804e9955d2aa34a51b1c4230f9e0d6f4f343828`.
- Dist archive SHA-256 `da317ccd216fd9b8269087b934f37f7b2909bfb8ea4f5a66ae0fb5067afd9277`;
  dist tree `a8dbff15cc12575d5d6510a7f069a3ff61ceb5cc4fa72e1c270296336488b3b2`.
- Deployment canônico da ponte `7e9fb1c3-1ab8-4093-ac51-6ca720dd92f5`.
- Evidência da ponte `11120560339`, SHA-256
  `bdf4ea50620e9868ebecafa0231f101439b5e7f4ffccf88e6588834e0714369a`.
- Recuperação da ponte `11120680113`, SHA-256
  `112e4d2426c9cff36ae9f98d445ee9d9b1ee84bb55256d1761c401c71c3e46d0`.
- Terminal do primeiro canônico `11122435878`, SHA-256
  `f3fffbdd156d24f2c84bb0827cc13e13bf647af7e585573f33a01de24c2fa2a9`.
- Preliminar do último canônico `11123588265`, SHA-256
  `2129195ca34899c59bfafb7767f47403836c2fa2005c3ace1148f1457ce5eef2`.
- Terminal do último canônico `11123953313`, SHA-256
  `85e8e99db924bb10cea8e0d65c2f87b5957aed0dbaa195f75c7fd37ba48af19f`.
- Métricas do último canônico `11123778561`, SHA-256
  `7de3ac0f3b68bcd6064282a7258724916fc9f3df20dd0a019a6591196c4feef2`.

Os dois canônicos consumiram o mesmo pacote e ponte; não houve rebuild equivalente ou nova ponte.
Recovery durável e sua cópia remota foram verificados antes de cada mutação. O segundo run só
foi disparado após diagnosticar e corrigir a falha exata do primeiro e comprovar recuperação.

### Gates aprovados, correção Auth e limite do diagnóstico atual

G11 teve 29/29 checks aprovados nos dois runs: leitura p95 189/300 ms, limite 500 ms; comandos
800/254 ms, limite 800 ms. O primeiro valor de comando foi exatamente 800 ms, sem arredondamento
para aprovar. Protocolo, warmups, amostras e limites permaneceram iguais. No último G12, as três
janelas públicas tiveram p95 de 724,655/603,626/586,862 ms, disponibilidade 100% e zero 5xx.

G7 do primeiro canônico aprovou todos os 13 checks, incluindo a fixture de produtos governados,
termos sob lease, atributos, idempotência e não exposição de campos privados. Essa evidência é
do primeiro run; não preencher G7 skipped do segundo como se tivesse executado.

A falha Auth do primeiro canônico era somente de localização: o produtor gravava no diretório
temporário enquanto consumidores exigiam o workspace. `ae70f19` corrige o destino e acrescenta
quatro testes executáveis que falharam antes e passaram depois. 45 testes focados passaram, com
um skip Windows existente; check integral aprovado, build 18,11 s. No segundo run, o artefato
contém `g12-staging-auth.json`, origem/redirects exatos de staging e signup público desabilitado.
Não mudou CLI, API, configuração de Auth ou política de segurança.

O diagnóstico de acessibilidade foi limitado a uma travessia das seis rotas em Chrome real e a
uma execução somente leitura dos 50 testes públicos com os mesmos dois workers, zero retries
e limites originais. Todas as seis rotas exibiram H1; os testes tiveram **47 aprovações e três
skips previstos em 1,3 min**. O ajuste local de diagnóstico inclui a rota nas asserções e confere
HTTP 200/404 antes de cada scan completo Axe. Nenhum prazo, teste ou severidade foi reduzido;
traces de rede, vídeos e screenshots brutos foram desabilitados apenas nesse diagnóstico para
não persistir dados sensíveis. Isso não substitui evidência terminal ou explica a falha anterior.

Na janela da reprovação, os logs unificados Supabase tinham 699 respostas 200 e quatro 404 da
função pública, sem 5xx; execução máxima observada de 4.290 ms. Isso não prova qual resposta foi
entregue pelo Cloudflare ao navegador. O [incidente de latência do Supabase](https://status.supabase.com/)
seguia aberto, mas não foi adotado como causa definitiva. Não iniciar loop de reexecução.

Continuam pendentes homologação canônica verde, captação positiva Chrome e suas dependências,
recaptura/aprovação nominal e UAT/rollback. Mesmo papel de cadastro/aprovação, Tmeasurement no item
20 e autorização técnica de staging já estão resolvidos. Itens 17/18 permanecem provisórios;
CAT-D010 continua adiado. As Fatias 1–4 implementadas não precisam ser refeitas.

## Resultado histórico — antes da correção de conflitos e das validações G11/G7

O SHA servido em staging é `88e9bcf8a324d35b12dba3c4f8cd522011270d26`, com check local, CI e
ponte verdes. Seu diagnóstico único `36742897039` reprovou G11, landing editorial e primeiro cleanup.
A recuperação prevista terminou limpa. A correção G7 de produtos não foi alcançada pelo run;
continua sem validação remota. Não houve run canônico subsequente, challenge ou captação positiva.

Uma lacuna de diagnóstico do cleanup foi confirmada e corrigida no código: os rótulos constantes
das etapas recusadas passam a ser preservados com indicadores de resíduo/auditoria. Nenhuma mensagem
bruta, payload, identificação de ator ou credencial entra no relatório. O ajuste não muda operações,
condições de reprovação, retries, RLS, AAL2, budgets ou runtime. A revisão e a validação exatas são
registradas abaixo. O código em `origin/main` avançou para `830664f6384e6bf15e19b91816b82ccc42ba1ef6`;
não foi promovido a staging. Não reimplementar Fatias 1–4 nem a realocação Chrome já aprovada.

## Esclarecimentos funcionais históricos — 30 de setembro de 2026

O usuário informou **Tmeasurement** como fabricante do item 20 e confirmou que cadastro e aprovação
pertencem ao mesmo papel. Os contratos existentes aceitam `ownerRole` e `approverRole` iguais.
Mais importante, [CAT-D003 e CAT-D004](decisoes-funcionais-aprovadas-2026-09-13.md) já permitem
ao Administrador publicar o próprio conteúdo; uma segunda pessoa não é obrigatória no Catálogo.
A exigência posterior de aprovador independente foi uma interpretação incorreta da documentação,
não uma proteção a acrescentar ao contrato. Fica corrigida para este núcleo, preservando o histórico.

Não se alteram os fluxos editoriais existentes de outras áreas nem a segregação de release,
revisão de segurança ou atestação documental. Administrador e Operador conservam suas capacidades,
RLS/AAL2/auditoria permanecem obrigatórios, e evidências server-owned de UAT não são autoatestadas.
Confirmar o papel não equivale a aprovar os produtos ainda não recapturados e homologados.

A [lista nominal](lista-nominal-prioritaria-cat-d009-2026-09-24.md) contém a fonte primária da marca
Tmeasurement e distingue essa confirmação da identidade exata do modelo comercial. O item 20 muda
de `bloqueado-completude` por fabricante ausente para `pendente-recaptura`; nenhum modelo OEM,
especificação, certificação, mídia ou direito foi inferido por equivalência. Itens 17/18 permanecem
`user-confirmed-provisional`, sem aprovação, carga, publicação ou cutover.

Retomada verificada com GitHub Vnd93, holder existente, ambas as árvores canônicas limpas em `main`,
fetch/origin iguais e zero workflows ativos ou fences. Staging continua com 113 migrations/última
`0113`, flag desligada, zero overrides, produtos, snapshots e leases QA ativas. O incidente público
de latência do Supabase seguia aberto na consulta; não prova sozinho a causa de G11/503 e não foi
usado para aprovar um gate. Não houve nova execução, mutação remota, mudança de runtime ou de schema.

Validação dirigida em `830664f6384e6bf15e19b91816b82ccc42ba1ef6`: os **11 testes existentes** de
`tests/contracts/catalog-release.test.ts` passaram em **20,48 s**, incluindo entrada nominal com
papéis iguais, itens provisórios, flag, fronteira sem SKU e cobertura/UAT. Não se duplicou teste ou
implementação já existente. O check integral da documentação passou: **303 arquivos Markdown,
428 links locais e zero padrões sensíveis**; revisão do diff e `git diff --check` aprovados.
Esta entrega é documental e não exige deploy do CMS; commit/push e CI são verificados no
encerramento da sessão, sem invalidar ou reconstruir os artefatos da aplicação.

Pendências vigentes: G11/503 diagnosticados sem estabilidade comprovada, G7 de produtos ainda não
alcançado remotamente, Chrome positivo, recaptura/aprovação nominal e UAT/rollback. **Não falta
autorização genérica de staging, outro papel funcional nem o nome do fabricante do item 20.**
As menções anteriores a essas pendências neste histórico não devem reabri-las.

## Resultado histórico anterior à validação remota da fixture G7

Após o diagnóstico dirigido descrito abaixo, o candidato
`88e9bcf8a324d35b12dba3c4f8cd522011270d26` corrigiu a fixture G7 com dados governados e isolados.
Passou no check local completo; a homologação remota desse novo SHA continua pendente.
Os resultados anteriores permanecem históricos, não autorização reaproveitável.

A realocação aprovada foi implementada em `cccedddc22b895a58f8bca74b649ede3200a1572`, com check
completo, CI e ponte aprovados. O controle adicional `624eaf0b1256485fbe8ae1174c8219ff94846885`
também passou no check e CI. O run canônico `36725530364` consumiu os mesmos bytes, mas foi
interrompido pelo budget de latência G11 antes do Chrome. Finalizer e watchdog recuperaram staging;
a seção de execução abaixo registra a falha, sem converter CI verde em homologação funcional.

Antes da aprovação de sequência abaixo, o candidato `035350ad690dcba40bd4542705a6b184b01b87bc` foi
implantado exclusivamente em staging, com o mesmo pacote selado no CI e promovido pela ponte.
O run canônico passou G11, G12 e G17, mas **não homologou o release**: o ciclo editorial tentou
captar um lead usando um token dummy incompatível com a prova Turnstile exigida. Finalizer e
watchdog terminaram verdes. Não houve retry do run, redução de proteção ou operação de produção.

O trabalho integrado das Fatias 1–4 permanece preservado; não deve ser reiniciado. Não houve
carga comercial, publicação do catálogo ou cutover. A flag `ev2.catalog_v1` continua desligada.
Os horários deste registro são UTC; a execução atravessou a noite de 29 para 30 de setembro em BRT.

## Correções em main

| SHA completo                               | Alteração e prova                                                                                                                                                                                                                                             |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `95c21a5a6eaba362e626b454e336d5c17a9ca2fc` | Leitura do formulário público via GET na RPC STABLE, seletores nulos omitidos e retry interno do SDK desligado; preservados teto de 900 ms e duas tentativas externas de leitura, sem retry de escrita ou recusa de autorização. 37 testes focados passaram.  |
| `a94c33d903416587f6136e88a2bd1b2e3d7d3a6d` | Patches de segurança Undici 7.29.1/8.10.2; a primeira forma de overrides passou localmente, mas falhou no npm 10.9.8 da CI. Nenhum pacote final foi promovido.                                                                                                |
| `9752b9dd61654bbd770806a3f8858e0bc1de4771` | Overrides por major da dependência folha, sem alterar os bytes do lockfile anterior. Instalação limpa com npm 10.9.8 e CI completos passaram; novos alertas independentes do Dependabot impediram promoção.                                                   |
| `5ae3566e3a094b8a58402a0a77ff7eec0b1c2a21` | Patches brace-expansion 1.1.21/2.1.7/5.0.12, sem upgrade de major consumidor. Três entradas do lockfile alteradas; metadados libc preservados. Audit e Dependabot zerados.                                                                                    |
| `035350ad690dcba40bd4542705a6b184b01b87bc` | Referências sintéticas de G17 mantêm o UUID completo, evitando colisão de prefixo numérico truncado com o detector de telefone. Quatro regressões SQL e contratos Node adicionados/ajustados; detector, modelo, prompt, schema e runtime não foram alterados. |

O `npm run check` final passou com 220 arquivos/1.388 testes Vitest, suites Node, evals, lint,
tipos e build de 28,22 s. O budget dos quatro chunks iniciais ficou em 798.432 bytes. Permanecem
16 skips de symlink específicos de Windows já existentes. O primeiro check da correção G17
identificou o contador pgTAP complementar ainda em 46; ele foi atualizado para 50 e o check completo
foi repetido com sucesso, sem remoção de testes. A CI final aprovou 65 arquivos/2.137 testes pgTAP.

Node 22, CLI Supabase 2.116.0 e locks Deno foram preservados. Não houve atualização ampla de
dependências. As correções de segurança foram conferidas nas fontes primárias:
[Undici 7.29.1](https://github.com/nodejs/undici/releases/tag/v7.29.1),
[Undici 8.10.2](https://github.com/nodejs/undici/releases/tag/v8.10.2),
[brace-expansion GHSA-q2hr-2g5m-vwhr](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-q2hr-2g5m-vwhr),
[GHSA-qhr7-859c-m2p7](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-qhr7-859c-m2p7) e
[GHSA-6j4f-fj2g-mc7p](https://github.com/juliangruber/brace-expansion/security/advisories/GHSA-6j4f-fj2g-mc7p).

## Histórico de runs e baseline real

| Run                                                                          | SHA curto | Resultado                                                                     | Duração |
| ---------------------------------------------------------------------------- | --------- | ----------------------------------------------------------------------------- | ------- |
| [36650624152](https://github.com/Vnd93/gaiatec-cms/actions/runs/36650624152) | `95c21a5` | CI bloqueado por audit Undici; lanes funcionais verdes                        | 328 s   |
| [36651628213](https://github.com/Vnd93/gaiatec-cms/actions/runs/36651628213) | `a94c33d` | CI bloqueado por instalação npm 10.9.8                                        | 218 s   |
| [36652204008](https://github.com/Vnd93/gaiatec-cms/actions/runs/36652204008) | `9752b9d` | CI verde; não promovido devido aos alertas brace-expansion                    | 452 s   |
| [36653515334](https://github.com/Vnd93/gaiatec-cms/actions/runs/36653515334) | `5ae3566` | CI verde                                                                      | 475 s   |
| [36654315402](https://github.com/Vnd93/gaiatec-cms/actions/runs/36654315402) | `5ae3566` | Ponte verde; watchdog `36655114487` skipped                                   | 597 s   |
| [36655248545](https://github.com/Vnd93/gaiatec-cms/actions/runs/36655248545) | `5ae3566` | Deploy reprovado em G17; finalizer 148 s verde e watchdog `36657273172` verde | 1.538 s |
| [36658205367](https://github.com/Vnd93/gaiatec-cms/actions/runs/36658205367) | `035350a` | CI verde, attempt 1                                                           | 429 s   |
| [36658865515](https://github.com/Vnd93/gaiatec-cms/actions/runs/36658865515) | `035350a` | Ponte verde; watchdog `36659591120` skipped                                   | 554 s   |
| [36660065421](https://github.com/Vnd93/gaiatec-cms/actions/runs/36660065421) | `035350a` | Deploy reprovado na captação editorial; recuperação verde                     | 1.495 s |

O run automático duplicado de push `36651625981` foi cancelado pela concorrência do CI; não foi
um retry manual nem produziu artefato promovido. Todos os candidatos seguintes corresponderam a
correções distintas, com novo SHA e nova validação, não a reruns cegos de uma falha.

No candidato final, o CI durou 7m09, a ponte 9m14 e o deploy encerrado com recuperação 24m55.
A soma é 41m18; o intervalo entre início do CI e fim do deploy foi 48m43. **Isso não comprova o SLO
de caminho feliz de 40–60 minutos**, pois Chrome e evidência final não executaram. Não há comparação
end-to-end verde válida com os candidatos anteriores que pararam em gates diferentes.

| Etapa do run `36660065421`                               | Tempo observado |
| -------------------------------------------------------- | --------------- |
| Preflight                                                | 32 s            |
| Validação de fonte, paralela ao baseline                 | 48 s            |
| Validação do baseline real                               | 115 s           |
| Job serial deploy, incluindo gates até a falha editorial | 1.161 s         |
| Dentro do deploy: download do pacote selado              | 42 s            |
| Dentro do deploy: canário de migrations sintéticas       | 142 s           |
| Dentro do deploy: G11 herdado e três janelas G12         | cerca de 273 s  |
| Finalizer                                                | 159 s           |
| Métricas                                                 | 13 s            |

As linhas internas não devem ser somadas novamente ao job deploy. O caminho serial de validação
continua concentrando a duração; a incompatibilidade da captação é o bloqueio funcional imediato.
Nenhum limite de produto, amostra lenta, teste de segurança ou recuperação foi removido para atingir tempo.

## Pacote, deployment e evidências do candidato final

- CI `36658205367`, attempt 1, perfil `full-release` (bootstrap sem checkpoint terminal verde).
- Artefato final `11073600773`, digest SHA-256
  `53fd3bf600cd35e43f6cbd49de2ce56d468bc39f18c0b0b6d482478a2ad9eab2`.
- Dist archive SHA-256 `cf262f8b9cb26438364f296f130a064a9922d29a21f8eda3d10c0d01497cb516`.
- Dist tree SHA-256 `74922456212680b140bfa344c62c766ac9ab8eea59ff5e2daa097810bc74d5cc`.
- Ponte `36658865515`, evidência `11073328319`, digest
  `4047001d21354fdd9a0597b7e431a9f8904f7a777ddbf40030f7c78c9a4680d0`.
- Deployment canônico `5820955e-dfc7-4dc8-8497-7ab57fb4f8b7`, criado em `2026-09-30T02:20:25.750Z`,
  marcador `g12-staging-bridge-run-36658865515-1`.
- Deploy canônico `36660065421`: início `02:29:17Z`, término `02:54:12Z`, attempt 1,
  candidato e rollback `035350ad690dcba40bd4542705a6b184b01b87bc`, `diagnostic_run=false`.
- Evidência preliminar `11073913788`, digest
  `253e2b37789f87a43fdff577ffb89cc279d13e51d5409306236087f0ec62183a`.
- Estado durável `11073374828`, digest
  `3e13e01201f2e17a7caee0c57b6941c0ae1b5c01d67706084b4857d1d0ca6f1f`.
- Recovery `11073683902`, digest
  `8b9999ae8030b8119197c9c0c0b2cdbf6ee17a58ff04add4d78ff13448370fba`.
- Evidência terminal de recuperação `11074716859`, digest
  `5e76ca08e33547e3ada92d7b6ae604af76adfa3e49a3a73a2b6292bda29bfd40`.
- Relatório de duração `11074483900`, digest
  `e76f1501fe11aa69afb70860bcd646c4b3ec3ed67c8880734f04985e48f95d04`.
- Watchdog [36661969245](https://github.com/Vnd93/gaiatec-cms/actions/runs/36661969245): sucesso,
  terminado às `02:55:07Z`.

O artefato terminal comprova recuperação, não aprovação funcional do release. Nenhum rebuild
equivalente substituiu o pacote selado. A ponte comprovou compatibilidade/fail-closed, não envio
positivo de formulário nem homologação Chrome.

## Diagnósticos e progresso efetivamente provado

### G17 e privacidade

O run anterior `36655248545` falhou com `CMS_AI_UNREDACTED_DATA`. Uma consulta pura ao detector
reproduziu a recusa de referências com oito dígitos provenientes de UUID truncado; o UUID completo
foi aceito. E-mail/telefone em conteúdo aninhado continuaram recusados. O payload rejeitado original
não foi retido: não é possível atribuir sua causa exclusiva ao prefixo. A auditoria agregada mostrou
uma chamada de provedor bem-sucedida, com 207 tokens de entrada e 72 de saída, sem reter conteúdo.

Depois da correção, o **G17 canônico aprovou 12 checks** em `36660065421`, usando inferência real
com `inclusionai/ling-3.0-flash-sante:free`. Dois atores foram limpos, zero linhas de negócio ativas,
auditoria mantida. ZDR, coleta negada, preços máximos zero e proibição de fallback pago permanecem.
Não houve mudança do modelo nesta rodada.

### Desempenho e formulário público

No `5ae3566`, G11 passou 29/29: p95 servidor de leitura 180 ms e comando 401 ms; wall 495/659 ms.
No `035350a`, passou novamente 29/29: p95 servidor 97/268 ms, wall 532/817 ms. Os budgets de servidor
500/800 ms ficaram inalterados; tempos wall são apresentados separadamente e não ocultados.
As três janelas G12 tiveram 100% de disponibilidade, zero 5xx, segurança e restore aprovados,
RPO 0/RTO 1 minuto, sem promoção stable.

O ciclo editorial final aprovou identidade do shell, RBAC, recusa de publicação em AAL1, formulário
versionado, agendamento/publicação/restauração de blog e renderização da campanha/formulário. A falha
anterior de HTTP 503 nessa etapa não se repetiu neste run. Isso comprova esta execução, não estabilidade
universal nem causalidade exclusiva da correção de retry. O incidente Supabase observado no diagnóstico
anterior tampouco prova a causa de todos os atrasos históricos.

### Bloqueio diagnosticado antes da aprovação: prova positiva do Turnstile

Em `scripts/phase7/staging-roundtrip.mjs`, o canário usa `XXXX.DUMMY.TOKEN.XXXX` na captação positiva,
enquanto a sitekey configurada de staging não é uma chave dummy. O backend recusou a requisição com
HTTP 403/`challengeRequired`, depois de aprovar as negativas de token ausente/inválido.

A [documentação oficial de testes do Turnstile](https://developers.cloudflare.com/turnstile/troubleshooting/testing/)
explica a separação entre tokens/chaves dummy e reais. Além disso, a resposta dummy documentada não
prova o `cData` UUID da solicitação. Uma reprodução local somente leitura confirmou que a política
vigente rejeita esse `cData` incompatível mesmo para a chave oficial de teste. Nenhum segredo foi
lido ou alterado e nenhum token real foi capturado. Não se conclui que a configuração real esteja errada.

Nas regras atuais, a captação positiva depende do navegador real, mas a fase Chrome depende do
sucesso desse canário automático. É necessária uma decisão explícita sobre a **realocação da prova
positiva para a etapa Chrome**, preservando suas dependências e mantendo os demais gates automáticos
independentes antes do challenge. Não trocar a proteção por chaves always-pass, não aceitar dummy
como positivo, não injetar um token nem declarar o gate aprovado por ausência de erro.

Naquele encerramento, a implementação dessa realocação ainda não havia sido feita. Antes de um novo run, a matriz versionada e
os testes contratuais devem provar a preservação de: captação 201 real; idempotência; persistência,
consentimento e outbox; RBAC negativo; exportação AAL2; anonimização; cleanup/resíduo; challenge
SHA/deployment-bound, validade e antirreplay; recuperação durável e evidência terminal obrigatória.
Não eliminar uma assertiva de API/compatibilidade apenas por existir uma verificação visual parecida.

## Aprovação e matriz da realocação para Chrome real

Em 30/09/2026, o usuário aprovou explicitamente mover a captação positiva e suas verificações
dependentes para a etapa Chrome real, preservando todos os controles. Esta aprovação resolve a
decisão de sequência; não aprova um SHA novo, produção, carga comercial ou cutover.

A implementação local usa o formulário sintético da campanha exata no canário de staging. O
transporte normal serializa o corpo uma vez e, somente após o primeiro HTTP 201 com `duplicate=false`,
faz uma única duplicação deliberada dos mesmos bytes. Exige outro HTTP 201, `duplicate=true` e a
mesma referência. Não há retry após falha, extração/injeção de token, chave always-pass ou caminho
especial no backend. Formulários normais e produção continuam enviando uma única requisição.
O marcador visual `Idempotência HTTP 201 confirmada.` só aparece após essas duas respostas.
Ele é uma assertiva do código do candidato, não uma alegação de captura de tráfego pelo operador.

| Controle preservado                                                                                                                                 | Etapa obrigatória                                                              | Evidência vinculada                                                                                            |
| --------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| CAPTCHA ausente/inválido recusado; RBAC editorial, publicação AAL1 recusada, expiração, bulk, restauração e auditoria                               | Faixa automática anterior ao challenge                                         | Roundtrip editorial identifica escopo automático; não declara a captação positiva aprovada                     |
| Primeiro 201 real, segundo 201 idempotente e mesma referência                                                                                       | Formulário público no Chrome real, com widget genuíno                          | Atestação consumida, texto de sucesso e screenshot vinculados ao SHA/run/attempt/challenge; token nunca retido |
| Uma persistência, consentimento, vínculo de formulário/ator/SHA/ambiente, histórico inicial e outbox unitários                                      | Bootstrap autenticado após a atestação Chrome                                  | Leitura RLS real e prova de auditoria em `cms-final-coverage.json`                                             |
| Negativa de atribuição pelo marketing, atribuição comercial, exportação AAL1 recusada, exportação AAL2, anonimização e outbox/auditoria preservados | Após Chrome, compatibilidade legacy/hybrid, percurso semântico e rollback AAL2 | `cms-real-browser-lead-controls.json`, com 13 assertivas obrigatórias e deployment exato                       |
| Revogação dos três atores temporários; limpeza dos fixtures Chrome; ausência de resíduo                                                             | `finally` das dependências e cleanup/residue compartilhados                    | Leases duráveis, auditoria de encerramento e recuperação/watchdog existentes                                   |
| Nenhum sucesso terminal com prova ausente, falsa, reusada ou de outro alvo                                                                          | Materialização e selagem terminal                                              | Digest do relatório, bindings exatos, manifesto e upload imutável obrigatórios                                 |

A compatibilidade legacy/hybrid negativa e o percurso autenticado AAL2 do frontend rollback não
foram removidos. A captação positiva real usa o contrato público selecionado pelo formulário do
candidato; a ponte de compatibilidade não é reclassificada como prova positiva de envio legado.

Os controles pós-Chrome compartilham o limite existente de 30 minutos com o percurso rollback,
executando depois dele e falhando se qualquer comando falhar. O teto contratual de 200 minutos
entre provisionamento e cleanup continua igual, inferior à lease de 240 minutos. O primeiro
check local detectou a soma indevida de 15 minutos; a implementação foi corrigida, sem alterar o
teste de limite, o TTL, os 2.100 segundos de espera do watcher ou a validade/antirreplay do challenge.

Fontes atuais consultadas antes da mudança: [MFA do Supabase](https://supabase.com/docs/guides/auth/auth-mfa),
[migração dos endpoints de logs](https://supabase.com/changelog/48235-migration-of-supabase-management-api-logs-all-analytics-endpoint-to-logs-endpoint)
e [validação server-side do Turnstile](https://developers.cloudflare.com/turnstile/get-started/server-side-validation/).
Não houve alteração de CLI, migrations, Auth, RLS, Edge Functions, Node pinado, secrets ou endpoints de logs.

O novo candidato `cccedddc22b895a58f8bca74b649ede3200a1572` passou no `npm run check`: 220 arquivos/
1.403 testes Vitest, suites Node, evals, lint, tipos e build em 26,41 s; quatro chunks iniciais
totalizam 799.039 bytes. Permanecem os 16 skips de symlink específicos de Windows. A documentação
passou com 303 arquivos Markdown, 414 links locais e zero padrões sensíveis. O teste de escopo usa
a mesma derivação do título para chave que a UI real, recusando o prefixo sintético antigo.

O CI `36719306735` aprovou o candidato em 522 s, perfil `full-release`. O único pacote promovível
é `11098206613`, digest `sha256:542f2b6bc7525924caef3189026ba89aa64d1da483bc82644e3fcfe04482b2f3`.
O arquivo dist tem digest `6e4c50013e7fd34448c782664b82a0c6cbceb5b0e560868f31316242be5ff9c4`
e a árvore `350bd4e80736ca4ce398f6cb9d1179cbdcfd526511316ffc275186d4b707c4cd`.

### Retomada somente das métricas da ponte, sem nova promoção

A ponte `36720500359` promoveu esses mesmos bytes: job `109904084336`, attempt 1, aprovado
em 658 s. Deployment canônico `15e18a82-b107-4ba0-93bd-bcf5aba4dc49`. O backend temporário foi
restaurado na versão 506, com três probes consecutivos `public-v2` e liberação formal da lease.
As duas fixtures headless foram limpas, com resíduo zero e auditoria preservada.

O workflow terminou inicialmente em falha porque **somente** `pipeline-metrics` recebeu HTTP 502
da API de jobs do GitHub. O watchdog `36721871811` confirmou `no-state-no-mutation`; a consulta
ao staging confirmou SHA exato, 113 migrations, flag desligada e zero leases de QA ou dados de
catálogo. Nenhuma promoção foi repetida e nenhum gate foi ignorado.

Após esse diagnóstico, houve uma única repetição do job de métricas: `109912879805`, attempt 2,
aprovado em 9 s. A ponte ficou verde e o watchdog `36723103432` foi skipped como previsto.
O artefato de promoção continua `11098867415`, digest
`sha256:40fa91e025e2fcbe4d6a2a4d018e69afe81c4d2320d32488fc418293265a1952`, produzido no attempt 1.
O GitHub copia a dependência aprovada com outro ID/attempt, mas conserva timestamps e steps da
execução original. A [documentação de reruns](https://docs.github.com/en/actions/how-tos/manage-workflow-runs/re-run-workflows-and-jobs?tool=cli)
e o [filtro de histórico de jobs](https://github.blog/changelog/2020-03-09-new-filter-parameter-in-workflow-jobs-api/)
foram consultados; o comportamento foi conferido na API autenticada, não inferido apenas pela UI.

A correção mínima de controle distingue o produtor da promoção do attempt verde de métricas.
Exige inventário completo de jobs; sucesso terminal; mesmos SHA, run, workflow e branch;
timestamps e steps idênticos para a dependência copiada; criação do artefato durante a execução
original; upload imutável e gate terminal aprovados. Qualquer nova execução de promoção, histórico
incompleto, job desconhecido ou mudança de identidade invalida a reutilização. A prova de deployment
continua vinculada ao attempt 1; a duração remota é resolvida pelo attempt 2. O estado vivo e os
digests serão novamente verificados antes do deploy, sem dispensar nenhum gate pós-deploy.

Os 14 s de `observedSeconds` do relatório do attempt 2 medem a retomada das métricas, **não** a
promoção de 658 s. A ponte inteira, incluindo diagnóstico/retomada, vai de 13:16:53 a 13:38:23 UTC
(1.290 s). Esses períodos não podem ser apresentados como um caminho feliz de 14 s.

A fotografia anterior ao dispatch registrava a revisão de controle em validação, sem mudança ou
recompilação do candidato já promovido. Deploy e Chrome estavam pendentes. A prontidão do Chrome
foi conferida com sessão autenticada em staging, sem gerar challenge antecipado.

### Execução canônica e recuperação após o bloqueio de desempenho

O controle `624eaf0b1256485fbe8ae1174c8219ff94846885` passou no check completo e em 44 testes
focados de proveniência/compatibilidade. O CI `36724177499` aprovou todas as lanes em 536 s.
O pacote gerado por esse CI de controle **não substituiu** o pacote do candidato `ccceddd`.

O [run canônico 36725530364](https://github.com/Vnd93/gaiatec-cms/actions/runs/36725530364),
attempt 1, executou de 13:58:03 a 14:17:35 UTC (1.172 s). Preflight, validação de origem, leitura
do baseline, recovery durável, verificação dos bytes e provas de migrations passaram. A resolução
da ponte confirmou produtor 1 e attempt verde 2, preservando o artefato `11098206613` e seu digest.

O G11 herdado reprovou antes de completar a etapa das três janelas G12. A única violação de budget
registrada foi `adminReadP95Ms=958`, acima de 500 ms. A sequência continuou serial, com exatamente
20 warmups e uma única janela de 20 medições; não houve descarte de amostras nem retry-until-green.

| Medida p95 na janela reprovada     | Observado | Tratamento                                        |
| ---------------------------------- | --------: | ------------------------------------------------- |
| Leitura administrativa no servidor |    958 ms | Reprovada; teto 500 ms preservado                 |
| RPC administrativa                 |    950 ms | Diagnóstico, não substitui a medida normativa     |
| Núcleo SQL do snapshot             |    695 ms | Diagnóstico da subfase, sem excluir custo do gate |
| Rate limit                         |     21 ms | Proteção mantida                                  |
| Leitura wall                       |  1.316 ms | Reportada separadamente, sem ocultar rede         |
| Comando no servidor                |    454 ms | Aprovado; teto 800 ms preservado                  |

Os percentis são calculados separadamente e não devem ser somados ou subtraídos para atribuir
custos exatos. A maior amostra de leitura no servidor foi 1.886 ms; a correspondente subfase SQL
registrou 1.184 ms. Disponibilidade de G11 foi 100%, outbox lag 0, auditoria 100%, RPO 0 e RTO
1 minuto. A recusa de review da medição reprovada é o fail-closed esperado, não uma aprovação ausente
a ser suprida manualmente. As lanes pós-deploy, Chrome e evidência final ficaram skipped.

Finalizer `109928079743` passou em 212 s. O watchdog `36728015014` terminou verde e classificou
`recoveryRequired=false`; não houve compensação adicional nem nova promoção. A prova terminal
`11103552620`, digest `sha256:71bef85c5902c046af05d0dc1aab481bb2df05b4b2cdca88bf690827d6eefaec`,
registrou 100% de disponibilidade, zero 5xx, p95 público 688,970 ms e SHA exato `ccceddd`.
O relatório de duração `11103168473`, digest
`sha256:6cfa41a264b8ccf3fd69779e3f9bd4f1cedcf492ce30325bd094bbf15feabd56`, classifica a execução como
`non-happy-path`; seus 1.168 s foram capturados antes da conclusão final do workflow.

Da abertura do CI do candidato às 13:06:45 até o encerramento desse deploy às 14:17:35 decorreram
4.250 s (70 min 50 s), incluindo o 502 da ponte, diagnóstico, correção de controle e seu CI.
Isso excede a meta de 40–60 minutos e **não** constitui SLO de caminho feliz: a homologação falhou.

### Diagnóstico somente leitura e condição de retomada

Após a recuperação, o inventário remoto confirmou zero workflows queued/in_progress/waiting/
pending/requested nos dois repositórios, zero fences de recovery e zero leases de QA ativas.
Staging conservou 113 migrations/última `0113`, `ev2.catalog_v1=false`, zero overrides, produtos,
snapshots e tabelas do catálogo sem RLS. A identidade GitHub `Vnd93`, o holder e os checkouts main
limpos/sincronizados foram reconfirmados. Produção permaneceu intocada.

A comparação `035350a..ccceddd` não contém alterações em Supabase, G11 ou no orquestrador G12.
A inspeção de catálogo e estatísticas encontrou zero índices inválidos e zero espera ativa por
lock. A consulta dos eventos críticos usou o índice parcial existente (`Index Only Scan`,
zero leituras de disco, 1,578 ms de execução), não justificando criar outro índice para esse trecho.
As estatísticas acumuladas da RPC cronometrada registram 800 chamadas, média 97,29 ms e máximo
1.764,49 ms; não são uma janela do run reprovado nem provam estabilidade atual.

Foram consultados o [changelog atual do Supabase](https://supabase.com/changelog), a
[orientação de inspeção do banco](https://supabase.com/docs/guides/observability/inspect) e o
[status de latência](https://status.supabase.com/). Em 30/09 havia incidente de latência intermitente
para clientes no leste dos EUA, ainda sem resolução. Isso é contexto operacional, **não** prova da
causa exclusiva do custo SQL observado. A versão de banco consultada era 17.6; não foi executado
upgrade, reindexação, ajuste de configuração, migration, limpeza de histórico ou redução de controle.

A mudança de sequência está entregue, mas a captação positiva real e as 13 verificações dependentes
ainda não têm prova executada neste candidato. Não gerar atestação, reaproveitar aprovação de outro
SHA ou marcar o release como verde. Antes de outro run canônico, isolar a latência G11 em diagnóstico
dirigido; preservar e revalidar o CI, ponte e pacote exatos que continuem válidos. Não repetir o
deploy cegamente, reconstruir os mesmos artefatos ou reiniciar as Fatias 1–4.

## Diagnóstico dirigido após a recuperação de ccceddd

O passe único [36733465791](https://github.com/Vnd93/gaiatec-cms/actions/runs/36733465791), attempt 1,
usou controle `624eaf0b1256485fbe8ae1174c8219ff94846885` e candidato
`cccedddc22b895a58f8bca74b649ede3200a1572`. Executou de 15:00:43 a 15:16:24 UTC: **941 s**,
11 checks aprovados e dois reprovados. É diagnóstico `approvable=false`, não aprovação terminal.
Não aplicou migration, não promoveu frontend nem implantou Edge Functions.

O G11 manteve uma janela de 20 aquecimentos e 20 amostras, sem descarte ou alteração de budget:
leitura administrativa p95 **647 ms / limite 500 ms**, comandos **322 ms / limite 800 ms**.
Na leitura, RPC p95 639 ms, snapshot SQL p95 404 ms e wall p95 925,91 ms. A melhora em relação
a 958 ms não torna o resultado aprovado. Nenhuma repetição automática foi autorizada pelo diagnóstico.

O outro bloqueio ficou isolado no ciclo editorial G7: o dry-run de dois produtos sintéticos
selecionava opções corporativas por service role. A normalização escopada da migration `0078`
recusava corretamente esses termos para os atores QA. A fixture também precisava usar uma definição
de atributo homologada do catálogo governado e SKUs sintéticos distintos. Não é autorização para
adicionar SKU ou importação ao Núcleo de Catálogo: trata-se do canário legado já existente.

A correção reutiliza o provisionador autenticado da fixture Chrome: cinco opções privadas e cinco
entidades mestras QA, definição/conjunto técnico pertencentes ao ator, prova de catálogo e lease
durável antes da primeira mutação. Os containers corporativos não são alterados ou adotados como
dados QA. Somente `ev2.master_data` e `ev2.pim_v2` recebem overrides temporários de usuário, por
30 minutos; `ev2.catalog_v1` permanece default-off. A limpeza terminal existente continua obrigatória.

O diagnóstico aprovou cleanup/resíduo; o watchdog `36735461416` terminou verde e sua compensação
ficou skipped. A consulta posterior confirmou 113 migrations/última `0113`, zero leases QA ativas,
overrides do catálogo, produtos ou snapshots; sem workflow ativo ou fence de recovery.

| Evidência do diagnóstico | Identidade imutável                                                                                |
| ------------------------ | -------------------------------------------------------------------------------------------------- |
| Relatórios               | Artefato `11106313192`, SHA-256 `96cbefdbc018faae88be1d44349208c2360763d172679176be1602e459a54409` |
| Métricas                 | Artefato `11106323538`, SHA-256 `775e3415f42d163c02fb3905d1a2129dfe5f6d8b8a9ca16accb8f76e7322884b` |

### Limites do diagnóstico de infraestrutura

Não havia queries ativas, espera por lock, transações antigas, índices inválidos ou I/O de disco/temp
na RPC cronometrada. Os crons próximos ao run anterior duraram no máximo 176 ms. O EXPLAIN dirigido
dos filtros levou 111,595 ms de planejamento e 6,260 ms de execução, mas sem contexto QA ativo;
**não substitui o gate autenticado**. JIT permaneceu desligado e nenhuma configuração foi alterada.

No dashboard do projeto staging exato, a observação das 15:14 UTC mostrou 406,52 MB de RAM,
288,51 MB usados, 112,54 MB de cache/buffers e 607,14 MB de swap. O percentual de swap mostrado
era relativo à RAM, não à capacidade total de swap. CPU 35,60% era uma amostra, não média da janela.
Commit de memória de 1,67 GB também não prova sozinho pressão física sustentada.
Segundo a [documentação atual de memória e swap](https://supabase.com/docs/guides/troubleshooting/memory-and-swap-usage-explained-aPNgm0),
swap pode guardar páginas frias normalmente. Não foi comprovada necessidade de upgrade pago.

O [incidente de latência do Supabase](https://status.supabase.com/) continuava aberto na atualização
de 30/09 às 14:54 UTC. Pode contribuir para a variabilidade, mas não é causa exclusiva demonstrada.
Não houve upgrade, migração regional, tuning especulativo, exclusão de histórico ou redução de gates.
O próximo teste de candidato corrigido deve verificar o G7 e todos os controles aplicáveis; não serve
para escolher uma janela conveniente de G11 nem permite reutilizar aprovações do SHA anterior.

### Correção local e revisão antes de nova promoção

O commit `0494b6de521a15a0e1c076c71774f633325a998e` implementou os pré-requisitos governados.
Passou em 38 testes focados, check local completo e
[CI 36738377833](https://github.com/Vnd93/gaiatec-cms/actions/runs/36738377833), de 15:39:15 a
15:46:45 UTC, 450 s. Não foi promovido. A revisão seguinte encontrou um detalhe da fixture:
o ID de valor técnico era clonado entre produtos, mas a projeção possui chave primária global.
Uma regressão reproduziu a colisão antes da correção e passou com ID distinto por produto.

O commit `88e9bcf8a324d35b12dba3c4f8cd522011270d26` contém esse ajuste mínimo, sem modificar o
schema ou controles de produto. O novo `npm run check` passou: 220 arquivos/1.403 testes da aplicação,
suítes Node/contratuais, evals, lint, tipos e build em 19,33 s, com 799.039 bytes iniciais dentro do
budget. Os skips existentes de symlink no Windows não foram transformados em prova de Linux;
o CI próprio do candidato continua obrigatório. Runtime Node e CLI pinados preservados.

A validação remota deve consumir exclusivamente o pacote selado do SHA `88e9bcf`, após seu CI,
com nova vinculação de ponte e diagnóstico. Os pacotes anteriores continuam preservados como
histórico, não como artefato equivalente do novo candidato.

## Validação remota da fixture G7 — candidato 88e9bcf

| Execução                                                                                 | Resultado                                                | Duração terminal             |
| ---------------------------------------------------------------------------------------- | -------------------------------------------------------- | ---------------------------- |
| [CI 36739513362](https://github.com/Vnd93/gaiatec-cms/actions/runs/36739513362)          | Sucesso, attempt 1, perfil `full-release` fail-closed    | 392 s, 15:48:19–15:54:51 UTC |
| [Ponte 36740518613](https://github.com/Vnd93/gaiatec-cms/actions/runs/36740518613)       | Sucesso, attempt 1, mesmos bytes selados                 | 756 s, 15:56:22–16:08:58 UTC |
| [Diagnóstico 36742897039](https://github.com/Vnd93/gaiatec-cms/actions/runs/36742897039) | Reprovado, attempt 1, 10 checks aprovados / 3 reprovados | 859 s, 16:15:40–16:29:59 UTC |

Esses componentes não formam uma cadeia canônica verde: não há cumprimento comprovado do SLO de
40–60 minutos. O relatório diagnóstico capturou 852 s antes de terminar; o maior step foi o check
local, 259 s. A ponte mediu 736 s no job de promoção; sua maior etapa foi a prova de A sobre o
backend existente, 112 s. Não confundir duração parcial, diagnóstico e caminho feliz de release.

### Artefato único e recuperação da ponte

- Pacote CI `11109981732`, SHA-256
  `c90276c6906ec023e49cc569938994af2cb44c4d3461eb518f8c0fd168e79274`.
- Dist archive `f04f161c1355674cb89b35944e0d50f530fcd736a7eb88004588b9d38cc89cfb`;
  dist tree `22b3cb5fff9b42b564e7d78ac09855ec79bd1795ddf942a7a8444f7eb8954ae1`.
- Prova da ponte `11110484019`, SHA-256
  `0d569b057ee1cd3fc3119b3a88154a1f212193c53d0bc8e67464abddd7c7c388`.
- Deployment canônico `85b12a18-538f-4d45-bc2b-b68529c9807e`; preview
  `3d095702-ae75-4e3d-9684-48ec42f879ad`. Ambos vinculados ao SHA exato.
- Restauração `11109884383`, SHA-256
  `80f6c96c93e40eb047f313cf8ab5e7041d15cf2d2127dcf52238385ad08ee919`.
  Backend restaurado na versão 513, três probes `public-v2` HTTP 200 consecutivos; cleanup e resíduo
  das fixtures aprovados. Watchdog `36742084820` skipped após sucesso, sem compensação necessária.

A ponte comprovou compatibilidade com backend legado e fail-closed sem token. Não comprovou envio
positivo nem UAT do novo catálogo. Antes do diagnóstico: aliases g12/g17 servindo SHA exato,
checkouts limpos/sincronizados, GitHub Vnd93, zero operações concorrentes e fences.

### Diagnóstico reprovado e encerramento seguro

G11 manteve 20 aquecimentos e 20 amostras de leitura, com 10 comandos (uma mutação e nove replays
idempotentes). Leitura p95 **4.924 ms / limite 500 ms**, RPC 4.915 ms, snapshot SQL 2.439 ms e wall
5.208,98 ms. Comandos passaram em **277 ms / limite 800 ms**, wall 833,30 ms. Aquecimentos ficaram
entre 61–415 ms; todas as leituras medidas ficaram entre 818–5.965 ms. Não houve descarte,
novo aquecimento seletivo, mudança de budget ou retry-until-green. A causa exclusiva não está provada.

O ciclo G7 confirmou shell, RBAC, recusa de publicação AAL1, formulário versionado e blog
agendado/publicado/restaurado. Parou em landing HTTP 503 / API HTTP 200, antes de testar os produtos
governados. Portanto, o ajuste da fixture ainda não foi validado remotamente. G17 aprovou 12 checks,
mas não substitui essa falha. O incidente público de latência do Supabase continuava aberto;
não foi usado como desculpa para promover, nem como prova de necessidade de upgrade pago.

O primeiro cleanup retornou `QA_CMS_FIXTURE_CLEANUP_INCOMPLETE`. A retomada de recuperação já
prevista no workflow passou, suspendeu cinco atores, preservou dois eventos de auditoria e provou
resíduo ativo zero em todas as categorias. O diagnóstico permanece reprovado pelo primeiro resultado.
O relatório original não conservou o rótulo da etapa recusada; não é possível reconstruir sua causa
exata a partir do erro genérico. A correção de observabilidade não inventa esse dado histórico.

Watchdog `36744646809` passou; compensação ficou skipped. Consulta posterior confirmou as 14 leases
criadas no diagnóstico como `cleaned`, sem falhas de lease registradas; zero leases ativas. Catálogo
default-off, sem overrides, produtos ou snapshots; 113 migrations/última `0113`, sem workflow ativo
ou fence. Chrome real confirmou acesso autenticado e a mensagem de preparação do catálogo, sem
mudança da flag. Produção e carga/publicação/cutover comercial não foram tocados.

| Evidência                 | Identidade imutável                                                                       |
| ------------------------- | ----------------------------------------------------------------------------------------- |
| Relatórios do diagnóstico | `11111637812`, SHA-256 `0a3626414b445d522ec70e8cc8ed88006890b776a72e1d782dd7485cd555265b` |
| Métricas do diagnóstico   | `11111911974`, SHA-256 `ad830193a9216a32e04888376150eaaca79971bd6bb488865952399532f156aa` |

Não houve outra promoção ou repetição de gate após essa falha. A próxima execução depende de
estabilidade diagnosticada, nova validação dos bytes alterados e preservação integral dos gates.
Continuam pendentes o aprovador funcional independente de CAT-D009, a origem/fabricante do item 20,
Chrome positivo e UAT/rollback. Itens 17/18 provisórios; CAT-D010 adiado. A pausa da automação antiga
não foi confirmada: duas consultas ao serviço expiraram, sem alteração de configuração ou criação
de agendamento duplicado.

## Correção mínima da evidência de cleanup — 830664f

O commit `830664f6384e6bf15e19b91816b82ccc42ba1ef6` preserva o erro bloqueante
`QA_CMS_FIXTURE_CLEANUP_INCOMPLETE` e adiciona ao relatório somente códigos de etapas permitidos
em uma lista fixa, deduplicados, e indicadores booleanos de verificação de resíduo/auditoria.
Valores desconhecidos viram `QA_CMS_FIXTURE_UNKNOWN_CLEANUP_STEP`; mensagens brutas e payloads
não são serializados. Erros não produzidos pelo tipo interno não podem fornecer esse diagnóstico.

Revisão do diff limitada a `scripts/qa/cms-browser-fixture.mjs` e seu teste: nenhuma alteração em
migrations, workflows, ambiente, bibliotecas, operações de cleanup, condições de falha, número de
retries ou autorização. Mesmo com resíduo zero, uma etapa recusada mantém a reprovação original.
Essa correção não reconstrói retroativamente a etapa que falhou no run `36742897039`.

Validação local concluída:

- Três regressões novas: códigos deduplicados com gate reprovado; ausência de dados sensíveis ou
  diagnóstico forjado; distinção entre verificação ausente e prova terminal limpa.
- 41 testes focados passaram no runner nativo, cobrindo fixture, transporte de conclusão de lease
  e pré-requisitos dos produtos. A regressão foi observada falhando antes da implementação.
- `npm run check` integral passou: 220 arquivos Vitest / 1.403 testes, suites Node e contratos,
  evals, lint, tipos e build. Build em 18,84 s, quatro chunks iniciais / 799.039 bytes; Excel e PDF
  continuam lazy. Os skips existentes de symlink no Windows não foram convertidos em aprovações.
- Formatação e `git diff --check` passaram. GitHub Vnd93, repositórios canônicos em `main`, fetch
  sem divergência, mudanças alheias não incluídas. Commit e push sem force, stash ou rebuild de
  artefatos remotos.

O [CI 36746568215](https://github.com/Vnd93/gaiatec-cms/actions/runs/36746568215) terminou verde,
attempt 1, em **480 s** (16:45:46–16:53:46 UTC). Durações dos jobs: plano 31 s, quality 333 s,
browser 93 s, banco 169 s, runtime Edge 153 s, pacote 91 s e métricas 13 s. Os jobs independentes
se sobrepõem; não somar suas durações como caminho crítico. Quality foi a maior etapa desta CI,
com 263 s no check. A seleção manteve `full-release`/`bootstrap-full` fail-closed. O SLO registrado
é `component-only`, não aprovação do caminho feliz completo.

O pacote selado novo é `11113216731`, SHA-256
`d673e5f6226331fc6bf8b2e802b92675018b31c731603db8118df8826c0e823a`.
Dist archive `100d70dd5291d2799dd3c232f19e38e5c9cc16a761a5e16c7a66e6854dc264ec`;
dist tree `7850590d782cce60088ff5f95ea767f3159a10bd2f0dbf94cd4647ac3976d7f8`.
Seleção imutável `11112942147`, SHA-256
`acaeb203ccecfb3ca214e997ff2cc9237bf011f359ad72704761a09d31095af4`;
métricas `11112309704`, SHA-256
`ac237ba06e0a043ba0284774c4180869c0465a6712de4aeadc588d7295758253`.
Esses artefatos pertencem somente a `830664f`; não substituem as evidências do staging `88e9bcf`.
Nenhuma ponte ou promoção desse SHA foi disparada.
O frontend live continua em `88e9bcf`, não no novo commit. Deploy permanece bloqueado pelos gates
operacionais reprovados; a correção de diagnóstico não é uma resolução presumida de G11 ou do 503.

## Encerramento histórico anterior — candidato 035350a

A sonda terminal do candidato final teve 100% de disponibilidade, zero 5xx e p95 público 510,270 ms.
Após finalizer/watchdog: 113 migrations, última `0113`; flag desligada; zero overrides, produtos,
snapshots, leases de QA ativas e tabelas de catálogo sem RLS. Não havia workflow concorrente nem
fence/estado de recovery pendente. GitHub `Vnd93`; ambos os checkouts canônicos em `main`, limpos,
fetch e sincronização fast-forward conferidos; holder existente mantido, sem takeover por TTL.

O Chrome real permaneceu disponível com sessão autenticada, mas o challenge deste run não foi criado:
as lanes pós-deploy, Chrome e evidência de aprovação ficaram skipped. Não há homologação funcional
completa do catálogo. CAT-011 continua dependendo de recaptura/aprovação nominal independente;
CAT-012 continua dependendo de UAT/rollback real. Itens 17/18 são provisórios, item 20 incompleto,
CAT-D010 adiado até dois ciclos manuais estáveis. A autorização de staging não resolve essas decisões.

A pausa da automação histórica `cms-organiza-o-p-s-handoff` **não pôde ser confirmada**: a consulta
retornou somente um cartão, sem configuração, e não foram encontrados arquivos `automation.toml`
na pasta padrão; `CODEX_HOME` estava ausente. Nenhuma automação substituta foi criada nem campos
desconhecidos sobrescritos. Se ela ainda constar ativa no aplicativo, o responsável deve pausá-la
enquanto a decisão de sequência estiver pendente. Não repetir deploy automaticamente.

Este registro é documental: validar, commitar e publicar no repositório de documentação não exige
novo deploy do CMS e não altera o SHA candidato já implantado.
