# Gate G12 — implantação controlada

**Decisão atual:** APROVADO E CONCLUÍDO<br>
**Escopo executado:** implantação do candidato imutável `e52b25d9…` pelo workflow protegido<br>
**Staging:** canary G12 aprovado tecnicamente para o SHA `e52b25d9…`<br>
**Produção:** promovida e verificada pelo run `34039654304`

## Critérios vinculantes

| Critério          | Evidência exigida                                                                   | Estado atual                                                          |
| ----------------- | ----------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| G11 válido        | aceite G11 e canary sintético rastreável                                            | atendido; assurance segregada aceita                                  |
| Artefato imutável | SHA completo igual em checkout, `X-Release`, `/healthz` e manifest                  | SHA `e52b25d…` validado em staging e produção                         |
| CI e segurança    | suíte integral, RLS, E2E, acessibilidade e audit sem vulnerabilidade alta           | checks e canary aprovados                                             |
| Canary G12        | alias isolado, dois usuários sintéticos MFA, overrides individuais de 30 minutos    | requalificado no SHA `e52b25d…`; 27/27 e três janelas aprovadas       |
| Projeções         | comparação v1/candidato sem divergência                                             | reconciliação zero; aceite final pendente                             |
| Error budget      | três janelas consecutivas saudáveis, com amostra, versão e ambiente                 | 3 de 3 janelas aprovadas                                              |
| Recuperação       | baseline produtiva e drill de rollback compatível com RPO 0/RTO <= 15 min           | backup externo cifrado e restore drill aprovados                      |
| GitHub            | `main` protegida, PR de `@Vnd93`, CODEOWNERS solo, CI estrita e ambiente segregado  | GitHub Pro, proteções e ambientes aprovados                           |
| Backend produtivo | Supabase exclusivo, backups, RLS, migrations e funções aprovadas                    | schema, funções, Auth, Vault, RLS e cron verificados no run produtivo |
| Privacidade/legal | aceite identificado e hash do escopo dos fluxos com dados reais                     | atendido; escopo e dados públicos do DPO aprovados                    |
| E-mail/CSP        | Resend entregue em teste sintético e CSP enforced sem violação crítica no mesmo SHA | atendido no SHA `e52b25d…`                                            |
| Operação          | `@Vnd93` nos quatro papéis, risco solo, janela, treinamento e canal de plantão      | modelo solo e risco aceitos; janela será fixada no registro final     |
| Autorização       | registro `G12_<sha>.json` v2 e `AUTORIZO-G12-PRODUCAO:<sha>`                        | autorização exata recebida e consumida pelo workflow                  |

## Regra de decisão

G12 só pode ser marcado como aprovado quando todas as linhas estiverem atendidas por evidência real.
Não são aceitos placeholders, métricas inferidas ou sessões declaradas sem ocorrência. A exceção de
governança humana única vale somente para `@Vnd93`, com risco aceito e evidência separada por papel;
ela não remove segregações técnicas de permissão existentes no CMS.

Qualquer uma das condições abaixo produz decisão `pause` e impede ampliação:

- P0 ou P1 aberto;
- incidente ou revisão de segurança/privacidade não aprovada;
- divergência de projeção;
- disponibilidade abaixo de 99,9%, 5xx acima de 0,1% ou latência fora do budget;
- mismatch de SHA, manifest, header ou ambiente;
- menos de três janelas consecutivas saudáveis;
- tentativa de pular estágio;
- baseline de rollback diferente da aprovada.

## Limite após o encerramento

A aprovação e o go-live concluído estão vinculados exclusivamente ao SHA
`e52b25d903251cf538918d89049a58524c3c9911`. Qualquer implantação futura exige uma nova decisão
vinculada ao novo candidato. Este gate não autorizou ativação global das funcionalidades EV2.
