-- Questão 3: Faturamento por Categoria
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


-- Questão 4: Pedidos Cancelados por Estado
-- Objetivo: Listar o número de pedidos cancelados por estado do cliente.
-- Tabelas: olist_orders_dataset (o) e olist_customers_dataset (c)
SELECT c.customer_state, COUNT(*) AS pedidos_cancelados
FROM olist_orders_dataset AS o 
LEFT JOIN olist_customers_dataset AS c 
USING(customer_id)
WHERE o.order_status = 'canceled'
GROUP BY c.customer_state
ORDER BY pedidos_cancelados DESC; 