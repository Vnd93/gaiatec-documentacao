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
ultima_revisao: 2026-09-29
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
---

# Status atual do site e CMS GAIATEC

## Situação vigente — 29 de setembro de 2026: modelo gratuito com ZDR

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
