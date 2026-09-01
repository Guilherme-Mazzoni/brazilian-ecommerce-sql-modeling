-- =====================================================================
-- Questão 5: Cidades de Mão Dupla 
-- =====================================================================
-- Objetivo: Encontrar cidades com pelo menos um cliente E pelo menos um vendedor.
-- Tabelas: olist_customers_dataset e olist_sellers_dataset

SELECT c.customer_city 
FROM olist_customers_dataset AS c 

INTERSECT 

SELECT s.seller_city 
FROM olist_sellers_dataset AS s;

-- =====================================================================
-- Questão 6: Estados Sem Compradores 
-- =====================================================================
-- Objetivo: Listar estados com vendedores cadastrados excluindo os que têm clientes.
-- Tabelas: olist_sellers_dataset e olist_customers_dataset

SELECT s.seller_state 
FROM olist_sellers_dataset AS s 

EXCEPT 

SELECT c.customer_state 
FROM olist_customers_dataset AS c;

-- =====================================================================
-- Questão 7: Lista de Cidades Ativas 
-- =====================================================================
-- Objetivo: Unificar cidades de clientes e vendedores em uma única coluna sem duplicados.
-- Tabelas: olist_customers_dataset e olist_sellers_dataset

SELECT c.customer_city AS cidades_ativas
FROM olist_customers_dataset AS  c 

UNION 

SELECT s.seller_city 
FROM olist_sellers_dataset AS s;

-- =====================================================================
-- Questão 23: Estados Com Clientes Mas Sem Vendedores
-- =====================================================================
-- Objetivo: Mapear estados que possuem compradores cadastrados, mas não possuem nenhum lojista vendendo na plataforma.
 
SELECT customer_state AS estado
FROM olist_customers_dataset 

EXCEPT 

SELECT seller_state AS estado
FROM olist_sellers_dataset ;

-- =====================================================================
-- Questão 24: Cidades Gêmeas de Negócios
-- =====================================================================
-- Objetivo: Identificar quais cidades possuem simultaneamente clientes e vendedores cadastrados, restringindo a análise aos estados de SP e RJ.
-- Tabelas: olist_customers_dataset (c) e olist_sellers_dataset (s)

SELECT customer_state AS estado, customer_city AS cidade
FROM olist_customers_dataset 
WHERE customer_state IN ('SP','RJ')

INTERSECT 

SELECT seller_state AS estado, seller_city AS cidade
FROM olist_sellers_dataset 
WHERE seller_state IN ('SP','RJ');

-- =====================================================================
-- Questão 25: Unificação de Hubs de CEP (UNION)
-- =====================================================================
-- Objetivo: Criar uma lista consolidada e sem duplicidades de todos os prefixos de CEP ativos no e-commerce (seja de cliente ou vendedor).
-- Tabelas: olist_customers_dataset (c) e olist_sellers_dataset (s)
-- Colunas para unir: customer_zip_code_prefix e seller_zip_code_prefix (nomeie a coluna final como 'ceps_ativos')

SELECT c.customer_zip_code_prefix AS ceps_ativos
FROM olist_customers_dataset AS c

UNION

SELECT s.seller_zip_code_prefix AS ceps_ativos
FROM olist_sellers_dataset AS s ;