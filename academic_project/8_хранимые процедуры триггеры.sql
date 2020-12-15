-- Базы данных. Курсовой проект.
-- Практическое задание
-- Требования к курсовому проекту:
-- 
-- 8. хранимые процедуры, функции, триггеры;
-- 

USE web_shop;

-- -----------------------------------------------------------------------------------------------------------------------
-- 1. При изменении количества товара в магазине, общее количество товара в таблице товаров (поле products.available),
-- 	  должно изменяться на соответствующую величину.
-- 2. Количество товара не может быть меньше нуля.
--    При попытке вставить, в данном случае, должна выдаваться ошибка 45000 с соответствующим разьяснением.
--    При создании нового товара всегда поле products.available = 0.
-- 3. При добавлении новой записи в таблицу products_shops,
--    должно измениться общее количество товара в таблице товаров (products.available), для соответствующей позиции.
-- -----------------------------------------------------------------------------------------------------------------------
-- DESCRIBE products_shops;
-- DESCRIBE products;

-- ----------------------------------------------------------------------------------------------
-- 1. Создаём функцию возвращающую общее количество товара во всех магазинах по его идентификатору
-- ----------------------------------------------------------------------------------------------
DROP FUNCTION IF EXISTS product_count;
DELIMITER //

CREATE FUNCTION product_count(product INT) RETURNS INT DETERMINISTIC
-- Возвращает общее количество товара во всех магазинах по его идентификатору
BEGIN
	DECLARE res INT;

 	SELECT SUM(product_count) AS product_count
	  FROM products_shops
	 WHERE product_id = product
	 GROUP BY product_id
  	  INTO res;
 
	RETURN res;
END//

DELIMITER ;
-- SELECT product_count(20);

-- ----------------------------------------------------------------------------------------------
-- 2. Создаём триггеры на таблицу products
-- ----------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS check_available_insert;
DROP TRIGGER IF EXISTS check_available_update;

DELIMITER //

-- 1 --
CREATE TRIGGER check_available_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN 
	-- Количество доступных товаров (products.available) нового товара по умолчанию.
	-- Cоздан на случай, если будет попытка добавления в таблицу products нового товара,
 	-- с количеством товара available отличным от нуля.
	SET NEW.available = 0;
END//

-- 2 --
CREATE TRIGGER check_available_update BEFORE UPDATE ON products
FOR EACH ROW
BEGIN 
	-- Количество доступных товаров (products.available) не может быть меньше нуля.
	IF NEW.available < 0 THEN 
	 	-- Ошибка. Количество товара не может быть меньше нуля.
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ITEM QUANTITY CANNOT BE LESS THAN ZERO';
	END IF;
END//

DELIMITER ;
/*
-- Проверка
INSERT INTO products (product_types_id, name, description, format, weight, anotation, available, price)
VALUES
(8, -- Прочие канцтовары
'Деревянная фоторамка «Line natur», 10 х 15 см',
'Деревянная фоторамка «Line natur», 10 х 15 см',
'17.5 x 12.3 x 1.2',
140, 
'Прекрасно, если вы храните фотографии или детские рисунки. Поместите их в красивую деревянную рамку и поставьте на видное место, например, на рабочий стол.
Тогда они будут напоминать вам о счастливых событиях и поднимать настроение! Фотографии в такой рамке станут отличным украшением любой комнаты.

Размер фоторамки: 17.5 х 12.5 см
Размер фотографии: 10 х 15 см
Материал: дерево
Страна-производитель: Китай.',
-1,
160);

SELECT id, product_types_id, name, description, format, weight, anotation, available, price, created_at FROM products ORDER BY id DESC LIMIT 1;
-- */

-- ----------------------------------------------------------------------------------------------
-- 3. Создаём триггеры на таблицу products_shops
-- ----------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS check_products_count_insert;
DROP TRIGGER IF EXISTS check_products_count_update;
DELIMITER //
-- 1 --
CREATE TRIGGER check_products_count_insert AFTER INSERT ON products_shops
FOR EACH ROW
BEGIN 
	-- При добавлении новой записи в таблицу products_shops, должно измениться общее количество товара
	-- в таблице товаров (products.available), для соответствующей позиции.
	IF NEW.product_count < 0 THEN 
	 	-- Ошибка. Количество товара не может быть меньше нуля.
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ITEM QUANTITY CANNOT BE LESS THAN ZERO';
	ELSE
		-- Увеличиваем общее количество товара доступное для покупателя
		UPDATE products
		   SET available=available + NEW.product_count
		 WHERE id = NEW.product_id;	
	END IF;
END//

-- 2 --
CREATE TRIGGER check_products_count_update AFTER UPDATE ON products_shops
FOR EACH ROW
-- При изменении количества товара в магазине, общее количество товара в таблице товаров (поле products.available),
-- должно изменяться на соответствующую величину.
-- Если количество товара становится < 0, выдаётся ошибка о недопустимости подобного действия
-- Если всё в порядке, обновляется поле available таблицы product
BEGIN 
	DECLARE num INT;
	SET num = product_count(NEW.product_id);
    -- SELECT SUM(product_count) AS product_count FROM products_shops WHERE product_id = NEW.product_id GROUP BY product_id INTO num;
  	IF num < 0 THEN 
  	 	-- Ошибка. Количество товара не может быть меньше нуля.
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ITEM QUANTITY CANNOT BE LESS THAN ZERO';
	ELSE
		UPDATE products
		   SET available = num
		 WHERE id = NEW.product_id;
	END IF;
END//

DELIMITER ;

-- ----------------------------------------------------------------------------------------------
-- 4. Создаём процедуру изменяющую количества товара в таблице products_shops
-- ----------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS product_count_change;
delimiter //

CREATE PROCEDURE product_count_change(new_product_count INT, product INT, shop INT)
BEGIN
	-- DECLARE num INT;
	IF NOT EXISTS (SELECT 1 FROM products_shops WHERE product_id = product AND shop_id = shop) THEN
		-- Не допустимая операция. Данный товар отсутствует в этом магазине.
 		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'OPERATION IS NOT VALID. THE ITEMS IS NOT IN THE STORE';
	ELSE
		IF  (new_product_count <= 0) THEN
			-- Не допустимая операция. Количество товара не может быть < 0.
 			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'OPERATION IS NOT VALID. ITEM QUANTITY CANNOT BE LESS THAN ZERO';
		ELSE
			UPDATE products_shops
			   SET product_count = new_product_count
			 WHERE product_id = product AND shop_id = shop;
		END IF;
	END IF;
END//
DELIMITER ;


-- ---------------------------------------------------------
-- Проверка
-- ---------------------------------------------------------

-- INSERT INTO products_shops (product_id, shop_id, product_count) VALUES (1, 15, 1);
-- INSERT INTO products_shops (product_id, shop_id, product_count) VALUES (1, 15, 1);
-- INSERT INTO products_shops (product_id, shop_id, product_count) VALUES (1, 35, 13);
CALL product_count_change(5, 1, 34);
CALL product_count_change(11, 1, 15);

SELECT "products_shops" AS `table`, shop_id, product_id, product_count FROM products_shops WHERE product_id = 1
UNION ALL
SELECT "products" AS `table`, '' AS shop_id, id AS product_id, available AS product_count FROM products WHERE id = 1;


-- ----------------------------------------------------------------------------------------------
-- 5. Создаём триггеры на таблицу users_products (Корзина покупателя)
-- ----------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS check_users_products__products_count_insert;
DELIMITER //
-- 22. В триггере check_users_products__products_count_insert вероятно нужно также проверять чтобы не было задано больше товара, чем есть остатке.
-- 1 --

CREATE TRIGGER check_users_products__products_count_insert BEFORE INSERT ON users_products
FOR EACH ROW
-- При добавлении новой записи в таблицу users_products, должно проверяется доступное количество товара.
-- Если количество доступного товара = 0, выдаётся сообщение об ошибке.
BEGIN 
	-- 3. При добавлении новой записи в таблицу users_products, должно проверяется доступное количество товара.
	DECLARE num INT;
	SELECT available FROM products WHERE id = NEW.product_id INTO num;
  	IF num <= 0 THEN 
  	 	-- Ошибка. Товар отсутствует.
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ITEM IS NOT EVALABLE';
	ELSE
	  	IF num > product_count(NEW.product_id) THEN 
	  	 	-- Ошибка. Товар отсутствует.
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ITEM QUANTITY NOT ENOUGH FOR ORDER';
		ELSE
			SET NEW.product_count = num;
		END IF;
	END IF;
END//

DELIMITER ;