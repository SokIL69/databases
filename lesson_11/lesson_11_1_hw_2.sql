-- Бызы данных. Урок 11. Оптимизация запросов.

-- Практическое задание по теме “Оптимизация запросов”
-- 1. Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа и содержимое поля name.
-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.

USE vk;

-- -----------------------------------------------------------------------------------------------------------------------
-- 2. (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
-- -----------------------------------------------------------------------------------------------------------------------

-- Для задания создаём тестовую таблицу
DROP TABLE IF EXISTS users_test; 
CREATE TABLE users_test (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	email VARCHAR(100),
	phone VARCHAR(100),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS users_new_lines;

DELIMITER //

CREATE PROCEDURE users_new_lines(N int)
BEGIN
	DECLARE v1 int DEFAULT 1;
	WHILE v1 <= N DO
		INSERT users_test (first_name, last_name, email, phone)
			SELECT
				CONCAT(
					CHAR( FLOOR(65 + (RAND() * 25))),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97)
				), -- 
				CONCAT(
					CHAR( FLOOR(65 + (RAND() * 25))),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97),
				    CHAR(ROUND(RAND()*25)+97)
				),
				CONCAT(char(round(rand()*25)+97), CAST(FLOOR(1000000 + RAND()*8999999) AS CHAR), '@example.com'),
				CAST(FLOOR(1000000 + RAND()*8999999) AS CHAR);

			SET v1 = v1 + 1;
	
	END WHILE;
END//

DELIMITER ;


SET @N = 10; -- задаём @N = 1000000 и запускаем
CALL users_new_lines(@N);

SELECT * FROM users_test ORDER BY id DESC LIMIT 100;
