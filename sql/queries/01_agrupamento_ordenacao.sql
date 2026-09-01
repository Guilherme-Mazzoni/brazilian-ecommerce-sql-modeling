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