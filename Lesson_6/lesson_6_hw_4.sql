-- Урок 6
-- Вебинар. Операторы, фильтрация, сортировка и ограничение. Агрегация данных
-- 
-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение.
-- Агрегация данных
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:
-- 1. Создать и заполнить таблицы лайков и постов.
-- 2. Создать все необходимые внешние ключи и диаграмму отношений.
-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).

USE vk;

-- -----------------------------------------------------------------------------------------------------------------------
-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
-- -----------------------------------------------------------------------------------------------------------------------
-- 
-- Подсчитать общее количество лайков десяти самым молодым пользователям
-- Для решения задачи, необходимо брать поле user_id из на которую ссылается поле target_id таблицы likes.
-- Считаем что это таблца постов posts.
-- 

DROP TABLE IF EXISTS tmp;
-- CREATE TEMPORARY TABLE tmp (user_id INT, birthday DATE, count INT, fio VARCHAR(255));
CREATE TABLE tmp (user_id INT, birthday DATE, likes_count INT, posts_count INT, fio VARCHAR(255));

-- Добавлем в таблицу tmp - 10 самых молодых пользователя
INSERT INTO tmp 
	SELECT user_id, birthday, 0, 0, (SELECT CONCAT( first_name, ' ', last_name) FROM users WHERE id = profiles.user_id)
	  FROM profiles
	 ORDER BY birthday DESC LIMIT 10;

SELECT * FROM tmp;
	   
-- Обновляем общее количество постов у 10 самых молодых пользователей
UPDATE tmp AS t1, -- Не работает с временной таблицей
	(
		SELECT COUNT(1) AS posts_count,
			   user_id
		  FROM posts
		 WHERE user_id IN (SELECT user_id FROM tmp)
		GROUP BY user_id
	) AS t2
SET t1.posts_count = t2.posts_count
WHERE t1.user_id = t2.user_id

SELECT * FROM tmp;

-- Обновляем количество лайков у 10 самых молодых пользователей
UPDATE tmp AS t1, -- Не работает с временной таблицей
	(
		SELECT 	user_id_new AS user_id,
				COUNT(1) AS likes_count
		 FROM
			 (
				SELECT  target_id,
						(
							SELECT user_id
							   FROM posts
							  WHERE id = likes.target_id
									-- AND	user_id IN ( SELECT user_id FROM profiles  ORDER BY birthday DESC LIMIT 10)
								  	-- This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'
								  	-- Поэтому используем временную таблицу
									AND  user_id IN (SELECT user_id FROM tmp)
						) AS user_id_new
				  FROM likes
				HAVING user_id_new IS NOT NULL
			 ) AS young
		GROUP BY user_id_new
		ORDER BY user_id_new
	) AS t2
SET t1.likes_count = t2.likes_count
WHERE t1.user_id = t2.user_id

SELECT * FROM tmp;


SELECT 'Общее количество лайков десяти самых молодых пользователей:'
 	UNION 
SELECT CONCAT('Пользователь - ', fio, ', родился ',birthday , '. Он написал ', posts_count, ' пост(а/ов) и получил ', likes_count, ' лайк(а/ов) за свои посты.') AS message FROM tmp;


DROP TABLE IF EXISTS tmp;
-- ------------------------------------------------------------------------------------------------------



-- ------------------------------------------------------------------------------------------------------
-- Пояснения к решению
-- ------------------------------------------------------------------------------------------------------
SELECT user_id, birthday FROM profiles ORDER BY birthday DESC LIMIT 10;

-- Посты десяти самым молодым пользователям
SELECT DISTINCT user_id, id
		   FROM posts
		  WHERE user_id IN ( SELECT user_id FROM tmp);

-- Лайки к постам десяти самым молодым пользователям
SELECT	target_id,
		(SELECT user_id
		   FROM posts
		  WHERE id = likes.target_id
			  	-- AND	user_id IN ( SELECT user_id FROM profiles  ORDER BY birthday DESC LIMIT 10)
			  	-- This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'
			  	-- Поэтому используем временную таблицу
				AND  user_id IN (SELECT user_id FROM tmp)
		) AS user_id_new -- идентификатор пользольвателя входящего в десятку самых молодых
  FROM likes
HAVING user_id_new IS NOT NULL


-- Количество лайков к постам самых молодых пользователей
SELECT 	user_id_new AS user_id,
		COUNT(1) AS COUNT,
  	    (SELECT CONCAT( first_name, ' ', last_name) FROM users WHERE id = young.user_id_new) 
 FROM
	 (
		SELECT  target_id,
				(SELECT user_id
				   FROM posts
				  WHERE id = likes.target_id
					  	-- AND	user_id IN ( SELECT user_id FROM profiles  ORDER BY birthday DESC LIMIT 10)
					  	-- This version of MySQL doesn't yet support 'LIMIT & IN/ALL/ANY/SOME subquery'
					  	-- Поэтому используем временную таблицу
						AND  user_id IN (SELECT user_id FROM tmp)
				) AS user_id_new
		  FROM likes
		HAVING user_id_new IS NOT NULL
	 ) AS young
GROUP BY user_id_new
ORDER BY user_id_new;

-- ------------------------------------------------------------------------------------------------------


/*
UPDATE users t1,
  (
  SELECT *
    FROM (
      SELECT f1,f2
        FROM users       
        WHERE login = 'user1'
    ) t2
SET t1.f1 = t2.f1, t1,f2 = t2.f2
WHERE login = 'user2'

 
UPDATE table_1 AS tbl_1
    INNER JOIN(
        SELECT type, COUNT(*) AS cnt
        FROM table_1
        GROUP BY type
    ) AS tbl_2 USING(type)
SET tbl_1.cnt = tbl_2.cnt;
*/