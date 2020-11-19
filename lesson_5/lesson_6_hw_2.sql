-- 
-- Урок 5
-- Практическое задание теме «Агрегация данных»
-- 
-- 1. Подсчитайте средний возраст пользователей в таблице users.
-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
--    Следует учесть, что необходимы дни недели текущего года, а не года рождения.
-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы.

SELECT DATABASE();

USE shop;

-- -------------------------------------------------------------
-- 1. Подсчитайте средний возраст пользователей в таблице users. 
-- -------------------------------------------------------------
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

-- 
-- Выполнение задания
-- 

SELECT NULL AS year, AVG( YEAR(NOW()) -  YEAR(birthday_at) ) AS avr_age
  FROM users;

SELECT CAST( YEAR(birthday_at) AS char) AS year, YEAR(NOW()) -  YEAR(birthday_at) AS age
  FROM users
UNION
SELECT 'Средний возраст:' AS year, AVG( YEAR(NOW()) -  YEAR(birthday_at) ) AS age -- avr_age
  FROM users;

-- -------------------------------------------------------------------------------------
-- 2. Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
--    Следует учесть, что необходимы дни недели текущего года, а не года рождения.
-- -------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
TRUNCATE TABLE users;

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Илья', '1989-10-15'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Пётр', '2000-01-22'),
  ('Михаил', '1980-01-01'),
  ('Мария', '1992-08-29'); 
 
-- 
-- Выполнение задания
-- 
SELECT id, birthday_at, DAYOFWEEK(birthday_at) as day, DAYNAME(birthday_at) as dayname FROM users;
-- SELECT CONCAT(CAST( DAY(NOW()) AS char), '.', CAST(MONTH(NOW()) AS char), '.2020');
-- SELECT STR_TO_DATE(CONCAT(CAST( DAY(NOW()) AS char), '.', CAST(MONTH(NOW()) AS char), '.2020'), '%d.%m.%Y');

SELECT 
	id,
	name,
	birthday_at,
	STR_TO_DATE(CONCAT(CAST( DAY(birthday_at) AS char), '.', CAST(MONTH(birthday_at) AS char), '.2020'), '%d.%m.%Y') AS day_in_this_year,
	DAYOFWEEK(STR_TO_DATE(CONCAT(CAST( DAY(birthday_at) AS char), '.', CAST(MONTH(birthday_at) AS char), '.2020'), '%d.%m.%Y')) AS day,
	DAYNAME(STR_TO_DATE(CONCAT(CAST( DAY(birthday_at) AS char), '.', CAST(MONTH(birthday_at) AS char), '.2020'), '%d.%m.%Y')) AS dayname
  FROM users
 ORDER BY day;
  
SELECT DAYNAME(STR_TO_DATE(CONCAT(CAST( DAY(birthday_at) AS char), '.', CAST(MONTH(birthday_at) AS char), '.2020'), '%d.%m.%Y')) AS dayname,
	   SUM(1) AS 'кол-во дней рождения',
	   DAYOFWEEK(STR_TO_DATE(CONCAT(CAST( DAY(birthday_at) AS char), '.', CAST(MONTH(birthday_at) AS char), '.2020'), '%d.%m.%Y')) AS day
  FROM users
 GROUP BY day, dayname;
 
-- -----------------------------------------------------------------
-- 3. (по желанию) Подсчитайте произведение чисел в столбце таблицы. 
-- -----------------------------------------------------------------
-- 
-- Подготовка данных
-- 
TRUNCATE TABLE tmp;

CREATE TEMPORARY TABLE tmp (id SERIAL PRIMARY KEY, value INT);
INSERT INTO tmp (value) VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (-1), (-2), (0);
SELECT * FROM tmp;
-- 
-- Решение
-- 
SELECT @var := SUM(1)%2 FROM tmp WHERE value < 0; # определяем чётное или нечётное количество отрицательных значений
SELECT @var_0 := SUM(1) FROM tmp WHERE value = 0; # определяем, есть ли среди значений 0
-- 
-- 2*3*4*5 = exp(ln(2) + ln(3) + ln(4) + ln(5)) = exp(ln(2*3*4*5))
-- 
SELECT IF( @var_0 > 0, 0, EXP(SUM(LN(ABS(value))))*IF(@var > 0, -1, 1) ) FROM tmp;
# если есть значения = 0, возвращаем 0
# количество отрицательных значений чётное возвращаем произведение
# количество отрицательных значений нечётное возвращаем результат умножаем на -1

-- SELECT SIGN(value) FROM tmp;
-- SELECT @@sort_buffer_size;
-- SELECT SUM(1), SUM(1) DIV 2, SUM(1)%2  FROM tmp WHERE value < 0;
