# Evidências de infraestrutura produtiva — 4 de setembro de 2026

## Escopo autorizado e preservado

Foi autorizada a pausa do projeto Supabase `DZ System Project`
(`pbmyttjnqijdbscrjayk`) para liberar uma das duas vagas Free, com a restrição explícita de não
pausar nem alterar o `GAIATEC CMS Staging`. Também estava autorizada a criação isolada do projeto
`GAIATEC CMS Production`, sem deploy, migrations, funções, dados reais, domínio real, ativação de
flags ou promoção do staging estável.

## Resultado observado

| Projeto                | Ref.                   | Organização            | Região      | Estado final     |
| ---------------------- | ---------------------- | ---------------------- | ----------- | ---------------- |
| GAIATEC CMS Staging    | `glcqsosxwgmlhzgcsnzv` | `zfznxacuguxlydpatcpo` | `us-east-2` | `ACTIVE_HEALTHY` |
| DZ System Project      | `pbmyttjnqijdbscrjayk` | `zfznxacuguxlydpatcpo` | `us-east-2` | `INACTIVE`       |
| GAIATEC CMS Production | `chfuhctnhqgyjowkvllv` | `doveeoohvxkygssakxnk` | `us-east-2` | `ACTIVE_HEALTHY` |

O projeto `DZ System Project` foi **pausado, não excluído**. A interface do Supabase informa que um
projeto Free pausado pode ser retomado durante a janela de restauração da plataforma. O staging
permaneceu saudável durante toda a operação.

O projeto produtivo foi criado em `2026-09-04T15:10:21.391835Z` com:

- plano Free e compute `nano`;
- Data API habilitada;
- exposição automática de novas tabelas desabilitada;
- RLS automático habilitado para novas tabelas;
- senha de banco aleatória de 52 caracteres gerada por CSPRNG e inserida sem impressão ou gravação
  em arquivo;
- nenhuma migration, função, integração GitHub ou dado aplicado.

## Exceção operacional do plano Free

A escolha do plano Free preserva o isolamento, mas **não satisfaz o requisito de produção** do G12.
Segundo a documentação oficial, o plano não inclui backups automáticos nem PITR e projetos com pouca
atividade podem ser pausados após sete dias. Antes de dados reais ou go-live, é obrigatório:

1. definir exportação lógica regular, armazenamento externo protegido e retenção;
2. executar e registrar um restore drill compatível com o RPO/RTO aprovado; e
3. aceitar formalmente o risco residual ou migrar a organização para um plano com garantias
   produtivas.

Referências: [preços e limites do Supabase](https://supabase.com/pricing),
[pausa de projetos Free](https://supabase.com/docs/guides/platform/free-project-pausing) e
[backups de banco](https://supabase.com/docs/guides/platform/backups).

## Repositório executável e bloqueio GitHub confirmado

O repositório privado executável [`Vnd93/gaiatec-cms`](https://github.com/Vnd93/gaiatec-cms) foi
criado sob administração de `Vnd93`. A linha histórica, as branches relevantes e a tag de arquivo
foram migradas e validadas por SHA. O GitHub Actions foi bloqueado durante a transferência e depois
reativado com dependências fixadas por SHA completo e allowlist mínima.

Apesar da administração efetiva, a interface do GitHub informa que rulesets e proteções clássicas
não são aplicados ao repositório privado enquanto ele permanecer em conta pessoal Free. A
configuração segura dos secrets não foi contornada:

- nenhuma regra sem enforcement foi criada;
- o ambiente `production` não foi criado;
- nenhum secret ou variable de produção foi cadastrado;
- o workflow continua exigindo ambiente e proteção de `main` válidos e falha fechado na ausência;
- a senha de banco não foi armazenada em secret de repositório nem em local não autorizado.

A remoção do bloqueio exige organização GitHub Team/Enterprise e revisor técnico independente. Só
depois da proteção efetiva as credenciais podem ser inseridas diretamente no ambiente protegido.
Evidência detalhada: [migração do repositório executável](MIGRACAO_REPOSITORIO_EXECUTAVEL_2026-09-04.md).

## Decisão

Infraestrutura Supabase isolada: **provisionada**. Backend produtivo aprovado para uso real:
**não**. Gate G12 e qualquer mudança em produção permanecem bloqueados.
