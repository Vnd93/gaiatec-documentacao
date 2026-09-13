---
id: gaiatec-registro-consolidacao-2026-09-13
titulo: Registro de consolidação documental de 13 de setembro de 2026
status: ativo
tipo: registro-de-auditoria
area: qualidade-auditoria
fase: transversal
ambiente: local-e-github
responsavel: Vnd93
data_criacao: 2026-09-13
ultima_revisao: 2026-09-13
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - ../00-indice/status-atual.md
  - ../00-indice/mapa-repositorios.md
  - ../90-historico/handoff-g12-pre-consolidacao-2026-09-13.md
---

# Registro de consolidação documental de 13 de setembro de 2026

## Problemas confirmados

- status ativo parado em 6 de setembro e divergente do GitHub;
- instruções incompatíveis entre fluxo direto em `main` e política antiga de branch + PR;
- pasta local `FONTE_DE_VERDADE` incompleta, com referências obrigatórias a arquivos inexistentes;
- múltiplos clones e handoffs sem classificação clara de autoridade;
- branch documental com quatro commits locais e três alterações ainda não publicadas;
- branches remotas já incorporadas, mas ainda visíveis como linhas de trabalho.

## Preservação realizada

Antes da consolidação, todo o trabalho da branch `docs/g12-production-release` foi commitado e
publicado em `060c05f`. A tag imutável `archive/docs-g12-production-release-2026-09-13` preserva a
linha completa, inclusive o estudo de LLM que não foi promovido a recomendação vigente porque exige
nova verificação de produto, disponibilidade e preços.

Documentos soltos no diretório de trabalho foram movidos para arquivo histórico com manifesto de
hash, sem apagar bytes. Os controles operacionais necessários permaneceram na raiz.

## Decisões

- manter uma única fonte canônica humana em `gaiatec-documentacao/main`;
- manter documentação histórica, mas fora do caminho de entrada;
- tratar estado remoto como fonte de verdade operacional;
- manter Staging e Production separados apesar da organização Supabase comum;
- remover somente branches comprovadamente incorporadas ou preservadas por tag;
- não alterar visibilidade pública nem exigir PR, pois isso mudaria a política vigente e poderia
  afetar integrações.

## Organização do GitHub

Foram removidas 44 branches remotas: 26 do CMS com patches já incorporados e 18 da documentação,
das quais 17 já incorporadas e uma preservada pela tag de arquivo. Branches com commits exclusivos
permaneceram disponíveis. A exclusão automática de branch após merge de PR excepcional foi
habilitada nos dois repositórios.
