# Relatório de qualificação final — EV2.15

**Data:** 5 de setembro de 2026<br>
**Base G14:** `64cea11e196bc3889dc6ea7ab1b6b151f64b0220`<br>
**Candidato de hardening:** `36c5cae3ff565f4b10974a84f021d6491d248931`<br>
**Candidato final reprodutível:** `aa1b6466d5040b73bf381249c819fb233af67b44`<br>
**Head integrado final:** `e92632c4faf0d488b5d62c316f8d165f8e02aff9`<br>
**PRs de código:** [#8](https://github.com/Vnd93/gaiatec-cms/pull/8) e
[#9](https://github.com/Vnd93/gaiatec-cms/pull/9)<br>
**PR documental:** [Vnd93/gaiatec-documentacao#7](https://github.com/Vnd93/gaiatec-documentacao/pull/7)<br>
**Produção:** não alterada

## Escopo avaliado

A revisão final percorreu o diff da EV2.14, o estado dos PRs empilhados, a configuração de CI, os
testes de banco e navegador, o build, o orçamento de bundle e a auditoria de dependências. O único
passivo mecânico mensurável encontrado era um conjunto de 46 avisos de lint. A correção também
identificou três comportamentos concretos: liberação inconsistente do observador, um divisor visual
que ignorava suas cores e texto de carregamento não exposto a tecnologia assistiva.

O item `EV2-Q01` foi encerrado no registro mestre, e o risco `MED-04` da especificação passou a
apontar para os controles permanentes de lazy loading e lint 0/0 no CI.

Na repetição final em Windows, a revisão encontrou uma divergência entre o hash do dataset G14 e o
valor aprovado em Linux. A causa era o cálculo sobre bytes com finais de linha dependentes da
plataforma. O candidato final normaliza CRLF/CR para LF antes do SHA-256 e inclui regressão explícita
para checkouts LF e CRLF. Ambos agora produzem o hash aprovado
`9721baaa99e79d199a1ec198974b5299c43d3c6ea27aee2e1572188fd920f035`.

## Resultado local do candidato

| Controle                        | Resultado                                        |
| ------------------------------- | ------------------------------------------------ |
| `npm run format:check`          | aprovado                                         |
| ESLint                          | aprovado; 0 erros e 0 avisos                     |
| TypeScript estrito e compatível | aprovado                                         |
| Vitest                          | 51 arquivos e 168/168 testes aprovados           |
| EV2.0–EV2.14                    | todos os testes e evals aprovados                |
| Dataset G14 em LF e CRLF        | mesmo hash aprovado nas duas plataformas         |
| Fases legadas e integração      | todas aprovadas                                  |
| Build                           | aprovado                                         |
| Orçamento de bundle             | 4 chunks iniciais, 761.138 bytes; Excel/PDF lazy |
| `npm audit --audit-level=high`  | 0 vulnerabilidades                               |
| `git diff --check`              | aprovado                                         |

O aviso informativo do Vite para chunks lazy de Excel/PDF não representa regressão do carregamento
inicial: os dois pacotes permanecem fora dos quatro chunks iniciais e o orçamento automatizado foi
aprovado.

## Resultado remoto

| Execução                                                                                   | Estado                                             |
| ------------------------------------------------------------------------------------------ | -------------------------------------------------- |
| [CI de push 33976345138](https://github.com/Vnd93/gaiatec-cms/actions/runs/33976345138)    | aprovado: qualidade, banco e navegador             |
| [CI do PR 33976383770](https://github.com/Vnd93/gaiatec-cms/actions/runs/33976383770)      | aprovado: qualidade, banco e navegador             |
| [Preview do PR 33976383828](https://github.com/Vnd93/gaiatec-cms/actions/runs/33976383828) | aprovado; artefato preservado, sem secret de Pages |
| [CI integrado 33977119188](https://github.com/Vnd93/gaiatec-cms/actions/runs/33977119188)  | aprovado: qualidade, banco e navegador             |
| [CI de push 33978362532](https://github.com/Vnd93/gaiatec-cms/actions/runs/33978362532)    | aprovado: qualidade, banco e navegador             |
| [CI do PR 33978403863](https://github.com/Vnd93/gaiatec-cms/actions/runs/33978403863)      | aprovado: qualidade, banco e navegador             |
| [Preview do PR 33978403853](https://github.com/Vnd93/gaiatec-cms/actions/runs/33978403853) | aprovado; artefato preservado, sem secret de Pages |
| [CI integrado 33978694434](https://github.com/Vnd93/gaiatec-cms/actions/runs/33978694434)  | aprovado: qualidade, banco e navegador             |

O artefato imutável do CI de push possui digest
`sha256:6ea5cbadb957e711db099d43ad9a57e6dd9288bbe39b4e89d37e00dc9276c9c9`.
O artefato do head integrado possui digest
`sha256:4bfb36286c077e250ee9073c168d4b1f050f7f2b7d92d395dd830262ead3be95`.
O artefato do head integrado final possui digest
`sha256:c8b9c34b918ae425966d0af356602224ba13a85fa69483a6699d65707f1c1b85`.

O build de staging foi refeito localmente com `VITE_RELEASE` fixado no SHA candidato final e gerou
um manifesto de 1.457 arquivos com digest
`465478e86a6e11be0f15b52ad4791ba8935df17c3bad7530d440e7c6f5712cbe`. O mesmo diretório foi
publicado pelo Wrangler autenticado somente no branch Pages `ev2-final-rc`:

- URL imutável: `https://b494321e.gaiatec-cms-staging.pages.dev`;
- alias isolado: [ev2-final-rc](https://ev2-final-rc.gaiatec-cms-staging.pages.dev);
- `/healthz`: HTTP 200, `ready`, ambiente `staging` e release exata;
- `/release-manifest.json`: HTTP 200, 1.457 arquivos e release exata;
- smoke HTTP: 6/6 cenários aprovados, incluindo 404 reais e rota privada `no-store`;
- `x-robots-tag`: `noindex, nofollow, noarchive` nos contratos e nas páginas avaliadas.

Nenhuma migration, Edge Function, flag, identidade ou dado foi criado ou alterado nesta validação.
O alias G14 e o staging estável não foram tocados.

## Integração

Os PRs de código [#6](https://github.com/Vnd93/gaiatec-cms/pull/6),
[#7](https://github.com/Vnd93/gaiatec-cms/pull/7) e
[#8](https://github.com/Vnd93/gaiatec-cms/pull/8) e
[#9](https://github.com/Vnd93/gaiatec-cms/pull/9) foram reposicionados e integrados, nessa ordem,
em `ev2/desenvolvimento-fases-1-a-12`. O head consolidado contém tanto o SHA aprovado do G14 quanto
o SHA do hardening final e sua correção de reprodutibilidade. Os PRs documentais
[#5](https://github.com/Vnd93/gaiatec-documentacao/pull/5) e
[#6](https://github.com/Vnd93/gaiatec-documentacao/pull/6) também foram integrados em `main` nessa
ordem. O PR documental [#7](https://github.com/Vnd93/gaiatec-documentacao/pull/7) consolida este
relatório e o índice final no mesmo branch canônico.

## Decisão final

Não há bloqueador P0 ou P1 conhecido no escopo validado. O código está qualificado e integrado no
ramo de desenvolvimento EV2; o CI final do head consolidado e as validações locais/remotas do
candidato aprovaram qualidade, banco, navegador, reprodutibilidade e staging isolado. Isto
não equivale a garantia absoluta contra defeitos futuros nem autoriza produção. O Gate G12,
dados/domínios reais, provider externo, ativação global e promoção do staging estável permanecem
independentes e bloqueados.
