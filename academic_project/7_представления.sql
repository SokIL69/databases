-- Базы данных. Курсовой проект.
-- Практическое задание
-- Требования к курсовому проекту:
-- 
-- 7. представления (минимум 2);
-- 

USE web_shop;

SELECT * FROM v_product_types;
SELECT * FROM v_income;

-- 
-- 1-е Представление
-- 
DROP VIEW IF EXISTS v_product_types;

CREATE VIEW v_product_types
AS
-- 
-- Информация о типах товара с учётом вложенности подтипов (3 - уровня)
-- 
SELECT id, product_type 
FROM (
		SELECT id,
			id AS id_3,
			parent_id,
			-- IF(parent_id = 0, id, parent_id) AS parent_id_1,
			IF(parent_id = 0, id, id) AS parent_id_1,
			IF(parent_id = 0, id, parent_id) AS prnt,
			level,
			IF(parent_id = 0, product_type, CONCAT('. ', product_type)) AS product_type			
		FROM product_types
		WHERE level < 2
		UNION
		SELECT id,
			id AS id_3,
			parent_id, 
			IF(parent_id = 0, id, parent_id) AS parent_id_1,
			(SELECT parent_id FROM product_types pt_1 WHERE pt_1.id = pt.parent_id) AS prnt,
			level,
			IF(parent_id = 0, product_type, CONCAT('. . ', product_type)) AS product_type
		FROM product_types pt
		WHERE level = 2
 		UNION 
		SELECT id,
		    IF(level = 3, parent_id , id) AS id_3,
			parent_id, 
			(SELECT parent_id FROM product_types pt_1 WHERE pt_1.id = pt.parent_id) AS parent_id_1,
			(
			  SELECT parent_id 
			    FROM product_types pt_2
			   WHERE pt_2.id IN (
						SELECT parent_id 
						  FROM product_types pt_1 
						 WHERE pt_1.id = pt.parent_id
					 )
			) AS prnt,
			level,
			IF(parent_id = 0, product_type, CONCAT('. . . ', product_type)) AS product_type
		FROM product_types pt
		WHERE level = 3
		ORDER BY prnt, level, parent_id_1
 		) AS tbl;

 	
-- 
-- 2-е Представление
-- 
DROP VIEW IF EXISTS v_income;

CREATE VIEW v_income
AS
-- 
-- Суммарный отчёт о доходе полученных на площадке интернет магазина
-- в разрезе товаров
-- 
SELECT DISTINCT 
	   pr.id, -- идентификатор товара
	   pr.name AS product, -- товар
	   pr.price, -- цена товара
 	   SUM(op.product_count) OVER window_op AS product_count, -- общее количество товара приобретённое всеми покупателями
 	   SUM(op.product_count * pr.price) OVER window_op AS product_income, -- общий доход по данному товару
       SUM(o1.cost) OVER() AS full_income -- общий доход по всем позициям
FROM products pr
	LEFT OUTER JOIN orders_products op ON op.product_id = pr.id	 
	LEFT OUTER JOIN orders o1 ON op.order_id = o1.id
 	WINDOW window_op AS (PARTITION BY op.product_id)
ORDER BY pr.id
 	;

