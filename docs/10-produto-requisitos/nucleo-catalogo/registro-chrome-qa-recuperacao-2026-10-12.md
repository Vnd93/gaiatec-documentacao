---
id: gaiatec-catalogo-chrome-qa-recuperacao-2026-10-12
titulo: Catálogo manual no Chrome e recuperação durável em staging
status: validacao-parcial-com-recuperacao-concluida
tipo: evidencia-homologacao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-12
ultima_revisao: 2026-10-12
fonte_canonica: gaiatec-documentacao
---

# Catálogo manual no Chrome e recuperação durável em staging

O ciclo funcional isolado passou no Google Chrome instalado, com sessão humana
autenticada, MFA/AAL2 e backend real de staging. A recuperação terminal encerrou
todos os registros e acessos sintéticos, preservando histórico e auditoria. Isso
não encerra a homologação integral: o gate canônico do 503 permanece reprovado,
e foram encontrados dois desvios de mensagem e uma falha de indicadores.

Todos os horários abaixo são UTC; o ciclo ocorreu na noite de 11 de outubro no
horário de Brasília. Não houve dados comerciais, importação, publicação, indexação,
cutover, alteração de produção ou ativação da flag global.

## Identidade da execução

| Binding                                      | Valor                                                              |
| -------------------------------------------- | ------------------------------------------------------------------ |
| SHA do CMS servido e testado                 | `a6c2c2e2a3004cea8c0d51084b9a16a606a12939`                         |
| CI produtor original                         | `38099349665/1`                                                    |
| Bridge original                              | `38099931970/1`, terminal com sucesso                              |
| Artefato original                            | `11687154595`                                                      |
| Digest do artefato                           | `f0b4581a01287ec23910b46f32dc5b92c596cdfe43ef2e2439fc194804f7b6fe` |
| Deployment staging                           | `f7761b44-4816-44cc-ae4b-9cd833daf89b`                             |
| Run tag QA                                   | `QA-CMS-FINAL-20261012-a6c2c2e2`                                   |
| Digest das definições de funções do catálogo | `6434b90d4d2a720125fc1ef0de1546263791fdb70d38631d83bac0152935d0b0` |
| Digest do plano de recuperação               | `fdcb99654a1c6078a68ddcfa41bc80005ca9ec545c1f14bd90067fc569c9f205` |
| Manifest preparado e commitado               | `2026-10-12T00:43:41.682521Z`                                      |
| Confirmação de MFA/AAL2 antes dos testes     | `2026-10-12T01:11:35Z`                                             |
| Recuperação terminal concluída               | `2026-10-12T01:32:10.164830Z`                                      |

O digest de funções não é um snapshot integral do ambiente para o verificador
canônico. Não foi emitido challenge de Chrome nem atestado terminal de release:
estes casos funcionais não substituem os gates automáticos prévios.

O perfil GitHub era `Vnd93`; checkout CMS `main` limpo e igual a `origin/main`,
após fetch. Os cinco estados ativos de workflows dos dois repositórios estavam
zerados. A consulta completa de 729 deployments Cloudflare confirmou zero ativos,
deployment original concluído e `/healthz` com SHA, ambiente e header exatos.

Uma identidade nova dedicada recebeu o convite; uma conta operacional existente
não foi convertida. O usuário definiu senha e MFA no Chrome, sem fornecer os
segredos ao executor. O manifest foi commitado antes dos grants e, em transação
posterior, do override individual `user/staging` de 90 minutos. O lease original
de quatro horas não foi prorrogado nem teve suas datas alteradas.

## Casos efetivamente comprovados

| Área                            | Prova observada no Chrome e backend real                                                                                                                                                                                                                     |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Estado fechado e vazio          | Catálogo fechado antes do override QA; depois, estado vazio e formulário manual sem carga comercial.                                                                                                                                                         |
| Validação                       | Nome obrigatório, slug com formato inválido, justificativa ausente e quantidade zero foram recusados. Editorial incompleto recebeu erro contextual.                                                                                                          |
| Cadastro manual                 | Quatro rascunhos sintéticos: produto, kit, modelo e variante. Gravação, reabertura e campos persistidos; nenhum snapshot público.                                                                                                                            |
| Conflito CAS                    | Duas abas editaram a mesma revisão. A segunda gravação obsoleta foi recusada; comparação mostrou base, tentativa e versão atual, preservando a revisão vencedora.                                                                                            |
| Histórico e revisão             | Histórico das revisões 1 e 2; restauração da revisão 1 criou revisão 3. Classificação complementar gravada em mobile criou revisão 4; marcar pronto criou revisão 5, sem publicar.                                                                           |
| Permissão negativa              | O mesmo ator QA foi temporariamente reduzido a leitura. Uma tela ainda aberta tentou gravar: backend recusou, revisão e resumo permaneceram. Ao recarregar, edição ficou desabilitada e novo cadastro oculto. O papel QA original foi restaurado e auditado. |
| Classificação                   | Categoria ativa, três termos editoriais ativos, categoria principal e indústria complementar próprias do mesmo grupo.                                                                                                                                        |
| Relações                        | Composição kit/produto com `2 un`, acessório simétrico, heranças modelo/produto e variante/modelo, e supressão local que preservou a relação da origem.                                                                                                      |
| Editorial                       | Tecnologia, indústria e aplicação tiveram rascunhos de revisão 1, sem publicação ou pedido de indexação.                                                                                                                                                     |
| Mobile e acessibilidade parcial | Chrome com viewport `412×915`: cadastro e editorial sem overflow horizontal e sem controles visíveis sem rótulo. Capturas visuais de desktop e mobile inspecionadas. Isso não substitui auditoria completa de teclado, foco e contraste.                     |
| Duplicidade                     | Slug já usado foi recusado sem quinto produto. A mensagem confundiu duplicidade com conflito de revisão; registrar como desvio, não como caso aprovado integralmente.                                                                                        |

Os testes de permissão reduziram somente o ator QA; não alteraram definições de
papéis, permissões globais, RLS, MFA, regras de autorização ou contas existentes.
Todas as entidades e referências pertenciam ao manifest isolado.

## Recuperação e ausência de estado ativo

O executor retirou o override e as permissões QA, suspendeu o perfil, revogou as
sessões e bloqueou a identidade temporária. Chamou apenas o caminho público normal
`cms_complete_qa_actor_lease`; o hook terminal 0118 executou a compensação durável.
Não houve chamada direta ao compensador, alteração de datas, claims, PID ou XID
forjados, exclusão de histórico nem marcação manual de `cleaned`.

| Verificação terminal                                                   | Resultado                                                          |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------ |
| Manifest                                                               | `cleaned`                                                          |
| Produtos próprios                                                      | 4 arquivados, todos draft, sem categoria principal ou complementar |
| Termos próprios                                                        | 4 inativos                                                         |
| Relações e heranças                                                    | 3 relações e 2 heranças retiradas por novas revisões               |
| Editorial                                                              | 3 editoriais `unpublished`, sem indexação                          |
| Leases ativos e recuperação aberta                                     | 0 e 0                                                              |
| Produtos próprios ativos, mappings, snapshots atuais e outbox pendente | Todos 0                                                            |
| Sessões, overrides, papéis e perfis QA ativos                          | Todos 0                                                            |
| Auditoria e revisões preservadas                                       | 37 eventos do catálogo e 12 revisões de produto                    |
| Identidade QA                                                          | Bloqueada; Chrome recusou acesso após recarregar                   |
| Flag global                                                            | `false`                                                            |

Resíduo zero significa ausência de estado ativo; os registros arquivados e as
trilhas imutáveis são intencionalmente preservados. A limpeza também comprovou
`ready→draft/archived`, retirada de relações/heranças e encerramento editorial no
mesmo caminho durável, além do ciclo menor já registrado em 11 de outubro.

## Pendências reais para a entrega

1. Resolver a causa interna do 503 e obter validação canônica íntegra. Esta execução
   não repetiu release nem aumentou timeout para obter verde; resposta do suporte
   não foi verificada nesta sessão.
2. Corrigir e revalidar os desvios de mensagem: duplicidade apresentada como conflito
   de revisão; sucesso editorial anterior mantido após mudar termo ou recusar um
   formulário incompleto. Os dados foram protegidos, mas a comunicação foi inadequada.
3. Diagnosticar os indicadores parcialmente indisponíveis na visão geral. A falha
   reapareceu em uma segunda aba autenticada; não houve código ou trace conclusivo
   no console, portanto não atribuir ao 503 histórico ou ao banco por inferência.
4. Concluir negativas de referências/ciclos e payload inseguro, preview editorial
   autenticado, RLS completo, teclado/foco/contraste e compatibilidade além de Chrome.
   Não preencher os nove gates completos como `passed` com base nesta prova parcial.

Qualquer novo SHA exige os gates e evidências dependentes dos bytes alterados.
As correções posteriores não são consideradas homologadas por este registro.
O acesso QA desta execução foi encerrado, não é acesso operacional permanente.

Acesso de staging: `https://ev2-g17-canary.gaiatec-cms-staging.pages.dev`;
workspace `/admin/nucleo-catalogo`, fechado para usuários normais com global OFF.
Produção não está liberada por esta evidência.
