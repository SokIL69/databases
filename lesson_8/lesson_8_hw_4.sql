-- Урок 8
-- Вебинар. Урок 8. Вебинар. Сложные запросы
-- 
-- Практическое задание по теме “Сложные запросы".
-- 
-- Переписать запросы, заданые к ДЗ урока 6, с использованием JOIN
-- Работаем с БД vk и тестовыми данными, которые вы сгенерировали ранее:
-- 
-- 
-- 3. Определить кто больше поставил лайков (всего) - мужчины или женщины?
-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).

USE vk;

-- -----------------------------------------------------------------------------------------------------------------------
-- 4. Подсчитать общее количество лайков десяти самым молодым пользователям (сколько лайков получили 10 самых молодых пользователей).
-- -----------------------------------------------------------------------------------------------------------------------
-- вариант с JOIN
-- Количество лайков которые получили пользователи как пользователи (без учёта лайков за контент)
SELECT profiles.user_id, birthday, COUNT(likes.id) AS likes_total
  FROM profiles
   	   LEFT JOIN likes ON likes.target_id = profiles.user_id AND likes.target_type_id = 2
 GROUP BY profiles.user_id
 ORDER BY birthday DESC LIMIT 10

 -- Суммируем
SELECT SUM(likes_total)
FROM (
		SELECT COUNT(likes.id) AS likes_total
		  FROM profiles
		       LEFT JOIN likes ON likes.target_id = profiles.user_id AND likes.target_type_id = 2
		 GROUP BY profiles.user_id
		 ORDER BY birthday DESC LIMIT 10
) AS user_likes;

-- Проверка
 SELECT profiles.user_id, birthday, likes.*
  FROM profiles
   LEFT JOIN likes ON likes.target_id = profiles.user_id AND likes.target_type_id = 2
  WHERE birthday >= '2015-05-12'
  ORDER BY birthday DESC;
 
-- ------------------------------------------------------------------------------
-- Вариант с подсчётом лайков за всё включая медиафайлы, посты и сообщения.
SELECT tbl.user_id, tbl.birthday, SUM(likes) AS likes
FROM (
   (SELECT profiles.user_id, birthday, likes.user_id AS target_id, COUNT(likes.id) AS likes
	  FROM likes
	 	   RIGHT JOIN profiles ON likes.user_id = profiles.user_id AND likes.target_type_id != 2
	 GROUP BY profiles.user_id
	 ORDER BY birthday DESC LIMIT 10 )
		UNION
   (SELECT profiles.user_id, birthday, likes.target_id, COUNT(likes.id) AS likes
	  FROM profiles
	       LEFT JOIN likes ON likes.target_id = profiles.user_id AND likes.target_type_id = 2
	 GROUP BY profiles.user_id
	 ORDER BY birthday DESC LIMIT 10 )
) AS tbl
GROUP BY tbl.user_id, tbl.birthday
ORDER BY tbl.birthday DESC;
-- ------------------------------------------------------------------------------- --
