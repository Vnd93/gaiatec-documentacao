# EV2.12 — implantação controlada

**Estado consolidado:** release produtiva concluída e verificada.<br>
**Gate:** G12 aprovado e encerrado para o SHA
`e52b25d903251cf538918d89049a58524c3c9911`.<br>
**Produção:** promovida em 6 de setembro de 2026 pelo workflow protegido, run `34039654304`.<br>
**Estado presente global:** [status-atual](../../../00-indice/status-atual.md).

## Objetivo

Promover um artefato imutável com identificação de release, preflight, observabilidade, decisão por
error budget, responsabilidades aprovadas e rollback recuperável. A fase não criou migration:
utilizou as migrations aditivas homologadas até `0054` e preservou as flags EV2 desligadas por
padrão.

## Entregas

| Entrega           | Implementação                                                                               |
| ----------------- | ------------------------------------------------------------------------------------------- |
| Estado da release | `GET /healthz`, `X-Release` e `release-manifest.json` concordam com o SHA completo          |
| Canary isolado    | workflow `EV2.12 Canary Preview`, alias `ev2-g12-canary`                                    |
| Gate automatizado | probe HTTP, budgets, três janelas consecutivas e pausa fail-closed                          |
| Aprovação formal  | registro G12 por SHA, quatro responsabilidades de `@Vnd93`, janela e rollback identificados |
| Promoção          | preflight do mesmo `dist`, baseline capturada antes do deploy e candidato imutável          |
| Recuperação       | rollback autorizado somente para deployment e SHA previamente conferidos                    |

## Limite da autorização

A confirmação `AUTORIZO-G12-PRODUCAO:<SHA completo>` foi consumida exclusivamente para o candidato
registrado. O encerramento não autoriza uma nova implantação e não se estende à EV2.17. Qualquer SHA
posterior exige novo conjunto de evidências, decisão e autorização literal.

## Documentos operacionais

- [Registro de encerramento G12](registro-encerramento-g12-2026-09-06.md)
- [Evidências do canary G12 em staging](EVIDENCIAS_CANARY_G12_2026-09-04.md)
- [Evidências do canary G12 final no SHA e52b25d](EVIDENCIAS_CANARY_G12_E52B25D_2026-09-05.md)
- [Evidências da implementação local](EVIDENCIAS_IMPLEMENTACAO_LOCAL_2026-09-04.md)
- [Evidências da infraestrutura produtiva](EVIDENCIAS_INFRAESTRUTURA_PRODUCAO_2026-09-04.md)
- [Evidências da execução produtiva](EVIDENCIAS_PRODUCAO_G12_2026-09-06.md)
- [Gate G12](GATE_G12.md)
- [Plano de canary em staging](PLANO_CANARY_STAGING.md)
- [Leitura consolidada dos pré-requisitos](pre-requisitos-infraestrutura-atual-2026-09-06.md)
- [Snapshot documental dos pré-requisitos](PRE_REQUISITOS_INFRAESTRUTURA.md)
- [Matriz de rollout](MATRIZ_ROLLOUT.md)
- [Runbook de go-live e rollback](RUNBOOK_GO_LIVE_E_ROLLBACK.md)
- [Treinamento e handover](TREINAMENTO_E_HANDOVER.md)
- [Modelo de aprovação](G12_APPROVAL.template.json)
- [Controles finais EV2.16](../fase-16/README.md)

O probe pós-promoção passou, o rollback não foi acionado e as rotas reais foram verificadas no Edge.
