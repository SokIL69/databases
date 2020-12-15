-- Базы данных. Практическое задание. Требования к курсовому проекту:
-- 1. Составить общее текстовое описание БД и решаемых ею задач;
-- 2. минимальное количество таблиц - 10;
-- 3. скрипты создания структуры БД (с первичными ключами, индексами, внешними ключами);
-- 4. создать ERDiagram для БД;
-- 5. скрипты наполнения БД данными;
-- 6. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
-- 7. представления (минимум 2);
-- 8. хранимые процедуры / триггеры;

USE web_shop;
-- ---------------------------------------------------------------------------------- --
-- 6. скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы) --
-- ---------------------------------------------------------------------------------- --
-- База данных должна предоставлять информацию в различных разрезах:

-- 
-- Суммарный отчёт о доходе полученных на площадке интернет магазина
-- в разрезе товаров
-- 
SELECT * FROM v_income;
-- или
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

-- 
-- 1. Наличие товара в разрезе категорий товаров;
-- 
SELECT pr.id, 
	   product_type,
	   pr.name AS product,
	   price, -- pr.format, pr.weight, 
	   IF(available, 'доступно', 'нет в наличии') AS available,
	   -- pr.description, anotation,
	   product_count AS count,
	   sh.name AS Shop
  FROM products pr
 	   JOIN product_types pt ON pt.id = pr.product_type_id
	   LEFT OUTER JOIN products_shops ps ON pr.id = ps.product_id 
	   LEFT OUTER JOIN shops sh ON sh.id = ps.shop_id
 WHERE pt.product_type LIKE 'Настольные и семейные игры'
-- WHERE pt.id = 51
;

-- 
-- 2. Наличие товара в в конкретных магазинах, их количестве в данном магазине;
-- 
SELECT sh.name AS Shop, /*pr.id,*/ 
	   product_type,
	   pr.name AS product,
	   price, /*pr.format, pr.weight, available, pr.description, anotation,*/
	   product_count AS count
  FROM products pr
	   JOIN product_types pt ON pt.id = pr.product_type_id
	   LEFT OUTER JOIN products_shops ps ON pr.id = ps.product_id 
	   LEFT OUTER JOIN shops sh ON sh.id = ps.shop_id
  WHERE sh.name  LIKE 'м. ВДНХ'
-- WHERE sh.id=77
;

-- 
-- 3. Подробная информация о товаре;
-- 
SELECT  pr.id,
		-- pr.product_type_id,
		product_type, 
		pr.name AS product,
		price,
		pr.format,
		pr.weight, 
		IF(available, 'доступно', 'нет в наличии') AS available,
		pr.description, 
		anotation, 
		product_count AS count, 
		sh.name AS Shop -- , ps.product_id, ps.shop_id
  FROM products pr
  	JOIN product_types pt ON pt.id = pr.product_type_id
  	LEFT OUTER JOIN products_shops ps ON pr.id = ps.product_id 
  	LEFT OUTER JOIN shops sh ON sh.id = ps.shop_id
  WHERE pr.name LIKE 'Настольная игра "Азбука Мурррзе": на 2-6 игроков'
-- WHERE pr.id = 15
-- WHERE pt.product_type LIKE 'Настольные и семейные игры';
;

-- 
-- 4. Оценка товара и отзывы покупателей на данный товар;
-- 
SELECT  -- pr.id,
		pr.name AS product,
		estimate,
		feedback,
		login
  FROM products pr
	   LEFT OUTER JOIN ratings rt ON rt.product_id = pr.id
	   JOIN users usr ON usr.id = rt.user_id
 WHERE pr.name LIKE '%"Азбука Мурррзе"%';

-- 
-- 5. Подробная инфорамация о объекте книга;
-- 
SELECT bk.name,
	   bk.author,
	   bk.id,
 	   pt.product_type AS genre,
	   ph.name AS publishing_house,
	   sr.name AS series,
	   bk.`year`,
	   bk.isbn,
	   bk.number_pages,	   
	   bk.cover_type,
   	   bk.circulation,
	   -- bk.genre_id,
	   bk.`language`,
	   IF(bk.miniature = TRUE, "миниатюрное издание", ""),
   	   IF(bk.new = TRUE, "новое издание", "")
  FROM books bk
     JOIN product_types pt ON pt.id = bk.genre_id
  	 JOIN publishing_houses ph ON bk.publishing_house_id = ph.id
  	 JOIN series sr ON bk.series_id = sr.id
  -- WHERE pt.product_type LIKE 'Книги для детей'
  ORDER BY genre;

-- 
-- 6. Наличие книг в разрезе магазинов с их количеством
-- 
SELECT bk.name,
	   bk.author,
	   bk.id,
 	   pt.product_type AS genre,
	   -- ph.name AS publishing_house,
	   -- sr.name AS series,
	   bk.`year`,
	   -- bk.isbn,
	   -- bk.number_pages,	   
	   -- bk.cover_type,
   	   -- bk.circulation,
	   -- bk.genre_id,
	   -- bk.`language`,
	   -- IF(bk.miniature = TRUE, "миниатюрное издание", ""),
   	   -- IF(bk.new = TRUE, "новое издание", ""),
   	   product_count AS count, 
   	   sh.name AS shop
  FROM books bk
	 JOIN product_types pt ON pt.id = bk.genre_id
	 JOIN products pr ON bk.product_id = pr.id
     LEFT OUTER JOIN products_shops ps ON pr.id = ps.product_id 
     LEFT OUTER JOIN shops sh ON sh.id = ps.shop_id
WHERE bk.author LIKE '%Pro%'
ORDER BY genre;

-- 
-- 7. Информация о издательстве и изданных им книгах продаваемых в инитернет магазине;
-- 
SELECT ph.id, 
	   ph.name AS publishing_house,
	   -- ph.description,
	   bk.name AS book,
	   bk.author,
	   bk.`year` 
FROM publishing_houses ph
	 JOIN books bk ON bk.publishing_house_id = ph.id
WHERE ph.name LIKE '%nemo%'
ORDER BY publishing_house;

-- 
-- 8. Серии книги, в разрезе издательств, книги изданные в данной серии;
-- 
SELECT sr.id, 
	   ph.name AS publishing_house,
	   sr.name AS serias,
	   -- ph.description,
	   bk.name AS book,
	   bk.author,
	   bk.`year` 
FROM series sr
	 JOIN publishing_houses ph ON ph.id = sr.publishing_house_id
	 LEFT OUTER JOIN books bk ON bk.series_id = sr.id
-- WHERE ph.name LIKE '%nemo%'
-- WHERE sr.name LIKE 'Enim tempora illum iure.'
ORDER BY publishing_house, serias;

-- 
-- 9. Проводимые акции, с возможностью просмотра информации о сроках их действия, учавствующих товарах, условиях акции;
-- 
SELECT pm.id,
	   pm.start_date,
	   pm.end_date,
	   pm.discount,
	   pm.bonuse,
	   pm.description,
	   pr.name AS product
FROM web_shop.promotions pm
	LEFT JOIN products_promotons pp ON pp.promotion_id = pm.id
	LEFT JOIN products pr ON pr.id = pp.product_id
WHERE pm.end_date > CURRENT_TIMESTAMP
ORDER BY pm.start_date DESC
;

-- 
-- 10. Информация о покупателях, о состоянии корзины покупателя, его заказах, активности покупателя;
-- Общее количество покупателей и общая стоимость оплаченных ими заказов
-- 

-- 
-- 11. Пользователь системы должны иметь возможность увидеть любой товар выбранной им категории, наличие этого товара, 
-- его свойствах цене и т.д. Должен иметь возможность выбора магазина (эти возможности представленны выше, см. 1, 2, ..., 9).
-- 

-- 12. Пользователь может откладывать товар в корзину, просматривать её, добавлять и удалять товары из корзины;
SELECT -- up.product_id,
	   -- up.user_id,
	   usr.fio,
	   pr.name AS product,
	   up.product_count
  FROM users_products up
	JOIN products pr ON pr.id = up.product_id
	JOIN users usr ON usr.id = up.user_id 
WHERE fio LIKE 'Hershel Koss'
ORDER BY fio, product
;	


-- 13. Пользователь должен иметь возможность просматривать свои заказы, отслеживать состояние заказа,
--  степень его готовности, просматривать информацию о купленных им товарах в интернет-маагзине.

SELECT fio,
	   order_number,
	   order_date,
	   cost,
	   CASE
	   	 WHEN state = 0 THEN "не оплачен"
	     WHEN state = 1 THEN "оплачен"
	     WHEN state = 2 THEN "формируется на складе"
	     WHEN state = 3 THEN "доставляется"
	     WHEN state = 4 THEN "доставлен"
	     WHEN state = 5 THEN "завершён"
	     ELSE "статус неопределён"
	   END AS state -- Состояние заказа
FROM orders ord
	JOIN users usr ON usr.id = ord.user_id
-- ORDER BY order_number
;

SELECT fio,
	   order_id,
	   order_number,
	   order_date,
	   cost,
	   CASE
	   	 WHEN state = 0 THEN "не оплачен"
	     WHEN state = 1 THEN "оплачен"
	     WHEN state = 2 THEN "формируется на складе"
	     WHEN state = 3 THEN "доставляется"
	     WHEN state = 4 THEN "доставлен"
	     WHEN state = 5 THEN "завершён"
	     ELSE "статус неопределён"
	   END AS state, -- Состояние заказа
	   pr.name AS product,
	   op.product_count
FROM orders ord
	JOIN orders_products op ON op.order_id = ord.id
	JOIN products pr ON pr.id = op.product_id
	JOIN users usr ON usr.id = ord.user_id
-- WHERE order_number = '1776'
WHERE fio LIKE '%Alda Gutkowski MD%'
   OR fio LIKE '%Alden Homenick%'
   OR order_number = '1776'
ORDER BY fio, order_number;

-- 
-- 14. Пользователь должен иметь возможность оценивать товар, оставлять о неём отзывы,
--  а также просматривать оценку товара и отзывы оставленные другими пользователями;
-- 
SELECT  -- pr.id,
		pr.name AS product,
		estimate,
		feedback,
		login
  FROM products pr
	   LEFT OUTER JOIN ratings rt ON rt.product_id = pr.id
	   JOIN users usr ON usr.id = rt.user_id
 WHERE pr.name LIKE '%"Азбука Мурррзе"%';

-- 
-- 15 У покупателя должна быть возможность связаться со службами интернет магазина и получить обратную связь от них.
-- 
SELECT usr.id, login, fio, birsday, usr.email, phone, сonsent, fb.created_at
FROM users usr
	INNER JOIN feedbacks fb ON fb.user_id = usr.id
	INNER JOIN feedback_recipients fr ON fb.recipient_id = fr.id
;


-- 17. Общее количество товара во всех магазинах
SELECT pr.id, 
	   product_type,
	   pr.name AS product,
	   price, -- pr.format, pr.weight, 
	   IF(available, 'доступно', 'нет в наличии') AS available,
	   prsh.product_count
  FROM products pr
  	JOIN product_types pt ON pt.id = pr.product_type_id
	LEFT OUTER JOIN (
		 	SELECT SUM(product_count) AS product_count, product_id
			  FROM products_shops
			 GROUP BY product_id
			 ) prsh ON prsh.product_id = pr.id
ORDER BY pr.id DESC;
			
			
-- 18. Общий доход по всем заказам, по товарам, по категориям товаров
SELECT id, user_id, order_number, order_date, address, cost, delivery_service, state, payment_date, delivary_date, order_ditails, created_at, updated_at
FROM web_shop.orders;


-- 
-- Информация о типах товара с учётом вложенности подтипов (3 - уровня)
-- 
SELECT @i:=@i+1 num, id, product_type FROM v_product_types, (SELECT @i:=0) X;

-- или

SELECT @i:=@i+1 num, id, product_type 
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
		FROM product_types pt, (SELECT @i:=0) X
		WHERE level = 3
		ORDER BY prnt, level, parent_id_1
		) AS tbl
ORDER BY num;


