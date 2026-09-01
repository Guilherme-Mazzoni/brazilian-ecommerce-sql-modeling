-- =====================================================================
-- Questão 8: Categorias Premium 
-- =====================================================================
-- Objetivo: Calcular o preço médio dos itens por categoria de produto.
-- Tabelas: olist_order_items_dataset (i) e olist_products_dataset (p)
-- Regra de Negócio: Retorne apenas as categorias com preço médio maior que R$ 150,00.
-- Ordenação: Do preço médio mais alto para o mais baixo. 

SELECT COALESCE(p.product_category_name, 'Não Informado'), ROUND(AVG(o.price)::numeric,2) AS preco_medio
FROM olist_order_items_dataset AS o 
LEFT JOIN olist_products_dataset AS p 
	USING(product_id)
GROUP BY p.product_category_name
HAVING ROUND(AVG(o.price)::numeric,2) > 150
ORDER BY preco_medio DESC; 

-- =====================================================================
-- Questão 9: Tradução de Campeões de Venda 
-- =====================================================================
-- Objetivo: Descobrir as 5 categorias de produtos que mais venderam em quantidade de itens.
-- Tabelas: olist_order_items_dataset (i), olist_products_dataset (p) e product_category_name_translation (t)
-- Retorno: O nome da categoria em inglês (product_category_name_english) e a quantidade de itens vendidos.
-- Ordenação: Da maior quantidade para a menor, limitada aos 5 primeiros registros.

SELECT t.product_category_name_english, COUNT(o.order_item_id) AS qtd_vendida
FROM olist_order_items_dataset AS o 
LEFT JOIN olist_products_dataset AS p 
	USING(product_id)
LEFT JOIN product_category_name_translation AS t 
	ON p.product_category_name = t.product_category_name 
GROUP BY t.product_category_name_english
ORDER BY qtd_vendida DESC
LIMIT 5; 
