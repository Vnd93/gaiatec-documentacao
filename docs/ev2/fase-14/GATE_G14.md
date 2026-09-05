# Gate G14 — IA transacional controlada

**Decisão atual:** APROVADO no escopo sintético de staging<br>
**SHA de código aprovado pelo REV-01:** `64cea11e196bc3889dc6ea7ab1b6b151f64b0220`<br>
**Escopo validado:** somente fixtures sintéticas no alias isolado de staging<br>
**Produção, dados reais, domínios reais e provider externo:** bloqueados

## Critérios vinculantes

| Critério     | Evidência exigida                                                      | Estado no SHA aprovado                      |
| ------------ | ---------------------------------------------------------------------- | ------------------------------------------- |
| CI integral  | format, lint, typecheck, testes, evals, build e audit sem alta/crítica | aprovado localmente e nos CIs de push e PR  |
| Contrato     | cinco tools fechadas, schemas estritos, erro preserva estado           | aprovado                                    |
| Flags        | `ev2.ai_assist` + `ev2.ai_execute` default-off e individual ≤30 min    | aprovado; defaults desligados               |
| Migration    | `0054` aditiva, rehearsal com rollback e pgTAP                         | aplicada em staging; 58/58 pgTAP            |
| Função       | somente `cms-ai-execute`, provider-off e JWT/MFA                       | v1 ativa em staging com verificação JWT     |
| Candidato    | SHA completo no alias `ev2-g14-canary`, health/manifest exatos         | aprovado; release exata e `health=ready`    |
| Identidade   | dois usuários sintéticos MFA, sem credenciais persistentes             | aprovado; ambos removidos após o canary     |
| Segregação   | autor não aprova; aprovador não executa; hash e TTL exatos             | aprovado                                    |
| Atomicidade  | falha deixa zero aplicação parcial; locks seguem ordem global          | aprovado, inclusive sob concorrência        |
| Idempotência | replay e resposta ambígua reutilizam comando/chave; divergência falha  | aprovado                                    |
| Compensação  | snapshot íntegro, renovação após expiração e versão monotônica         | aprovado, inclusive recuperação concorrente |
| Negativos    | produção, dado real, PII, injeção, tool/escopo amplo recusados         | aprovado                                    |
| Resíduo      | zero usuário, override, credencial e fixture sintética                 | aprovado; contraprova independente com zero |
| Limites      | zero mutação real/produção/staging estável e zero chamada externa      | aprovado                                    |
| Revisão      | revisão técnica/segurança independente vinculada ao SHA                | REV-01 aprovou o SHA completo               |

## Regra de decisão

G14 muda para `APROVADO` somente quando todas as linhas estiverem atendidas pelo mesmo SHA de
código e as evidências sanitizadas estiverem versionadas. Falha de limpeza, vínculo, segregação,
atomicidade, idempotência, compensação ou fronteira de dados produz `pause` imediato.

O workflow de preview não aprova o gate. Migration, função, build candidato, pgTAP, executor
integrado e limpeza são evidências independentes e cumulativas.

## Tentativa fail-closed preservada

O REV-01 aprovou inicialmente `81e042070775062faf8e13505894b8d31a5931ca`. O candidato foi
publicado somente no alias isolado e passou por rehearsal, migration, pgTAP, função, smoke,
release/health e acessibilidade. O executor G14 interrompeu antes de criar os usuários ao detectar
`404` na rota administrativa válida `/admin/assistente/execucao`.

A causa era um inventário incompleto de rotas no Worker. A correção sincronizou as seis superfícies
afetadas e acrescentou um teste de regressão do inventário administrativo completo. O relatório
sanitizado da tentativa comprova `externalProviderCalls=0`, `realDataUsed=false`,
`productionMutations=0` e `syntheticResidue=0`.

## Reexecução aprovada no SHA final

Após CI integral e aprovação nominal do REV-01, o alias `ev2-g14-canary` foi atualizado para
`64cea11e196bc3889dc6ea7ab1b6b151f64b0220`. A migration `0054` e a função `cms-ai-execute` já
aplicadas foram mantidas sem republicação. O build candidato ficou restrito a uma implantação
Cloudflare Pages do tipo Preview, sem alterar o branch estável.

A reexecução concluiu 35/35 verificações entre `14:59:15Z` e `15:00:06Z`: dois usuários sintéticos
com MFA, overrides individuais, contrato provider-off, segregação entre autor/revisor/executor,
hash e expiração, execução atômica e idempotente, conflitos concorrentes, compensação monotônica,
auditoria completa e testes negativos. A sonda HTTP mediu 82 respostas, 100% de disponibilidade,
0% de HTTP 5xx e p95 público de 1.181,11 ms; todos os orçamentos por rota foram atendidos.

O executor e a contraprova posterior registraram resíduo sintético zero. As flags permaneceram
default-off, as revisões permaneceram em 86 e a outbox em 103 antes e depois. Não houve chamada a
provedor externo, uso de dado real, mutação de produção, ativação global ou promoção do staging
estável.

## O que G14 não autoriza

A aprovação de G14 valida apenas o sandbox sintético. Ela não permite apontar as tools para
conteúdo real, habilitar provider externo, configurar domínio real, promover o staging estável,
alterar produção ou fundir a branch. Cada expansão exige autorização e gate próprios.
