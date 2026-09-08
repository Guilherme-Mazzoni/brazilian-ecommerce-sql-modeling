# Caderno de Exercícios SQL (Intermediário - Apenas Exercícios Pendentes v4) — Olist

Este caderno contém apenas os **22 exercícios pendentes** do seu projeto de modelagem e análise de dados do Olist. Para evitar qualquer tipo de confusão, as Questões de 1 a 7 que você já resolveu com sucesso foram removidas.

As questões mantêm os seus números originais para que você possa rastrear e documentar sua evolução perfeitamente!

---

## TEMA 1: Agrupamentos, Filtros e Funções de Data (GROUP BY & ORDER BY)

### **Questão 10: Sazonalidade de Vendas por Mês**
* **Objetivo:** Analisar a evolução mensal de vendas para identificar meses de pico comercial.
* **Sua Missão:** Extraia o ano e o mês (formato YYYY-MM ou ano e mês separados) do campo `order_purchase_timestamp` e conte o número de pedidos realizados. Filtre apenas os pedidos com status 'delivered' ou 'shipped'.
* *Tabelas utilizadas:* `olist_orders_dataset`

### **Questão 11: Horário de Pico das Compras**
* **Objetivo:** Descobrir qual o horário do dia em que os clientes mais realizam compras na plataforma.
* **Sua Missão:** Extraia apenas a hora (0 a 23) do campo `order_purchase_timestamp`, conte a quantidade de pedidos para cada hora e ordene do horário mais movimentado para o menos movimentado.
* *Tabelas utilizadas:* `olist_orders_dataset`

### **Questão 12: Vendedores com Mais de 100 Itens Vendidos (HAVING)**
* **Objetivo:** Identificar lojistas com alto volume de vendas para ações de fidelização.
* **Sua Missão:** Agrupe a tabela de itens por `seller_id` e exiba a quantidade de itens vendidos por cada um. Retorne apenas os vendedores que venderam **mais de 100 itens** no total.
* *Tabelas utilizadas:* `olist_order_items_dataset`

### **Questão 13: Ticket Médio por Vendedor**
* **Objetivo:** Descobrir quais lojistas possuem o maior valor médio por item vendido.
* **Sua Missão:** Agrupe a tabela de itens por `seller_id` e calcule a média do preço (`price`) dos produtos vendidos por cada um. Ordene pela maior média de preço.
* *Tabelas utilizadas:* `olist_order_items_dataset`

### **Questão 14: Concentração de Meios de Pagamento**
* **Objetivo:** Identificar quais métodos de pagamento dominam o volume transacional.
* **Sua Missão:** Liste os tipos de pagamento (`payment_type`) e a quantidade de transações feitas com cada tipo. Ordene de forma decrescente pela quantidade.
* *Tabelas utilizadas:* `olist_order_payments_dataset`

### **Questão 15: Categorias de Peso Elevado**
* **Objetivo:** Identificar categorias de produtos com grande peso médio, útil para negociações de frete pesado.
* **Sua Missão:** Agrupe os produtos por categoria (`product_category_name`) e calcule o peso médio em gramas (`product_weight_g`). Retorne apenas as categorias cujo peso médio seja **maior que 5.000g (5kg)**.
* *Tabelas utilizadas:* `olist_products_dataset`

---

## TEMA 2: Cruzamento de Dados (JOINs)

### **Questão 16: Receita Total de Frete por Estado do Vendedor**
* **Objetivo:** Analisar quais estados de lojistas movimentam mais recursos logísticos.
* **Sua Missão:** Junte a tabela de itens de pedidos com a tabela de vendedores para calcular a soma do valor do frete (`freight_value`) por estado do vendedor (`seller_state`). Ordene do maior frete total para o menor.
* *Tabelas utilizadas:* `olist_order_items_dataset`, `olist_sellers_dataset`

### **Questão 17: Avaliações Críticas por Categoria**
* **Objetivo:** Identificar quais categorias de produtos possuem o maior número de avaliações ruins (notas 1 e 2).
* **Sua Missão:** Cruze as tabelas de itens de pedidos, produtos e avaliações. Calcule o número de avaliações com nota (`review_score`) igual a 1 ou 2, agrupando pelo nome da categoria de produto (`product_category_name`). Ordene de forma decrescente.
* *Tabelas utilizadas:* `olist_order_items_dataset`, `olist_products_dataset`, `olist_order_reviews_dataset`

### **Questão 18: Tempo de Entrega Prometido vs. Realizado**
* **Objetivo:** Analisar se os clientes de determinados estados estão recebendo os pedidos antes ou depois da estimativa.
* **Sua Missão:** Junte as tabelas de pedidos e clientes. Calcule o tempo médio em dias entre a data de compra (`order_purchase_timestamp`) e a entrega real (`order_delivered_customer_date`), e compare com a média da estimativa de entrega (`order_estimated_delivery_date`), agrupando por estado do cliente (`customer_state`).
* *Tabelas utilizadas:* `olist_orders_dataset`, `olist_customers_dataset`

### **Questão 19: Métodos de Pagamento Preferidos por Estado**
* **Objetivo:** Identificar preferências regionais de pagamento no Brasil.
* **Sua Missão:** Cruze as tabelas de pedidos, pagamentos e clientes para contar a quantidade de transações por estado do cliente (`customer_state`) e tipo de pagamento (`payment_type`).
* *Tabelas utilizadas:* `olist_orders_dataset`, `olist_order_payments_dataset`, `olist_customers_dataset`

### **Questão 20: Impacto de Fotos no Catálogo**
* **Objetivo:** Descobrir se produtos com mais fotos no catálogo geram mais pedidos.
* **Sua Missão:** Cruze a tabela de itens vendidos com a de produtos para contar o número de vendas realizadas (linhas em itens) agrupado pela quantidade de fotos do produto (`product_photos_qty`). Filtre para remover valores nulos de fotos e ordene pela quantidade de fotos.
* *Tabelas utilizadas:* `olist_order_items_dataset`, `olist_products_dataset`

### **Questão 21: Vendas por Dia da Semana**
* **Objetivo:** Entender o comportamento de compra do consumidor ao longo da semana.
* **Sua Missão:** Cruze a tabela de pedidos com a de itens. Extraia o dia da semana do campo `order_purchase_timestamp`, calcule o total de itens vendidos e ordene para descobrir qual o dia da semana mais lucrativo.
* *Tabelas utilizadas:* `olist_orders_dataset`, `olist_order_items_dataset`

### **Questão 22: Receita de Produtos vs. Frete por Estado**
* **Objetivo:** Comparar o peso do custo do produto com o custo logístico de envio por estado destinatário.
* **Sua Missão:** Cruze as tabelas de itens de pedidos com a de clientes. Calcule a soma de `price` e a soma de `freight_value` agrupadas por estado do cliente (`customer_state`).
* *Tabelas utilizadas:* `olist_order_items_dataset`, `olist_customers_dataset`

---

## TEMA 3: Operações de Conjunto (UNION, EXCEPT & INTERSECT)

### **Questão 23: Estados Com Clientes Mas Sem Vendedores (EXCEPT)**
* **Objetivo:** Mapear estados consumidores que não possuem nenhuma base de lojistas cadastrados na plataforma.
* **Sua Missão:** Liste os estados onde residem clientes (`customer_state`), **excluindo** aqueles onde residem vendedores (`seller_state`).
* *Tabelas utilizadas:* `olist_customers_dataset`, `olist_sellers_dataset`

### **Questão 24: Cidades Gêmeas de Negócios (INTERSECT)**
* **Objetivo:** Identificar cidades que são polos simultâneos de lojistas e clientes, mas de forma restrita aos estados de São Paulo e Rio de Janeiro.
* **Sua Missão:** Filtre as cidades de clientes de SP e RJ e faça a interseção com as cidades de vendedores também restritas a SP e RJ.
* *Tabelas utilizadas:* `olist_customers_dataset`, `olist_sellers_dataset`

### **Questão 25: Unificação de Hubs de CEP (UNION)**
* **Objetivo:** Consolidar todos os prefixos de CEP com atividade no e-commerce para modelagem de malha logística.
* **Sua Missão:** Crie uma lista unificada de todos os prefixos de CEP (`customer_zip_code_prefix` unida com `seller_zip_code_prefix`) sob o nome de coluna `ceps_ativos`.
* *Tabelas utilizadas:* `olist_customers_dataset`, `olist_sellers_dataset`

---

## TEMA 4: Desafios Intermediários (Misturando Conceitos)

### **Questão 8: Categorias Premium (JOIN + GROUP BY + HAVING)**
* **Objetivo:** Identificar quais categorias de produtos possuem um valor médio de venda elevado.
* **Sua Missão:** Calcule o preço médio (`price`) dos itens por categoria de produto. Retorne apenas as categorias cujo preço médio seja **maior que R$ 150,00**. Ordene o resultado do preço mais alto para o mais baixo.
* *Tabelas utilizadas:* `olist_order_items_dataset`, `olist_products_dataset`

### **Questão 9: Tradução de Campeões de Venda (JOIN Duplo)**
* **Objetivo:** Analisar as categorias mais vendidas com seus nomes em inglês para apresentação executiva.
* **Sua Missão:** Descubra quais são as **5 categorias de produtos que mais venderam em quantidade de itens**. A sua consulta deve retornar o nome da categoria in inglês (`product_category_name_english`) e a quantidade de itens vendidos.
* *Tabelas utilizadas:* `olist_order_items_dataset`, `olist_products_dataset`, `product_category_name_translation`

### **Questão 26: Classificação de Preços de Produtos (CASE WHEN)**
* **Objetivo:** Segmentar os produtos do catálogo por faixa de preço para análise de mix de produtos.
* **Sua Missão:** Escreva uma query que classifique os itens vendidos em 3 categorias: "Barato" (preço menor que R$ 50), "Médio" (entre R$ 50 e R$ 200) e "Caro" (maior que R$ 200). Exiba a quantidade de itens vendidos em cada uma dessas faixas e ordene de forma decrescente pela quantidade.
* *Tabelas utilizadas:* `olist_order_items_dataset`

### **Questão 27: Desempenho Logístico de Postagem**
* **Objetivo:** Monitorar o cumprimento do prazo de postagem de mercadorias pelos vendedores.
* **Sua Missão:** Junte as tabelas de pedidos e itens. Classifique cada item vendido como "Postado no Prazo" ou "Postado com Atraso" comparando a data em que o pedido foi entregue à transportadora (`order_delivered_carrier_date`) com a data limite de postagem estabelecida (`shipping_limit_date`). Traga a contagem total de itens em cada classificação.
* *Tabelas utilizadas:* `olist_orders_dataset`, `olist_order_items_dataset`

### **Questão 28: Identificação de Clientes Recorrentes (HAVING)**
* **Objetivo:** Identificar clientes que realizaram mais de um pedido na plataforma (fidelidade).
* **Sua Missão:** Agrupe a tabela de clientes e pedidos para contar a quantidade de pedidos (`order_id`) por cliente único (`customer_unique_id`). Retorne apenas os clientes que possuem **mais de 2 pedidos** realizados.
* *Tabelas utilizadas:* `olist_orders_dataset`, `olist_customers_dataset`

### **Questão 29: Transações de Alto Valor e Alto Parcelamento**
* **Objetivo:** Analisar o risco e o comportamento de transações financeiras de alto ticket.
* **Sua Missão:** Filtre a tabela de pagamentos para listar os pedidos realizados com o tipo de pagamento "cartão de crédito" (`credit_card`) que foram parcelados em **mais de 10 vezes** e que tiveram um valor total de pagamento (`payment_value`) **maior que R$ 500,00**. Exiba o `order_id`, o número de parcelas e o valor pago, ordenando do maior valor para o menor.
* *Tabelas utilizadas:* `olist_order_payments_dataset`
