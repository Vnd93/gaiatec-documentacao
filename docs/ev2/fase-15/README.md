# EV2.15 — Fechamento técnico e integração segura

**Estado:** código qualificado e integrado; fechamento documental em validação<br>
**Data-base:** 5 de setembro de 2026<br>
**Branch de código consolidada:** `ev2/desenvolvimento-fases-1-a-12`<br>
**Branch documental:** `docs/ev2-fase-15-fechamento-operacional`<br>
**Produção, dados reais e staging estável:** inalterados

## Objetivo

Encerrar a dívida técnica acionável encontrada depois da aprovação do G14, validar o conjunto
completo em CI e em um preview efêmero e integrar, em ordem, os incrementos EV2.13, EV2.14 e o
hardening final. Esta fase não cria um novo gate funcional nem amplia o escopo autorizado pelo
G14.

## Correções de fechamento

- o ciclo de vida do `IntersectionObserver` passou a observar e liberar o mesmo elemento;
- o divisor diagonal voltou a renderizar a transição definida por suas propriedades;
- o carregador em grade passou a anunciar seu estado para tecnologia assistiva;
- imports, constantes, cálculos e callbacks sem consumidores foram removidos;
- dependências de hooks, código não usado e fronteiras Fast Refresh passaram de aviso para erro de
  CI;
- as exceções Fast Refresh ficaram restritas e documentadas somente para módulos que expõem uma
  API composta deliberada;
- duas regressões de componente foram adicionadas para proteger as correções visuais e de
  acessibilidade.

## Critérios de qualificação

| Critério                      | Resultado exigido                                                     |
| ----------------------------- | --------------------------------------------------------------------- |
| Formatação, lint e TypeScript | zero erro e zero aviso acionável                                      |
| Testes                        | suíte Vitest integral e gates EV2.0–EV2.14 aprovados                  |
| Dados                         | migrations e testes de banco aprovados, sem mutação remota desta fase |
| Navegador                     | suíte Playwright aprovada                                             |
| Build                         | build de produção reproduzível e orçamento de bundle aprovado         |
| Dependências                  | zero vulnerabilidade no nível configurado de auditoria                |
| Preview                       | SHA exato em URL efêmera, não indexável, com smoke HTTP aprovado      |
| Integração                    | PRs empilhados consolidados em ordem e sem conflito                   |

## Ordem de integração

1. código EV2.13, PR `Vnd93/gaiatec-cms#6` — integrado;
2. código EV2.14, PR `Vnd93/gaiatec-cms#7` — integrado;
3. hardening final, PR `Vnd93/gaiatec-cms#8` — integrado;
4. documentação EV2.13, PR `Vnd93/gaiatec-documentacao#5` — integrada;
5. documentação EV2.14, PR `Vnd93/gaiatec-documentacao#6` — integrada;
6. este fechamento documental, em PR próprio.

Cada PR posterior deve ser reposicionado para a base consolidada somente depois da integração do
anterior. Uma validação remota verde não autoriza publicação em produção.

## Evidência

- [Relatório de qualificação final](RELATORIO_QUALIFICACAO_FINAL_2026-09-05.md)
- [PR de código #8](https://github.com/Vnd93/gaiatec-cms/pull/8)
- [CI de push do candidato](https://github.com/Vnd93/gaiatec-cms/actions/runs/33976345138)
- [CI do PR do candidato](https://github.com/Vnd93/gaiatec-cms/actions/runs/33976383770)
- [Preview efêmero validado](https://ev2-final-rc.gaiatec-cms-staging.pages.dev)
- [CI do ramo consolidado](https://github.com/Vnd93/gaiatec-cms/actions/runs/33977119188)

## Limites remanescentes

O estado qualificado significa ausência de falhas conhecidas nos controles executados, não uma
promessa absoluta de inexistência de defeitos futuros. O Gate G12 de produção continua independente
e pendente. Nenhum resultado desta fase autoriza dados ou domínios reais, provedor externo,
ativação global, promoção do staging estável ou publicação em produção.
