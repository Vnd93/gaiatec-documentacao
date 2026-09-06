---
id: gaiatec-ev2-f12-runbook-go-live-rollback
titulo: Runbook de go-live e rollback EV2.12
status: ativo
tipo: runbook
area: operacao-entrega
fase: ev2-fase-12
ambiente: producao
responsavel: Vnd93
data_criacao: 2026-09-04
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - "gaiatec-documentacao@bee751b:docs/ev2/fase-12/RUNBOOK_GO_LIVE_E_ROLLBACK.md"
relacionados:
  - registro-encerramento-g12-2026-09-06.md
  - EVIDENCIAS_PRODUCAO_G12_2026-09-06.md
---

# Runbook de go-live e rollback EV2.12

> Versão canônica reconciliada em 6 de setembro de 2026 a partir do blob `37f7017c07370ca9ec4e93570e1399480a424c99`
> do commit CMS `123a15e6680e048dc29d176076149f01cf0830dc`. A revisão documental anterior permanece no histórico
> Git pelo blob `2cc8912b720301f9214cdd0aaca4b5cf6eead9ea`.

## Regra de ouro

Produção só pode mudar pelo workflow `Deploy production`, executado em `main`, para um SHA completo
com registro G12 correspondente. Não executar Wrangler manualmente, não recompilar entre preflight e
promoção e não substituir o alvo de rollback durante a janela.

## Pré-janela

1. Confirmar todos os itens de [pré-requisitos](PRE_REQUISITOS_INFRAESTRUTURA.md).
2. Congelar candidato e registrar aprovação em `approvals/G12_<sha>.json` por commit de governança
   posterior, sem alterar o candidato.
3. Registrar change reference, janela e as quatro responsabilidades exercidas pelo único operador
   `@Vnd93`, conforme o risco formalmente aceito.
4. Confirmar backup do banco, restore drill, RPO 0/RTO <= 15 min e ausência de migration destrutiva.
5. Identificar o deployment `Production` atual e seu SHA; ambos devem coincidir com o rollback
   aprovado no registro G12.
6. Confirmar canary, três janelas, comparação de projeções, segurança, privacidade, acessibilidade e
   zero P0/P1.

## Promoção

O workflow executa, nesta ordem:

1. verifica branch, SHA, proteções GitHub, configuração produtiva e registro G12;
2. roda a suíte integral e o audit no checkout exato;
3. gera um único `dist` com todas as flags candidatas em `false`;
4. sela `release-manifest.json` com o SHA;
5. publica esse mesmo artefato no preview isolado `ev2-g12-preflight` do projeto produtivo;
6. valida `/healthz`, `X-Release`, manifest, rotas, noindex e budgets;
7. captura a baseline `Production` e a compara ao alvo de rollback aprovado;
8. aplica as migrations do candidato no Supabase produtivo isolado;
9. configura os segredos, publica todas as Edge Functions e fixa os quatro endpoints sem JWT;
10. restringe Auth, configura o Vault do worker e verifica migration `0054`, RLS, cron, Vault e
    inventário de funções;
11. publica o mesmo `dist` em `main` somente se todo o backend passar;
12. verifica o domínio real com 20 amostras e registra evidência.

## Gatilhos de rollback

- probe pós-promoção falha;
- mismatch de SHA/ambiente ou resposta sem `X-Release`;
- P0/P1, perda, duplicação ou divergência de projeção;
- incidente de segurança/privacidade;
- 5xx, disponibilidade ou latência excede o budget;
- owner de mudança ordena abortamento.

## Rollback

Na falha do probe pós-promoção, o workflow chama automaticamente a API de rollback do Cloudflare
para o deployment produtivo capturado antes da mudança e então executa smoke no domínio real. O
workflow termina com falha mesmo quando a restauração funciona, mantendo o incidente visível.

As migrations desta janela são aditivas e não são desfeitas automaticamente. Se o frontend falhar,
o rollback restaura o site anterior enquanto o backend novo permanece sem consumo pelo shell antigo e
com todas as flags EV2 desligadas. Qualquer correção de banco deve ser compensatória, nunca destrutiva.

Para rollback manual, executar `Rollback production` em `main` e informar:

- UUID de um deployment cujo ambiente seja `Production`;
- SHA completo correspondente;
- change/incident reference;
- confirmação `ROLLBACK-G12-PRODUCTION`.

O script lê o deployment antes da mutação e rejeita previews, UUID/SHA divergentes e projeto que não
seja `gaiatec-website`. Rollback nunca remove tabelas, colunas, auditoria ou histórico.

Referência operacional: [Cloudflare Pages — rollbacks](https://developers.cloudflare.com/pages/configuration/rollbacks/).

## Pós-evento

1. Confirmar release ativa, rotas críticas e integridade das projeções.
2. Preservar logs sanitizados, manifest, probes, approvals e timestamps.
3. Comunicar status e impacto sem dados pessoais.
4. Remover overrides temporários e confirmar flags default-off.
5. Abrir análise causal e só retomar a partir do estágio anterior após três novas janelas saudáveis.
