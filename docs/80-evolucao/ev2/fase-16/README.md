# EV2.16 — controles vinculantes de prontidão para produção

**Estado consolidado em 6 de setembro de 2026:** controles técnicos e externos aprovados para o
candidato `e52b25d903251cf538918d89049a58524c3c9911`; autorização literal validada e consumida pelo
go-live G12, concluído no run `34039654304`.<br>
**Estado presente global:** [status-atual](../../../00-indice/status-atual.md).

Esta fase converteu os pré-requisitos finais em verificações automáticas e evidências imutáveis. Os
controles e a autorização são vinculados ao candidato; não concedem autorização permanente nem se
transferem para a EV2.17.

## Resultado por controle

| Controle                  | Implementado no repositório                                 | Resultado consolidado                   |
| ------------------------- | ----------------------------------------------------------- | --------------------------------------- |
| GitHub e mantenedor único | PR de `@Vnd93`, CODEOWNERS exclusivo, CI e branch protegida | controles aprovados                     |
| Backup e restore          | dump cifrado externo e restore efêmero comparado            | run `34000214134` aprovado              |
| DPO/legal                 | identidade, instante, referência e hash exato do escopo     | aprovado                                |
| E-mail                    | entrega sintética pelo Resend para o candidato              | comprovada                              |
| CSP                       | enforcement no candidato com evidências HTTP e navegador    | aprovado sem violação crítica           |
| Operação                  | quatro responsabilidades, risco solo, evidências e janela   | aceitos                                 |
| Autorização final         | literal `AUTORIZO-G12-PRODUCAO:<SHA completo>`              | recebida, verificada e consumida no G12 |

## Artefatos

- [Proteção GitHub no modelo solo](GITHUB_PROTECAO_E_REVISORES.md)
- [Backup e restore](BACKUP_EXTERNO_E_RESTORE_DRILL.md)
- [Provedor de e-mail](PROVEDOR_EMAIL_PRODUCAO.md)
- [Análise CSP](ANALISE_CSP.md)
- [Responsáveis, DPO/legal e autorização](RESPONSAVEIS_E_APROVACOES.md)
- [Escopo DPO/legal padrão](ESCOPO_DPO_LEGAL_PADRAO.md)
- [Declaração histórica de 5 de setembro](REGISTRO_DECLARACAO_GOVERNANCA_DPO_RISCO_2026-09-05.md)
- [Registro consolidado de declaração e autorização](registro-declaracao-governanca-dpo-risco-2026-09-06.md)
- [Evidências históricas de 5 de setembro](EVIDENCIAS_CONTROLES_2026-09-05.md)
- [Evidências consolidadas de 6 de setembro](evidencias-controles-2026-09-06.md)
- [Evidência HTTP aprovada do canary CSP](evidencias/G16_CSP_HTTP_7804d5b.json)
- [Evidência de navegador aprovada do canary CSP](evidencias/G16_CSP_BROWSER_7804d5b.json)
- [Primeira janela HTTP preservada em pausa](evidencias/G16_CSP_HTTP_7804d5b_ATTEMPT1_PAUSE.json)
- [Encerramento do Gate G12](../fase-12/registro-encerramento-g12-2026-09-06.md)

O approval operacional consumido pelo deployment permanece no repositório executável, pois é um
controle de release validado pelo workflow, e não documentação narrativa.
