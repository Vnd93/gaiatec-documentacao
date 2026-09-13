---
id: gaiatec-fluxo-desenvolvimento-release
titulo: Fluxo de desenvolvimento e release
status: ativo
tipo: procedimento-operacional
area: operacao-entrega
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-13
ultima_revisao: 2026-09-13
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - ../00-indice/comece-aqui.md
  - ../00-indice/ambientes-e-execucao.md
  - ../70-governanca-legal/governanca.md
---

# Fluxo de desenvolvimento e release

## Preparação

1. Ler `AGENTS.md` e o lease operacional aplicável.
2. Confirmar o perfil GitHub `Vnd93`.
3. Executar `git fetch`, verificar alterações locais e preservar trabalho preexistente.
4. Trabalhar em `main` e sincronizar somente por fast-forward.
5. Confirmar que não há outro escritor nem workflow equivalente em fila ou execução.

## Implementação e entrega

1. Fazer a menor alteração que resolve a causa comprovada.
2. Executar validações proporcionais ao risco.
3. Vincular evidências ao SHA exato.
4. Commitar e publicar em `origin/main` sem force-push.
5. Para código, executar o alvo padrão de deploy associado à `main` e promover os mesmos bytes
   selados entre canário e produção.
6. Para documentação, concluir após validação, commit e push; deploy de aplicação não se aplica.

## Gates e ambientes

- Staging e produção são ambientes separados. Aprovação em staging não autoriza mutação manual de
  produção.
- Falha de gate exige causa, correção mínima e nova validação no novo SHA.
- Finalizer ou watchdog verde após falha prova compensação/encerramento, não aprovação funcional.
- Não reutilizar aprovação, artefato ou evidência de outro SHA.
- Não reduzir MFA, AAL, RLS, auditoria, autorização ou isolamento para liberar um gate.

## Encerramento e handoff

Registrar SHA, testes, runs, resultado do deploy, resíduos, bloqueios e próxima ação. Liberar o lease
ao terminar. Uma sessão sucessora retoma pelo estado remoto e por este registro, não pela suposição
de que uma tarefa `idle` esteja travada.
