---
id: gaiatec-governanca-repositorio-documental
titulo: Governanca do repositorio documental
status: ativo
tipo: politica-de-governanca
area: governanca-legal
fase: transversal
ambiente: github
responsavel: Vnd93
data_criacao: 2026-09-04
ultima_revisao: 2026-09-06
fonte_canonica: gaiatec-documentacao
substitui:
  - GOVERNANCA.md
relacionados:
  - controles-repositorio.md
  - origem.md
  - ../00-indice/status-atual.md
  - ../00-indice/politica-ciclo-de-vida-documental.md
---

# Governança do repositório documental

## Finalidade e limites

`Vnd93/gaiatec-documentacao` é a única fonte canônica dos documentos técnicos, funcionais,
operacionais, de produto, governança e evolução do projeto GAIATEC Sistemas.

Este repositório não deve conter:

- código executável da aplicação ou artefatos de build;
- tokens, chaves, senhas, arquivos `.env` ou credenciais;
- workflows com autoridade para alterar staging ou produção;
- cópias não sanitizadas de logs ou dados pessoais;
- espelhos manuais de arquivos cujo papel real seja executável.

Código, infraestrutura, testes, deployment, fixtures e controles consumidos por automação pertencem
ao [`Vnd93/gaiatec-cms`](https://github.com/Vnd93/gaiatec-cms). A fronteira está no
[mapa de repositórios](../00-indice/mapa-repositorios.md).

## Autoridade e identidades

- `Vnd93` é o único perfil administrativo humano autorizado nesta fotografia.
- IA pode apoiar análise, edição, teste e revisão técnica, mas não representa outra identidade
  GitHub, outro administrador ou aprovação humana independente.
- Não se deve fabricar segregação de funções: quando uma segunda pessoa autorizada não estiver
  disponível, a ausência de revisão humana independente é registrada como risco explícito.
- Gates e autorizações continuam exigindo evidência objetiva e decisão humana; checks automáticos
  não substituem essa decisão.

## Fluxo de alteração

1. Criar branch com prefixo `docs/`, `governance/` ou `evidence/` a partir da base remota correta.
2. Atualizar [origem.md](origem.md) quando conteúdo vier de outro repositório ou artefato.
3. Aplicar metadados, nomenclatura e estados da
   [política de ciclo de vida](../00-indice/politica-ciclo-de-vida-documental.md).
4. Executar formatação, links, varredura de segredos/dados pessoais e validações pertinentes.
5. Abrir PR para `main`, descrevendo objetivo, origem, impacto, risco e rollback.
6. Obter revisão humana independente quando houver outra pessoa formalmente autorizada. Na ausência,
   registrar a limitação e exigir todos os checks e evidências aplicáveis.
7. Não fazer merge antes da decisão humana responsável.

Force-push, exclusão de `main`, commits diretos de rotina e bypass deliberado de checks são
proibidos por política.

## Proteção e plano GitHub

Em 6 de setembro de 2026, a API pública informa que o repositório é público, usa `main` como branch
padrão e marca `main` como protegida. Os detalhes administrativos da regra devem ser confirmados em
sessão autenticada antes de mudanças de governança.

A existência de proteção não comprova GitHub Pro: o GitHub oferece proteção de branches e rulesets
em repositórios públicos também no GitHub Free. O plano de assinatura deve ser consultado na conta,
e não inferido a partir de uma regra visível.

## Evidências e rastreabilidade

Cada evidência deve identificar, quando aplicável:

- ambiente e data/hora;
- SHA completo do candidato;
- execução, deployment ou projeto observado;
- atores sintéticos ou responsáveis, sem credenciais e dados pessoais desnecessários;
- resultado, resíduos, decisão e bloqueios remanescentes.

Evidências imutáveis mantêm seus bytes. Correções são documentos aditivos e devem ligar a origem ao
sucessor. Documentação de prontidão não substitui autorização explícita nem pode declarar produção
aprovada enquanto houver requisito pendente.
