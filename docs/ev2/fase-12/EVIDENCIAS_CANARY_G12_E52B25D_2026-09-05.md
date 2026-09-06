# Evidências do canary G12 final em staging — 5 de setembro de 2026

**Resultado técnico:** `G12_CANARY_PASS`  
**Candidato:** `e52b25d903251cf538918d89049a58524c3c9911`  
**Produção e staging estável:** não alterados  
**Autorização de produção:** ainda pendente da frase literal vinculada ao SHA completo

## Identidade e fronteira

| Campo                     | Evidência                                                                             |
| ------------------------- | ------------------------------------------------------------------------------------- |
| Projeto Cloudflare        | `gaiatec-cms-staging`                                                                 |
| Alias isolado             | `https://ev2-g12-canary.gaiatec-cms-staging.pages.dev`                                |
| Deployment imutável final | `https://9511ef3c.gaiatec-cms-staging.pages.dev`                                      |
| Backend                   | Supabase staging `glcqsosxwgmlhzgcsnzv`                                               |
| Atores                    | dois usuários sintéticos com MFA/AAL2 e papéis segregados                             |
| Overrides                 | individuais, temporários e removidos no encerramento                                  |
| Canary run                | `de784acc-a557-4ed1-b4ca-84f0ea26f077`                                                |
| Assurance run G11         | `104b95be-7c7a-479e-83ba-8001a0a876ab`                                                |
| Evidência JSON            | [`G12_CANARY_E52B25D_2026-09-05.json`](evidencias/G12_CANARY_E52B25D_2026-09-05.json) |
| SHA-256 do relatório      | `88411f10217bdcdf08395adea2f73412de38163c2e3a80ef0e8f9a7d41b34299`                    |

O preflight confirmou o mesmo SHA no checkout, em `/healthz`, `X-Release` e
`release-manifest.json`. O alias continuou com ambiente `staging`, `noindex` e sem promoção do
staging estável.

## Execução fail-closed e correção do executor

As tentativas anteriores à medição final foram preservadas como diagnóstico:

1. a primeira publicação não continha o `release-manifest.json`; o canary interrompeu antes de criar
   atores;
2. após a correção do artefato, o executor detectou que o staging estável legado ainda não expunha
   os novos contratos de release; ele interrompeu sem promovê-lo;
3. o executor passou a comparar uma impressão SHA-256 da raiz estável quando ambos os contratos
   legados estão ausentes, mantendo contrato parcial e candidato em modo estrito;
4. a primeira medição completa marcou leitura administrativa p95 de 659 ms, acima do limite de
   500 ms; os dois atores e overrides foram removidos;
5. foram adicionadas cinco leituras de aquecimento descartadas, sem alterar limites nem o conjunto
   de 20 amostras medidas. Uma única medição final foi então executada.

A correção metodológica, os testes e o relatório foram mesclados no
[PR `Vnd93/gaiatec-cms#25`](https://github.com/Vnd93/gaiatec-cms/pull/25), com CI e Preview
aprovados. A `main` do CMS recebeu o merge `10ec170e4656fc6713cb931563ac0f5ca3e880a9`.

## Medição final

| Sinal                        |           Resultado |               Limite |
| ---------------------------- | ------------------: | -------------------: |
| Verificações integradas      |            27 de 27 |                todas |
| Disponibilidade              |                100% |             >= 99,9% |
| Leitura administrativa p95   |              385 ms |            <= 500 ms |
| Comando p95                  |              406 ms |            <= 800 ms |
| Outbox p95                   |                0 ms |         <= 60.000 ms |
| Cobertura de auditoria       |                100% |                 100% |
| Restore transacional         | RPO 0; RTO 1 minuto | RPO 0; RTO <= 15 min |
| Acessibilidade crítica/séria |                 0/0 |                  0/0 |
| P0/P1                        |                 0/0 |                  0/0 |

## Três janelas consecutivas

| Janela                                 | Respostas | Disponibilidade | 5xx | p95 público | Resultado |
| -------------------------------------- | --------: | --------------: | --: | ----------: | --------- |
| `dc6d5f9c-b220-41a9-8e98-b25a91db93fc` |        22 |            100% |  0% |  888,371 ms | pass      |
| `18eef6ff-2e96-4865-a03c-be65afe75010` |        22 |            100% |  0% |  974,514 ms | pass      |
| `f8eabccf-e8d0-4f10-af32-06307e1aeca1` |        22 |            100% |  0% |  881,917 ms | pass      |

Cada janela validou as quatro rotas obrigatórias, os contratos do candidato, o SHA dos headers,
`noindex`, CSP e os budgets HTTP.

## Pós-condições

- zero atores sintéticos ativos;
- zero credenciais sintéticas ativas;
- zero overrides ativos;
- zero leads sintéticos com dados pessoais preservados;
- zero uso de dados reais;
- zero mutações em produção;
- staging estável não promovido e com impressão de conteúdo inalterada
  `4e60c8b8668a1fe1dcd27b64046ce64216ac1dc19381b1938bddbfe6be0d6017`.

## Decisão

O candidato final está tecnicamente qualificado em staging. Esta evidência não executa nem autoriza
produção. O workflow produtivo continuará bloqueado até existir o registro G12 v2 aprovado e a frase
literal `AUTORIZO-G12-PRODUCAO:e52b25d903251cf538918d89049a58524c3c9911` emitida por `@Vnd93`.
