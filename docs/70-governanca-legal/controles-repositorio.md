---
id: gaiatec-controles-repositorios
titulo: Estado dos controles dos repositorios
status: ativo
tipo: registro-de-controles
area: governanca-repositorios
fase: ev2-fase-17
ambiente: github
responsavel: Vnd93
data_criacao: 2026-09-05
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - CONTROLES_REPOSITORIO.md
relacionados:
  - governanca.md
  - origem.md
  - ../00-indice/status-atual.md
  - ../00-indice/mapa-repositorios.md
---

# Estado dos controles dos repositórios

**Verificado em:** 6 de setembro de 2026  
**Administrador humano:** `Vnd93`

## Estado verificável

| Controle                                      | Documentação                 | CMS                                |
| --------------------------------------------- | ---------------------------- | ---------------------------------- |
| Repositório                                   | `Vnd93/gaiatec-documentacao` | `Vnd93/gaiatec-cms`                |
| Visibilidade informada pela API               | público                      | público                            |
| Branch padrão informada pela API              | `main`                       | `ev2/desenvolvimento-fases-1-a-12` |
| `main` informada como protegida               | sim                          | sim                                |
| Branch padrão legada informada como protegida | não aplicável                | não                                |
| Fonte de verdade                              | documentação humana          | código e controles executáveis     |
| Identidade administrativa humana              | `Vnd93`                      | `Vnd93`                            |

A consulta pública confirma o indicador de proteção, não seus detalhes. Required checks, aplicação a
administradores, bypasses, environments, secrets e permissões administrativas precisam ser
confirmados em sessão autenticada antes de qualquer alteração de branch padrão ou liberação.

## Validação documental

O workflow `Documentation quality`:

- executa em pull requests e em push para `main`;
- usa `contents: read`;
- fixa `actions/checkout` e `actions/setup-node` por SHA completo;
- executa `npm ci` e `npm run check`;
- verifica Prettier, links locais e padrões conhecidos de credenciais sem imprimir o conteúdo.

`.secrets`, `.codex-worktrees` e `.git` são excluídos da caminhada local de validação. Segredos de
runtime são proibidos neste repositório e não foram lidos durante a reorganização.

## Proteção, plano e revisão

Não se infere GitHub Pro pela proteção observada. Proteção de branches e rulesets estão disponíveis
para repositórios públicos no GitHub Free; o plano efetivamente contratado só pode ser confirmado
nas configurações da conta.

`Vnd93` é o único perfil humano administrativo conhecido. Portanto:

- CODEOWNERS e checks podem exigir revisão de caminho e qualidade, mas não criam uma segunda pessoa;
- IA não conta como revisor GitHub independente;
- `required_approving_review_count` deve refletir a disponibilidade real de revisores autorizados;
- a ausência de segunda identidade humana é risco aceito/documentado, não requisito fictício
  satisfeito.

## Pendências antes de mudar a branch padrão do CMS

1. revisar e integrar o PR nº 35 da fase 17;
2. confirmar proteção/rulesets e checks de `main` em sessão autenticada;
3. confirmar environments, permissões e secrets dos workflows produtivos, sem revelar valores;
4. revisar referências externas à branch legada;
5. confirmar que workflows agendados necessários residem e passam em `main`;
6. alterar a configuração remota somente após aprovação humana e registrar a operação.

Até lá, trabalho novo parte de `main` ou da branch explícita de fase correspondente; a branch padrão
legada não deve ser tratada como linha vigente apenas por ser o valor configurado no GitHub.
