---
id: cms-inventario-telas-componentes-2026
titulo: Inventário de telas e componentes do CMS
status: ativo
tipo: inventario
area: cms
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - ../90-historico/cms-fases-0-a-11/fase-11/INVENTARIO_TELAS_E_COMPONENTES.md
relacionados:
  - design-system-admin-gaiatec.md
  - matriz-rotas-cms.md
---

# Inventário de telas e componentes do CMS

Persona principal: operador não técnico. Papéis complementares: comercial, marketing, técnico,
editor, revisor, administrador e superadministrador. Menu e ações são sempre derivados do RBAC.

## Arquitetura de navegação

| Seção         | Itens de primeiro nível                                | Abas internas                                                                                     |
| ------------- | ------------------------------------------------------ | ------------------------------------------------------------------------------------------------- |
| Trabalho      | Visão geral; Leads; Assistente IA; Centro de Qualidade | Meu trabalho foi absorvido por fila e atividade da Visão geral                                    |
| Catálogo      | Produtos; Serviços; Indústrias; Aplicações; Soluções   | Produtos: Catálogo, Cadastro em massa, Listas mestras, Busca e sinônimos; demais conforme domínio |
| Conteúdo      | Páginas; Editorial; Mídia                              | Páginas: Páginas, Modelos, Blocos, Tema do site                                                   |
| Marketing     | Campanhas; Formulários                                 | versões, vigência, consentimento e leads                                                          |
| Site          | Navegação; Dados globais; Posicionamentos              | cada documento mantém workflow próprio                                                            |
| Administração | Usuários e acessos; Auditoria; Diagnósticos            | Perfil e sessão é aberto pelo bloco do usuário                                                    |

A sidebar tem 236 px, busca global e itens sempre visíveis. Subferramentas exclusivas não criam
novos itens de menu. PIM, Dados mestres, Estúdio Visual e Multisite permanecem sob feature flag e
são apresentados no contexto da área correspondente.

## Telas e responsabilidades

- autenticação: Login, Recuperação, Definição de senha e MFA TOTP;
- Visão geral: quatro KPIs, fila de trabalho e atividade recente;
- Produtos: catálogo filtrável; importação em quatro etapas; vocabulários; sinônimos; editor em
  Dados essenciais, Modelos, Mídia e SEO/publicação;
- Serviços: Catálogo, Vínculos com produtos e Listas mestras;
- Indústrias: Setores, cobertura em cinco dimensões e Ordem no site;
- Aplicações: catálogo com indústria-mãe, vínculos com nota opcional e matriz produto × aplicação;
- Soluções: grupos de produtos e composição com produtos/serviços;
- Páginas: catálogo, modelos, biblioteca de blocos e tema; builder em outline/canvas/propriedades com
  miniabas Conteúdo, Estilo e Layout;
- Editorial, Mídia, Campanhas, Formulários e Leads: lista, drawer, ficha/editor e workflow;
- Navegação, Dados globais e Posicionamentos: documentos globais versionados e publicados;
- Centro de Qualidade: varredura, KPIs, gravidade e correção no destino exato;
- Assistente IA: resposta com fonte e proposta separada, sempre sujeita a aprovação ou rejeição;
- Auditoria: trilha imutável, filtros, KPIs, uso por usuário e CSV;
- Usuários, Perfil e Diagnósticos: identidade, RBAC/MFA/sessões e eventos operacionais.

## Padrões obrigatórios

Toda lista de entidade usa `RecordDrawer` antes da ficha completa. A ficha unificada contém Dados
principais, imagem 4:3, descrição, histórico e ações Voltar/Salvar; a imagem de apresentação é
obrigatória em serviço, indústria, aplicação e solução. Tabelas usam título + slug mono, badge e
ação Abrir. Ações terminais confirmam em toast. Estados de loading, vazio, erro, permissão e sessão
expirada oferecem causa e próximo passo sem alterar o layout.
