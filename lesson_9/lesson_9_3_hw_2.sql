-- Урок 9.
-- Видеоурок. Транзакции, переменные, представления. Администрирование. Хранимые процедуры и функции, триггеры
-- 
-- Практическое задание по теме “Хранимые процедуры и функции, триггеры"
-- 
-- 
-- 1. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". 
-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.
-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
-- Вызов функции FIBONACCI(10) должен возвращать число 55.

USE shop;

-- -----------------------------------------------------------------------------------------------------------------------
-- 2. В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
-- При попытке ОДНОВРЕМЕННО присвоить полям NULL-значение необходимо отменить операцию.
-- -----------------------------------------------------------------------------------------------------------------------

SELECT name, description -- id, price, catalog_id, created_at, updated_at
FROM shop.products;

DROP TRIGGER IF EXISTS check_name_discription_insert;

delimiter //

CREATE TRIGGER check_name_discription_insert AFTER INSERT ON products
FOR EACH ROW
BEGIN 
	IF NEW.name IS NULL AND NEW.description IS NULL THEN 
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'INSERT NULL VALUES INTO FIELDS name and description IS FORBIDDEN';
	END IF;
END//

DELIMITER ;


DROP TRIGGER IF EXISTS check_name_discription_update;

delimiter //

CREATE TRIGGER check_name_discription_update AFTER UPDATE ON products
FOR EACH ROW
BEGIN 
	IF NEW.name IS NULL AND NEW.description IS NULL THEN 
		SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'INSERT NULL VALUES INTO FIELDS name and description IS FORBIDDEN';
	END IF;
END//

DELIMITER ;


-- 
-- Проверка
-- 
START TRANSACTION;

-- пытаемся вставить значения name = NULL, description = NULL
INSERT INTO shop.products 
	(name, description, price, catalog_id, created_at, updated_at)
VALUES
	(NULL, NULL, 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- ошибка - 45001

SELECT id, name, description FROM products ORDER BY id DESC LIMIT 2;

-- вставляем запись, где name = NULL, description NOT IS NULL
INSERT INTO shop.products 
	(name, description, price, catalog_id, created_at, updated_at)
VALUES
	(NULL, 'description', 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- ошибка не возникает

-- вставляем запись, где name NOT IS NULL, description = NULL
INSERT INTO shop.products 
	(name, description, price, catalog_id, created_at, updated_at)
VALUES
	('name', NULL, 0, 0, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- ошибка не возникает
-- выводим вставленные записи 
SELECT id, name, description FROM products ORDER BY id DESC LIMIT 2;

-- 
SELECT id, name, description FROM products WHERE id = 1;
-- пытаемся обновить запись значениями name = NULL, description = NULL
UPDATE shop.products SET name=NULL, description=NULL WHERE id=1;
-- ошибка - 45001

-- обновляем запись значением name = NULL
UPDATE shop.products SET name=NULL WHERE id=1;
-- ошибка не возникает
SELECT id, name, description FROM products WHERE id =1;

-- обновляем запись значением name = NULL ( name = NULL )
UPDATE shop.products SET description = NULL WHERE id=1;
-- ошибка - 45001

SELECT id, name, description FROM products WHERE id =1;

ROLLBACK;
-- COMMIT;

