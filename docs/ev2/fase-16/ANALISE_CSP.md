# Análise e enforcement de Content Security Policy

## Achados

A política anterior estava apenas em `Content-Security-Policy-Report-Only` e continha
`https://api.resend.com` em `connect-src`, embora o navegador nunca deva chamar o provedor de e-mail.
Também faltavam duas origens usadas pelo RDO, o que quebraria CNPJ e geocodificação ao ativar o
enforcement.

Inventário validado no código:

| Diretiva      | Origens necessárias                                                    |
| ------------- | ---------------------------------------------------------------------- |
| `script-src`  | própria origem e Cloudflare Turnstile                                  |
| `style-src`   | própria origem, estilos inline atuais e Google Fonts                   |
| `font-src`    | própria origem, `data:` e Google Fonts                                 |
| `connect-src` | própria origem, Supabase HTTPS/WSS, Turnstile, BrasilAPI e Nominatim   |
| `frame-src`   | Turnstile, Google Maps e OpenStreetMap                                 |
| `img-src`     | própria origem, `data:`, `blob:` e HTTPS para mídia governada pelo CMS |

Foram adicionados `script-src-attr 'none'`, `worker-src`, `manifest-src` e
`upgrade-insecure-requests`. `api.resend.com` foi removido do navegador.

## Modo por ambiente

- local, staging comum e host desconhecido: Report-Only;
- alias isolado `ev2-g16-csp-canary` no projeto de staging: enforcement para teste em navegador;
- qualquer preview do projeto Cloudflare produtivo `gaiatec-website`: enforcement;
- domínios reais: enforcement somente quando `CF_PAGES_BRANCH=main`.

O probe G12 agora recusa o candidato se o header ativo estiver ausente, se ambos os modos estiverem
presentes, se BrasilAPI/Nominatim faltarem ou se Resend reaparecer no browser. O preview produtivo é
testado antes da promoção, portanto uma regressão CSP interrompe o workflow antes do domínio real.

## Resultado do canary controlado

O build imutável `ced95e61f89ff14eda9675e0ec730614899dde65` foi publicado somente no projeto
Cloudflare de staging, branch `ev2-g16-csp-canary`, deployment
`https://ae766b32.gaiatec-cms-staging.pages.dev`. O workflow passou a aquecer as quatro rotas duas
vezes antes de medir, sem alterar o orçamento de 1.500 ms. A mudança foi motivada por duas medições
do candidato anterior que preservaram 100% de disponibilidade e 0% de 5xx, mas capturaram o
aquecimento inicial acima do orçamento; essas tentativas foram mantidas no artefato operacional e
não tratadas como aprovação.

No SHA final do canary:

- a sonda HTTP passou 22/22 respostas, disponibilidade 100%, 0% de 5xx e p95 público de 1.127,818 ms;
- health, release header, manifesto, `noindex` e CSP corresponderam exatamente ao candidato;
- Chromium percorreu `/`, `/contato`, `/relatorio-de-obra/login` e `/admin/login`;
- as quatro rotas retornaram 200 com CSP enforced e `criticalViolations=0`;
- dados reais, produção, domínio real e staging estável permaneceram sem mutação.

Relatórios brutos: [HTTP](evidencias/G16_CSP_HTTP_ced95e61.json) e
[navegador](evidencias/G16_CSP_BROWSER_ced95e61.json).

## Riscos residuais e redução futura

- `style-src 'unsafe-inline'` ainda é necessário pelos estilos inline existentes; remover exige
  refatoração ou nonces/hashes de estilo;
- `img-src https:` aceita mídia HTTPS ampla porque URLs de mídia são geridas pelo CMS; uma allowlist
  fechada deve acompanhar a definição definitiva do storage;
- a ausência de endpoint de coleta significa que staging Report-Only precisa ser inspecionado no
  canary. Não foi criado endpoint público suscetível a spam apenas para alegar telemetria.

Scripts inline permanecem bloqueados. A orientação de CSP recomenda nonce ou hash em vez de liberar
`unsafe-inline`:
<https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Security-Policy/script-src>.

O canary de staging comprova o comportamento do SHA acima, mas não substitui o preview do candidato
final de produção. Se o SHA produtivo mudar, CSP e todas as demais evidências vinculadas ao candidato
devem ser repetidas.
