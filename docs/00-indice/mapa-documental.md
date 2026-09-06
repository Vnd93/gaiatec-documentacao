---
id: gaiatec-mapa-documental
titulo: Mapa documental GAIATEC
status: ativo
tipo: indice
area: governanca-documental
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - status-atual.md
  - catalogo-documentos.md
  - politica-ciclo-de-vida-documental.md
---

# Mapa documental GAIATEC

Este repositório é a fonte canônica da documentação humana técnica, funcional, operacional, de
produto, governança e evolução do site e do CMS GAIATEC. O repositório executável mantém somente
código, infraestrutura, testes, workflows, fixtures e controles operacionais consumidos pela
execução.

## Ordem recomendada de consulta

1. [Status atual](status-atual.md): fotografia consolidada e datada do estado presente.
2. Este mapa: regra de roteamento por assunto.
3. [Catálogo de documentos](catalogo-documentos.md): pontos de entrada e classificação.
4. [Glossário](glossario.md): vocabulário comum.
5. [Política de ciclo de vida](politica-ciclo-de-vida-documental.md): criação, revisão, substituição e
   arquivamento.
6. [Manifesto da migração](manifesto-migracao-documental.md) e
   [tabela das divergências](../60-qualidade-auditoria/tabela-resolucao-duplicidades.md): trilha de
   auditoria da reorganização.

## Taxonomia

| Faixa                      | Área               | Conteúdo esperado                                                       |
| -------------------------- | ------------------ | ----------------------------------------------------------------------- |
| `00-indice`                | Navegação e estado | Mapas, catálogo, glossário, manifestos e políticas documentais          |
| `10-produto-requisitos`    | Produto            | Objetivos, requisitos, escopo e planejamento de produto                 |
| `20-arquitetura-seguranca` | Arquitetura        | ADRs, arquitetura, dados, segurança e privacidade técnica               |
| `30-cms`                   | CMS                | Operação funcional do CMS, API humana e manual do usuário               |
| `40-site-publico`          | Site público       | Conteúdo, experiência pública e diretrizes editoriais                   |
| `50-operacao-entrega`      | Operação           | Runbooks vigentes, entrega e procedimentos operacionais                 |
| `60-qualidade-auditoria`   | Qualidade          | Auditorias, matrizes, decisões de consolidação e evidências de QA       |
| `70-governanca-legal`      | Governança         | Responsabilidades, origem, controles de repositório e obrigações legais |
| `80-evolucao/ev2`          | Evolução           | Plano, gates, relatórios e evidências da EV2 por fase                   |
| `90-historico`             | Histórico          | Fases encerradas e versões preservadas sem pretensão de atualidade      |
| `99-modelos`               | Modelos            | Templates e materiais reutilizáveis                                     |

Cada área possui um `indice.md`. Nomes novos usam `kebab-case`, sem espaços e sem acentos. ADRs e
evidências imutáveis podem preservar o nome legado quando renomeá-los prejudicaria a
rastreabilidade.

## Regras de roteamento

- Uma narrativa destinada a pessoas existe somente neste repositório.
- Um artefato consumido por CI, teste, deployment ou runtime fica no repositório executável e é
  classificado como controle, fixture ou saída operacional — não como documentação canônica.
- Evidências vinculadas a commit conservam bytes, nome e proveniência; correções são aditivas.
- Um documento substituído aponta explicitamente para o sucessor e não é reescrito para parecer
  atual.
- O estado corrente é consolidado em `status-atual.md`; relatórios históricos continuam datados.
- `.codex-artifacts` é área transitória por tarefa e nunca fonte canônica.

## Fronteiras entre repositórios

Consulte o [mapa de repositórios](mapa-repositorios.md). O índice curto mantido no CMS aponta para
este repositório; ele não replica manualmente esta árvore.
