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
-- 3. (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
-- Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
-- Вызов функции FIBONACCI(10) должен возвращать число 55.
-- -----------------------------------------------------------------------------------------------------------------------
-- Функция с рекурсией не работает
-- Ошибка SQL Error [1424] [HY000]: Recursive stored functions and triggers are not allowed.
/*
DROP FUNCTION IF EXISTS fibonacci;
delimiter //

-- Данный вариант не работает
CREATE FUNCTION fibonacci(num INT) RETURNS INT NOT DETERMINISTIC
BEGIN
	IF (num <= 2) THEN
		RETURN num ;
	ELSE
		RETURN fibonacci(num - 1) + fibonacci(num - 2);
	END IF;
END//
delimiter ;
SELECT fibonacci(10);
-- Ошибка SQL Error [1424] [HY000]: Recursive stored functions and triggers are not allowed.
*/

-- Представленные ниже варианты 1 и 2 - рабочие.
--  
-- вариант 1
--  
DROP FUNCTION IF EXISTS fibonacci;
delimiter //

-- вариант 1
CREATE FUNCTION fibonacci(n INT) RETURNS INT NOT DETERMINISTIC
-- число должно быть не больше числа N = 25
BEGIN
 	DECLARE res INT;
	SELECT   fibonachi_num FROM (
	  SELECT Num, fibonachi_num FROM
		(SELECT @f := @i + @j AS fibonachi_num, @i := @j, @j := @f, @s := @s + 1 AS Num
	        FROM 
				(SELECT 0 t UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0)a,
				(SELECT 0 t UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0 UNION ALL SELECT 0)b,
				-- генерируется N = 25 записей.
		        (SELECT @i := 1, @j := 0) sel1, -- Объявляем две переменные @i, @j и присваиваем им 1 и 0.
		        (SELECT @s := 0) i  -- Объявляем переменную @s - используем для нумерации строк
	  LIMIT  25) fib
	) tbl WHERE Num = n LIMIT 1 INTO res;
	RETURN res;
END//

delimiter ;

SELECT 10, fibonacci(10), 15, fibonacci(25);

--  
-- вариант 2
--  
DROP FUNCTION IF EXISTS fibonacci_1;

delimiter //

-- вариант 2
CREATE FUNCTION fibonacci_1(n INT) RETURNS BIGINT NOT DETERMINISTIC
-- число должно быть не больше квадрата количества записей в таблице (max 81)
BEGIN
 	DECLARE res BIGINT;
	SELECT   fibonachi_num FROM (
	  SELECT Num, fibonachi_num FROM
		(SELECT @f := @i + @j AS fibonachi_num, @i := @j, @j := @f, @s := @s + 1 AS Num
	        FROM products a, products b, -- генерируется N*N записей (N - число записей в таблице).
		        (SELECT @i := 1, @j := 0) sel1 -- Объявляем две переменные @i, @j и присваиваем им 1 и 0.
		        , (SELECT @s := 0) i  -- Объявляем переменную @s - используем для нумерации строк
	  LIMIT 81) fib
	) tbl WHERE Num = n LIMIT 1 INTO res;
	RETURN res;
END//

delimiter ;


-- число должно быть не больше количества записей в таблице
SELECT @num := COUNT(*) FROM products;
SELECT @num * @num;

SELECT 10, fibonacci_1(10), 25, fibonacci_1(25), IF(@num * @num > 81, 81, @num * @num), fibonacci_1(IF(@num * @num > 81, 81, @num * @num));

