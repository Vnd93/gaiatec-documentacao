---
id: gaiatec-catalogo-recuperacao-positiva-backend-2026-10-11
titulo: Recuperação positiva do catálogo no backend de staging
status: backend-parcial-validado-chrome-pendente
tipo: registro-homologacao
area: produto-requisitos
fase: nucleo-catalogo
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-11
ultima_revisao: 2026-10-11
fonte_canonica: gaiatec-documentacao
---

# Recuperação positiva do catálogo no backend de staging

O banco real compensou dois rascunhos sintéticos e um termo após a interrupção
do executor. O manifest foi comprometido em uma transação anterior às escritas;
o encerramento do lease disparou o hook terminal de 0118. A flag global permaneceu
OFF e produção não foi alterada. Esta é uma prova parcial de backend, **não a
homologação completa do sistema nem de Chrome real**.

## Autorização e identidade

O responsável autorizou registros sintéticos temporários e acesso isolado somente
para atores QA em staging, com recuperação prévia e limpeza comprovada. Nenhum
produto comercial, SKU, importação ou publicação foi realizado.

- CMS: `a6c2c2e2a3004cea8c0d51084b9a16a606a12939`, `main` limpa e igual a `origin/main`.
- CI produtor: `38099349665/1`; bridge já concluído: `38099931970/1`.
- Artefato original: `11687154595`, digest
  `f0b4581a01287ec23910b46f32dc5b92c596cdfe43ef2e2439fc194804f7b6fe`.
- Deployment canônico: `f7761b44-4816-44cc-ae4b-9cd833daf89b`.
- Run tag: `QA-CMS-FINAL-20261011-a6c2c2e2`.
- Snapshot técnico das definições de funções do catálogo:
  `6434b90d4d2a720125fc1ef0de1546263791fdb70d38631d83bac0152935d0b0`.
  Esse hash não substitui o snapshot completo nem o verificador canônico de UAT.
- Plano de recuperação selado antes da escrita:
  `6184717a080773366386e984e6f10ba94dfaade67216a4f2c242da52b3afae64`.

Antes da execução: GitHub `Vnd93`, holder com handoff explícito, zero workflows
concorrentes nos cinco estados consultados em ambos os repositórios, paginação
Cloudflare completa sem deployment ativo, zero atores QA ativos, manifests
abertos e produtos do novo catálogo. O preflight versionado de 0118 passou.

## Casos executados

Segredos, senha temporária, TOTP, tokens e sessão existiram apenas em memória.
O provisionador geral não foi executado: ele prepara áreas além do catálogo e
grava credenciais em arquivos. Não houve concessão de acesso RDO.

| Caso                           | Resultado e limite                                                                             |
| ------------------------------ | ---------------------------------------------------------------------------------------------- |
| Recuperação anterior à mutação | Manifest preparado, COMMIT independente e releitura em outra transação                         |
| Autenticação real              | Supabase Auth, enrollment/challenge/verify TOTP e AAL2; execução por SDK, não Chrome           |
| Isolamento da flag             | Workspace fechado antes do override; acesso após override `user` somente do ator QA em staging |
| Cadastro manual no backend     | Dois produtos sintéticos em rascunho; releitura confirmou a primeira revisão e os campos       |
| Taxonomia no backend           | Uma categoria sintética criada e ativada                                                       |
| Revisão                        | Atualização de um rascunho executada; a verificação de conflito ficou inconclusiva             |
| Recuperação após interrupção   | Executor terminou; nova chamada ao backend encerrou o lease e acionou a compensação            |

O primeiro pedido de ator foi recusado por run tag inválido, com sete caracteres
do SHA em vez dos oito exigidos. A consulta confirmou zero atores criados; o
identificador do executor foi corrigido, sem mudar o sistema.

A verificação de CAS esperava `40001`, enquanto 0114 traduz conflitos de negócio
para `PT409`. O código do retorno observado não foi preservado: **não marcar CAS
como aprovado nem concluir que houve falha do controle**. Relações, hierarquia e
editorial não chegaram a ser executados nesta janela.

O encerramento inicial foi recusado pelo guard do executor: ele contava todos os
leases do run tag, incluindo dois leases históricos já `cleaned`. A recuperação
posterior selecionou exclusivamente o ator inscrito no manifest, com datas de
criação/expiração exatas e marcador privado válido. Não alterou o TTL, `prepared_xid`,
PID, claims, estado do manifest ou código de função para liberar a recuperação.

## Limpeza comprovada

Preparação no relógio do banco: `2026-10-11T17:31:01.738021Z`.
Conclusão: `2026-10-11T17:32:29.803693Z`. Intervalo entre preparação e limpeza:
aproximadamente 88 segundos; não é duração do pipeline inteiro.

O caminho de encerramento removeu somente o override QA, revogou o escopo,
retirou o papel, suspendeu o perfil, revogou sessões e bloqueou o ator sintético.
`cms_complete_qa_actor_lease` acionou o hook; o compensador não foi chamado
diretamente. A compensação preservou revisões, auditoria e propriedade histórica.

| Estado terminal consultado                           | Resultado                                       |
| ---------------------------------------------------- | ----------------------------------------------- |
| Manifest                                             | `cleaned`                                       |
| Leases inscritos com binding exato                   | Todos `cleaned`; datas preservadas              |
| Ledger histórico próprio                             | 3 entidades retidas                             |
| Produtos próprios                                    | 2 arquivados, em draft, sem classificação ativa |
| Termo próprio                                        | 1 inativo                                       |
| Auditoria própria                                    | 8 eventos retidos                               |
| Sessões QA, overrides, QA ativos, recuperação aberta | 0 em cada consulta                              |
| Flag global                                          | `false`                                         |

Os dois produtos arquivados são fixtures sintéticas retidas para integridade da
auditoria, não uma carga comercial. Não apagá-los para transformar a contagem
histórica em zero. Resíduo zero significa ausência de estado ativo próprio.

## Pendências da entrega

Continuam pendentes os sete fluxos e nove gates do contrato completo em Chrome
real autenticado. A causa interna do 503 não foi comprovada e o chamado Supabase
permanece registrado; esta execução não corrige nem revalida esse transporte.
Não houve novo release, migration, rebuild ou alteração do CMS.

O teste de restauração do backup `38131544678` falhou no ambiente efêmero por
ausência de `auth.mfa_recovery_code_sets`. Produção não foi modificada nem o
workflow repetido nesta sessão; esse desvio permanece separado do catálogo.

## Referências

- [Recusas da recuperação e observação do 503](registro-recuperacao-negativa-e-503-2026-10-10.md).
- [Roteiro de homologação do sistema vazio](roteiro-homologacao-sistema-vazio-staging-2026-10-10.md).
- [Promoção e buscas administrativas](registro-promocao-e-buscas-staging-2026-10-10.md).
