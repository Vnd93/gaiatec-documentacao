---
id: gaiatec-politica-leitura-auth-2026-10-13
titulo: Política de leitura administrativa e segurança de senha em staging
status: homologacao-pendente
tipo: registro-de-evidencia
area: cms
fase: homologacao
ambiente: staging
responsavel: Vnd93
data_criacao: 2026-10-13
ultima_revisao: 2026-10-13
fonte_canonica: gaiatec-documentacao
---

# Política de leitura administrativa e segurança de senha em staging

O responsável confirmou p95 de leitura administrativa de até **2.147 ms**
para staging e o futuro candidato de produção. Essa decisão não autoriza
deploy, cutover ou mudança de produção. A decisão altera o requisito para
novas medições; não transforma os runs históricos reprovados em aprovados.

## Candidato validado no CI

O SHA `b99595c15e364a573aac1a4516f6ed2d5c660e51` foi revisado, commitado e
publicado em `main`. O [CI 38405653746, tentativa 1](https://github.com/Vnd93/gaiatec-cms/actions/runs/38405653746)
terminou com todos os sete jobs verdes. O perfil selecionado foi `full-release`.
A validação local completa passou com 240 arquivos Vitest, 1.704 testes,
verificações adicionais de segurança e release e build em 21,09 s.

A migration aditiva `0120_cms_admin_read_latency_budget.sql` muda somente
duas expressões de leitura. Ela exige os digests exatos anteriores e posteriores
e preserva todos os atributos de `pg_proc`, permissões e `search_path`.
O frontend aceita capabilities antigas durante a transição; deve ser instalado
antes da migration. O histórico 0116 permanece imutável.

Staging e produção exatos usam 2.147 ms para leitura. Local e ambientes
desconhecidos mantêm 500 ms. Comandos continuam independentes: 2.000 ms em
staging e 800 ms em produção. Amostragem p95, revisão independente, segurança,
MFA/AAL2, RLS, auditoria, acessibilidade e recuperação continuam obrigatórios.

| Evidência | ID ou digest SHA256 |
| --- | --- |
| Pacote frontend original | `11816914807` |
| Digest do pacote | `a061899d044952acf5ca3a6fe386a826c7ba8efc6b04b1ee8b68c1638cec8639` |
| Seleção validada | `11817004759` |
| Digest da seleção | `f131885071b670b6930aed577894fd8d40466fe94708c06548eec4316f3a8e97` |
| Archive do dist | `60048d1edd4bc88a6c611851a2399c9fddbf758dd1462664e32324e13f4b767f` |
| Árvore do dist | `a38b1589d20c87e43a1791b87c8532f7a2b4870897f8a2667c0f532d75ca87df` |
| Payload de banco | `11819182307` |
| Digest do payload | `cef9b9e3e2da0a011d7f4ce4a2a7850b48acdeff551f8be9cead21b816b9a739` |
| Migration 0120 | `f4aa323251419b7a95e9cb8077b2b8a0e87cc00ab4f516aa0b4f6f1fdfa99a88` |

## Segurança de senha comprovada em staging

O Auth aceitava mínimo de 6 caracteres, enquanto o painel exigia 12.
Uma alteração controlada somente em staging alinhou o backend a 12.
O GET posterior comprovou que somente `password_min_length` mudou.
Cadastro público continua desabilitado. Não houve mudança de senha de usuário,
MFA, papéis, sessões, produção ou faturamento. O configurador versionado passa
a exigir o mesmo valor em releases futuros de staging.

A ativação da proteção contra senhas vazadas foi recusada com HTTP 402 por
restrição do plano. O GET posterior comprovou ausência de mudança e a proteção
permanece desabilitada. Não houve contratação ou tentativa repetida. Essa é
uma limitação real, não um gate aprovado. Ver
[aviso e requisito do Supabase](https://supabase.com/docs/guides/auth/password-security#password-strength-and-leaked-password-protection).

## Estado de entrega e próximos gates

No fechamento deste registro, staging ainda serve o SHA `15290b5bfa65124669756ed4c5277ee857e6d93f`;
a ponte do novo candidato e a aplicação da migration 0120 estão pendentes.
CI verde não é homologação no Chrome real nem entrega integral do sistema.

Não há QA ativo ou recovery de catálogo aberto. As identidades QA encerradas
permanecem bloqueadas; o próximo destinatário foi confirmado e sua elegibilidade
verificada, mas nenhum convite foi enviado antes da promoção do candidato.
Flag global OFF, nenhum produto comercial, SKU, importação ou publicação.

A causa histórica do 503 continua sem comprovação de exclusividade às páginas
de instrumentação ou proteção catódica. Ambas responderam HTTP 200 em uma
observação posterior, o que não prova renderização ou ausência de intermitência.
A autorização condicional de remoção não foi aplicada.

Faltam a promoção e os gates no mesmo candidato, os casos de atores/escopos,
referências e formulários, acessibilidade integral, homologação autenticada,
rollback e limpeza comprovada. O [guia de operação manual](../../30-cms/manual-do-usuario/operacao-catalogo-manual.md)
continua preparado, não liberado. Produção permanece intocada.
