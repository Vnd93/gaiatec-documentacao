---
id: gaiatec-status-atual-2026-09-13
titulo: Status atual do site e CMS GAIATEC
status: ativo
tipo: status-consolidado
area: governanca-documental
fase: execucao
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-06
ultima_revisao: 2026-09-13
fonte_canonica: gaiatec-documentacao
substitui:
  - gaiatec-status-atual-2026-09-06
relacionados:
  - comece-aqui.md
  - ambientes-e-execucao.md
  - mapa-repositorios.md
  - ../60-qualidade-auditoria/registro-consolidacao-2026-09-13.md
---

# Status atual do site e CMS GAIATEC

Fotografia verificada em **13 de setembro de 2026, 14:50 BRT**. Consulte o estado remoto novamente
antes de qualquer decisão operacional.

## Código e GitHub

- `Vnd93/gaiatec-cms`: branch padrão `main`, SHA
  `0d8386e51ad3185300479ee42642bdf19d935f82`.
- CI desse SHA: [run 34770336844](https://github.com/Vnd93/gaiatec-cms/actions/runs/34770336844),
  concluído com sucesso.
- bridge de frontend de staging:
  [run 34770627214](https://github.com/Vnd93/gaiatec-cms/actions/runs/34770627214), concluído com
  sucesso.
- deploy de staging:
  [run 34771260324](https://github.com/Vnd93/gaiatec-cms/actions/runs/34771260324), concluído com
  falha no ciclo editorial autenticado e mutante. O job finalizer concluiu com sucesso.
- watchdog do deploy:
  [run 34772770045](https://github.com/Vnd93/gaiatec-cms/actions/runs/34772770045), concluído com
  sucesso.
- Ao fim da observação não havia workflow em fila ou execução.

Conclusão correta: o código está publicado em `main` e passou no CI, mas o candidato **não foi
homologado** pelo deploy de staging. Finalizer e watchdog verdes provam encerramento seguro; não
transformam o gate funcional reprovado em aprovação.

## Supabase

Os projetos Staging (`glcqsosxwgmlhzgcsnzv`) e Production (`chfuhctnhqgyjowkvllv`) estão na mesma
organização, **GAIATEC Production**, com isolamento preservado. Staging permanece à frente de
produção. Consulte [ambientes e execução](ambientes-e-execucao.md).

## Documentação

- `Vnd93/gaiatec-documentacao` é a fonte canônica da documentação humana.
- O fluxo vigente é direto em `main`, conforme o `AGENTS.md`; a política antiga de branch + PR foi
  substituída.
- A branch antiga `docs/g12-production-release`, seus commits locais e o trabalho não commitado foram
  preservados no commit `060c05f` e na tag
  `archive/docs-g12-production-release-2026-09-13` antes da consolidação.
- Cópias soltas e a antiga pasta local `FONTE_DE_VERDADE` são material histórico, não instrução
  operacional vigente.

## Próxima ação de desenvolvimento

Retomar a partir do SHA atual, investigar a falha do passo “Run the complete authenticated mutating
editorial cycle first” no run 34771260324 e corrigir somente a causa comprovada. Revalidar CI e o
deploy de staging no novo SHA. Não promover produção e não repetir o mesmo run.
