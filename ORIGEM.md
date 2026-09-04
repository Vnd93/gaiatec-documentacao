# Origem da documentação

- Repositório de origem: <https://github.com/pedronishida/website_gaiatecsistemas>
- Branch de origem: `main`
- Commit de origem: `63da59443701fc1045575d511b026a609a7cd2b3`
- Data do commit de origem: `2026-08-27T22:59:02-03:00`
- Data da transferência: `2026-09-04`
- Conta administradora do novo repositório: `Vnd93`

## Escopo transferido

Foram transferidos todos os 10 arquivos Markdown existentes no commit de origem, com o conteúdo preservado. A estrutura relativa foi mantida dentro de `documentacao-original/`; o `README.md` original foi renomeado para `README_PROJETO_ORIGINAL.md` para permitir que este repositório tenha um índice próprio na raiz.

## Atualização EV2

- Repositório de origem: <https://github.com/pedronishida/website_gaiatecsistemas>
- Branch de origem: `ev2/desenvolvimento-fases-1-a-12`
- Commit qualificado de origem: `5c3e00f3ca5d5be6754c130c75cc01745e30e03e`
- Data da transferência: `2026-09-04`
- Destinos: `docs/ev2/`, `docs/adr/`, `docs/auditoria-cms-2026-09-01/` e `docs/fase-1/`
- Escopo: 115 arquivos — 85 da EV2, 21 ADRs, 2 da auditoria-base e 7 evidências da Fase 1

A importação preserva o conteúdo das três árvores no commit acima. O remoto de origem está
configurado somente para leitura neste checkout; a manutenção documental passa a ocorrer neste
repositório.

## Repositório executável administrável

- Repositório privado: <https://github.com/Vnd93/gaiatec-cms>
- Origem histórica: <https://github.com/pedronishida/website_gaiatecsistemas>
- Data da migração: `2026-09-04`
- Branch ativa migrada: `ev2/desenvolvimento-fases-1-a-12`
- Ponta validada na migração: `5c3e00f3ca5d5be6754c130c75cc01745e30e03e`
- Branch padrão após o hardening: `ev2/desenvolvimento-fases-1-a-12`
- Merge do hardening: `77cda0b2c5d6999cfb5d260ad24f06f83d231b11`
- Candidato G12 preservado: `8250db0ddb221306a2621aa9c6004f45823ec532`

O checkout de desenvolvimento passou a usar `Vnd93/gaiatec-cms` como `origin`. O repositório
histórico permanece configurado como `legacy-source`, somente para leitura e com push localmente
desabilitado. Detalhes: [evidência da migração](docs/ev2/fase-12/MIGRACAO_REPOSITORIO_EXECUTAVEL_2026-09-04.md).

## Atualização EV2.13

- Repositório executável de origem: <https://github.com/Vnd93/gaiatec-cms>
- Branch de origem: `ev2/fase-13-hardening-pre-producao`
- SHA do candidato qualificado: `518e8e5df605264013d94a16998d00168d4d03c7`
- Commit documental de origem: `8740d1cb776f76953d16b6c23ac94d960a8192f6`
- CI vinculada: [run 33924530169](https://github.com/Vnd93/gaiatec-cms/actions/runs/33924530169)
- Data da sincronização: `2026-09-04`
- Destinos: `docs/ev2/fase-13/`, `docs/adr/ADR-022*`, índice EV2, backlog EV2.0 e notas G12

A atualização registra o Gate G13 de staging, suas evidências JSON sanitizadas e a elegibilidade
runtime fail-closed. Ela não transfere código, build ou secrets e não declara o Gate G12 nem produção
aprovados.
