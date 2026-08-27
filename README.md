# Brazilian E-Commerce (Olist) — Modelagem Física & Analytics SQL

Este repositório contém um projeto prático completo de **Modelagem de Dados e Engenharia de Analytics** utilizando o banco de dados público de e-commerce brasileiro da **Olist**. 

O grande diferencial deste projeto é que ele não se limita a apenas responder perguntas de negócio com SQL. Ele documenta todo o processo de **Data Quality (Qualidade de Dados)** e **Validação Física**, demonstrando como premissas teóricas de modelagem se comportam (e muitas vezes falham) quando confrontadas com os dados reais de produção.

---

## 📂 Estrutura do Repositório

O projeto está organizado da seguinte forma para facilitar a leitura técnica e a execução das consultas:

```text
meu-projeto-olist-sql/
│
├── README.md                     # Visão geral do projeto e principais aprendizados
│
├── docs/                         # Documentação detalhada de modelagem (Obsidian-ready)
│   ├── 01_mapeamento_pks.md      # Validação física e correção de Chaves Primárias (PKs)
│   └── 02_mapeamento_fks.md      # Validação de Chaves Estrangeiras (FKs) e Integridade Referencial
│
└── sql/                          # Scripts SQL prontos para execução
    ├── validations/              # Queries de testes de integridade e qualidade
    │   ├── valida_pks.sql        # Testes de unicidade e não-nulidade das PKs
    │   └── busca_orfaos.sql      # Varredura em busca de chaves estrangeiras órfãs
    │
    └── queries_analiticas/       # Resolução de desafios de negócio (Agrupamentos e Conjuntos)
        ├── 01_group_by_joins.sql # Queries de agregação, filtros e junções complexas
        └── 02_operacoes_conjunto.sql # Queries avançadas com UNION, EXCEPT e INTERSECT
```

---

## 🧠 Principais Descobertas de Arquitetura

### 1. O Caso Crítico de `olist_order_reviews_dataset` 💬
*   **Premissa Teórica:** A coluna `review_id` deveria atuar como uma Chave Primária Simples da tabela de avaliações.
*   **Descoberta Prática:** A validação física revelou duplicidades legítimas do mesmo `review_id` associado a diferentes pedidos (`order_id`).
*   **Causa Raiz (Negócio):** Carrinhos de compras multi-vendedor. Quando um cliente compra de lojistas diferentes em uma mesma sessão, o sistema gera múltiplos `order_id` por questões logísticas, mas apenas uma pesquisa de satisfação (`review_id`). O sistema então replica a avaliação para todos os pedidos daquela transação.
*   **Solução:** Implementação de uma **Chave Primária Composta** unindo `{review_id, order_id}` para assegurar a integridade do banco de dados e evitar que análises de satisfação dupliquem dados financeiros.

### 2. A Tabela de Geolocalização (`olist_geolocation_dataset`) 📍
*   **Descoberta Prática:** O prefixo de CEP (`geolocation_zip_code_prefix`) possui múltiplas coordenadas espaciais para o mesmo código. 
*   **Solução:** A tabela foi mapeada estritamente como uma **dimensão auxiliar de apoio geográfico**, desprovida de PK física, evitando quebras catastróficas de constraint em pipelines de carga.

### 3. A Prevenção contra "Explosão de Dados" (Produto Cartesiano) ⚠️
*   Unir tabelas transacionais paralelas de grãos diferentes, como itens de pedidos (1:N) e parcelamentos de pagamentos (1:N), gera uma duplicação cartesiana silenciosa que infla os números de faturamento da empresa.
*   **Boa Prática Aplicada:** Pré-agregação de dados utilizando agrupamentos cirúrgicos antes de efetuar junções lógicas finais.

---

## 🛠️ Tecnologias Utilizadas
*   **SQL (DQL / DDL)** — Para consultas analíticas de conjunto, junções e validações físicas.
*   **Modelagem Dimensional** — Estruturação de relacionamentos entre fatos e dimensões.
*   **Git & GitHub** — Para versionamento de código e portfólio.
*   **Obsidian** — Para documentação e registro de conceitos de engenharia de dados.

---

## 🎯 Como Executar este Projeto

1.  **Obtenha os Dados:** Baixe o conjunto de dados público da Olist (disponível no Kaggle).
2.  **Crie o Banco de Dados:** Execute as instruções de criação de tabelas e carregue os dados em seu SGDB de preferência (PostgreSQL, SQLite, MySQL, etc.).
3.  **Valide as Chaves:** Rode os scripts de `/sql/validations/` para comprovar os estados físicos das PKs e FKs descritos na documentação.
4.  **Explore as Queries Analíticas:** Rode as consultas em `/sql/queries_analiticas/` para responder as principais perguntas estratégicas de negócio sobre vendas, frete, comportamento de pagamento e distribuição geográfica.

---
*Este projeto foi desenvolvido com foco em demonstrar maturidade técnica de qualidade de dados (Data Quality) e empatia com as regras de negócio por trás das tabelas.*
