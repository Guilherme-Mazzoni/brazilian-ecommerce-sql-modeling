-- Questão 5: Cidades de Mão Dupla 
-- Objetivo: Encontrar cidades com pelo menos um cliente E pelo menos um vendedor.
-- Tabelas: olist_customers_dataset e olist_sellers_dataset

SELECT c.customer_city 
FROM olist_customers_dataset AS c 

INTERSECT 

SELECT s.seller_city 
FROM olist_sellers_dataset AS s;

-- Questão 6: Estados Sem Compradores 
-- Objetivo: Listar estados com vendedores cadastrados excluindo os que têm clientes.
-- Tabelas: olist_sellers_dataset e olist_customers_dataset

SELECT s.seller_state 
FROM olist_sellers_dataset AS s 

EXCEPT 

SELECT c.customer_state 
FROM olist_customers_dataset AS c;

-- Questão 7: Lista de Cidades Ativas 
-- Objetivo: Unificar cidades de clientes e vendedores em uma única coluna sem duplicados.
-- Tabelas: olist_customers_dataset e olist_sellers_dataset

SELECT c.customer_city AS cidades_ativas
FROM olist_customers_dataset AS  c 

UNION 

SELECT s.seller_city 
FROM olist_sellers_dataset AS s;