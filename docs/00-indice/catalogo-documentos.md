---
id: gaiatec-catalogo-documentos
titulo: Catalogo de documentos GAIATEC
status: ativo
tipo: catalogo
area: governanca-documental
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - mapa-documental.md
  - manifesto-migracao-documental.md
  - ../60-qualidade-auditoria/tabela-resolucao-duplicidades.md
---

# Catálogo de documentos GAIATEC

Use este catálogo como ponto de entrada. O inventário integral, incluindo hashes, origem e decisões
de migração, está no [manifesto](manifesto-migracao-documental.md) e em sua versão CSV.

## Documentos transversais

| Documento                                                                                                            | Tipo               | Status     | Finalidade                                              |
| -------------------------------------------------------------------------------------------------------------------- | ------------------ | ---------- | ------------------------------------------------------- |
| [Status atual](status-atual.md)                                                                                      | status consolidado | ativo      | Estado presente de fases, branches e controles          |
| [Mapa documental](mapa-documental.md)                                                                                | índice             | ativo      | Roteamento pela taxonomia                               |
| [Mapa de repositórios](mapa-repositorios.md)                                                                         | mapa               | ativo      | Autoridade e fronteiras entre repositórios/áreas locais |
| [Glossário](glossario.md)                                                                                            | glossário          | ativo      | Vocabulário comum                                       |
| [Política de ciclo de vida](politica-ciclo-de-vida-documental.md)                                                    | política           | ativo      | Estados, metadados, substituição e arquivo              |
| [Manifesto de migração](manifesto-migracao-documental.md)                                                            | manifesto          | em revisão | Inventário, decisões e trilha de movimentação           |
| [Tabela de duplicidades](../60-qualidade-auditoria/tabela-resolucao-duplicidades.md)                                 | decisão            | ativo      | Resolução individual das 24 divergências                |
| [Relatório final da reorganização](../60-qualidade-auditoria/relatorio-final-reorganizacao-documental-2026-09-06.md) | auditoria          | em revisão | Diagnóstico, validações, rollback, PRs e ações manuais  |

## Áreas canônicas

| Área                    | Índice                                                            | Escopo                               |
| ----------------------- | ----------------------------------------------------------------- | ------------------------------------ |
| Produto e requisitos    | [10-produto-requisitos](../10-produto-requisitos/indice.md)       | Escopo, requisitos e planejamento    |
| Arquitetura e segurança | [20-arquitetura-seguranca](../20-arquitetura-seguranca/indice.md) | Arquitetura, ADRs, dados e segurança |
| CMS                     | [30-cms](../30-cms/indice.md)                                     | Uso e operação funcional do CMS      |
| Site público            | [40-site-publico](../40-site-publico/indice.md)                   | Experiência e conteúdo público       |
| Operação e entrega      | [50-operacao-entrega](../50-operacao-entrega/indice.md)           | Runbooks e procedimentos vigentes    |
| Qualidade e auditoria   | [60-qualidade-auditoria](../60-qualidade-auditoria/indice.md)     | Auditorias, QA e evidências          |
| Governança e legal      | [70-governanca-legal](../70-governanca-legal/indice.md)           | Papéis, controles e origem           |
| Evolução EV2            | [80-evolucao](../80-evolucao/indice.md)                           | Evolução, gates e fases EV2          |
| Histórico               | [90-historico](../90-historico/indice.md)                         | Fases e snapshots encerrados         |
| Modelos                 | [99-modelos](../99-modelos/indice.md)                             | Materiais reutilizáveis              |

## Entregáveis de referência

| Documento                                                                                                          | Forma               | Status     |
| ------------------------------------------------------------------------------------------------------------------ | ------------------- | ---------- |
| [Manual do Usuário — DOCX](../30-cms/manual-do-usuario/manual-do-usuario-cms-gaiatec.docx)                         | editável            | ativo      |
| [Manual do Usuário — PDF](../30-cms/manual-do-usuario/manual-do-usuario-cms-gaiatec.pdf)                           | distribuição        | ativo      |
| [Especificação EV2](../80-evolucao/ev2/ESPECIFICACAO_TECNICA_FUNCIONAL_E_PLANO_DE_IMPLEMENTACAO.md)                | Markdown            | ativo      |
| [Decisões EV2](../80-evolucao/ev2/DECISOES_E_ACOES_NECESSARIAS.md)                                                 | Markdown            | ativo      |
| [Fase 17](../80-evolucao/ev2/fase-17/README.md)                                                                    | índice de fase      | em revisão |
| [Pré-requisitos EV2.12 consolidados](../80-evolucao/ev2/fase-12/pre-requisitos-infraestrutura-atual-2026-09-06.md) | síntese aditiva     | em revisão |
| [Validação local de 29/08/2026](../90-historico/cms-validacao-local/ultima-validacao-local-2026-08-29.md)          | evidência histórica | histórico  |

## Busca e manutenção

- Pesquise pelo `id` para referências estáveis e pelo frontmatter `area`, `fase`, `tipo` ou `status`
  para filtros documentais.
- Consulte `90-historico` quando a pergunta exigir o estado de uma fase encerrada, não o presente.
- Consulte o manifesto CSV para localizar todas as origens, inclusive itens arquivados, ignorados ou
  mantidos por dependência técnica.
- Binários e evidências imutáveis são descritos em índices adjacentes; seus bytes não recebem
  alterações meramente documentais.
