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
-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
-- -----------------------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
DESCRIBE catalogs;
TRUNCATE TABLE catalogs;

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
SELECT * FROM catalogs;

DESCRIBE products;
TRUNCATE TABLE products;

INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Intel Core i3-8100', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 7890.00, 1),
  ('Intel Core i5-7400', 'Процессор для настольных персональных компьютеров, основанных на платформе Intel.', 12700.00, 1),
  ('AMD FX-8320E', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 4780.00, 1),
  ('AMD FX-8320', 'Процессор для настольных персональных компьютеров, основанных на платформе AMD.', 7120.00, 1),
  ('ASUS ROG MAXIMUS X HERO', 'Материнская плата ASUS ROG MAXIMUS X HERO, Z370, Socket 1151-V2, DDR4, ATX', 19310.00, 2),
  ('Gigabyte H310M S2H', 'Материнская плата Gigabyte H310M S2H, H310, Socket 1151-V2, DDR4, mATX', 4790.00, 2),
  ('MSI B250M GAMING PRO', 'Материнская плата MSI B250M GAMING PRO, B250, Socket 1151, DDR4, mATX', 5060.00, 2),
  ('MSI nVidia GeForce GT 710', 'Видеокарта MSI nVidia GeForce GT 710, GT 710 1GD3H LP, 1ГБ, DDR3, Low Profile, Ret', 2990.00, 3),
  ('GIGABYTE nVidia GeForce GT 710', 'Видеокарта GIGABYTE nVidia GeForce GT 710, GV-N710D5SL-2GL, 2ГБ, GDDR5, Low Profile, Ret', 3600.00, 3);

SELECT * FROM products;

-- 
-- Решение
-- 
-- 2. Выведите список товаров products и разделов catalogs, который соответствует товару.
SELECT p.id, p.name, p.description, c.name, c.id 
  FROM products p INNER JOIN
  	   catalogs c ON p.catalog_id = c.id
ORDER BY c.id;