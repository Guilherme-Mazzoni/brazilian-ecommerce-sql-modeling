# Brazilian E-Commerce (Olist) — Modelagem Física & Analytics SQL

Este repositório contém um projeto prático completo de **Modelagem de Dados e Engenharia de Analytics** utilizando o banco de dados público de e-commerce brasileiro da **Olist** [21]. 

O grande diferencial deste projeto é que ele vai além de responder perguntas de negócio tradicionais com SQL [21]. Ele documenta um processo rigoroso de **Data Quality (Qualidade de Dados)** e **Validação Física de Modelagem** [1]. O objetivo é demonstrar na prática como premissas teóricas de modelagem se comportam e falham quando confrontadas com dados reais de produção [1].

---

## 📂 Estrutura do Repositório

O projeto é organizado de forma modular, separando a camada de scripts analíticos da documentação técnica (Obsidian-ready):

```text
olist-sql-portfolio/
├── sql/
│   ├── schema/
│   │   └── 01_import_schema.sql             # Criação de tabelas e carregamento de dados
│   └── queries/
│       ├── 01_consultas_basicas.sql         # Exercícios iniciais e operadores básicos (Tema 1)
│       ├── 02_agrupamentos_filtros.sql      # Agregações avançadas com GROUP BY e HAVING (Tema 1)
│       ├── 03_joins_relacionamentos.sql     # Cruzamento de dados entre entidades (Tema 2)
│       ├── 04_desafios_intermediarios.sql   # Resoluções de CASE WHEN e lógica condicional (Tema 4)
│       └── 05_subconsultas_avancadas.sql    # Lógicas de subconsultas (WHERE, FROM, SELECT, Correlacionadas)
├── docs/
│   ├── modelagem/
│   │   ├── mapeamento_pks.md                # Documentação técnica de validação das chaves primárias
│   │   └── mapeamento_fks.md                # Documentação técnica de integridade de chaves estrangeiras
│   ├── guia-postgres-obsidian.md            # Atalhos e otimizações de uso do PostgreSQL no Obsidian
│   └── caderno_exercicios.md                # Caderno oficial com as 29 questões originais do projeto
├── .gitignore                               # Filtros para ignorar arquivos locais volumosos (.csv, .db, logs)
└── README.md                                # Visão geral do projeto e progresso atualizado (100% concluído)
```

---

## 📊 Status do Progresso (Analytics SQL)

O projeto é guiado por um caderno de **29 desafios analíticos** de nível intermediário, cobrindo todo o ciclo de e-commerce da Olist [21].

### 📈 Taxa de Conclusão Geral: 29 de 29 questões resolvidas (100% concluído)

#### 1. Tema 1: Agrupamentos, Filtros e Funções de Data (`01_consultas_basicas.sql` / `02_agrupamentos_filtros.sql`)
*   **Status:** 8 de 8 resolvidas (**100% concluído**)
*   *Tópicos abordados:* Concentração geográfica de clientes [22], faturamentos parciais, ticket médio por lojista [25], sazonalidade mensal de vendas [29], horários de pico [29] e filtragem agregada com cláusula `HAVING` [19].

#### 2. Tema 2: Cruzamento de Dados e Joins (`03_joins_relacionamentos.sql`)
*   **Status:** 9 de 9 resolvidas (**100% concluído**)
*   *Tópicos abordados:* Cruzamentos de múltiplas tabelas transacionais [24, 25, 27, 28], cálculo de frete acumulado por estado do lojista [24, 32], correlação entre quantidade de fotos do catálogo e vendas [24, 30], desvio logístico de entrega (prazo estimado vs. real) [29] e faturamento consolidado de produtos contra logística por estado [22, 24].

#### 3. Tema 3: Operações de Conjunto (`03_joins_relacionamentos.sql`)
*   **Status:** 6 de 6 resolvidas (**100% concluído**)
*   *Tópicos abordados:* Álgebra relacional na prática. Identificação de estados consumidores puros com `EXCEPT` [23], mapeamento de polos simultâneos de comércio com `INTERSECT` [24] e fusão de bases de CEPs ativos para rotas de entrega via `UNION` [25].

#### 4. Tema 4: Desafios Intermediários e Lógica Condicional (`04_desafios_intermediarios.sql`)
*   **Status:** 6 de 6 resolvidas (**100% concluído**)
*   *Destaques resolvidos:*
    *   **Questão 26 (Classificação de Preços):** Segmentação de mix de produtos do catálogo em faixas ("Barato", "Médio" e "Caro") usando estrutura `CASE WHEN` com agrupamento pelo alias gerado.
    *   **Questão 27 (Desempenho Logístico):** Auditoria de prazos de expedição comparando a data real de postagem (`order_delivered_carrier_date`) com o limite estipulado (`shipping_limit_date`) [24, 28], utilizando `INNER JOIN` otimizado para expurgar registros órfãos ou nulos de forma eficiente.
    *   **Questão 28 (Clientes Recorrentes):** Mapeamento de fidelidade de carteira identificando clientes únicos (`customer_unique_id`) com mais de 2 pedidos realizados na plataforma através de agrupamento e filtragem com `HAVING`.
    *   **Questão 29 (Transações de Alto Risco):** Monitoramento e filtragem de faturamentos financiados por cartão de crédito (`credit_card`) com parcelamento superior a 10 vezes e valor total por transação acima de R$ 500,00.

---

## 🧠 Principais Aprendizados de Engenharia de Dados & Data Quality

### 1. Desmitificando a Unicidade de `olist_order_reviews_dataset` [4]
*   **Premissa Teórica:** A documentação tradicional sugere que a coluna `review_id` serve como Chave Primária Simples para o cadastro de avaliações [4].
*   **Descoberta Prática:** Testes de validação física revelaram que `review_id` possui duplicidades legítimas na base [4].
*   **A Causa de Negócio:** "Carrinhos Multi-Vendedor" [5]. Quando um cliente compra itens de múltiplos lojistas na mesma transação, a plataforma gera pedidos diferentes (`order_id`) para distribuir corretamente a logística [5]. O consumidor final, porém, avalia a experiência de compra por meio de um **único formulário** para aquela transação [5]. O sistema, de forma legítima, replica o mesmo `review_id` e o associa separadamente a cada `order_id` envolvido [5, 6].
*   **A Solução Física:** A única modelagem de chaves estruturalmente correta no banco físico é declarar uma **Chave Primária Composta** unindo `{review_id, order_id}` [6]. Isso evita o risco de sobreposição ou inflação de volumetria [2].

### 2. O Erro de Assumir CEP como Chave Primária [19]
*   **Descoberta Prática:** O prefixo de CEP na tabela `olist_geolocation_dataset` (`geolocation_zip_code_prefix`) possui múltiplas coordenadas geográficas de latitude e longitude associadas [19, 23].
*   **Implicação Técnica:** Tentar fazer um JOIN direto por essa coluna assumindo-a como PK gera um produto cartesiano silencioso [2].
*   **Solução:** Mapeamento estrito da tabela como uma **dimensão de apoio geográfico sem PK natural definida** [3]. A tabela exige pré-agregação ou limpeza de coordenadas duplicadas antes de qualquer operação de relacionamento [2].

### 3. Evitando a Explosão de Dados em Relações 1:N Paralelas
*   Unir tabelas transacionais paralelas de grãos distintos (como itens de pedidos e parcelamentos de pagamentos) de forma direta pode gerar uma duplicação cartesiana silenciosa [26, 27].
*   **Boa Prática Aplicada:** Agrupamentos cirúrgicos locais são executados de forma isolada antes do cruzamento de dados na query final.

---

## 🛠️ Tecnologias Utilizadas

*   **SQL (PostgreSQL)** — Engenharia analítica de dados, manipulação de conjuntos e validações físicas [2, 3].
*   **DBeaver** — Interface para desenvolvimento de scripts e visualização das tabelas de dados.
*   **Git & GitHub** — Controle de versão, documentação de branches e repositório de portfólio profissional.
*   **Obsidian** — Segunda mente técnica utilizada para documentar padrões lógicos de modelagem de dados.

---

## 🎯 Como Executar este Repositório

1.  **Obtenha os Dados:** Baixe o banco de dados público da Olist no Kaggle.
2.  **Crie a Estrutura Física:** Importe e execute o script `/sql/schema/01_import_schema.sql` para erguer as tabelas em seu ambiente PostgreSQL local.
3.  **Execute as Validações de Sanidade:** Rode as instruções documentadas em `/docs/modelagem/mapeamento_pks.md` para comprovar os estados físicos de unicidade do modelo.
4.  **Explore os Scripts Analíticos:** Acesse a pasta `/sql/queries/` para consultar as resoluções ordenadas de todas as questões do projeto.
