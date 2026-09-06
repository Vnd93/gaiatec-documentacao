---
id: gaiatec-glossario-documental
titulo: Glossario documental e operacional
status: ativo
tipo: glossario
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
  - politica-ciclo-de-vida-documental.md
---

# Glossário documental e operacional

| Termo                 | Definição usada neste projeto                                                                                   |
| --------------------- | --------------------------------------------------------------------------------------------------------------- |
| Arquivo histórico     | Área fora dos repositórios ativos que preserva cópias validadas, hashes e possibilidade de rollback.            |
| Artefato operacional  | Arquivo consumido ou produzido por código, teste, CI, workflow ou procedimento executável.                      |
| Branch padrão         | Branch que o GitHub apresenta por padrão e usa como base de diversos eventos e operações.                       |
| Canônico              | Única fonte autorizada para manutenção futura de determinado conteúdo.                                          |
| Check                 | Verificação automatizada associada a código, documento ou PR. Não equivale a aprovação humana.                  |
| Controle operacional  | Autorização, configuração, fixture ou evidência necessária à execução segura de um processo automatizado.       |
| Documento ativo       | Documento vigente, revisável e indicado pelo catálogo como fonte de orientação atual.                           |
| Documento substituído | Versão não vigente preservada com referência explícita ao sucessor.                                             |
| Evidência imutável    | Registro probatório associado a data, ambiente, execução ou SHA cujos bytes não são corrigidos retroativamente. |
| Fixture               | Dado estável usado por teste automatizado, identificado como suporte ao comportamento testado.                  |
| Gate                  | Conjunto de condições e evidências para decidir avanço, pausa ou rollback de uma fase.                          |
| Manifesto             | Registro auditável de origem, hash, decisão, destino e validação de cada item migrado.                          |
| PR                    | Pull request usado para revisão e integração controlada de uma branch.                                          |
| Revisão independente  | Avaliação humana por identidade distinta e autorizada. Ferramentas de IA não criam essa independência.          |
| SHA                   | Identificador de objeto/commit Git; quando citado por evidência, integra sua rastreabilidade.                   |
| SHA-256               | Hash criptográfico usado para validar identidade byte a byte de arquivos copiados.                              |
| Snapshot              | Fotografia datada de um estado; não deve ser atualizada para parecer uma observação posterior.                  |
| Sucessor              | Documento vigente que substitui total ou parcialmente outro documento.                                          |
| Worktree              | Diretório de trabalho registrado pelo Git e associado a branch ou commit específico.                            |
