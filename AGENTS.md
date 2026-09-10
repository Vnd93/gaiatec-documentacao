# Regras operacionais canonicas do projeto GAIATEC

## Fluxo Git e entrega

- No repositorio executavel `Vnd93/gaiatec-cms`, desenvolver diretamente em `main`, salvo excecao
  solicitada explicitamente pelo usuario.
- Antes de editar, executar `git fetch`, confirmar o perfil GitHub `Vnd93`, verificar branch e
  checkout e sincronizar somente por fast-forward. Nunca descartar alteracoes locais.
- Preservar toda alteracao preexistente do usuario e nunca inclui-la incidentalmente em stage, commit
  ou deploy. Nao usar stash automatico para ocultar trabalho existente.
- Concluir implementacoes com as validacoes aplicaveis, commit, push sem force e deploy do alvo
  autorizado. Se um gate bloquear a entrega, corrigir dentro do escopo ou registrar a unica acao
  externa necessaria, sem contornar a protecao.
- Nao criar branch, worktree, pull request ou merge no repositorio executavel sem solicitacao
  explicita. O repositorio documental deve respeitar sua branch autorizada e seu proprio upstream.
- Nao usar force-push, reset destrutivo ou checkout destrutivo.

## Coordenacao, seguranca e evidencia de releases do CMS

- Manter somente uma sessao com lease de escrita ativo por vez. Outra sessao so pode escrever depois
  de um handoff explicito, consistente e confirmado; as demais devem permanecer em modo somente
  leitura.
- Nunca permitir que duas sessoes disparem o mesmo workflow, migration, canario, promocao ou deploy.
  Antes de qualquer disparo, consultar o estado remoto real e reutilizar execucoes terminais validas.
- No repositorio `Vnd93/gaiatec-cms`, trabalhar diretamente em `main`. Antes de editar, executar
  `git fetch`, confirmar o perfil GitHub `Vnd93`, verificar branch e checkout e sincronizar apenas por
  fast-forward.
- Preservar toda alteracao preexistente do usuario e nunca inclui-la incidentalmente em stage, commit
  ou deploy. Nao usar stash automatico para ocultar trabalho existente.
- Nao usar force-push, reset destrutivo, checkout destrutivo nem reduzir autenticacao, autorizacao,
  RLS, auditoria, validacoes ou outros controles de seguranca para liberar um gate.
- Vincular testes, matrizes, artefatos, aprovacoes e evidencias ao SHA exato. Qualquer mudanca do SHA
  invalida a aprovacao anterior e exige revalidar tudo o que depende dos bytes alterados.
- Produzir um unico artefato final selado e promover exatamente os mesmos bytes do canario para
  producao, sem recompilar entre ambientes.
- Proibir `.env.local`, configuracao `local`, credenciais ou endpoints de staging no build produtivo.
  Confirmar `VITE_CMS_ENVIRONMENT=production` e o projeto Supabase de producao antes da promocao.
- Manter staging e producao separados em Supabase, Cloudflare, variaveis, secrets, dados sinteticos e
  evidencias. Nunca tratar uma validacao de staging como mutacao ou aprovacao de producao.
- Preservar MFA, AAL, RLS, auditoria imutavel, revogacao de sessao e a separacao de papeis, escopos e
  dados entre CMS e RDO. Nenhuma excecao temporaria de MFA pode permanecer ativa no release final.
- Homologar com Google Chrome real, sessao autenticada e backend real do ambiente correspondente.
  Nao substituir essa homologacao por mock, resposta simulada, analise estatica, simples renderizacao
  ou navegador headless.
- Depois de congelado o candidato, aceitar somente correcoes minimas necessarias para falhas criticas
  ou altas, seguranca, perda ou integridade de dados, autenticacao, publicacao, acessibilidade ou
  homologacao. Toda correcao exige teste de regressao e revalidacao da area afetada.
- Registrar sugestoes esteticas, refatoracoes amplas e expansoes futuras sem inseri-las no release
  congelado, salvo quando forem indispensaveis para satisfazer um gate bloqueante ja aprovado.
- Nunca registrar senha, token, chave, segredo TOTP, cookie, e-mail pessoal, identificador de pessoa,
  dado pessoal ou payload sensivel em arquivo, commit, log, evidencia ou relatorio.
- Quando um gate vinculado ao SHA exigir autorizacao literal, apresentar somente a frase exata
  produzida pelo gate e aguardar a autorizacao correspondente. Nao reutilizar autorizacao de outro
  SHA, ambiente ou gate.
