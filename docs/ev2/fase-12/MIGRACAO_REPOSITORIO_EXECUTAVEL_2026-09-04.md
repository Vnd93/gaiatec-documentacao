# Migração do repositório executável — 4 de setembro de 2026

## Resultado

O repositório privado [`Vnd93/gaiatec-cms`](https://github.com/Vnd93/gaiatec-cms) foi criado como
fonte administrável do código executável, separado de `Vnd93/gaiatec-documentacao`. Nenhum deploy,
migration remota, dado real, domínio, flag ou recurso de produção foi alterado.

## Origem e referências validadas

Origem histórica: `pedronishida/website_gaiatecsistemas`. A cópia local inicial era rasa; antes da
transferência, o histórico foi completado pela origem e validado com `git fsck --full --strict`.
Foram auditados 218 commits alcançáveis.

| Referência                               | SHA validado                               |
| ---------------------------------------- | ------------------------------------------ |
| `main`                                   | `63da59443701fc1045575d511b026a609a7cd2b3` |
| `Remodelagem`                            | `9e25a28e6aac1b3aab179f755bf0b3c8e16605b4` |
| `ev2/fase-0-documentacao-e-planejamento` | `4428979cdaf34eea15af31e47baccee68beaba44` |
| `ev2/desenvolvimento-fases-1-a-12`       | `5c3e00f3ca5d5be6754c130c75cc01745e30e03e` |
| `cms-archive-2026-05`                    | `e3576b51aaf77d8f3124739bd9a483715401dcab` |

O candidato G12 `8250db0ddb221306a2621aa9c6004f45823ec532` permanece contido na branch EV2. A
comparação pós-push confirmou correspondência exata de todas as referências. O checkout de trabalho
passou a usar o novo repositório como `origin`; a origem histórica ficou como `legacy-source`, com
push desabilitado localmente.

## Auditoria antes do push

- nenhum blob alcançável excede 50 MiB; o maior tem aproximadamente 10,8 MiB;
- nenhum token GitHub, Cloudflare, AWS, OpenAI, Supabase `service_role` ou chave privada real foi
  detectado;
- os dois blocos de chave privada encontrados são fixtures sintéticas curtas dos testes EV2.10;
- o único JWT histórico detectado tem papel público `anon` e pertence ao projeto pausado
  `pbmyttjnqijdbscrjayk`; a árvore atual não o contém e usa variáveis de ambiente com fallback local
  inerte;
- `.env.example` contém somente exemplos e orientações, sem refs de staging/produção ou JWT real.

## Controles aplicados

| Controle                           | Estado verificado                                                       |
| ---------------------------------- | ----------------------------------------------------------------------- |
| Visibilidade                       | privado                                                                 |
| Branch padrão                      | `ev2/desenvolvimento-fases-1-a-12`, alinhada ao desenvolvimento ativo   |
| Actions durante a migração         | desabilitado; nenhum workflow executou durante o push histórico         |
| Política de Actions                | ações GitHub e três dependências externas por SHA exato                 |
| Pin de dependências                | SHA completo obrigatório; 0 referências mutáveis na branch de hardening |
| Permissão padrão do `GITHUB_TOKEN` | somente leitura                                                         |
| PR por workflow                    | criação e aprovação desabilitadas                                       |
| Reuso por outros repositórios      | desabilitado                                                            |
| Retenção de artefatos/logs         | 30 dias                                                                 |
| Dependências                       | grafo, alertas, malware e security updates agrupados habilitados        |

O hardening foi integrado pelo
[PR executável #1](https://github.com/Vnd93/gaiatec-cms/pull/1), no merge
`77cda0b2c5d6999cfb5d260ad24f06f83d231b11`, depois de quatro checks aprovados: qualidade,
banco local com pgTAP, navegador e preview. A validação local também aprovou `npm run check`,
`npm audit --audit-level=high` com zero vulnerabilidades e `npm run build:staging`.
A [execução pós-merge](https://github.com/Vnd93/gaiatec-cms/actions/runs/33917765696) também foi
aprovada em `push`, com os três jobs de qualidade, banco e navegador concluídos sem erro.

A branch padrão foi alterada de `main` para `ev2/desenvolvimento-fases-1-a-12`. Assim, novos PRs,
clones e a análise automática de dependências passam a usar a linha efetivamente ativa, sem
promover código nem executar qualquer ação em produção. A `main` histórica foi preservada para a
futura integração produtiva controlada.

Após a troca, o Dependabot reavaliou a base ativa e passou a registrar `0` alertas abertos e `35`
alertas fechados. Os quatro PRs automáticos inicialmente criados sobre a `main` histórica foram
redirecionados, recompostos por comando do bot e encerrados pelo próprio Dependabot como
desnecessários para a árvore EV2 atual. A confirmação local por `npm audit --audit-level=low` também
retornou zero vulnerabilidades em todos os níveis.

## Bloqueio preservado

O GitHub informa que rulesets e proteções clássicas não são aplicados a repositórios privados de
conta pessoal Free. Por isso:

- não foi criada regra de `main` sem enforcement;
- não foi criado ambiente `production`;
- nenhum secret ou variable de produção foi cadastrado;
- nenhuma promoção ou execução produtiva foi autorizada.

Para remover o bloqueio, mover o repositório para uma organização GitHub Team/Enterprise, cadastrar
o responsável técnico independente, proteger `main` com PR, approval, checks estritos e sem bypass,
e somente então criar o ambiente `production` com revisão e `prevent_self_review`.
