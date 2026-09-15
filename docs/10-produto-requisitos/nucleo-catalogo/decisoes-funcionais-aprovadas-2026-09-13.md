---
id: gaiatec-nucleo-catalogo-decisoes-funcionais-2026-09-13
titulo: Decisões funcionais aprovadas do Núcleo de Catálogo
status: ativo
tipo: registro-de-decisoes
area: produto-requisitos
fase: nucleo-catalogo
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-13
ultima_revisao: 2026-09-14
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - ../../20-arquitetura-seguranca/adr/ADR-001-recadastramento-limpo-e-cutover.md
  - ../../20-arquitetura-seguranca/adr/ADR-005-rbac-cms-rdo.md
  - ../../20-arquitetura-seguranca/adr/ADR-007-publicacao-outbox-cache.md
  - ../../20-arquitetura-seguranca/adr/ADR-012-campos-internos-e-cadastro-em-massa-governado.md
  - ../../20-arquitetura-seguranca/adr/ADR-014-vocabularios-controlados-genericos.md
  - ../../20-arquitetura-seguranca/adr/ADR-019-rascunho-publicacao-e-concorrencia.md
  - ../../20-arquitetura-seguranca/adr/ADR-020-identidade-pim-e-proveniencia.md
  - ../../20-arquitetura-seguranca/adr/ADR-028-vinculos-bidirecionais-do-catalogo.md
---

# Decisões funcionais aprovadas do Núcleo de Catálogo

## Autoridade, escopo e precedência

Estas decisões foram aprovadas pelo responsável em 13 de setembro de 2026 e detalhadas em 14 de
setembro de 2026. Elas são a referência funcional vigente para o novo Núcleo de Catálogo,
especialmente para contratos, tabelas e APIs `cms_catalog_*`.

Quando houver incompatibilidade, CAT-D001 a CAT-D010 prevalecem neste escopo sobre especificações
anteriores. Essa precedência:

- não reescreve evidências, entregas EV2 encerradas, snapshots históricos ou contratos legados;
- não altera o fluxo editorial das demais áreas do CMS;
- não autoriza migration, ativação de feature flag, carga, cutover ou mutação de produção;
- não declara a implementação concluída: cada decisão ainda precisa de rastreabilidade entre
  requisito, código, banco/API, teste e gate de release.

## Resumo executivo

| ID       | Tema                    | Decisão vigente                                                                  |
| -------- | ----------------------- | -------------------------------------------------------------------------------- |
| CAT-D001 | Concorrência            | versionamento otimista, conflito explícito e sobrescrita administrativa auditada |
| CAT-D002 | SKU                     | totalmente fora desta fase                                                       |
| CAT-D003 | Publicação              | fluxo novo somente para o Catálogo; demais fluxos do CMS são preservados         |
| CAT-D004 | Papéis                  | dois perfis visíveis, com capacidades internas granulares em API e RLS           |
| CAT-D005 | Classificação           | uma classificação principal ativa em `Categoria/Família de Produto`              |
| CAT-D006 | Kits e relações         | Kit é subtipo de Produto; composição e herança têm regras determinísticas        |
| CAT-D007 | Preço e disponibilidade | preço, estoque e disponibilidade comercial permanecem fora                       |
| CAT-D008 | Páginas de termos       | Tecnologia, Indústria e Aplicação podem ter página editorial opcional            |
| CAT-D009 | Carga e cutover         | catálogo novo começa vazio atrás de flag; site antigo permanece até gate nominal |
| CAT-D010 | Importação em massa     | posterior à estabilização do cadastro manual e não bloqueia o primeiro cutover   |

## CAT-D001 — Concorrência e conflito de edição

### Decisão

Toda gravação mutável deve enviar a versão que o cliente leu (`expectedVersion` ou equivalente).
Se a versão persistida já tiver mudado, o servidor não grava parcialmente e não aplica
“última gravação vence”. Ele devolve conflito com comparação suficiente para decisão humana.

O conflito deve mostrar, por campo ou relação relevante:

- valor da base lida pelo editor;
- tentativa local;
- valor atualmente persistido;
- autor, horário e correlação da alteração concorrente, sem expor dado sensível.

O usuário pode recarregar, reaplicar seletivamente ou abandonar sua tentativa. Sobrescrita forçada
é excepcional e restrita a Administrador com sessão AAL2, justificativa obrigatória e auditoria.

### Critérios de aceite

- uma versão desatualizada não altera nenhum dado;
- o contrato usa resposta de conflito estável, preferencialmente HTTP 409;
- listas, termos, atributos e relações seguem o mesmo controle, não apenas Produto;
- override registra versão anterior, versão resultante, motivo, ator e correlation ID;
- dois clientes concorrentes são exercitados em teste, inclusive conflito em relação/taxonomia.

## CAT-D002 — SKU fora desta fase

### Decisão

SKU não será implementado nesta fase. O novo catálogo não terá sequência, entidade, campo,
permissão, validação, filtro, importação, busca, API pública ou JSON-LD de SKU. UUID interno e slug
público são as identidades usadas agora.

Qualquer SKU existente no site antigo permanece exclusivamente no legado até decisão futura. A
eventual adoção posterior deve ser aditiva e aprovada em novo registro, sem reaproveitar
silenciosamente uma semântica anterior.

### Critérios de aceite

- nenhum contrato `cms_catalog_*` exige ou emite SKU;
- nenhum gate de prontidão comercial depende de SKU;
- templates de importação desta fase não contêm SKU;
- busca pública e administrativa não criam um “código substituto” com valor comercial implícito.

## CAT-D003 — Publicação exclusiva do Catálogo

### Decisão

O fluxo abaixo vale somente para o Núcleo de Catálogo. O fluxo editorial já existente das outras
áreas do CMS é preservado.

Estados de revisão:

1. `Rascunho` — editável e não público;
2. `Pronto` — submetido à revisão;
3. `Publicado` — snapshot público aprovado.

O ciclo da entidade (`Ativo` ou `Arquivado`) é separado do estado da revisão. Operador cria, edita
e submete. Administrador publica, despublica, arquiva e restaura. O Administrador pode publicar o
próprio conteúdo; uma segunda pessoa não é obrigatória nesta fase, mas toda ação permanece
auditada.

Editar conteúdo publicado cria novo rascunho e mantém o snapshot vigente no ar. Restaurar versão
histórica também cria novo rascunho; nunca substitui diretamente o publicado.

### Critérios de aceite

- transições inválidas são recusadas no backend, independentemente da interface;
- somente snapshot publicado aparece no site e na API pública;
- falha na nova revisão não altera o conteúdo público vigente;
- despublicar não equivale a apagar, e arquivar não reescreve histórico;
- cache/outbox publica ou invalida exatamente a revisão aprovada.

## CAT-D004 — Papéis visíveis e capacidades internas

### Decisão

Administrador e Operador são os dois perfis visíveis. Internamente, autorização permanece granular
na API, nas funções e na RLS.

O Operador pode:

- criar e editar rascunhos;
- usar termos ativos;
- propor novos termos sem ativá-los;
- preparar relações permitidas;
- submeter conteúdo como `Pronto`.

O Administrador pode, adicionalmente:

- criar, alterar, inativar e mesclar listas/termos;
- reclassificar conteúdo em massa;
- publicar, despublicar, arquivar e restaurar;
- confirmar importação em massa quando ela existir;
- executar override de conflito.

Operações estruturais ou críticas exigem AAL2, prévia de impacto, motivo e auditoria. Não existe
exclusão física funcional; correções usam inativação, arquivamento, substituição ou compensação.

### Critérios de aceite

- ocultar um botão não substitui verificação no backend/RLS;
- cada capacidade possui testes positivos e negativos por papel e AAL;
- merge, reclassificação, restauração, importação e override são exclusivamente administrativos;
- auditoria é imutável e não contém segredos ou dados pessoais desnecessários.

## CAT-D005 — Classificação principal

### Decisão

`Categoria/Família de Produto` é uma única taxonomia hierárquica e a única fonte da classificação
principal. Um rascunho pode estar incompleto; publicar exige exatamente um termo principal ativo.
Tecnologia, Indústria, Aplicação e demais listas são vínculos N:N complementares.

Cada termo tem no máximo um pai nesta fase. Polihierarquia e ciclos são proibidos.

Inativar ou mesclar termo referenciado exige substituto ativo e análise de impacto. O sistema cria
novas revisões para os conteúdos afetados e preserva os snapshots históricos. Mescla não reescreve
o passado e não muda classificação publicada silenciosamente.

### Critérios de aceite

- zero ou mais de um termo principal bloqueiam publicação;
- termo principal inativo bloqueia publicação;
- FK/constraints ou validação transacional impedem ciclos e múltiplos pais;
- inativação/merge são atômicos, auditados e reversíveis por nova revisão;
- Indústria não é tratada como classificação principal.

## CAT-D006 — Kits e relações

### Decisão

Kit é subtipo de Produto e pode ser apresentado para cotação; não representa compra em e-commerce.
As relações tipadas incluem:

- contém;
- componente obrigatório;
- componente opcional;
- acessório;
- compatível;
- alternativa;
- substitui;
- sucessor;
- exclusão/supressão local, usada para controlar herança.

Composição exige quantidade positiva e unidade de uma lista controlada. Obrigatoriedade ou
opcionalidade é derivada do tipo da relação, sem booleano duplicado. O destino pode ser Produto,
Modelo ou Variante.

Nesta fase, são proibidos autorrelação, ciclos aplicáveis, kit dentro de kit e composição ambígua.
Relações simétricas têm um único registro canônico; a API projeta os dois sentidos.

Herança usa precedência determinística `Variante → Modelo → Produto`: regra direta vence herdada;
no mesmo nível, exclusão local vence inclusão. A interface informa a origem da relação efetiva.

### Critérios de aceite

- relação obrigatória inválida bloqueia publicação;
- quantidade/unidade são exigidas somente para relações de composição;
- ciclos, autorrelação, duplicação simétrica e kit aninhado são recusados;
- testes cobrem herança, override, exclusão e projeção bidirecional;
- rollback preserva histórico e não faz exclusão física.

## CAT-D007 — Preço, estoque e disponibilidade

### Decisão

Preço, estoque e disponibilidade comercial permanecem fora desta entrega, inclusive na Variante.
Status de ciclo de vida técnico pode existir, mas não pode ser apresentado como disponibilidade ou
estoque.

O catálogo usa a chamada para ação `Solicitar orçamento`. Dados estruturados não incluem `Offer`
nem valores equivalentes a preço, moeda, estoque ou condição de venda.

### Critérios de aceite

- contratos públicos e administrativos não expõem campos comerciais fora de escopo;
- página, busca e filtros não inferem disponibilidade a partir de status técnico;
- JSON-LD é validado sem `Offer`;
- Kit “cotável” mantém a mesma chamada para orçamento dos demais produtos.

## CAT-D008 — Páginas editoriais de termos

### Decisão

Tecnologia, Indústria e Aplicação podem receber página pública editorial opcional. O padrão é
privado e `noindex`; não existe geração pública automática para todos os termos.

Publicar e tornar indexável são controles independentes. A indexação exige aprovação editorial e
ao menos um produto publicado relacionado. Slug, conteúdo e SEO são administrados explicitamente;
a lista de produtos é dinâmica e inclui somente snapshots publicados.

Mesclar termo cria redirecionamento 301 para o termo substituto. Inativar termo despublica a página
ou a redireciona de forma explícita. `Solução` permanece entidade editorial separada, conforme a
especificação vigente, e não vira automaticamente página de termo.

### Critérios de aceite

- termo sem opt-in não cria URL pública nem entra no sitemap;
- página pública ainda pode permanecer `noindex`;
- página indexável exige produto publicado e aprovação administrativa;
- merge/inativação não geram 404 silencioso nem conteúdo duplicado;
- busca e navegação só apresentam páginas efetivamente publicadas.

## CAT-D009 — Carga inicial e cutover

### Decisão

O catálogo novo começa vazio, protegido por feature flag. O site antigo permanece atendendo o
público até que uma lista nominal de produtos prioritários esteja 100% cadastrada, revisada e
aprovada no novo modelo.

Não haverá migração, cópia, reconciliação ou composição simultânea de fontes. Estado vazio é teste
de resiliência, não condição aceitável de entrada pública.

O cutover exige cumulativamente:

- lista nominal prioritária com responsável e aprovação registrada;
- 100% dos itens dessa lista publicados e conferidos;
- UAT aprovado;
- rollback testado;
- ausência de P0/P1 abertos;
- nenhuma categoria primária presente na navegação sem produto publicado.

Rollback devolve o leitor público à fonte anterior sem copiar dados entre os modelos.

### Critérios de aceite

- a feature flag impede fonte mista;
- desativar o novo catálogo restaura a leitura antiga de forma testada;
- a lista nominal, e não apenas uma quantidade, constitui o gate de cobertura;
- o site novo apresenta estado vazio seguro em teste, mas o gate impede cutover vazio.

## CAT-D010 — Importação em massa

### Decisão

Importação não entra na Onda 1 e não bloqueia o primeiro cutover. Ela só pode avançar após pelo
menos dois ciclos manuais completos e estáveis:

`cadastro → revisão → publicação → uso → feedback`.

Se houver P0/P1 ou mudança estrutural relevante depois desses ciclos, é obrigatório um terceiro
ciclo estável antes da importação.

Quando implementada, a capacidade terá:

- template versionado;
- dry-run fiel ao commit;
- erros por linha e resumo de impacto;
- idempotência por UUID interno e chave técnica de lote/linha;
- auditoria e rollback compensatório;
- confirmação exclusiva de Administrador com AAL2.

A importação cria ou atualiza apenas rascunhos. Não cria termos, não publica, não usa SKU, não migra
legado e não apaga fisicamente. Atualizações obedecem CAT-D001. Rollback automático só é permitido
quando o rascunho importado não sofreu edição posterior; nos demais casos, exige compensação
revisada.

### Critérios de aceite

- dois ciclos estáveis são documentados antes do início da implementação;
- dry-run e commit usam a mesma versão de template e regras;
- repetir o mesmo lote não duplica conteúdo;
- conflito de versão não é sobrescrito pelo lote;
- falha parcial não publica nem deixa estado invisível sem auditoria.

## Dependência por onda

| Momento                                     | Decisões que devem estar implementadas e testadas           |
| ------------------------------------------- | ----------------------------------------------------------- |
| Fundação/Onda 1                             | CAT-D001, CAT-D003, CAT-D004, CAT-D005, CAT-D006 e CAT-D007 |
| Antes de expor páginas editoriais de termos | CAT-D008                                                    |
| Antes do primeiro cutover público           | CAT-D009 e todas as fundações consumidas pelo catálogo      |
| Depois da estabilização manual              | CAT-D010                                                    |
| Fase futura, mediante nova aprovação        | qualquer capacidade de SKU                                  |

CAT-D008 e CAT-D010 não bloqueiam o primeiro cutover. CAT-D001, CAT-D003, CAT-D004 e CAT-D005 são
fundações e não podem ser postergadas para depois da implementação que depende delas.

## Pendência operacional que não altera as decisões

Ainda é necessário materializar a lista nominal de produtos prioritários do CAT-D009, com
responsável, critérios de completude e aprovação registrada. Isso é um artefato de execução do
cutover, não uma ambiguidade funcional do modelo.

## Registro de compatibilidade com decisões anteriores

| Documento anterior | Tratamento no novo Núcleo de Catálogo                                                                              |
| ------------------ | ------------------------------------------------------------------------------------------------------------------ |
| ADR-001            | compatível; CAT-D009 acrescenta gate nominal e impede fonte mista                                                  |
| ADR-005            | compatível; CAT-D004 explicita capacidades por operação                                                            |
| ADR-007            | compatível com esclarecimento: restauração cria Rascunho; só nova publicação gera revisão pública                  |
| ADR-012            | parcialmente superado: SKU sai e importação é adiada; controles compatíveis de segurança/qualidade permanecem      |
| ADR-014            | compatível; CAT-D008 adiciona exposição editorial opcional de termos                                               |
| ADR-019            | parcialmente clarificado: Catálogo não tem estado extra de aprovação nem segundo aprovador; concorrência permanece |
| ADR-020            | parcialmente superado: SKU não é entidade nesta fase                                                               |
| ADR-028            | parcialmente superado: `Categoria/Família de Produto`, não Indústria, é a principal                                |
