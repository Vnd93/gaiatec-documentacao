---
id: gaiatec-nucleo-catalogo-matriz-rastreabilidade-2026-09-24
titulo: Matriz de rastreabilidade e gates do Núcleo de Catálogo
status: ativo-planejamento
tipo: matriz-de-rastreabilidade
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging-e-local
responsavel: Comercial GAIATEC Sistemas
data_criacao: 2026-09-24
ultima_revisao: 2026-09-24
fonte_canonica: gaiatec-documentacao
decisoes: CAT-D001-CAT-D010
---

# Matriz de rastreabilidade e gates do Núcleo de Catálogo

Este documento transforma CAT-D001–CAT-D010 em unidades verificáveis para as Fatias 1–4. Não
autoriza migration remota, carga de legado, ativação global de flag, cutover ou produção. O catálogo
novo começa vazio, sem fonte mista e sem SKU, conforme CAT-D002 e CAT-D009.

## Regra de seleção de perfil

| Perfil | Mudança permitida | Gates obrigatórios | Artefato/rollback |
| --- | --- | --- | --- |
| `frontend-only` | telas, copy, acessibilidade, flag sem contrato novo | check, unit, build, browser real em staging | pacote frontend selado; desligar flag |
| `edge-only` | contrato/Edge sem schema novo | check, unit, contrato API, Auth/RLS de staging, browser real | bundle Edge único; restaurar versão anterior |
| `database-auth` | migration, RLS, auditoria, Auth/AAL2 | manifesto de migration, pgTAP, advisors, RLS negativo/positivo, rollback local e staging | migration imutável; compensação/rollback testado |
| `full-release` | combinação de áreas ou ambiguidade | todos os gates acima, artefato único e canário completo | pacote único por SHA; rollback de leitura, Edge e banco |

Qualquer mudança que atravesse mais de uma área, altere contrato de publicação, classificação,
relações, RLS/Auth ou tenha classificação incerta seleciona `full-release`. Nenhum perfil menor pode
ser escolhido para reduzir gates.

## Mudança → decisão → gate → evidência

| Fatia | Entrega verificável | Decisões | Gates de entrada | Gates de saída e evidência | Rollback |
| --- | --- | --- | --- | --- | --- |
| F1 — fundação | entidades, revisão otimista, taxonomia principal, papéis e RLS | D001, D004, D005 | contrato versionado, owner de taxonomia, flag default-off | migração local/staging, pgTAP concorrência/RLS, API 409, auditoria sem PII, Chrome autenticado | desativar flag; migration compensatória aprovada |
| F2 — revisão/publicação | Rascunho/Pronto/Publicado, snapshot público e CTA de orçamento | D003, D007 | F1 verde, outbox/cache definido, sem Offer/preço/estoque | testes de transição inválida, snapshot isolado, JSON-LD sem Offer, smoke Edge/Chrome | leitor volta ao snapshot anterior; não apagar histórico |
| F3 — kits e relações | tipos de relação, quantidades/unidades, herança e exclusões | D005, D006 | F1 e F2 verdes, vocabulário de unidades aprovado | pgTAP de ciclo/autorrelação/duplicata, projeção bidirecional, rollback de revisão | nova revisão compensatória; sem exclusão física |
| F4 — termos e cutover prep | páginas Tecnologia/Indústria/Aplicação opt-in, lista nominal e gate de cobertura | D008, D009; D010 explicitamente fora | F1–F3 verdes, UAT e owners nomeados | Chrome real, noindex/SEO, sitemap opt-in, lista 100% revisada, rollback ensaiado | manter site antigo e flag off |

## Checkpoints e imutabilidade

Cada tentativa registra `sha`, perfil, digest do artefato, deployment ID, snapshot do ambiente,
resultado de cada gate, owner e timestamp. Retry só reutiliza um gate independente ainda válido;
mudança de SHA, bytes, schema, estado remoto ou ambiente invalida os dependentes. O desafio de
Chrome é emitido somente após os gates automáticos e watcher estarem prontos.

## Métricas de planejamento

Registrar duração por etapa (preflight, validações paralelas, mutação serial, pós-deploy somente
leitura, Chrome e evidência). O SLO de caminho feliz é 40–60 minutos; qualquer extrapolação deve
identificar o gargalo e nunca relaxar segurança. O primeiro cutover permanece bloqueado enquanto a
lista nominal não tiver 100% de cadastro, revisão e aprovação.
