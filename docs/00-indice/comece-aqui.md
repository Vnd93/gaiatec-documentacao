---
id: gaiatec-comece-aqui
titulo: Comece aqui
status: ativo
tipo: guia-de-entrada
area: governanca-documental
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-13
ultima_revisao: 2026-09-13
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - status-atual.md
  - ambientes-e-execucao.md
  - mapa-repositorios.md
  - ../50-operacao-entrega/fluxo-desenvolvimento-e-release.md
---

# Comece aqui

Use esta ordem para iniciar ou retomar qualquer trabalho:

1. Leia o `AGENTS.md` do checkout em uso. Ele define o fluxo operacional vigente.
2. Consulte o [status atual](status-atual.md), sem transformar a fotografia datada em fonte de
   verdade permanente.
3. Confirme o estado remoto real: branch e SHA, workflows, ambiente e projeto Supabase.
4. Consulte [ambientes e execução](ambientes-e-execucao.md) antes de usar variáveis, migrations,
   functions, aliases ou deploys.
5. Siga o [fluxo de desenvolvimento e release](../50-operacao-entrega/fluxo-desenvolvimento-e-release.md).

## Ordem de autoridade

Em caso de divergência, vale a seguinte precedência:

1. instrução explícita atual do responsável;
2. `AGENTS.md` aplicável ao checkout;
3. controles executáveis e estado remoto do GitHub/Supabase;
4. documentação ativa deste repositório;
5. relatórios e evidências históricas.

Arquivos chamados `HANDOFF`, `STATUS`, `FONTE_DE_VERDADE` ou semelhantes fora desta taxonomia não
substituem esta ordem. Eles devem ser tratados como registros históricos até serem reconciliados.

## Regra de retomada

Uma sessão `idle` não é, por si só, uma falha. Antes de retomar, verifique se ela:

- aguarda um workflow, finalizer, watchdog ou autorização vinculada a SHA;
- possui lease de escrita vigente;
- concluiu o turno e deixou monitoramento automático;
- foi bloqueada por um gate real ou apenas encerrou um ciclo controlado.

Nunca inicie um workflow duplicado para “destravar” uma sessão sem consultar o estado remoto.
