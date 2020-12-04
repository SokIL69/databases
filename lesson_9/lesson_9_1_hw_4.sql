-- Урок 9.
-- Видеоурок. Транзакции, переменные, представления. Администрирование. Хранимые процедуры и функции, триггеры
-- 
-- Практическое задание по теме “Транзакции, переменные, представления”.
-- 
-- 
-- 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.
-- 2. Создайте представление, которое выводит название name товарной позиции из таблицы products
-- и соответствующее название каталога name из таблицы catalogs.
-- 3. (по желанию) Пусть имеется таблица с календарным полем created_at. В ней размещены
-- разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17.
-- Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1,
-- если дата присутствует в исходном таблице и 0, если она отсутствует.
-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at.
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежихзаписей.

USE shop;

-- -----------------------------------------------------------------------------------------------------------------------
-- 4. (по желанию) Пусть имеется любая таблица с календарным полем created_at.
-- Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
-- -----------------------------------------------------------------------------------------------------------------------
-- SHOW TABLES;

DROP TABLE IF EXISTS tbl_task_3;
CREATE TABLE tbl_task_3 (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Урок 9 Пример 3";

INSERT INTO tbl_task_3 (name, created_at) VALUES
	('position 1', '2020-12-02 23:58:18.0'),
	('position 2', '2020-12-03 23:58:18.0'),
	('position 3', '2020-12-04 23:58:18.0'),
	('position 4', '2020-12-05 23:58:18.0'),
	('position 5', '2020-12-06 23:58:18.0'),
	('position 6', '2020-12-07 23:58:18.0'),
	('position 7', '2020-12-08 23:58:18.0'),
	('position 8', '2020-12-09 23:58:18.0'),
	('position 9', '2020-12-10 23:58:18.0'),
	('position 10',	'2020-12-11 23:58:18.0');

SELECT * FROM tbl_task_3 ORDER BY created_at DESC;

START TRANSACTION;

-- Выводим записи которые мы собираемся удалить
SELECT * FROM tbl_task_3
WHERE created_at NOT IN (
	SELECT created_at
	  FROM (
			  SELECT created_at, id
			    FROM tbl_task_3
			   ORDER BY created_at DESC LIMIT 5
			) v1) ;

-- Удаляем лишние записи
DELETE FROM tbl_task_3
WHERE created_at NOT IN (
	SELECT *
	  FROM (
			  SELECT created_at
				FROM tbl_task_3
			   ORDER BY created_at DESC LIMIT 5) v1
			) ;

SELECT * FROM tbl_task_3 ORDER BY created_at DESC;

ROLLBACK;
-- COMMIT;


/*
SELECT count(*), id
FROM tbl_task_3 
GROUP BY id
HAVING count(*)  = 1
ORDER BY id DESC;
*/
