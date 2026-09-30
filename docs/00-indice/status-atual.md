---
id: gaiatec-status-atual-2026-09-13
titulo: Status atual do site e CMS GAIATEC
status: ativo
tipo: status-consolidado
area: governanca-documental
fase: execucao
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-30
fonte_canonica: gaiatec-documentacao
substitui:
  - gaiatec-status-atual-2026-09-06
relacionados:
  - comece-aqui.md
  - ambientes-e-execucao.md
  - mapa-repositorios.md
  - ../60-qualidade-auditoria/registro-consolidacao-2026-09-13.md
  - ../10-produto-requisitos/nucleo-catalogo/registro-staging-controlado-fatias-1-a-4-2026-09-29.md
  - ../10-produto-requisitos/nucleo-catalogo/registro-modelo-gratuito-zdr-2026-09-29.md
  - ../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md
---

# Status atual do site e CMS GAIATEC

## Situação vigente — 30 de setembro de 2026: fixture G7 corrigida; validação remota pendente

As Fatias 1–4 e a realocação aprovada da captação positiva para Chrome real já estão implementadas.
Não reiniciá-las. O diagnóstico dirigido `36733465791` terminou em 941 s, com 11 checks aprovados
e dois reprovados: G11 de leitura em 647 ms / limite 500 ms e fixture editorial G7 usando termos
corporativos fora do escopo QA. Cleanup, resíduo e watchdog `36735461416` foram aprovados.

O candidato `88e9bcf8a324d35b12dba3c4f8cd522011270d26` corrige a fixture com termos e atributos
governados pertencentes ao lease, SKUs sintéticos distintos e identificadores de especificação por
produto. Passou no check local completo: 220 arquivos/1.403 testes da aplicação, suítes contratuais,
lint, tipos e build. A regressão de colisão de ID falhou antes e passou depois da correção.
A homologação remota desse SHA ainda está pendente; CI anterior não aprova bytes alterados.

Permanecem obrigatórios G11, ciclo editorial real, Chrome autenticado, captação positiva e suas
13 verificações, UAT/rollback e evidência terminal. Não elevar budgets, escolher amostras favoráveis
ou converter diagnóstico em aprovação. CAT-011 exige aprovação nominal independente; itens 17/18
são provisórios e falta a origem/fabricante do item 20. CAT-D010 continua adiado.

O [registro de execução](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md)
separa diagnóstico, correção e entrega. Catálogo default-off; produção, publicação do catálogo,
carga comercial e cutover permanecem fora do escopo.

## Registro histórico preservado — 30 de setembro de 2026: Chrome implementado; G11 bloqueia homologação

O usuário aprovou mover a captação positiva e suas dependências para Chrome real, sem retirar
controles. A implementação `cccedddc22b895a58f8bca74b649ede3200a1572` passou no check completo
e no CI `36719306735`. A ponte `36720500359` promoveu o mesmo pacote selado para staging.
Não refazer as Fatias 1–4 nem reconstruir o artefato promovido.

A promoção passou no attempt 1; somente a consulta de métricas falhou com HTTP 502. Recuperação,
backend restaurado, cleanup e watchdog foram comprovados. Uma única retomada **somente de métricas**
passou no attempt 2, sem novo deploy. O controle `624eaf0b1256485fbe8ae1174c8219ff94846885`
passou no check completo, em 44 testes focados e no CI `36724177499`. Vincula a prova ao produtor
original e o relatório ao attempt verde, recusando qualquer mudança de execução.

O [deploy canônico 36725530364](https://github.com/Vnd93/gaiatec-cms/actions/runs/36725530364)
consumiu o candidato e pacote originais, mas reprovou o **G11: p95 de leitura administrativa 958 ms,
limite 500 ms**. Comandos passaram em 454 ms / limite 800 ms. A etapa Chrome ficou skipped e não
houve challenge nem captação positiva atestada. Não repetir automaticamente ou aumentar budgets.

Finalizer aprovado em 212 s e watchdog `36728015014` verde, sem recuperação adicional necessária.
Sonda terminal: 100% de disponibilidade, zero 5xx, identidade exata e p95 público 688,970 ms.
O diagnóstico somente leitura confirmou índices válidos e ausência de locks ativos; o custo está
concentrado no snapshot/RPC. O código Supabase/G11 não mudou desde `035350a`; o incidente de latência
do Supabase permanece aberto, mas não comprova sozinho a causa. Próximo passo: diagnóstico dirigido
desse gate antes de outra execução canônica; não reiniciar CI/ponte válidos nem as Fatias 1–4.

O [registro da realocação e retomada](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md)
contém matriz, testes, artefatos e tempos. O release completo e Chrome real ainda não foram homologados.
Flag desligada; 113 migrations; zero dados comerciais, overrides e leases QA ativas.
Produção, publicação do catálogo, carga comercial e cutover continuam fora do escopo.

## Registro histórico preservado — 30 de setembro de 2026: G17 anterior aprovado

O candidato `035350ad690dcba40bd4542705a6b184b01b87bc` está em `main` e em staging. Foram
entregues correções de leitura pública, patches de segurança e UUIDs completos nas fixtures de IA.
CI `36658205367` e ponte `36658865515` verdes; mesmo pacote selado, sem rebuild. Não refazer as Fatias 1–4.

O [deploy canônico 36660065421](https://github.com/Vnd93/gaiatec-cms/actions/runs/36660065421)
passou G11 (29/29), G12 e G17 (12 checks, inferência real Sante gratuita/ZDR). Blog e campanha/formulário
também passaram, mas a **captação positiva foi recusada pelo Turnstile**: o canário ainda envia token
dummy antes da etapa Chrome. O release não está homologado; as lanes posteriores ficaram skipped.

Finalizer e watchdog `36661969245` verdes; sonda terminal com 100% de disponibilidade/zero 5xx.
113 migrations, última `0113`; catálogo default-off, zero overrides, produtos, snapshots e leases QA
ativas; RLS preservada. Produção, carga comercial, publicação do catálogo e cutover intocados.

A próxima decisão é realocar a captação positiva e suas provas dependentes para a etapa Chrome real,
preservando todas as negativas, idempotência, RBAC/AAL2, LGPD, cleanup e evidência terminal. Não aceitar
token dummy, retirar gate ou repetir o run. A pausa da automação histórica não foi confirmada.
O [registro de correções, tempos, artefatos e retomada](../10-produto-requisitos/nucleo-catalogo/registro-resiliencia-editorial-seguranca-2026-09-30.md)
detalha a evidência. Aprovação nominal independente e UAT/rollback do catálogo continuam pendentes;
itens 17/18 provisórios, item 20 incompleto e CAT-D010 adiado.

## Registro histórico preservado — 29 de setembro de 2026: modelo gratuito com ZDR

A autorização de substituição do modelo foi executada exclusivamente em staging. O candidato
`840049128e28e0d66bdd2725cf9df140a326ff29` passou no CI e bridge; migration `0113` aplicada.
O modelo ativo é `inclusionai/ling-3.0-flash-sante:free`, com ZDR, coleta negada e preços máximos
zero. Dados reais, publicação automática, acesso direto ao banco e fallback pago continuam proibidos.

O canário operacional executou inferência real com dados sintéticos e aprovou 12 checks no
[diagnóstico 36620622496](https://github.com/Vnd93/gaiatec-cms/actions/runs/36620622496), com cleanup
e resíduo aprovados. **Esse diagnóstico não aprova o release nem substitui o gate canônico G17.**

O [deploy canônico 36618100708](https://github.com/Vnd93/gaiatec-cms/actions/runs/36618100708)
permanece reprovado por latência G11. O diagnóstico também reprovou comandos (p95 3.675 ms / budget
800 ms) e o ciclo editorial da landing sintética (página/API HTTP 503). O incidente ativo de latência
do Supabase é compatível com parte dos atrasos; não comprova a causa de todos os sintomas.
Finalizer e watchdogs terminaram verdes. Não repetir deploy cegamente nem aumentar budgets.

Estado posterior: 113 migrations, última `0113`, flag `ev2.catalog_v1` desligada, zero overrides,
produtos, snapshots ou leases de QA ativas; RLS preservada. Produção não foi alterada. Chrome real
confirmou apenas sessão autenticada e barreira default-off, não homologação funcional completa.

O [registro da substituição e diagnóstico](../10-produto-requisitos/nucleo-catalogo/registro-modelo-gratuito-zdr-2026-09-29.md)
contém SHAs, digests, resultados Qwen/Sante, tempos e retomada. Não refazer as Fatias 1–4. Faltam
estabilidade/diagnóstico dos bloqueios, gates canônicos, Chrome real completo, UAT/rollback e
aprovação nominal independente. Itens 17/18 permanecem provisórios, item 20 incompleto e CAT-D010
adiado. Não houve carga comercial, publicação do catálogo ou cutover.

## Registro histórico preservado — 29 de setembro de 2026: antes da substituição

O texto abaixo registra a fotografia anterior à autorização de selecionar outro modelo. Sua decisão
pendente foi resolvida pela autorização e execução descritas acima; o registro histórico permanece.

O usuário autorizou migrations e deploy controlados **exclusivamente em staging**. Foram aplicadas
as migrations até `0111` e implantados os bytes selados do candidato
`87010df64300c4c41089f9d0fc74e6bd6ed1a6a7`, sob o controle de release
`92b87565111d09d7b2eb25f3e1f307e9219d8766`. Não reiniciar a implementação das Fatias 1–4.

O [deploy 36595593172](https://github.com/Vnd93/gaiatec-cms/actions/runs/36595593172) passou pelos
gates de migrations, integridade, compatibilidade, três janelas G12 e regressões de navegador,
mas **não foi homologado**: o canário de IA recebeu `OPENROUTER_NO_ALLOWED_PROVIDER`. A consulta
ao OpenRouter confirmou zero endpoints para o modelo fixado. Finalizer e watchdog terminaram
verdes; estado/fences foram liberados por CAS e não havia operação concorrente ao fechar a evidência.

`ev2.catalog_v1` permanece desligada, com zero overrides, produtos, snapshots e leases de QA ativos.
As tabelas do catálogo mantêm RLS. A inspeção em Chrome real autenticado confirmou apenas a barreira
default-off; não substitui UAT funcional. Não houve publicação de catálogo, carga, cutover nem alteração
de produção.

O bloqueio imediato exige decidir entre manter o modelo atual e aguardar disponibilidade ou autorizar
a seleção e validação de outro modelo gratuito com ZDR e coleta de dados proibida. Não há retry
automático nem autorização implícita para trocar o modelo ou reduzir privacidade. Após resolver esse
gate, ainda faltam a homologação Chrome completa, o UAT/rollback do catálogo e a aprovação nominal
independente; itens 17/18 continuam provisórios e item 20 incompleto.

O [registro de staging controlado](../10-produto-requisitos/nucleo-catalogo/registro-staging-controlado-fatias-1-a-4-2026-09-29.md)
contém a cadeia exata de SHA/artefatos, correções já concluídas, recuperação, tempos e ponto de retomada.
Esta atualização prevalece sobre as fotografias históricas abaixo somente quanto ao estado atual.

## Registro histórico preservado — 28 de setembro de 2026

O texto desta seção registra o escopo e o estado daquela data. A restrição então vigente a migrations
e deploy hospedados foi substituída exclusivamente para staging pela autorização de 29 de setembro.

O desenvolvimento integrado das Fatias 1–4 do Núcleo de Catálogo está em `main`, SHA
`486fa5c40baeafe7212914591499245ddef4a5a6`. O
[run 36512509486](https://github.com/Vnd93/gaiatec-cms/actions/runs/36512509486) terminou
integralmente verde: qualidade, banco isolado, navegador automatizado, runtime Edge, pacote e
métricas. Foram aprovados 1.351 testes Vitest e 2.110 testes pgTAP.

O código inclui workspace administrativo, RPCs, revisão/publicação por snapshot, relações,
herança e páginas editoriais. A feature flag continua default-off. Não houve migration hospedada,
deploy, carga, publicação ou cutover; produção não foi alterada. Chrome real autenticado em staging,
aprovação nominal e rollback real permanecem pendentes: CI verde não equivale a esses gates.

Consulte o [registro de integração e gates restantes](../10-produto-requisitos/nucleo-catalogo/registro-integracao-fatias-1-a-4-2026-09-28.md)
para SHA, artefatos, digests, tempos e ponto de retomada. A próxima ação é obter autorização
específica para implantação/homologação controlada de staging; não reiniciar fatias implementadas
nem repetir os runs históricos. Itens 17/18 continuam provisórios e CAT-D010 continua adiado.

## Registro histórico preservado — 13 de setembro de 2026

O texto abaixo é evidência histórica, não instrução operacional vigente. Sua antiga “próxima ação”
foi substituída pelo ponto de retomada acima. Sempre confirmar o estado remoto antes de agir.

Fotografia verificada em **13 de setembro de 2026, 14:50 BRT**. Consulte o estado remoto novamente
antes de qualquer decisão operacional.

## Código e GitHub

- `Vnd93/gaiatec-cms`: branch padrão `main`, SHA
  `0d8386e51ad3185300479ee42642bdf19d935f82`.
- CI desse SHA: [run 34770336844](https://github.com/Vnd93/gaiatec-cms/actions/runs/34770336844),
  concluído com sucesso.
- bridge de frontend de staging:
  [run 34770627214](https://github.com/Vnd93/gaiatec-cms/actions/runs/34770627214), concluído com
  sucesso.
- deploy de staging:
  [run 34771260324](https://github.com/Vnd93/gaiatec-cms/actions/runs/34771260324), concluído com
  falha no ciclo editorial autenticado e mutante. O job finalizer concluiu com sucesso.
- watchdog do deploy:
  [run 34772770045](https://github.com/Vnd93/gaiatec-cms/actions/runs/34772770045), concluído com
  sucesso.
- Ao fim da observação não havia workflow em fila ou execução.

Conclusão correta: o código está publicado em `main` e passou no CI, mas o candidato **não foi
homologado** pelo deploy de staging. Finalizer e watchdog verdes provam encerramento seguro; não
transformam o gate funcional reprovado em aprovação.

## Supabase

Os projetos Staging (`glcqsosxwgmlhzgcsnzv`) e Production (`chfuhctnhqgyjowkvllv`) estão na mesma
organização, **GAIATEC Production**, com isolamento preservado. Staging permanece à frente de
produção. Consulte [ambientes e execução](ambientes-e-execucao.md).

## Documentação

- `Vnd93/gaiatec-documentacao` é a fonte canônica da documentação humana.
- O fluxo vigente é direto em `main`, conforme o `AGENTS.md`; a política antiga de branch + PR foi
  substituída.
- A branch antiga `docs/g12-production-release`, seus commits locais e o trabalho não commitado foram
  preservados no commit `060c05f` e na tag
  `archive/docs-g12-production-release-2026-09-13` antes da consolidação.
- Cópias soltas e a antiga pasta local `FONTE_DE_VERDADE` são material histórico, não instrução
  operacional vigente.

## Próxima ação de desenvolvimento

Retomar a partir do SHA atual, investigar a falha do passo “Run the complete authenticated mutating
editorial cycle first” no run 34771260324 e corrigir somente a causa comprovada. Revalidar CI e o
deploy de staging no novo SHA. Não promover produção e não repetir o mesmo run.
