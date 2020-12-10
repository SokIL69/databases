-- Бызы данных. Урок 11. Оптимизация запросов.
-- 
-- Практическое задание по теме “Оптимизация запросов”
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products
-- в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

USE shop;

-- -----------------------------------------------------------------------------------------------------------------------
-- 1. Создайте таблицу logs типа Archive.
-- Пусть при каждом создании записи в таблицах users, catalogs и products
-- в таблицу logs помещается
-- время и дата создания записи,
-- название таблицы,
-- идентификатор первичного ключа
-- содержимое поля name.
-- -----------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME NOT NULL,
	table_name VARCHAR(55) NOT NULL,
	tbl_id INT UNSIGNED NOT NULL,
	name VARCHAR(255) NOT NULL
) ENGINE = ARCHIVE;

-- Создаём тригер для users
DROP TRIGGER IF EXISTS users_to_logs;

DELIMITER //

CREATE TRIGGER users_to_logs AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, tbl_id, name)
		VALUES (NOW(), 'users', NEW.id, NEW.name);
END //

DELIMITER ;

-- Создаём тригер для catalogs
DROP TRIGGER IF EXISTS catalogs_to_logs;

DELIMITER //

CREATE TRIGGER catalogs_to_logs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, tbl_id, name)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //

DELIMITER ;

-- Создаём тригер для products
DROP TRIGGER IF EXISTS products_to_logs;

DELIMITER //

CREATE TRIGGER products_to_logs AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, tbl_id, name)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //

DELIMITER ;


-- 
-- Проверка
-- 
INSERT INTO users (name, birthday_at) VALUES ('Артём', '1997-10-11'), ('Данил', '2000-12-01');

SELECT * FROM users ORDER BY id DESC;
SELECT * FROM logs;

INSERT INTO catalogs (name) VALUES ('Аксесуары'), ('Лазерные принтеры'), ('МФУ');

SELECT * FROM catalogs ORDER BY id DESC;
SELECT * FROM logs;

INSERT INTO products (name, description, price, catalog_id)
VALUES ('XEROX Phaser 3020', 'Принтер лазерный XEROX Phaser 3020 лазерный, цвет: белый [p3020bi]', 7450.00, 7),
		('KYOCERA P3145dn', 'Принтер лазерный KYOCERA P3145dn лазерный, цвет: белый [1102tt3nl0]', 500.00, 14);

SELECT * FROM products ORDER BY id DESC;
SELECT * FROM logs;
