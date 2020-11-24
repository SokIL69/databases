-- Урок 7
-- Видеоурок. Сложные запросы
-- 
-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.

USE shop;
SHOW TABLES;

-- -----------------------------------------------------------------------------------------------------------------------
-- 1. Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
-- -----------------------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
DESCRIBE users;

TRUNCATE TABLE users;
INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Илья', '1989-10-15')
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Пётр', '2000-01-22'),
  ('Михаил', '1980-01-01'),
  ('Мария', '1992-08-29');

SELECT * FROM users; 

DESCRIBE orders;

TRUNCATE TABLE orders;
INSERT orders (user_id) VALUES (1), (3), (4), (1), (8), (9), (5), (5), (5);
SELECT * FROM orders;

-- 
-- Решение
-- 
-- 1. Cписок пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
SELECT DISTINCT users.id, users.name
FROM users INNER JOIN 
		orders ON users.id = orders.user_id;

-- Cписок пользователей users сделавших заказ и их заказы.
SELECT o.id AS order_id, u.name, o.created_at AS order_date, o.user_id
  FROM users u INNER JOIN 
	  orders o ON u.id = o.user_id
ORDER BY o.user_id;
	 
-- Cписок пользователей users и их заказов если они есть.
SELECT u.id, u.name, o.id AS order_id, o.created_at AS order_date
FROM users u LEFT OUTER JOIN 
	orders o ON u.id = o.user_id
ORDER BY u.id;
