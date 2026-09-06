---
id: gaiatec-status-atual-2026-09-06
titulo: Status atual do site e CMS GAIATEC
status: ativo
tipo: status-consolidado
area: governanca-documental
fase: ev2-fase-17
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - mapa-repositorios.md
  - ../80-evolucao/ev2/fase-17/README.md
  - manifesto-migracao-documental.md
---

# Status atual do site e CMS GAIATEC

Fotografia verificada em **6 de setembro de 2026**. Este documento consolida o presente sem alterar
o significado de registros históricos.

## Estado executivo

- O ciclo de produção G12 possui registros de encerramento e evidências no repositório documental.
- A fase 17 está implementada no commit CMS `123a15e6680e048dc29d176076149f01cf0830dc` e é proposta
  pelo PR nº 35, com base em `main`; ela ainda não integra `main` nesta fotografia.
- `main` do CMS está em `49a748a1995631abd2f4f7541cb11dedb129f8d6`.
- O GitHub ainda informa `ev2/desenvolvimento-fases-1-a-12` como branch padrão do CMS, no commit
  `91ef5c9`. Isso é configuração legada, não indicação de que essa branch deva receber trabalho novo.
- A reorganização documental ocorre em worktrees limpos, nas branches
  `docs/reorganizacao-documental` e `chore/saneamento-documentacao`, sem merge automático.
- Nenhum deploy, migration, publicação, alteração de staging ou alteração de produção foi executado
  durante esta reorganização.

## Integridade preservada

- O checkout original da fase 17 estava limpo e seus nove commits exclusivos sobre `main` foram
  preservados.
- O worktree `.g6-homologation-aab55f7` permanece registrado, com uma alteração rastreada e um
  arquivo não rastreado; ele não foi movido, removido nem incorporado à reorganização.
- A branch documental `docs/g12-production-release` e `main` possuem commits diferentes, porém a
  mesma árvore Git; nenhum conteúdo exclusivo foi descartado.
- O repositório legado `pedronishida/website_gaiatecsistemas` permanece remoto e consultável. O push
  local foi desabilitado e um clone independente, validado por HEAD, tree e `git fsck`, foi criado no
  arquivo histórico.
- `.secrets` e `.codex-worktrees` permaneceram fora de leitura, cópia, movimentação e versionamento.

## Governança humana e revisão

`Vnd93` é o único perfil administrativo humano autorizado nesta fotografia. Ferramentas de IA
podem apoiar análise, implementação e verificação, mas não constituem uma segunda identidade
GitHub nem uma aprovação humana independente. Quando uma revisão independente real não estiver
disponível, essa limitação deve ser registrada como risco, e os controles automáticos e evidências
não devem ser descritos como uma segunda aprovação humana.

O plano de assinatura GitHub não foi inferido a partir da presença de proteção de branch: em
repositórios públicos, esse recurso também existe no GitHub Free. O estado verificável é que `main`
é pública e aparece protegida; detalhes administrativos da regra exigem consulta autenticada.

## Recomendação sobre a branch padrão do CMS

Alterar a branch padrão para `main`, mas somente após:

1. o PR nº 35 ser revisado e integrado por decisão humana;
2. confirmar, em sessão autenticada, proteção/rulesets e checks obrigatórios de `main`;
3. confirmar environments, secrets e permissões dos workflows de produção;
4. revisar integrações externas que possam citar a branch legada;
5. validar que workflows agendados necessários existem e são executáveis em `main`.

A mudança é recomendada porque eventos `schedule` executam apenas na branch padrão. O workflow de
backup produtivo está definido para `main`; manter outra branch como padrão pode fazer suas
execuções agendadas serem ignoradas. A alteração da configuração remota não faz parte desta
reorganização antes de aprovação.
