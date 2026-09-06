# ADR-025 — Drawer e ficha completa unificada

**Status:** aceita<br>
**Data:** 6 de setembro de 2026

## Contexto

Abrir diretamente editores densos reduz a velocidade de triagem e produz padrões diferentes por
entidade.

## Decisão

Toda lista abre um drawer de 400 px com tipo, nome, endereço mono, status, campos e resumo. A ação
primária abre o editor ou ficha completa. A ficha unifica Dados principais, imagem 4:3, descrição,
histórico e ações Voltar/Salvar. Foco inicial, Escape e retorno de foco são obrigatórios.

## Consequências

Triagem rápida e previsível; listas devem manter estado do item selecionado e testes de foco.
