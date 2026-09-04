# Documentação GAIATEC Sistemas

Fonte oficial da documentação técnica, funcional, operacional e de governança do projeto
**website_gaiatecsistemas**.

## Evolução do CMS — EV2

- [Índice e visão geral da EV2](docs/ev2/README.md)
- [Especificação técnica, funcional e plano de implementação](docs/ev2/ESPECIFICACAO_TECNICA_FUNCIONAL_E_PLANO_DE_IMPLEMENTACAO.md)
- [Decisões e ações necessárias](docs/ev2/DECISOES_E_ACOES_NECESSARIAS.md)
- [Gate de prontidão](docs/ev2/GATE_DE_PRONTIDAO.md)
- [Fase 12 — implantação controlada](docs/ev2/fase-12/README.md)
- [Estado da infraestrutura produtiva](docs/ev2/fase-12/EVIDENCIAS_INFRAESTRUTURA_PRODUCAO_2026-09-04.md)

## Arquitetura e auditoria

- [Registros de decisões arquiteturais](docs/adr/)
- [Relatório da auditoria CMS de 2026-09-01](docs/auditoria-cms-2026-09-01/RELATORIO.md)
- [Matriz da auditoria CMS de 2026-09-01](docs/auditoria-cms-2026-09-01/MATRIZ.md)

## Documentos

- [Auditoria e arquitetura recomendada para o site](documentacao-original/Analise%20e%20Arquitetura%20do%20Site%20-%20GAIATEC%20SISTEMAS.md)
- [Auditoria do site atual e arquitetura recomendada para o CMS](documentacao-original/AUDITORIA_CMS_GAIATEC.md)
- [Complemento técnico-operacional da auditoria do CMS](documentacao-original/COMPLEMENTO_TECNICO_OPERACIONAL_AUDITORIA_CMS_GAIATEC.md)
- [Procedimento de ajustes e desenvolvimento do painel administrativo](documentacao-original/PROCEDIMENTO_AJUSTES_E_DESENVOLVIMENTO_PAINEL_ADMINISTRATIVO_GAIATEC.md)
- [Delta da auditoria do site V2](documentacao-original/AUDIT-DELTA.md)
- [Prompts para geração de imagens](documentacao-original/PROMPTS-IMAGENS.md)
- [Banco de imagens V2](documentacao-original/PROMPTS-IMAGENS-V2.md)
- [Diretrizes gerais](documentacao-original/guidelines/Guidelines.md)
- [Atribuições](documentacao-original/ATTRIBUTIONS.md)
- [README original do projeto](documentacao-original/README_PROJETO_ORIGINAL.md)

## Origem e governança

Os arquivos em `documentacao-original/` foram copiados integralmente do branch `main` do repositório
de origem. As árvores `docs/ev2/`, `docs/adr/` e `docs/auditoria-cms-2026-09-01/` foram importadas do
branch de desenvolvimento EV2 no commit qualificado registrado em [ORIGEM.md](ORIGEM.md).

Este é o repositório principal para manutenção da documentação. Alterações futuras devem ser feitas
aqui por branches e pull requests, seguindo [GOVERNANCA.md](GOVERNANCA.md). Código executável,
workflows de implantação e secrets de runtime continuam fora deste repositório documental.
