---
id: gaiatec-guia-operacao-catalogo-manual
titulo: Operação e cadastros manuais do Núcleo de Catálogo
status: preparado-liberacao-pendente
tipo: guia-operacional
area: cms
fase: homologacao
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-13
ultima_revisao: 2026-10-15
fonte_canonica: gaiatec-documentacao
---

# Operação e cadastros manuais do Núcleo de Catálogo

Este guia descreve os controles existentes para cadastro manual e editorial.
A entrega integral ainda está pendente; não é autorização de publicação,
carga comercial, ativação global ou produção. Não é necessário fornecer uma
lista de produtos para homologar o sistema vazio.

## Acesso e situação atual

O painel de staging está em
[CMS GAIATEC staging](https://ev2-g17-canary.gaiatec-cms-staging.pages.dev/admin).
Use Google Chrome, seu próprio login e a verificação MFA. Não compartilhe
senha, link de convite ou código. Contas QA temporárias são encerradas após
os testes e não substituem a conta operacional.

O caminho **Núcleo de Catálogo** abre `/admin/nucleo-catalogo`. Enquanto a flag
global estiver OFF, a conta operacional vê “O novo catálogo está em preparação”.
Isso é um fechamento esperado, não um catálogo pronto para cadastro operacional.
Os passos abaixo se aplicam somente quando os controles estiverem disponíveis
por liberação legítima. Não editar flags, criar overrides ou trocar papéis para
contornar esse fechamento.

O código atual também bloqueia esse workspace em produção. Preparação de
candidato, homologação em staging e liberação de produção são estados distintos.
Nenhum endereço de produção ou cutover é entregue como autorizado neste guia.

## Operação sem IA externa

Esta entrega adota operação manual. O assistente informa que geração e execução
assistida estão desativadas; não é necessário contratar provedor, fornecer chave
ou usar IA para preencher campos, revisar conteúdo ou salvar um rascunho autorizado.
Essa decisão não remove validações, permissões, MFA ou revisão editorial.

Em **Diagnósticos**, a lista de alertas considera avisos e eventos críticos não
resolvidos. A rotina de retenção continua registrada, mas seus eventos informativos
não são falhas abertas. Se a leitura falhar, a tela deve informar indisponibilidade;
um erro de leitura não deve ser interpretado como zero alertas.

## Cadastro e revisão de produtos

1. Em **Produtos e revisões**, selecione **Novo produto**.
2. Preencha **Nome** e **Slug**. O slug usa letras minúsculas, números e hífens
   entre palavras; não aceita espaços, barras ou hífens repetidos.
3. Selecione **Tipo**: Produto, Kit, Modelo ou Variante. Informe resumo e descrição
   quando aplicáveis. A tela preserva limites explícitos de tamanho.
4. Use **Salvar rascunho** e confirme a revisão após a consulta. Salvar não publica
   nem cria snapshot público. Reabra o registro para conferir os campos.
5. Use **Consultar histórico imutável** para revisar mudanças. **Restaurar rascunho**
   cria uma nova revisão; não apaga as anteriores.

Categoria/família principal e classificações complementares devem referenciar
termos disponíveis e autorizados. Nesta entrega não importar SKUs, preencher
dados comerciais em massa, preço, estoque ou disponibilidade. Cadastros de teste
não são base comercial e não permanecem ativos após homologação.

## Termos e relações

**Classificação e termos** permite propor e editar termos conforme o papel.
Use nome, slug, taxonomia, termo pai quando aplicável e justificativa. Gestão de
ativação, inativação ou mesclagem exige permissão e considera o impacto nos
produtos. Termo ativo não equivale a página publicada.

Em **Kits e relações**, escolha origem, destino, relação e motivo. Composição
exige quantidade positiva e unidade controlada. Kits aninhados, ciclos,
referências inválidas e duplicidades são recusados; não reduzir a validação para
salvar. **Definir herança da origem para o destino** vincula Modelo ao Produto
ou Variante ao Modelo. **Relações efetivas e origem** distingue relação direta
de relação herdada. Retirar relação/herança registra uma nova revisão.

## Rascunhos e prévia editorial privada

1. Em **Páginas editoriais**, selecione um termo de indústria, tecnologia ou aplicação.
2. Preencha título editorial, resumo, blocos e justificativa. Cada linha do campo
   de parágrafos corresponde a um parágrafo do bloco.
3. Use **Salvar rascunho editorial**. Depois, **Ver revisão gravada** exibe o conteúdo
   salvo na sessão administrativa, sem abrir rota pública ou solicitar indexação.
4. Se houver alteração não salva, a prévia fica oculta e desabilitada. Salve ou
   descarte a tentativa; trocar de termo fecha a prévia anterior.

O leitor autorizado pode consultar a prévia sem editar. Controles de publicação
dependem de permissão, mas não devem ser usados nesta entrega. Publicar, pedir
indexação e aprovar indexação são decisões separadas; rascunho e prévia não
autorizam nenhuma delas.

## Conflitos e falhas

| Mensagem ou situação                                            | Ação segura                                                                           |
| --------------------------------------------------------------- | ------------------------------------------------------------------------------------- |
| Slug ou vínculo já em uso                                       | Corrigir o valor; a tentativa permanece editável                                      |
| Registro mudou                                                  | Comparar base, tentativa e versão atual; descartar ou revisar antes de reaplicar      |
| Operação indisponível para a sessão/ambiente                    | Verificar acesso legítimo; não converter conta ou remover MFA/RLS                     |
| Campos ou dependências inválidos                                | Corrigir campos e relações; nenhuma rejeição é sucesso parcial                        |
| Operação temporariamente indisponível ou resultado desconhecido | Não repetir o comando; recarregar e conferir revisão/histórico antes de outra mutação |
| Conteúdo editorial não disponível                               | Página permanece fechada; não confundir prévia privada com publicação                 |

Uma gravação desatualizada deve ser recusada, não sobrescrita silenciosamente.
Os ensaios já realizados usaram duas abas da mesma sessão; isso não substitui
os casos entre atores e escopos diferentes. Estes últimos passaram no backend
de staging em fase independente, sem novo convite; a prova de interface
autenticada continua separada.

## Evidências e condições de entrega

Os testes focados comprovaram cadastro sintético, CAS entre abas, hierarquia,
relações herdadas, composição, recusas de ciclo, três prévias editoriais, leitura
sem edição, mobile e recuperação durável. Os efeitos QA foram retirados,
preservando histórico e auditoria. Isso não fecha os sete fluxos e nove gates
como conjunto canônico.

Consulte o [estado atual](../../00-indice/status-atual.md) e o
[registro vigente de homologação](../../10-produto-requisitos/nucleo-catalogo/registro-homologacao-focada-e-historico-2026-10-15.md).
No candidato atual, revisão, histórico, papéis, escopos, referências e entradas
inválidas passaram na fase de backend. A acessibilidade pública automatizada
passou em desktop e mobile, acompanhada por verificações no Chrome real.
Ainda faltam a revalidação autenticada do histórico corrigido, a acessibilidade
integral do catálogo e o tratamento comprovado do 503.
A aceitação do valor administrativo de 2,147 s não corrige o 503 nem transforma
uma execução histórica reprovada em evidência aprovada.

Não será solicitado outro endereço nem aberto outro convite automaticamente.
Essa interrupção não habilita o catálogo para contas operacionais, não reabre
identidades temporárias e não dispensa a homologação pendente. Não tentar usar
senhas ou links de QA encerrado; mantenha sua conta operacional preservada.

O [manual da edição anterior](README.md) permanece preservado. Este complemento
não atualiza silenciosamente os arquivos DOCX/PDF nem declara o sistema liberado.
