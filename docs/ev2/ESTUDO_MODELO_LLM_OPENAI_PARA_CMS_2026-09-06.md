# Estudo de seleção de LLM OpenAI para o CMS GAIATEC

**Data-base:** 6 de setembro de 2026  
**Escopo:** assistência editorial, consulta, planejamento e execução controlada das funções do CMS  
**Recomendação principal:** `gpt-5.6-terra` pela Responses API, com roteamento opcional para
`gpt-5.6-luna` e `gpt-5.6-sol` conforme risco e complexidade

## 1. Resumo executivo

O melhor modelo único para iniciar a operação do CMS GAIATEC é o **GPT-5.6 Terra**. Ele ocupa o
melhor ponto de equilíbrio entre qualidade, capacidade de raciocínio, uso de ferramentas, saída
estruturada, latência e custo. A própria documentação da OpenAI posiciona o Terra para cargas que
equilibram inteligência e custo. Ele suporta texto e imagem, function calling, Structured Outputs e
a Responses API, com janela de contexto de 1,05 milhão de tokens.

A escolha do modelo, isoladamente, não habilita a administração completa do CMS. O código atual
possui duas superfícies diferentes:

1. a assistência editorial F-015 gera propostas com fonte, confiança e revisão humana;
2. a execução F-016 usa outro gateway, hoje restrito a cinco ferramentas e alvos sintéticos.

Para chegar ao uso integral do CMS, o LLM deve produzir planos e chamadas estruturadas, enquanto o
backend continua responsável por autenticação, RBAC, MFA, validação, idempotência, aprovação,
execução, auditoria e compensação. O modelo nunca deve receber credencial privilegiada nem escrever
diretamente no Supabase.

A arquitetura de produção recomendada é:

| Papel         | Modelo          | Uso recomendado                                                          |
| ------------- | --------------- | ------------------------------------------------------------------------ |
| Padrão        | `gpt-5.6-terra` | leitura, extração técnica, redação, planejamento e maioria das tools     |
| Econômico     | `gpt-5.6-luna`  | classificação, metadados, alt text, triagem e operações em massa simples |
| Escalonamento | `gpt-5.6-sol`   | planos entre módulos, ambiguidade alta e revisão de ações críticas       |
| Challenger    | `gpt-6-astra`   | benchmark e casos excepcionais após disponibilidade e avaliação próprias |

Se a organização exigir exatamente um modelo, sem roteamento, a decisão recomendada permanece
`gpt-5.6-terra`.

## 2. Evidências observadas no projeto

O estudo considerou o repositório executável `gaiatec-cms`, a especificação EV2 e os contratos das
fases de IA.

### 2.1 Superfícies administrativas existentes

O painel possui módulos de conteúdo, páginas, Estúdio Visual, produtos, importação em massa, PIM,
busca, qualidade, listas e dados mestres, campanhas, formulários, leads, mídia, sites, usuários e
diagnósticos. O backend distribui essas capacidades em Edge Functions separadas, o que favorece uma
allowlist de ferramentas por domínio e permissão.

### 2.2 Estado atual da IA

O candidato EV2.17 introduziu um adaptador OpenRouter travado em
`nvidia/nemotron-3.5-lightning:free`. Esse adaptador:

- usa Chat Completions;
- envia um trecho de fonte e recebe `summary`, `value` e `confidence`;
- faz parsing manual de JSON porque o modelo selecionado não aceitou o formato estruturado usado no
  primeiro ensaio;
- mantém aplicação e publicação automáticas desligadas;
- foi validado em staging com uma proposta sintética e revisão humana;
- não integra o modelo ao gateway transacional F-016.

O canary G17 demonstra conectividade, controles e fallback. Ele não constitui uma comparação de
qualidade entre LLMs: houve uma proposta sintética externa, enquanto os golden evals da EV2.10
continuam baseados no adaptador determinístico. Portanto, ainda não existe evidência empírica local
suficiente para declarar vencedor por precisão.

### 2.3 Limite da execução atual

O gateway `cms-ai-execute` expõe apenas:

- `draft.apply_patch`;
- `workflow.submit`;
- `release.schedule`;
- `release.publish`;
- `release.rollback`.

Essas ferramentas são `syntheticOnly`, reversíveis e limitadas a referências `g14x-*`. O plano é
montado pela interface, não pelo LLM. Assim, "uso completo do CMS" exige uma fase adicional de
contratos reais por módulo, sem remover os controles já implantados.

## 3. Requisitos derivados do CMS

| Requisito            | Necessidade do projeto                                   | Implicação para o modelo/arquitetura                              |
| -------------------- | -------------------------------------------------------- | ----------------------------------------------------------------- |
| Português técnico    | produtos industriais, especificações, SEO e documentação | boa extração e redação em português, com citação por campo        |
| Saída determinística | propostas, patches, planos e argumentos de tools         | Structured Outputs com JSON Schema estrito                        |
| Uso de ferramentas   | consultar e operar vários módulos                        | function calling com allowlist filtrada por RBAC                  |
| Contexto amplo       | páginas, PIM, documentos, taxonomias e histórico         | contexto grande, mas com recuperação seletiva                     |
| Multimodalidade      | datasheets, imagens e mídia                              | entrada de texto e imagem; OCR/documentos por pipeline controlado |
| Segurança            | PII, leads, credenciais, publicação e acessos            | redaction, classificação, MFA e policy engine fora do LLM         |
| Auditabilidade       | revisão, correlação, custo e rollback                    | log de metadados, hashes, versões e decisões do backend           |
| Continuidade         | CMS não pode parar com indisponibilidade do provedor     | fallback manual e filas recuperáveis                              |
| Custo previsível     | tarefas frequentes e importações em massa                | roteamento por complexidade, limites por sessão e cache permitido |

## 4. Comparação dos modelos atuais

Segundo a documentação oficial da OpenAI consultada na data-base, os quatro modelos comparados
suportam Responses API, function calling, Structured Outputs, entrada de imagem e contexto de 1,05
milhão de tokens. Os preços abaixo são por 1 milhão de tokens.

| Modelo          | Posicionamento oficial                 |   Entrada | Entrada em cache |     Saída | Adequação ao CMS                                                        |
| --------------- | -------------------------------------- | --------: | ---------------: | --------: | ----------------------------------------------------------------------- |
| `gpt-5.6-luna`  | alto volume sensível a custo           |  US$ 0,20 |         US$ 0,02 |  US$ 1,20 | excelente para tarefas simples; requer maior vigilância de qualidade    |
| `gpt-5.6-terra` | equilíbrio entre inteligência e custo  |  US$ 2,00 |         US$ 0,20 | US$ 12,00 | melhor padrão operacional                                               |
| `gpt-5.6-sol`   | trabalho profissional complexo         |  US$ 4,00 |         US$ 0,40 | US$ 20,00 | melhor escalonamento para casos difíceis                                |
| `gpt-6-astra`   | maior capacidade para fluxos complexos | US$ 10,00 |         US$ 1,00 | US$ 50,00 | maior capacidade absoluta, mas custo e acesso não justificam uso padrão |

Fontes oficiais: [catálogo de modelos](https://developers.openai.com/api/docs/models),
[comparador](https://developers.openai.com/api/docs/models/compare),
[GPT-5.6 Terra](https://developers.openai.com/api/docs/models/gpt-5.6-terra),
[GPT-5.6 Luna](https://developers.openai.com/api/docs/models/gpt-5.6-luna) e
[GPT-5.6 Sol](https://developers.openai.com/api/docs/models/gpt-5.6-sol).

### 4.1 Matriz de decisão preliminar

As notas são uma hipótese de engenharia para selecionar os modelos que devem entrar no bake-off;
não são benchmarks publicados pela OpenAI nem resultados do projeto.

| Critério                          |     Peso |     Luna |    Terra |      Sol |    Astra |
| --------------------------------- | -------: | -------: | -------: | -------: | -------: |
| Confiabilidade em tools e schemas |      35% |      8,0 |      9,0 |      9,5 |     10,0 |
| Raciocínio e conteúdo técnico     |      20% |      7,0 |      8,5 |      9,5 |     10,0 |
| Custo                             |      20% |     10,0 |      8,0 |      6,0 |      3,0 |
| Latência e throughput             |      15% |      9,5 |      8,5 |      7,5 |      6,0 |
| Aderência operacional imediata    |      10% |      9,0 |      9,0 |      9,0 |      5,0 |
| **Resultado preliminar**          | **100%** | **8,53** | **8,63** | **8,45** | **7,50** |

O Terra vence por pequena margem. Luna e Sol devem permanecer no teste porque podem ganhar em
classes específicas de tarefa.

### 4.2 Estimativa de custo para o contrato atual

O contrato F-015 limita cada chamada a aproximadamente 2.000 tokens de entrada e 900 de saída. Para
dimensionamento, foram usados dois cenários:

- médio: 1.200 tokens de entrada e 450 de saída;
- teto configurado: 2.000 tokens de entrada e 900 de saída.

| Modelo | Custo médio por 1.000 chamadas | Teto textual por 1.000 chamadas |
| ------ | -----------------------------: | ------------------------------: |
| Luna   |                       US$ 0,78 |                        US$ 1,48 |
| Terra  |                       US$ 7,80 |                       US$ 14,80 |
| Sol    |                      US$ 13,80 |                       US$ 26,00 |
| Astra  |                      US$ 34,50 |                       US$ 65,00 |

Estimativa baseada somente em tokens de texto, sem impostos, câmbio, chamadas de ferramentas pagas
ou tokens adicionais de raciocínio. O custo real deve ser medido pelos recibos de uso. Prompts acima
de 272 mil tokens possuem regra de preço diferente nos modelos GPT-5.6, mas o contrato atual fica
muito abaixo desse patamar.

## 5. Decisão recomendada

### 5.1 Modelo padrão

Usar `gpt-5.6-terra` com:

- Responses API;
- `reasoning.effort: "low"` para leitura, extração e rascunho;
- `reasoning.effort: "medium"` para planos com mais de um módulo ou ambiguidade relevante;
- `text.verbosity: "low"`;
- `store: false`;
- Structured Outputs com schema estrito;
- streaming apenas na resposta textual; planos e argumentos só após validação completa;
- limite de saída e timeout definidos pelo gateway.

A Responses API aceita texto, imagem e arquivo, custom tools com argumentos tipados, escolha de
ferramentas e Structured Outputs. Isso elimina o parsing tolerante de JSON existente no adaptador
OpenRouter e aproxima a resposta do contrato Zod já usado pelo projeto. Consulte a
[referência oficial da Responses API](https://developers.openai.com/api/reference/resources/responses/methods/create).

### 5.2 Roteamento recomendado após o piloto

O roteador deve ser determinístico e controlado pelo backend, nunca escolhido livremente pelo LLM:

| Classe             | Exemplos                                                     | Modelo/effort                                                  |
| ------------------ | ------------------------------------------------------------ | -------------------------------------------------------------- |
| Baixa complexidade | categorizar, sugerir tags, alt text, deduplicar nomes        | Luna / `none` ou `low`                                         |
| Padrão             | extrair datasheet, escrever página, SEO, proposta de patch   | Terra / `low`                                                  |
| Alta complexidade  | plano entre PIM, página, release e mídia; conflito de fontes | Sol / `medium`                                                 |
| Crítica            | publicar, rollback, anonimizar lead                          | Terra ou Sol produz plano; backend e humano autorizam/executam |

O Astra deve entrar como challenger periódico. A documentação atual o posiciona como o modelo mais
capaz e descreve recursos avançados para fluxos longos, mas seu preço é significativamente maior e
o acesso está em implantação gradual. Ele só deve substituir Sol ou Terra quando os evals locais
provarem ganho mensurável por tarefa. Consulte o
[guia oficial do GPT-6 Astra](https://developers.openai.com/api/docs/guides/latest-model).

## 6. Arquitetura-alvo para administração completa

```text
Operador autenticado
        |
        v
Orquestrador CMS (sessão, RBAC, MFA, orçamento, correlação)
        |
        +--> recuperação de contexto autorizado e sanitizado
        |
        +--> OpenAI Responses API (plano/argumentos estruturados)
        |
        v
Policy engine + dry-run + hash do plano
        |
        +--> revisão/aprovação humana proporcional ao risco
        |
        v
Tool gateway server-side
        |
        +--> APIs CMS por domínio, com idempotência e pós-verificação
        |
        v
Auditoria, recibo, compensação e fallback manual
```

### 6.1 Catálogo de ferramentas por domínio

| Domínio            | Tools de leitura/rascunho                                     | Tools mutantes, sempre controladas                     |
| ------------------ | ------------------------------------------------------------- | ------------------------------------------------------ |
| Conteúdo/páginas   | buscar, ler versão, propor bloco, revisar SEO                 | salvar rascunho, submeter, agendar, publicar, reverter |
| Produtos/PIM       | ler produto, extrair ficha, mapear taxonomia, validar unidade | criar/atualizar rascunho, importar lote aprovado       |
| DAM/mídia          | localizar ativo, ler metadados, sugerir alt text              | vincular/substituir ativo com direitos válidos         |
| Busca/qualidade    | diagnosticar lacunas, sugerir sinônimos e correções           | aplicar lote de correções aprovado                     |
| Marketing          | propor campanha, formulário e conteúdo                        | salvar, agendar e encerrar campanha                    |
| Leads              | resumir estado e SLA após minimização                         | nenhuma exportação de PII pelo modelo                  |
| Sites/configuração | ler configuração e comparar ambientes                         | alteração por plano específico e revisão forte         |
| Usuários/RBAC      | explicar permissões efetivas                                  | nenhuma concessão, revogação ou impersonação pelo LLM  |

### 6.2 Regras que devem permanecer fora do modelo

- autorização e filtragem do catálogo por usuário, site e ambiente;
- MFA e aprovação por outro ator para risco crítico;
- resolução do alvo por ID canônico, nunca apenas por nome livre;
- transições de estado, validações de negócio e constraints;
- idempotência, locks, limites de concorrência e orçamento;
- detecção e remoção de PII/segredos antes da chamada externa;
- gravação, auditoria, verificação de pós-estado e compensação;
- kill switch e fallback manual.

`parallel_tool_calls` deve ficar desligado para mutações. Uma sequência crítica deve ser executada
como uma transação ou saga server-side já validada, não como chamadas paralelas decididas pelo LLM.

## 7. Privacidade e conformidade

A documentação da OpenAI afirma que dados enviados pela API não são usados para treinar modelos,
salvo adesão explícita ao compartilhamento. Por padrão, contudo, logs de monitoramento de abuso
podem reter conteúdo por até 30 dias. Zero Data Retention e Modified Abuse Monitoring exigem
elegibilidade e aprovação da OpenAI. Na Responses API, `store` deve ser definido como `false`; com
ZDR aprovado, esse valor é forçado para falso.

Fonte: [controles de dados da plataforma OpenAI](https://developers.openai.com/api/docs/guides/your-data).

Antes de dados reais, a decisão EV2-D04 deve registrar:

1. organização/projeto OpenAI contratado e responsável financeiro;
2. DPA/termos, região e transferência internacional aplicável;
3. classes de dados permitidas e proibidas;
4. retenção padrão ou aprovação de ZDR/MAM;
5. política para PII, leads, documentos de terceiros e anexos restritos;
6. limites de gasto, alertas, rotação de chave e resposta a incidentes.

A chave `OPENAI_API_KEY` deve existir somente como secret da Edge Function. O navegador recebe apenas
o resultado autorizado do gateway. Recomenda-se projeto OpenAI separado por ambiente e chave de
service account com menor privilégio operacional disponível.

## 8. Plano de validação e adoção

### Etapa 1 — bake-off offline

Construir um conjunto versionado com 150 a 300 casos representativos, sanitizados e revisados:

- extração de especificações e unidades;
- identificação de ausência e conflito de fonte;
- redação editorial e SEO;
- classificação de taxonomia;
- geração de plano e argumentos de tools;
- tentativas de prompt injection, exfiltração e escalada de privilégio;
- português com termos industriais, tabelas e documentos visuais.

Executar Luna, Terra e Sol com o mesmo prompt, schema e contexto. Astra pode participar quando o
acesso estiver confirmado.

### Etapa 2 — metas de aprovação

| Métrica                              |                      Meta inicial |
| ------------------------------------ | --------------------------------: |
| JSON/schema válido                   |                              100% |
| Campos técnicos com fonte completa   |                              100% |
| Precisão de campos no golden set     |                            >= 95% |
| Tool fora da allowlist               |                                 0 |
| Bypass de permissão/MFA/policy       |                                 0 |
| Vazamento de PII ou segredo          |                                 0 |
| Ação crítica sem aprovação           |                                 0 |
| Alucinação de especificação ausente  |           0 nos casos bloqueantes |
| Disponibilidade preservando fallback |                              100% |
| Custo e latência                     | registrados por caso e por classe |

Também medir taxa de aceitação sem edição, distância da edição humana, tempo economizado, p50/p95,
tokens por tarefa, taxa de escalonamento e custo por proposta aceita.

### Etapa 3 — shadow mode

Em staging, gerar propostas em paralelo sem mostrá-las como decisão final nem aplicar mudanças.
Comparar Terra com o provedor atual e revisar amostras cegas. Nenhuma mutação real deve ocorrer.

### Etapa 4 — piloto assistivo

Habilitar somente leitura e rascunho para um grupo pequeno, com fontes públicas aprovadas ou internas
não sensíveis, orçamento baixo, revisão obrigatória e kill switch exercitado.

### Etapa 5 — tools reais por domínio

Liberar um domínio por vez: primeiro conteúdo em rascunho; depois PIM/DAM; por último workflow e
publicação. Cada tool real precisa de schema, RBAC/RLS, dry-run, idempotência, pós-condição,
compensação e eval próprios.

## 9. Riscos e tratamentos

| Risco                                   | Tratamento recomendado                                             |
| --------------------------------------- | ------------------------------------------------------------------ |
| Escolher por marketing do modelo        | bake-off com dados e fluxos GAIATEC                                |
| Modelo gerar JSON inválido              | Structured Outputs e validação Zod/SQL                             |
| Prompt injection em conteúdo recuperado | tratar fonte como dado, delimitar, filtrar e negar tools críticas  |
| Alvo errado ou ambíguo                  | ID canônico, preview, diff e confirmação explícita                 |
| Excesso de autonomia                    | modelo propõe; policy engine e gateway decidem o que pode executar |
| Vazamento de PII/segredo                | classificação, redaction, denylist, `store:false` e política DPO   |
| Custo imprevisível                      | roteamento, budgets, teto de saída, alertas e recibos de uso       |
| Mudança de comportamento do alias       | versão aprovada, eval contínuo e canary antes de promoção          |
| Dependência do provedor                 | adapter interno, timeout, circuit breaker e CMS manual funcional   |

## 10. Conclusão

Adotar **GPT-5.6 Terra como modelo padrão** e migrar a integração para a **Responses API com
Structured Outputs**. Depois do bake-off, usar **Luna para volume simples** e **Sol para escalonamento
complexo**. Manter **Astra como challenger**, não como padrão inicial.

O investimento prioritário deve ser o gateway de ferramentas reais por domínio e a avaliação com
casos representativos. O LLM planeja e propõe; a plataforma GAIATEC preserva autoridade sobre dados,
permissões, execução e publicação.
