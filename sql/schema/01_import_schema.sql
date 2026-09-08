-- =====================================================================
-- SCRIPT DE CRIAÇÃO DO SCHEMA - DATASET OLIST (PostgreSQL)
-- =====================================================================
-- Este script cria a estrutura física das 9 tabelas do ecossistema Olist.
-- Respeita as validações físicas e as chaves primárias/compostas identificadas.

-- 1. Tabela: olist_customers_dataset
CREATE TABLE IF NOT EXISTS olist_customers_dataset (
    customer_id VARCHAR(50) NOT NULL,
    customer_unique_id VARCHAR(50) NOT NULL,
    customer_zip_code_prefix VARCHAR(10) NOT NULL,
    customer_city VARCHAR(100) NOT NULL,
    customer_state VARCHAR(2) NOT NULL,
    CONSTRAINT pk_olist_customers PRIMARY KEY (customer_id)
);

-- 2. Tabela: olist_geolocation_dataset (Sem Chave Primária Única)
CREATE TABLE IF NOT EXISTS olist_geolocation_dataset (
    geolocation_zip_code_prefix VARCHAR(10) NOT NULL,
    geolocation_lat NUMERIC(15, 10) NOT NULL,
    geolocation_lng NUMERIC(15, 10) NOT NULL,
    geolocation_city VARCHAR(100) NOT NULL,
    geolocation_state VARCHAR(2) NOT NULL
);

-- 3. Tabela: olist_sellers_dataset
CREATE TABLE IF NOT EXISTS olist_sellers_dataset (
    seller_id VARCHAR(50) NOT NULL,
    seller_zip_code_prefix VARCHAR(10) NOT NULL,
    seller_city VARCHAR(100) NOT NULL,
    seller_state VARCHAR(2) NOT NULL,
    CONSTRAINT pk_olist_sellers PRIMARY KEY (seller_id)
);

-- 4. Tabela: olist_products_dataset
CREATE TABLE IF NOT EXISTS olist_products_dataset (
    product_id VARCHAR(50) NOT NULL,
    product_category_name VARCHAR(100),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT,
    CONSTRAINT pk_olist_products PRIMARY KEY (product_id)
);

-- 5. Tabela: product_category_name_translation
CREATE TABLE IF NOT EXISTS product_category_name_translation (
    product_category_name VARCHAR(100) NOT NULL,
    product_category_name_english VARCHAR(100) NOT NULL,
    CONSTRAINT pk_product_category_translation PRIMARY KEY (product_category_name)
);

-- 6. Tabela: olist_orders_dataset
CREATE TABLE IF NOT EXISTS olist_orders_dataset (
    order_id VARCHAR(50) NOT NULL,
    customer_id VARCHAR(50) NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    order_purchase_timestamp TIMESTAMP NOT NULL,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP NOT NULL,
    CONSTRAINT pk_olist_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customers FOREIGN KEY (customer_id) REFERENCES olist_customers_dataset (customer_id)
);

-- 7. Tabela: olist_order_items_dataset
CREATE TABLE IF NOT EXISTS olist_order_items_dataset (
    order_id VARCHAR(50) NOT NULL,
    order_item_id INT NOT NULL,
    product_id VARCHAR(50) NOT NULL,
    seller_id VARCHAR(50) NOT NULL,
    shipping_limit_date TIMESTAMP NOT NULL,
    price NUMERIC(10, 2) NOT NULL,
    freight_value NUMERIC(10, 2) NOT NULL,
    CONSTRAINT pk_olist_order_items PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT fk_order_items_orders FOREIGN KEY (order_id) REFERENCES olist_orders_dataset (order_id),
    CONSTRAINT fk_order_items_products FOREIGN KEY (product_id) REFERENCES olist_products_dataset (product_id),
    CONSTRAINT fk_order_items_sellers FOREIGN KEY (seller_id) REFERENCES olist_sellers_dataset (seller_id)
);

-- 8. Tabela: olist_order_payments_dataset
CREATE TABLE IF NOT EXISTS olist_order_payments_dataset (
    order_id VARCHAR(50) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(20) NOT NULL,
    payment_installments INT NOT NULL,
    payment_value NUMERIC(10, 2) NOT NULL,
    CONSTRAINT pk_olist_order_payments PRIMARY KEY (order_id, payment_sequential),
    CONSTRAINT fk_order_payments_orders FOREIGN KEY (order_id) REFERENCES olist_orders_dataset (order_id)
);

-- 9. Tabela: olist_order_reviews_dataset
-- Observação: A chave primária é COMPOSTA (review_id + order_id) devido a regras de negócio de carrinhos multi-vendedor.
CREATE TABLE IF NOT EXISTS olist_order_reviews_dataset (
    review_id VARCHAR(50) NOT NULL,
    order_id VARCHAR(50) NOT NULL,
    review_score INT NOT NULL,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP NOT NULL,
    review_answer_timestamp TIMESTAMP,
    CONSTRAINT pk_olist_order_reviews PRIMARY KEY (review_id, order_id),
    CONSTRAINT fk_order_reviews_orders FOREIGN KEY (order_id) REFERENCES olist_orders_dataset (order_id)
);

-- =====================================================================
-- INSTRUÇÕES DE IMPORTAÇÃO (COPY COMMAND - PostgreSQL)
-- =====================================================================
-- Caso esteja executando em uma instância local do Postgres, você pode importar os arquivos CSV usando:
-- (Ajuste o caminho físico '/path/to/csv/' para onde seus arquivos estão localizados)

-- COPY olist_customers_dataset FROM '/path/to/csv/olist_customers_dataset.csv' DELIMITER ',' CSV HEADER;
-- COPY olist_geolocation_dataset FROM '/path/to/csv/olist_geolocation_dataset.csv' DELIMITER ',' CSV HEADER;
-- COPY olist_sellers_dataset FROM '/path/to/csv/olist_sellers_dataset.csv' DELIMITER ',' CSV HEADER;
-- COPY olist_products_dataset FROM '/path/to/csv/olist_products_dataset.csv' DELIMITER ',' CSV HEADER;
-- COPY product_category_name_translation FROM '/path/to/csv/product_category_name_translation.csv' DELIMITER ',' CSV HEADER;
-- COPY olist_orders_dataset FROM '/path/to/csv/olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;
-- COPY olist_order_items_dataset FROM '/path/to/csv/olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;
-- COPY olist_order_payments_dataset FROM '/path/to/csv/olist_order_payments_dataset.csv' DELIMITER ',' CSV HEADER;
-- COPY olist_order_reviews_dataset FROM '/path/to/csv/olist_order_reviews_dataset.csv' DELIMITER ',' CSV HEADER;
