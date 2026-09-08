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

-- =====================================================================
-- Questão 26: Classificação de Preços de Produtos (CASE WHEN)
-- =====================================================================
-- Objetivo: Categorizar os produtos vendidos por faixas de preço para entender a distribuição do catálogo.
-- Tabelas: olist_order_items_dataset (i) 
-- Regra de classificação:
--   - Se o preço (price) for menor que 50: 'Barato' 
--   - Se o preço for entre 50 e 200 (inclusive): 'Médio'
--   - Se o preço for maior que 200: 'Caro'
-- Retorno esperado: A classificação criada e a contagem total de itens em cada uma, ordenada do maior volume para o menor.

SELECT 
	COUNT(*) AS contagem_total, 
	CASE 
		WHEN i.price < 50 THEN 'Barato'
		WHEN i.price BETWEEN 50 AND 200 THEN 'Médio'
		ELSE 'Caro'		
	END AS ClassificaoPreco
FROM olist_order_items_dataset AS i
GROUP BY ClassificaoPreco 
ORDER BY contagem_total DESC;


-- =====================================================================
-- Questão 27: Desempenho Logístico de Postagem (CASE WHEN)
-- =====================================================================
-- Objetivo: Analisar o cumprimento do prazo de postagem por parte dos lojistas parceiros.
-- Tabelas: olist_orders_dataset (o) e olist_order_items_dataset (i) 
-- Regra de classificação:
--   - Se order_delivered_carrier_date for menor ou igual a shipping_limit_date: 'Postado no Prazo' 
--   - Caso contrário: 'Postado com Atraso'
-- Filtro necessário: Remover registros onde alguma das datas comparadas esteja nula ou vazia.
-- Retorno esperado: A classificação criada e o total de itens para cada cenário.

SELECT COUNT(*) AS total_itens,
	CASE 
		WHEN order_delivered_carrier_date <= shipping_limit_date THEN 'Postado no Prazo'
		ELSE 'Postado com Atraso'
	END PrazoPostagem
FROM olist_orders_dataset AS o
INNER JOIN olist_order_items_dataset AS i 
USING(order_id)
WHERE o.order_delivered_carrier_date IS NOT NULL
	AND i.shipping_limit_date IS NOT NULL
GROUP BY prazopostagem
ORDER BY total_itens DESC