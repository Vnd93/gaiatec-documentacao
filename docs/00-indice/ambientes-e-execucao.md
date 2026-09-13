---
id: gaiatec-ambientes-e-execucao
titulo: Ambientes e execução do CMS
status: ativo
tipo: mapa-de-ambientes
area: operacao-entrega
fase: transversal
ambiente: todos
responsavel: Vnd93
data_criacao: 2026-09-13
ultima_revisao: 2026-09-13
fonte_canonica: gaiatec-documentacao
substitui: []
relacionados:
  - status-atual.md
  - mapa-repositorios.md
  - ../50-operacao-entrega/fluxo-desenvolvimento-e-release.md
---

# Ambientes e execução do CMS

## Supabase

Os dois projetos estão na organização **GAIATEC Production**, mas continuam isolados. Estar na mesma
organização simplifica administração e cobrança; não integra schemas, migrations, Functions,
Storage, Auth, secrets ou dados entre eles.

| Ambiente            | Projeto                | Project ref            | Função                                                       |
| ------------------- | ---------------------- | ---------------------- | ------------------------------------------------------------ |
| Staging/homologação | GAIATEC CMS Staging    | `glcqsosxwgmlhzgcsnzv` | receber primeiro migrations, Functions e validação sintética |
| Produção            | GAIATEC CMS Production | `chfuhctnhqgyjowkvllv` | receber somente candidato aprovado e promoção controlada     |

Regras obrigatórias:

- nunca copiar dados reais de produção para staging;
- nunca reutilizar secrets, service keys ou usuários entre ambientes;
- não aplicar em produção manualmente o que existe apenas em staging;
- não interpretar contagens diferentes como erro automático: staging deve avançar primeiro;
- vincular toda promoção ao SHA e ao mesmo artefato selado aprovado no canário;
- conferir `VITE_CMS_ENVIRONMENT=production` e o project ref de produção antes de promover.

## Estado observado em 13 de setembro de 2026

- staging: 97 migrations e 34 Edge Functions observadas;
- produção: 56 migrations e 32 Edge Functions observadas;
- os endpoints e project refs não mudaram durante a transferência organizacional;
- a diferença confirma que staging contém evolução ainda não promovida, não que os projetos devam
  ser “sincronizados” por cópia direta.

Variáveis locais não são fonte de verdade. Um arquivo `.env.local` pode misturar valores ou ficar
desatualizado; valide o alvo explicitamente antes de qualquer operação.

## GitHub e deploy

O repositório executável é `Vnd93/gaiatec-cms`, com branch padrão `main`. Deploys são executados
pelos workflows controlados do repositório; comandos manuais locais não substituem gates, evidência
ou segregação de ambientes.
