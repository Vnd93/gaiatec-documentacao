# Regras operacionais da documentação GAIATEC

- Este repositório é a fonte canônica da documentação humana do projeto.
- Trabalhar diretamente em `main`, conforme a política vigente do projeto. Não criar branch,
  worktree ou pull request salvo instrução explícita do responsável.
- Antes de editar: confirmar o perfil GitHub `Vnd93`, executar `git fetch`, verificar o checkout e
  sincronizar `main` apenas por fast-forward. Nunca descartar alterações locais.
- Manter somente uma sessão com lease de escrita ativo. As demais sessões ficam somente leitura.
- Preservar trabalho preexistente; não usar stash automático nem incluir mudanças incidentais.
- Executar `npm run check`, commitar e publicar em `origin/main` ao concluir. Alteração exclusivamente
  documental não possui deploy de aplicação.
- Nunca incluir segredo, credencial, cookie, dado pessoal ou payload sensível.
- Evidência histórica permanece imutável. Correções de estado atual são aditivas e apontam para o
  registro histórico correspondente.
- O estado remoto real do GitHub, Supabase e workflows prevalece sobre fotografias documentais
  antigas. Atualizar `docs/00-indice/status-atual.md` quando uma decisão depender do estado presente.
