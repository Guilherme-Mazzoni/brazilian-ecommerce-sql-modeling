-- =====================================================================
-- Questão 3: Faturamento por Categoria
-- =====================================================================
-- Objetivo: Calcular a receita total (soma de price) por categoria de produto.
-- Tabelas: olist_order_items_dataset (i) e olist_products_dataset (p)
SELECT 
    COALESCE(p.product_category_name, 'Não Informado') AS categoria_produto, 
    ROUND(SUM(i.price)::numeric, 2) AS faturamento_total
FROM olist_order_items_dataset AS i
LEFT JOIN olist_products_dataset AS p 
    ON i.product_id = p.product_id 
GROUP BY p.product_category_name 
ORDER BY faturamento_total DESC; 

-- =====================================================================
-- Questão 4: Pedidos Cancelados por Estado
-- =====================================================================
-- Objetivo: Listar o número de pedidos cancelados por estado do cliente.
-- Tabelas: olist_orders_dataset (o) e olist_customers_dataset (c)
SELECT c.customer_state, COUNT(*) AS pedidos_cancelados
FROM olist_orders_dataset AS o 
LEFT JOIN olist_customers_dataset AS c 
	USING(customer_id)
WHERE o.order_status = 'canceled'
GROUP BY c.customer_state
ORDER BY pedidos_cancelados DESC;

-- =====================================================================
-- Questão 16: Receita Total de Frete por Estado do Vendedor
-- =====================================================================
-- Objetivo: Analisar quais estados de lojistas movimentam mais recursos logísticos.
-- Tabelas: olist_order_items_dataset (i) e olist_sellers_dataset (s)

SELECT 
    s.seller_state, 
    ROUND(COALESCE(SUM(i.freight_value), 0)::numeric, 2) AS soma_frete 
FROM olist_sellers_dataset AS s  
LEFT JOIN olist_order_items_dataset AS i 
    USING(seller_id)
GROUP BY s.seller_state
ORDER BY soma_frete DESC; 

-- =====================================================================
-- Questão 17: Avaliações Críticas por Categoria (JOIN Triplo)
-- =====================================================================
-- Objetivo: Identificar quais categorias de produtos têm mais notas baixas (detratores).
-- Tabelas: olist_order_items_dataset (i), olist_products_dataset (p) e olist_order_reviews_dataset (r)

SELECT 
    COALESCE(p.product_category_name, 'Não Informado') AS categoria_produto, 
    COUNT(r.review_score) AS nota_1_2
FROM olist_order_reviews_dataset AS r 
LEFT JOIN olist_order_items_dataset AS i 
    USING(order_id)
LEFT JOIN olist_products_dataset AS p 
    ON i.product_id = p.product_id 
WHERE r.review_score IN (1, 2)
GROUP BY COALESCE(p.product_category_name, 'Não Informado') 
ORDER BY nota_1_2 DESC; 

-- =====================================================================
-- Questão 18: Tempo de Entrega Prometido vs. Realizado
-- =====================================================================
-- Objetivo: Analisar se os clientes de determinados estados estão recebendo os pedidos antes ou depois da estimativa.
-- Tabelas: olist_orders_dataset (o) e olist_customers_dataset (c)

SELECT 
    c.customer_state, 
    ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date::timestamp - o.order_purchase_timestamp::timestamp)) / 86400)::numeric, 2) AS media_dias_entrega_real,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.order_estimated_delivery_date::timestamp - o.order_purchase_timestamp::timestamp)) / 86400)::numeric, 2) AS media_dias_entrega_estimada
FROM olist_orders_dataset AS o
LEFT JOIN olist_customers_dataset AS c
    USING(customer_id)
WHERE o.order_delivered_customer_date IS NOT NULL 
  AND o.order_delivered_customer_date <> ''
GROUP BY c.customer_state
ORDER BY media_dias_entrega_real DESC;

-- =====================================================================
-- Questão 19: Métodos de Pagamento Preferidos por Estado
-- =====================================================================
-- Objetivo: Identificar preferências regionais de pagamento no Brasil.
-- Tabelas: olist_orders_dataset (o), olist_order_payments_dataset (p) e olist_customers_dataset (c)

SELECT 
    c.customer_state, 
    COALESCE(p.payment_type, 'Não Informado') AS metodo_pagamento, 
    COUNT(*) AS qtd_transacoes 
FROM olist_orders_dataset AS o 
LEFT JOIN olist_order_payments_dataset AS p 
    USING(order_id) 
LEFT JOIN olist_customers_dataset AS c 
    ON o.customer_id = c.customer_id 
GROUP BY 
    c.customer_state, 
    COALESCE(p.payment_type, 'Não Informado') 
ORDER BY 
    c.customer_state ASC, 
    qtd_transacoes DESC; 

-- =====================================================================
-- Questão 20: Impacto de Fotos no Catálogo
-- =====================================================================
-- Objetivo: Descobrir se produtos com mais fotos no catálogo geram mais vendas.
-- Tabelas: olist_order_items_dataset (i) e olist_products_dataset (p)

SELECT 
    p.product_photos_qty AS qtd_fotos, 
    COUNT(*) AS total_vendas  
FROM olist_order_items_dataset AS i 
LEFT JOIN olist_products_dataset AS p 
    USING(product_id)
WHERE p.product_photos_qty IS NOT NULL
GROUP BY p.product_photos_qty 
ORDER BY p.product_photos_qty ASC; 

-- =====================================================================
-- Questão 21: Vendas por Dia da Semana
-- =====================================================================
-- Objetivo: Entender o comportamento de compra ao longo da semana.
-- Tabelas: olist_orders_dataset (o) e olist_order_items_dataset (i)

SELECT 
    c.customer_state, 
    ROUND(SUM(i.price)::numeric, 2) AS receita_produtos, 
    ROUND(SUM(i.freight_value)::numeric, 2) AS custo_frete
FROM olist_order_items_dataset AS i 
LEFT JOIN olist_orders_dataset AS o
    USING(order_id)
LEFT JOIN olist_customers_dataset AS c 
    USING(customer_id)
GROUP BY c.customer_state
ORDER BY receita_produtos DESC; 

-- =====================================================================
-- Questão 22: Receita de Produtos vs. Frete por Estado
-- =====================================================================
-- Objetivo: Comparar a receita de produtos com o custo de frete por estado comprador.
-- Tabelas: olist_order_items_dataset (i) e olist_customers_dataset (c)

SELECT 
    c.customer_state, 
    ROUND(SUM(i.price)::numeric, 2) AS receita_produtos, 
    ROUND(SUM(i.freight_value)::numeric, 2) AS custo_frete
FROM olist_order_items_dataset AS i 
LEFT JOIN olist_orders_dataset AS o
    USING(order_id)
LEFT JOIN olist_customers_dataset AS c 
    USING(customer_id)
GROUP BY c.customer_state
ORDER BY receita_produtos DESC; 