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
-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.
-- -----------------------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
  id SERIAL PRIMARY KEY,
  `from` VARCHAR(255) COMMENT 'Откуда',
  `to` VARCHAR(255) COMMENT 'Куда'
) COMMENT = 'Таблица рейсов';

-- TRUNCATE TABLE flights;
INSERT INTO flights VALUES
  (NULL, 'Moscow', 'Berlin'),
  (NULL, 'Moscow', 'Rome'),
  (NULL, 'Berlin', 'Rome'),
  (NULL, 'Bratislava', 'Cairo'),
  (NULL, 'Moscow', 'Madrid'),
  (NULL, 'Madrid', 'Moscow'),
  (NULL, 'Cairo', 'Berlin');

SELECT * FROM flights;

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id SERIAL PRIMARY KEY,
  label VARCHAR(255) COMMENT 'Название города (англ.)',
  name VARCHAR(255) COMMENT 'Название города'
) COMMENT = 'Города';

-- TRUNCATE TABLE cities;
INSERT INTO cities VALUES
  (NULL, 'Moscow', 'Москва'),
  (NULL, 'Berlin', 'Берлин'),
  (NULL, 'Bratislava','Братислава'),
  (NULL, 'Cairo', 'Каир'),
  (NULL, 'Madrid', 'Мадрид'),
  (NULL, 'Rome', 'Рим');
 
SELECT * FROM cities;

-- 
-- Решение
-- 
-- 3. (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
-- Поля from, to и label содержат английские названия городов, поле name — русское.
-- Выведите список рейсов flights с русскими названиями городов.
SELECT fl.id, fl.`from`, ct1.name, fl.`to`, ct2.name
  FROM flights fl INNER JOIN 
  	   cities ct1 ON fl.`from` = ct1.label INNER JOIN
  	   cities ct2 ON fl.`to` = ct2.label
 ORDER BY fl.id;
