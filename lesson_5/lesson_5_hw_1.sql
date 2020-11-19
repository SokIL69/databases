-- Урок 5
-- Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение»
-- 
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
-- 2. Таблица users была неудачно спроектирована.
-- 	  Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
-- 	  Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
-- 	  0, если товар закончился и выше нуля, если на складе имеются запасы.
-- 	  Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
--    Однако нулевые запасы должны выводиться в конце, после всех
-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
--    Месяцы заданы в виде списка английских названий (may, august)
-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
--    Отсортируйте записи в порядке, заданном в списке IN.

SELECT DATABASE();

USE shop;

-- -----------------------------------------------------------------------------------------------------------------------
-- 1. Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем. 
-- -----------------------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
SHOW TABLES;
DESCRIBE users ;

TRUNCATE TABLE users;

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

UPDATE shop.users SET created_at=NULL , updated_at=NULL; 

-- 
-- Выполнение задания
-- 
UPDATE shop.users SET created_at=NOW() , updated_at=NOW(); 

SELECT * FROM users;


-- ----------------------------------------------------------------------------------------------------------------------------
-- 2. Таблица users была неудачно спроектирована.
-- Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10.
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
-- ---------------------------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
DESCRIBE users ;
SELECT * FROM users; 

-- 2.1 --
ALTER TABLE users MODIFY COLUMN created_at VARCHAR(25), MODIFY COLUMN updated_at VARCHAR(25);

-- 2.2 --
UPDATE users SET created_at=DATE_FORMAT(NOW(),'%d.%m.%Y %H:%i') , updated_at=DATE_FORMAT(NOW(),'%d.%m.%Y %H:%i');

-- 2.3 --
-- ALTER TABLE users MODIFY COLUMN created_at VARCHAR(16), MODIFY COLUMN updated_at VARCHAR(16);

DESCRIBE users;

SELECT * FROM users; 

-- 
-- Выполнение задания
-- 

-- 2.4 --
-- ALTER TABLE users MODIFY COLUMN created_at VARCHAR(25), MODIFY COLUMN updated_at VARCHAR(25);

-- 2.5 --
UPDATE users SET 
	created_at=DATE_FORMAT(STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'), '%Y-%m-%d %H:%i:%S.0'),
	updated_at=DATE_FORMAT(STR_TO_DATE(updated_at,'%d.%m.%Y %H:%i'), '%Y-%m-%d %H:%i:%S.0');

-- 2.6 --
ALTER TABLE users MODIFY COLUMN created_at DATETIME, MODIFY COLUMN updated_at DATETIME;

DESCRIBE users;

SELECT * FROM users; 


-- --------------------------------------------------------------------------------------------------------
-- 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
-- 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value.
-- Однако нулевые запасы должны выводиться в конце, после всех
-- --------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
TRUNCATE storehouses_products;

DESCRIBE storehouses_products;

INSERT INTO storehouses_products (storehouses_id, products_id, value) VALUES
	(1, 1, 0),
    (1, 2, 4),
    (1, 3, 0),
    (2, 4, 7),
    (2, 5, 56),
    (1, 6, 0),
    (1, 7, 4),
    (1, 8, 2500),
    (2, 9, 500),
    (2, 10, 30);
    
SELECT * FROM storehouses_products;

-- 
-- Выполнение задания
-- 

-- 1 вариант
SELECT id, value
  FROM storehouses_products
ORDER BY
	CASE
		WHEN value = 0 THEN 2147483647
		ELSE value
	END;

-- 2 вариант
SELECT 0 AS line, value FROM storehouses_products WHERE value != 0
UNION ALL 
SELECT 1 AS line, value FROM storehouses_products WHERE value = 0
ORDER BY line, value;


-- ----------------------------------------------------------------------------------------------
-- 4. (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
-- Месяцы заданы в виде списка английских названий (may, august)
-- ----------------------------------------------------------------------------------------------

SELECT * FROM users;
-- 
-- Выполнение задания
-- 
SELECT *
  FROM users
 WHERE MONTHNAME(birthday_at) = 'may' OR MONTHNAME(birthday_at) = 'august';


-- ------------------------------------------------------------------------------------------------------------------------
-- 5. (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
--    Отсортируйте записи в порядке, заданном в списке IN.
-- ------------------------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
TRUNCATE TABLE catalogs ;

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');

SELECT * FROM catalogs;

-- 
-- Выполнение задания
-- 
SELECT id, name
  FROM catalogs
 WHERE id IN (5, 1, 2)
ORDER BY
	CASE
		WHEN id = 5 THEN 0
		-- WHEN id = 1 THEN 1
		-- WHEN id = 2 THEN 2
		ELSE id
	END;
