-- Questão 1: Concentração de Clientes
-- Objetivo: Identificar a quantidade de clientes cadastrados por estado (customer_state).
-- Tabelas utilizadas: olist_customers_dataset
-- Ordene do estado com mais clientes para o com menos.

SELECT customer_state, COUNT(*) AS qtd_registros
FROM olist_customers_dataset 
GROUP BY customer_state 
ORDER BY qtd_registros DESC; 

-- Questão 2: Parcelamento de Compras
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