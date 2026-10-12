---
id: gaiatec-catalogo-homologacao-mensagens-chrome-2026-10-12
titulo: Homologação das mensagens do catálogo no Chrome real
status: homologacao-focada-recuperada
tipo: evidencia-release
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-12
ultima_revisao: 2026-10-12
fonte_canonica: gaiatec-documentacao
---

# Homologação das mensagens do catálogo no Chrome real

As correções de duplicidade e mensagens editoriais foram homologadas no Google
Chrome instalado, com login humano, MFA/AAL2 e backend real de staging. O ciclo
terminou com recuperação durável e acesso QA revogado. A flag global permaneceu
desligada; produção, produtos comerciais e importação ficaram fora do escopo.

Esta prova focada complementa a
[promoção das correções](registro-correcao-mensagens-staging-2026-10-12.md).
Não conclui a entrega integral: a causa do HTTP 503, os indicadores parcialmente
indisponíveis e os demais gates integrais continuam pendentes.

## Candidato e isolamento

- SHA: `0dd17227a4fca773913f14b32b5ce51ba3ef78e8`.
- Pacote original: `11722612754`, produtor CI `38193383120/1`.
- Digest do pacote: `243d1d3068ecce4457aba148c7b56fe680abbe83f16baa15177238f8a92037b2`.
- Deployment: `1639a263-9724-490e-931c-7db7d1fe4f68`.
- Execução QA: `QA-CMS-FINAL-20261012-0dd17227`.
- Snapshot de metadados de funções: `cf0843995f548806fc2cbb8bf8d37eca6a6c733b5c371aa7aa8cd30f6889503c`.
- Plano de recuperação: `b4bdb1d68ef1410e0b3dbf84b252584041ba71861f019f1237566e58c3d8b6c7`.

O snapshot cobre assinaturas e digests das funções CMS, não uma fotografia
integral do ambiente. O manifesto 0118 foi commitado antes de conceder permissões
ou criar override. Somente a identidade nele inscrita recebeu acesso temporário
ao catálogo, por escopo de usuário em staging. O Chrome mostrou o catálogo
fechado antes desse override. Senha, TOTP, cookies e links de convite não foram
capturados como evidência.

Antes do ciclo: `main` limpo e igual a `origin/main`, perfil GitHub `Vnd93`, zero
workflows ativos nos cinco estados consultados nos dois repositórios, 731
deployments Cloudflare paginados sem operação ativa e `/healthz` com ambiente,
SHA e header `x-release` exatos. Não houve rebuild, novo release ou alteração de
Auth, MFA, RLS, migrations ou limites de produto.

## Convite e autenticação

O primeiro convite foi emitido às `14:54:59Z`. A configuração de Auth mantém
validade de 3.600 segundos; a tentativa mostrada pelo responsável ocorreu depois
desse prazo. Os logs sanitizados de `/verify`, entre `18:10Z` e `18:21Z`,
registraram seis erros/mensagens de expiração. Nenhum payload, IP ou link secreto
foi retornado.

Um único reenvio oficial foi aceito para a mesma identidade ainda pendente, com
redirecionamento para `/admin/definir-senha`, sem ampliar o lease. O responsável
confirmou a tela correta e definiu a senha e o MFA. O backend confirmou uma
sessão AAL2, fator verificado e perfil ativo; o Chrome mostrou o painel real.
O prazo original do lease, `18:54:59.419222Z`, permaneceu intacto.

## Resultados no Chrome e backend reais

| Caso                                       | Resultado observado                                                                                                                             |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| Criação manual isolada                     | Um produto sintético persistido como rascunho, revisão 1 e sem snapshot público.                                                                |
| Slug duplicado                             | Segunda criação recusada; somente um produto persistido. Mensagem: “Este slug ou vínculo já está em uso. Revise os valores antes de salvar.”    |
| Salvamento editorial                       | Rascunho do termo A salvo e confirmado na revisão 1, sem publicação ou solicitação de indexação.                                                |
| Formulário editorial inválido após sucesso | Título vazio recusado com “Preencha título, resumo, blocos e justificativa.” O sucesso anterior desapareceu e a revisão persistida não avançou. |
| Mudança de termo após sucesso              | Após salvar a revisão 2 de A, selecionar B mostrou revisão 0 e campos vazios, sem sucesso anterior.                                             |
| Revogação terminal                         | Recarregar a aba mostrou acesso administrativo não autorizado; a saída segura normal retornou ao login.                                         |

Os dois termos sintéticos foram ativados exclusivamente para permitir a edição
editorial de QA. O termo B não recebeu página. A visão geral continuou exibindo
“Indicadores parcialmente indisponíveis”; sua causa não foi atribuída ao 503.
Este ciclo não repetiu nem substituiu os testes de relações, CAS, mobile e
restauração do [ciclo anterior](registro-chrome-qa-recuperacao-2026-10-12.md),
cuja evidência permanece vinculada ao SHA anterior.

## Recuperação e resíduo

A conclusão normal `cms_complete_qa_actor_lease` acionou o hook terminal 0118,
sem chamada direta ao compensador, claims artificiais, PID forjado ou mudança de
datas. Antes da conclusão, o acesso individual foi removido, papéis revogados,
perfil suspenso, sessões revogadas e a identidade QA bloqueada.

O manifesto terminou `cleaned` às `18:32:34.533521Z` de 12 de outubro de 2026:

- Um produto arquivado, em draft e sem snapshot corrente.
- Dois termos inativos e um editorial retirado, sem pedido de indexação.
- Zero outbox pendente, QA ativo, manifesto aberto, sessão, override, papel ativo
  ou perfil QA ativo.
- Nove eventos de auditoria do catálogo e duas revisões de produto preservados.
- Flag global `false` e produção intocada.

As contagens foram feitas pelo manifesto e pela identidade exata nele inscrita,
não por todos os atores históricos com o mesmo run tag. Registros sintéticos
retirados permanecem como histórico auditável; resíduo zero significa nenhum
efeito ou acesso ativo, não apagar auditoria.

## Limites de entrega

A homologação focada das mensagens está concluída em staging. Ela não aprova
produção, cutover, submissão positiva de lead, backend completo do candidato,
acessibilidade integral ou o canônico anteriormente reprovado. O sistema ainda
não está declarado pronto e homologado integralmente.
