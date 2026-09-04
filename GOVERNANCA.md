# Governança do repositório documental

## Finalidade e limites

`Vnd93/gaiatec-documentacao` é a fonte oficial dos documentos técnicos, funcionais, operacionais e
de governança do projeto GAIATEC Sistemas.

Este repositório não deve conter:

- código executável da aplicação ou artefatos de build;
- tokens, chaves, senhas, arquivos `.env` ou credenciais de banco;
- workflows com autoridade para alterar produção;
- cópias não sanitizadas de logs ou dados pessoais.

Secrets e controles de deployment pertencem exclusivamente ao repositório que executa o software.

## Fluxo de alteração

1. Criar uma branch com prefixo `docs/`, `governance/` ou `evidence/`.
2. Atualizar `ORIGEM.md` quando a mudança vier de outro repositório ou artefato.
3. Executar formatação e verificar links/segredos antes do commit.
4. Abrir pull request para `main` com objetivo, origem e impacto.
5. Para gates, aprovações ou produção, obter revisão de pessoa diferente do autor.
6. Preservar evidências históricas; correções devem ser aditivas ou registrar claramente a
   substituição.

## Proteção e segregação

A branch `main` deve bloquear force-push e exclusão e exigir pull request. A exigência de aprovação
independente deve ser ativada assim que o revisor técnico tiver conta GitHub registrada como
colaborador. O proprietário não deve aprovar a própria mudança quando o documento representar um
gate de liberação.

## Rastreabilidade EV2

Cada evidência EV2 deve identificar, quando aplicável:

- ambiente e data/hora;
- SHA completo do candidato;
- execução, deployment ou projeto observado;
- atores sintéticos ou responsáveis, sem credenciais e dados pessoais;
- resultado, resíduos e decisão do gate;
- bloqueios que permanecem ativos.

Documentação de prontidão nunca substitui autorização explícita nem deve declarar produção aprovada
quando houver requisito pendente.
