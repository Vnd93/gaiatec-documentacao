# Relatório final do canary G14 em staging

**Data:** 5 de setembro de 2026<br>
**Branch de código:** `ev2/fase-14-ia-transacional-controlada`<br>
**SHA aprovado pelo REV-01:** `64cea11e196bc3889dc6ea7ab1b6b151f64b0220`<br>
**Alias isolado:** `ev2-g14-canary.gaiatec-cms-staging.pages.dev`<br>
**Implantação candidata:** `0a81d9cf.gaiatec-cms-staging.pages.dev`<br>
**Decisão:** G14 aprovado no escopo sintético de staging; candidato não promovido

## Pré-condições confirmadas

- repositório de código limpo e exatamente no SHA aprovado pelo REV-01;
- CI local integral aprovado com 50 arquivos e 166/166 testes, 13/13 controles G14, 18/18
  avaliações adversariais, build e audit sem vulnerabilidade alta/crítica;
- CIs de push e PR aprovados no mesmo SHA;
- projeto remoto confirmado como `GAIATEC CMS Staging` (`glcqsosxwgmlhzgcsnzv`), `us-east-2`;
- migration aditiva `0054` já aplicada e pgTAP remoto aprovado em 58/58;
- `cms-ai-execute` v1 já ativa em staging, com verificação JWT e provider externo desligado;
- nenhuma republicação de função ou reaplicação de migration nesta reexecução.

## Candidato isolado

O build foi gerado do SHA exato e publicado somente como Preview do branch `ev2-g14-canary`. O
manifesto contém 1.457 arquivos e release
`64cea11e196bc3889dc6ea7ab1b6b151f64b0220`; o contrato `/healthz` retornou `ready` com a mesma
release. Seis rotas administrativas corrigidas retornaram `200`, `private, no-store` e `noindex`.

| Verificação                        | Resultado                                   |
| ---------------------------------- | ------------------------------------------- |
| Smoke HTTP                         | 6/6; páginas inexistentes mantiveram `404`  |
| Acessibilidade                     | 5 aprovadas; 1 caso desktop inaplicável     |
| Respostas da sonda ampliada        | 82                                          |
| Disponibilidade / HTTP 5xx         | 100% / 0%                                   |
| p95 público agregado               | 1.181,11 ms                                 |
| maior p95 por rota (`/produtos`)   | 1.305,90 ms; orçamento de 1.500 ms atendido |
| Release, headers, health e noindex | contratos exatos                            |

## Executor integrado

O executor rodou entre `2026-09-05T14:59:15.697Z` e `2026-09-05T15:00:06.342Z` e concluiu 35/35
verificações. Foram comprovados:

- dois usuários descartáveis com MFA/AAL2 e dois overrides individuais de até 30 minutos;
- flags globais desligadas e ausência de ativação ampla;
- catálogo fechado de cinco tools e fronteira exclusiva de dados sintéticos `g14x-*`;
- bloqueios de produção, dados pessoais, execução sem MFA e autoaprovação;
- aprovação por outro ator, vinculada ao hash/versão e com expiração;
- vencedor único em criação e execução concorrentes, sem aplicação parcial;
- execução atômica e idempotente, publicação apenas do alvo sintético;
- compensação aprovada por outro ator, renovação após expiração, ausência de deadlock e versão
  monotônica;
- trilha de política completa com 16 decisões correlacionadas.

## Limpeza e invariantes

O executor terminou com `syntheticResidue=0`. Uma consulta independente posterior confirmou zero
usuário de autenticação G14, perfil, override G14, alvo `g14x-canary-*` e plano sintético G14. As
duas flags continuaram default-off e sem kill switch; `cms_content_revisions` permaneceu em 86 e
`cms_publication_outbox` em 103, iguais ao baseline.

| Fronteira                         | Resultado |
| --------------------------------- | --------- |
| Chamadas a provedor externo       | 0         |
| Uso de dados reais                | 0         |
| Mutações de produção              | 0         |
| Resíduo sintético                 | 0         |
| Promoção do staging estável       | não houve |
| Ativação global, domínio ou merge | não houve |

## Rastreabilidade

- [CI do push, execução 33970950973](https://github.com/Vnd93/gaiatec-cms/actions/runs/33970950973);
- [CI do PR #7, execução 33970953195](https://github.com/Vnd93/gaiatec-cms/actions/runs/33970953195);
- [implantação Preview isolada](https://0a81d9cf.gaiatec-cms-staging.pages.dev);
- `evidencias/G14_CANARY_64cea11.json`: relatório sanitizado 35/35;
- `evidencias/G14_HTTP_PROBE_64cea11.json`: métricas HTTP ampliadas.

## Conclusão

Os critérios vinculantes do Gate G14 foram atendidos pelo mesmo SHA de código. A aprovação limita-se
ao sandbox sintético de staging. Produção, dados/domínios reais, provider externo, ativação global,
promoção do staging estável e merge permanecem fora do escopo e bloqueados.
