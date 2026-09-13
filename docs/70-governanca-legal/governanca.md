---
id: gaiatec-governanca-repositorio-documental
titulo: Governança do repositório documental
status: ativo
tipo: politica-de-governanca
area: governanca-legal
fase: transversal
ambiente: github
responsavel: Vnd93
data_criacao: 2026-09-04
ultima_revisao: 2026-09-13
fonte_canonica: gaiatec-documentacao
substitui:
  - GOVERNANCA.md
relacionados:
  - controles-repositorio.md
  - origem.md
  - ../00-indice/comece-aqui.md
  - ../00-indice/status-atual.md
  - ../00-indice/politica-ciclo-de-vida-documental.md
---

# Governança do repositório documental

`Vnd93/gaiatec-documentacao` é a única fonte canônica dos documentos humanos do projeto. Código,
infraestrutura, testes, deployment, fixtures e controles executáveis pertencem ao
[`Vnd93/gaiatec-cms`](https://github.com/Vnd93/gaiatec-cms).

Este repositório não recebe código da aplicação, builds, secrets, `.env`, credenciais, dados
pessoais, logs não sanitizados ou workflows com autoridade para alterar ambientes.

## Fluxo vigente

1. Obter lease exclusivo de escrita.
2. Confirmar `Vnd93`, executar `git fetch` e sincronizar `main` apenas por fast-forward.
3. Preservar alterações preexistentes e editar diretamente em `main`.
4. Atualizar proveniência e estado documental quando aplicável.
5. Executar `npm run check`.
6. Commitar e publicar em `origin/main`.
7. Liberar o lease; deploy de aplicação não se aplica.

Branch, worktree e pull request são exceções que exigem solicitação explícita. Force-push, descarte
de trabalho local, exclusão de `main` e bypass de checks continuam proibidos.

## Autoridade e evidência

- `Vnd93` é o perfil humano administrativo confirmado.
- IA apoia análise e execução, mas não representa segunda aprovação humana.
- Estado remoto e controles executáveis prevalecem sobre narrativas desatualizadas.
- Evidências identificam ambiente, horário, SHA, run e resultado sem expor dados sensíveis.
- Evidência histórica mantém seus bytes; correções são aditivas e apontam para a origem.
- “Pronto”, “publicado”, “compensado” e “homologado” são estados diferentes e não são
  intercambiáveis.
