# ADR-026 — Assistente IA governada na UI

**Status:** aceita<br>
**Data:** 6 de setembro de 2026

## Contexto

Linguagem natural acelera consultas, mas não constitui autorização para mutação.

## Decisão

Respostas exibem fonte e respeitam o escopo efetivo do usuário. Qualquer alteração vira proposta
com diff e aprovação humana; rejeição e aprovação são auditadas. A assistente não publica, exclui,
altera permissões nem aplica diretamente uma proposta. Capacidades transacionais sintéticas da
ADR-023 não ampliam este limite para conteúdo real.

## Consequências

A UI separa resposta, proposta e decisão; o servidor mantém fail-closed, expiração e idempotência.
