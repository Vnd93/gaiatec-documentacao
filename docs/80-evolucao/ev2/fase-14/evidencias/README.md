# Evidências do Gate G14

Este diretório recebe somente relatórios sanitizados do rehearsal e do canary da EV2.14 vinculados
ao SHA candidato. Não versionar tokens, chaves, senhas, e-mails dos usuários sintéticos, payloads
brutos ou qualquer dado real.

O executor aceita apenas nomes `G14_CANARY_<identificador>.json` diretamente neste diretório. Cada
relatório deve ser revisado antes do commit e conservar apenas resultados, correlações, métricas de
controle e a comprovação de resíduo sintético zero.

## Inventário

- `G14_CANARY_81e0420.json`: tentativa fail-closed de 5 de setembro de 2026. O executor recusou uma
  rota administrativa com status incorreto antes de criar usuários ou fixtures e confirmou resíduo
  zero. O arquivo não representa aprovação do gate.
- `G14_CANARY_64cea11.json`: reexecução aprovada de 5 de setembro de 2026, vinculada ao SHA completo
  `64cea11e196bc3889dc6ea7ab1b6b151f64b0220`; 35/35 verificações e resíduo sintético zero.
- `G14_HTTP_PROBE_64cea11.json`: sonda HTTP ampliada do mesmo candidato; 82 respostas, 100% de
  disponibilidade, 0% de HTTP 5xx e todos os orçamentos por rota atendidos.
