---
id: gaiatec-politica-ciclo-vida-documental
titulo: Politica de ciclo de vida documental
status: ativo
tipo: politica
area: governanca-documental
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - mapa-documental.md
  - catalogo-documentos.md
  - manifesto-migracao-documental.md
---

# Política de ciclo de vida documental

## Princípios

1. `gaiatec-documentacao` é a fonte canônica de documentação humana; o CMS não mantém espelho
   narrativo.
2. A decisão canônica considera conteúdo, finalidade, histórico Git, dependências e vínculo a
   gates/SHAs — nunca apenas a data de modificação.
3. Evidências imutáveis não são reescritas. Explicações, correções e decisões posteriores são
   documentos aditivos.
4. Nenhuma origem é retirada antes de inventário, hash, decisão de destino, cópia quando aplicável e
   validação.
5. Arquivamento preserva origem lógica, destino, hash e procedimento de restauração.

## Estados documentais

| Estado               | Significado                                     | Alteração permitida                          |
| -------------------- | ----------------------------------------------- | -------------------------------------------- |
| `rascunho`           | Em elaboração, ainda não normativo              | Sim, por branch e PR                         |
| `em-revisao`         | Candidato completo aguardando decisão           | Correções da revisão, por PR                 |
| `ativo`              | Fonte vigente para o escopo declarado           | Sim, com revisão e atualização de metadados  |
| `substituido`        | Não vigente; possui sucessor explícito          | Somente nota de sucessão ou correção aditiva |
| `historico`          | Snapshot preservado para contexto               | Não modernizar conteúdo; apenas catalogar    |
| `evidencia-imutavel` | Prova vinculada a execução/data/SHA             | Não alterar bytes; anexar nova evidência     |
| `arquivado`          | Retirado dos repositórios ativos após validação | Restauração controlada pelo manifesto        |

## Metadados obrigatórios para documentos ativos novos

O frontmatter deve conter: `id`, `titulo`, `status`, `tipo`, `area`, `fase`, `ambiente`,
`responsavel`, `data_criacao`, `ultima_revisao`, `fonte_canonica`, `substitui` e `relacionados`.

- `id` é estável e não depende do caminho.
- `status` usa um valor da tabela anterior.
- `substitui` lista IDs ou caminhos anteriores; use `[]` quando não houver.
- `relacionados` lista somente vínculos relevantes e verificáveis.
- Binários e evidências imutáveis recebem metadados em um README/catálogo adjacente, sem alterar
  seus bytes apenas para inserir frontmatter.

## Nomenclatura e localização

- Novos nomes: `kebab-case`, sem espaços e sem acentos.
- ADRs e evidências vinculadas a SHA preservam nomes legados quando necessário à rastreabilidade.
- O diretório segue a taxonomia definida no [mapa documental](mapa-documental.md).
- Um documento não pode ter duas cópias editáveis em repositórios distintos.

## Fluxo de criação e revisão

1. Definir finalidade, área, responsável e público.
2. Pesquisar o catálogo e o manifesto para evitar duplicação.
3. Criar em branch, com metadados e vínculos locais válidos.
4. Verificar Markdown/Prettier, links, dados sensíveis e coerência com código quando aplicável.
5. Revisar por PR. Aprovação de IA não é registrada como aprovação humana independente.
6. Atualizar `ultima_revisao`, catálogo e `status-atual.md` quando houver mudança de estado presente.

## Substituição

1. Criar ou identificar o sucessor canônico.
2. Marcar o anterior como `substituido` sem apagar conteúdo histórico relevante.
3. Registrar `substitui` no sucessor e referência ao sucessor no anterior quando o arquivo for
   mutável.
4. Para evidência imutável, não editar o anterior; registrar a relação no catálogo ou em documento
   aditivo.
5. Atualizar links e criar índice de compatibilidade quando o caminho antigo ainda for externo.

## Arquivamento e descarte

Antes de retirar um item dos repositórios ou da pasta ativa:

1. calcular SHA-256 e tamanho;
2. confirmar sucessor canônico ou valor exclusivamente histórico;
3. verificar ausência de dependência operacional ativa;
4. registrar origem e destino;
5. copiar por caminho exato e validar o hash de destino;
6. manter rollback documentado;
7. usar `git mv`/`git rm` para arquivos versionados e comandos próprios do Git para worktrees.

`.git`, `.codex-worktrees`, worktrees registrados e `.secrets` não são movidos manualmente.
`.codex-artifacts` é classificado por tarefa; intermediários reproduzíveis não são arquivados por
padrão.

## Revisão periódica

- `status-atual.md`: revisar a cada mudança de fase, release ou configuração de repositório.
- Documentos ativos: revisar quando comportamento, contrato, regra ou responsável mudar.
- Catálogo e links: validar em toda alteração documental.
- Histórico e evidências: auditar integridade por hash; não atualizar narrativa para refletir o
  presente.
