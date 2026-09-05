# Estado dos controles do repositório

**Verificado em:** 5 de setembro de 2026  
**Repositório:** `Vnd93/gaiatec-documentacao`  
**Visibilidade:** privado  
**Proprietário:** `Vnd93`

## Controles efetivos

| Controle                           | Estado                                                            |
| ---------------------------------- | ----------------------------------------------------------------- |
| Fonte oficial da documentação      | configurada em `main` pelo PR #1                                  |
| Validação automática               | `Documentation quality / quality` aprovada no PR #1               |
| Permissão do workflow              | `contents: read`; padrão do repositório também somente leitura    |
| Ações externas                     | somente ações criadas pelo GitHub; Marketplace genérico bloqueado |
| Criação/aprovação de PR por Action | desabilitada                                                      |
| Uso por outros repositórios        | desabilitado                                                      |
| Segredos de runtime                | proibidos pela governança e ausentes deste fluxo                  |
| Referências de Actions             | fixadas por SHA completo                                          |

O check executa formatação, valida links locais e procura padrões de credenciais sem imprimir o
conteúdo encontrado.

## Separação do código executável

O código, os workflows e o histórico técnico foram migrados para o repositório privado
[`Vnd93/gaiatec-cms`](https://github.com/Vnd93/gaiatec-cms). Este repositório continua sendo a fonte
oficial exclusivamente documental. A evidência de origem, integridade, controles de Actions e
bloqueios remanescentes está em
[Migração do repositório executável](docs/ev2/fase-12/MIGRACAO_REPOSITORIO_EXECUTAVEL_2026-09-04.md).

## Exceção de proteção da `main`

A interface administrativa do GitHub informa que rulesets e proteções clássicas **não são
aplicados** a este repositório privado enquanto ele estiver em uma conta pessoal Free. Criar uma
regra nessa condição produziria aparência de proteção sem enforcement real; por isso, nenhuma regra
inócua foi registrada.

Até a remoção da exceção:

- toda mudança deve usar branch e pull request;
- o check `Documentation quality / quality` deve estar verde antes do merge;
- force-push, exclusão da `main` e merge com check falhando são proibidos por processo;
- documentos de gate ou produção exigem revisão humana diferente do autor.

## Condição para enforcement técnico

Habilitar GitHub Pro na conta pessoal ou mover o repositório privado para uma organização GitHub
Team/Enterprise e então ativar:

1. pull request obrigatório;
2. PR obrigatório de `@Vnd93`, CODEOWNERS exclusivo e zero approvals, compatível com o mantenedor
   humano único;
3. check `Documentation quality / quality` obrigatório e atualizado com a base;
4. bloqueio de force-push e exclusão;
5. aplicação aos administradores, sem bypass para documentos de gate.

Essa limitação documental não deve ser confundida com o repositório de código: ambientes, branch
protection e secrets usados por deployment precisam existir e ser aplicados no repositório que
contém e executa os workflows da aplicação.
