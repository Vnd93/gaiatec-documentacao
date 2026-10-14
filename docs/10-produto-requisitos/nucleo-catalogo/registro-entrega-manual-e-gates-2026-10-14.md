---
id: gaiatec-registro-entrega-manual-e-gates-2026-10-14
titulo: Entrega manual e gates de homologação em staging
status: homologacao-pendente
tipo: registro-de-evidencia
area: cms
fase: homologacao
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-14
ultima_revisao: 2026-10-14
fonte_canonica: gaiatec-documentacao
---

# Entrega manual e gates de homologação em staging

O candidato implementa operação manual com IA externa desativada por decisão
do responsável. A entrega integral ainda depende dos gates e da homologação
real. A flag global `ev2.catalog_v1` permanece OFF. Não há autorização de
publicação em produção, cutover, importação de SKUs ou carga comercial.

## Candidato e ambiente atual

Em `2026-10-14T14:21:59Z`, staging serve
`cbb373663f1cdafcff4f7dc13c1a9a5e98dfdf8d`, na implantação
`2b7fb8a0-5bc0-4ad2-9257-f5c770af92ad`, com health 200 e ambiente exato.
As migrations 0120 e 0121 estão aplicadas; seus históricos não foram reescritos.
O scan completo de 768 implantações Cloudflare confirmou zero operação ativa.
GitHub confirmou ausência de runs ativos nos cinco estados consultados, nos
dois repositórios, e ausência de fences. O banco confirmou zero QA ativo,
recovery de catálogo aberto ou override ativo do catálogo.

O próximo candidato é `110d4e319a094a1c1c49b1ea71dd4ac719936c70`, publicado em
`main`. O [CI 38578642654, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38578642654)
passou nos sete jobs. Os validadores oficiais de origem e seleção retornaram
válidos. A promoção e a validação canônica desse SHA ainda estão pendentes.
O perfil é `full-release`, com seleção fail-closed e sem reutilização de gates
de mutação. CI verde não substitui homologação real em staging.

| Artefato do candidato      | ID ou SHA256                                                       |
| -------------------------- | ------------------------------------------------------------------ |
| Pacote original            | `11900824973`                                                      |
| ZIP do pacote              | `0b9e0dcbea50aebdfe2d10b4feb27e436f5e29e85bc3a9dd741b080afb8043cf` |
| Seleção original           | `11902755532`                                                      |
| ZIP da seleção verificado  | `7d728b610bd5b702e32fcedda1f5f13540775c95132fda72f573820dda5dfb2b` |
| Archive do dist            | `e3e6d51c81cbeef81ed8e4f5108255798cb2fb7a04392aead576a466f402a11e` |
| Árvore do dist             | `b31b4e95c661c65ac3b83f00a2b40f2ccc947fbd1c4883aad61a0efb98813809` |
| Payload de banco           | `11900329631`                                                      |
| Runtime das Edge Functions | `11902092679`                                                      |

## Operação manual sem provedor de IA

O commit `91188a8942b9ccb83ecc7ecee3e2b41791a30042` implementou a política
imutável `cms-manual-only-v1`. Geração e execução assistida são recusadas antes
da leitura de credenciais ou chamada externa. Flags individuais não reativam
o provedor. A configuração gerenciada de staging mantém o switch externo
desligado, preservando credenciais existentes e secrets não gerenciados.
Nenhuma contratação de provedor ou mudança em produção foi realizada.

O canário autenticado do SHA `cbb3736` comprovou as recusas e a ausência de
chamadas ao provedor. No Chrome real, a sessão operacional abriu o assistente
e a execução com avisos de modo manual, zero controles de geração/execução
e zero alertas. A conta não foi convertida em QA nem recebeu permissões extras.

## Falhas comprovadas e recuperação

O canônico `38500963463/1`, SHA `91188a8`, falhou no preparador de vocabulário:
dois códigos de erro não atendiam ao prefixo obrigatório do transporte.
A recusa ocorreu localmente, antes de HTTP. O commit `cbb3736` corrigiu apenas
esses códigos e vinculou a regressão ao guard real, sem alterar schema,
envelope, MFA ou autorização. O preparador passou no ciclo posterior.

O [canônico 38571333154, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38571333154)
passou em preflight, fonte, baseline, deploy e ambos os gates pós-deploy
somente leitura. O convite, senha e MFA sintéticos passaram em 50,6 s.
O bootstrap editorial falhou ao criar a campanha: o botão Salvar estava
desabilitado. O helper não preenchia o título do Hero nem o texto do bloco
Texto, obrigatórios no schema real. Nenhum challenge ou attestation real foi
emitido. Essa falha não é HTTP 503.

O commit `110d4e3` preenche esses dois blocos pela UI e exige Salvar habilitado
antes de esperar a resposta. A regressão usa o editor, a fábrica real de blocos
vazios e o schema estrito: ambos os blocos vazios são recusados e os preenchidos
são aceitos. Os seis testes passaram em desktop e os seis em mobile, sem
backend ou autenticação nessa regressão local. A validação completa passou
com 244 arquivos Vitest, 1.716 testes, demais suites e build em 25,64 s.
O editor, o backend, o schema e os timeouts não foram relaxados.

O finalizador e o [watchdog 38577330506](https://github.com/Vnd93/gaiatec-cms/actions/runs/38577330506)
terminaram com sucesso. O artefato terminal `11902475349` teve ZIP SHA256
`ae5993280e184cf2ddec55f48239dcb6b728bbf82875f9fb2d34c44472d8c330`
verificado. O probe terminal passou sem violações e a recuperação de navegador
constatou estado já terminal. A fotografia posterior de banco e ambientes
comprovou ausência de efeitos ativos; revisões e auditoria permanecem.

## Inventário de entrega

| Área                          | Implementado e evidência disponível                                                                                | Pendência para entrega integral                                                       |
| ----------------------------- | ------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------- |
| Catálogo manual e revisões    | Fatias 1–4 implementadas; cadastro, restauração e CAS entre abas passaram em ciclos focados anteriores             | Revalidar os casos dependentes no candidato final; atores e escopos distintos         |
| Termos, hierarquia e relações | Herança e composição testadas com recuperação durável em ciclo focado                                              | Referências externas ao escopo e demais entradas inválidas no candidato final         |
| Editorial e prévia privada    | Prévias de indústria, tecnologia e aplicação validadas em Chrome em ciclo anterior; canário editorial atual passou | Concluir o bootstrap canônico corrigido e as provas reais restantes                   |
| Indicadores administrativos   | Quatro cartões numéricos carregaram em Chrome no SHA `cbb3736`, sem alerta                                         | Consolidar a evidência junto dos demais gates do mesmo candidato                      |
| Convite, senha e MFA          | Ciclo sintético canônico passou; conta operacional preservada                                                      | Homologação humana QA isolada dos casos restantes, sem reabrir identidades encerradas |
| Recuperação, RLS e auditoria  | Recuperação durável 0118 e complemento QA 0121 aplicados; finalização terminal comprovada                          | Concluir rollback, revogação e limpeza no ciclo final aprovado                        |
| Acessibilidade e mobile       | Regressões automáticas públicas passaram; Instrumentação carregou em Chrome a 390 × 844 sem overflow               | Homologação integral de acessibilidade e compatibilidade no candidato final           |
| IA externa                    | Desativada por política do candidato e decisão do responsável                                                      | Não é requisito de ativação desta entrega manual                                      |

As evidências focadas anteriores continuam vinculadas aos respectivos SHAs,
como no [registro de 12 de outubro](registro-indicadores-e-evidencia-staging-2026-10-12.md).
Elas não transformam os runs canônicos reprovados em aprovados. Nenhuma lista
comercial de produtos é necessária para concluir os testes do sistema vazio.

## Limitações e critérios restantes

A causa do 503 histórico de navegação mobile continua sem comprovação.
Instrumentação carregou em Chrome desktop e mobile nesta observação; isso não
prova a causa nem a ausência de intermitência. Não houve remoção de páginas
porque a condição de exclusividade às páginas não foi demonstrada. O 503 do
provedor de IA é um incidente distinto; não é evidência da causa do documento.

O p95 administrativo aceito permanece 2.147 ms em staging e no futuro
candidato de produção, sem alterar os limites de comandos. Segurança,
MFA/AAL2, RLS, auditoria, acessibilidade, rollback e limpeza continuam gates.
A proteção de senhas vazadas continua indisponível por restrição do plano
Supabase, conforme o [registro de política e Auth](registro-politica-leitura-e-auth-2026-10-13.md).

O [painel de staging](https://ev2-g17-canary.gaiatec-cms-staging.pages.dev/admin)
exige login e MFA próprios. Com flag OFF, a conta operacional vê o Núcleo de
Catálogo em preparação, sem controles de criação. O
[guia de operação manual](../../30-cms/manual-do-usuario/operacao-catalogo-manual.md)
continua preparado, com liberação pendente. A entrega não está homologada
integralmente em staging nem liberada em produção.
