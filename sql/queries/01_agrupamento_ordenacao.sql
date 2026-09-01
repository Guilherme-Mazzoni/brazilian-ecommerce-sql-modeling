-- =====================================================================
-- Questão 1: Concentração de Clientes
-- =====================================================================
-- Objetivo: Identificar a quantidade de clientes cadastrados por estado (customer_state).
-- Tabelas utilizadas: olist_customers_dataset
-- Ordene do estado com mais clientes para o com menos.

SELECT customer_state, COUNT(*) AS qtd_registros
FROM olist_customers_dataset 
GROUP BY customer_state 
ORDER BY qtd_registros DESC; 

-- =====================================================================
-- Questão 2: Parcelamento de Compras
-- =====================================================================
-- Objetivo: Descobrir a média de parcelas (payment_installments) e o número máximo escolhido.
-- Tabelas utilizadas: olist_order_payments_dataset

-- Abordagem A: Média Geral (Considerando todos os métodos de pagamento)
SELECT ROUND(AVG(payment_installments),2) AS media_parcelas,
	MAX(payment_installments) AS maxima_parcelas
FROM olist_order_payments_dataset; 


-- Abordagem B (Recomendada para Negócio): Comportamento de Parcelamento Real (Apenas Cartão de Crédito)
-- Nota: Filtramos por 'credit_card' porque boletos e vouchers distorcem a média por serem sempre em 1x.
SELECT ROUND(AVG(payment_installments),2) AS media_parcelas,
	MAX(payment_installments) AS maxima_parcelas
FROM olist_order_payments_dataset
WHERE payment_type = 'credit_card'; 

-- =====================================================================
-- Questão 10: Sazonalidade de Vendas por Mês
-- =====================================================================
-- Objetivo: Analisar a evolução mensal de vendas para identificar meses de pico comercial.
-- Tabelas: olist_orders_dataset (o)
-- Filtro: Apenas pedidos com status 'delivered' (entregue) ou 'shipped' (enviado).

SELECT TO_CHAR(order_purchase_timestamp::timestamp, 'YYYY-MM') AS ano_mes,
	COUNT(o.order_id ) AS pedidos
FROM olist_orders_dataset AS o 
WHERE o.order_status IN ('delivered','shipped')
GROUP BY TO_CHAR(order_purchase_timestamp::timestamp, 'YYYY-MM')
ORDER BY pedidos DESC;

-- =====================================================================
-- Questão 11: Horário de Pico das Compras
-- =====================================================================
-- Objetivo: Descobrir qual o horário do dia em que os clientes mais realizam compras na plataforma.
-- Tabelas: olist_orders_dataset (o)

SELECT EXTRACT(HOUR FROM order_purchase_timestamp::timestamp) AS hora_compra, COUNT(order_id) AS pedidos
FROM olist_orders_dataset AS o 
GROUP BY EXTRACT(HOUR FROM order_purchase_timestamp::timestamp)
ORDER BY pedidos DESC; 

-- =====================================================================
-- Questão 12: Vendedores com Mais de 100 Itens Vendidos
-- =====================================================================
-- Objetivo: Identificar lojistas de alta performance com alto volume de vendas para ações de fidelização.
-- Tabelas: olist_order_items_dataset (i)

SELECT seller_id, COUNT(*) AS qtd_vendas
FROM olist_order_items_dataset
GROUP BY seller_id 
HAVING COUNT(order_id) > 100
ORDER BY qtd_vendas DESC; 

-- =====================================================================
-- Questão 13: Ticket Médio por Vendedor
-- =====================================================================
-- Objetivo: Descobrir quais lojistas possuem o maior valor médio por item vendido.
-- Tabelas: olist_order_items_dataset (i)

SELECT seller_id, ROUND(AVG(price)::numeric,2) AS media_preco
FROM olist_order_items_dataset 
GROUP BY seller_id 
ORDER BY media_preco DESC 
LIMIT 10; 


-- =====================================================================
-- Questão 14: Concentração de Meios de Pagamento
-- =====================================================================
-- Objetivo: Identificar quais métodos de pagamento dominam as transações.
-- Tabelas: olist_order_payments_dataset (p)

SELECT payment_type, COUNT(order_id ) AS transacoes
FROM olist_order_payments_dataset
GROUP BY payment_type 
ORDER BY transacoes DESC; 


-- =====================================================================
-- Questão 15: Categorias de Peso Elevado (HAVING)
-- =====================================================================
-- Objetivo: Identificar categorias de produtos pesados, útil para estratégias de frete de carga.
-- Tabelas: olist_products_dataset (p)
-- Missão: Calcule o peso médio em gramas dos produtos por categoria (product_category_name). Retorne apenas categorias com peso médio maior que 5.000g (5kg) e ordene do maior para o menor.

SELECT COALESCE(product_category_name, 'Não Informado'), ROUND(AVG(product_weight_g)::NUMERIC,2) AS media_peso 
FROM olist_products_dataset
GROUP BY product_category_name 
HAVING ROUND(AVG(product_weight_g)::NUMERIC,2) > 5000
ORDER BY media_peso DESC;