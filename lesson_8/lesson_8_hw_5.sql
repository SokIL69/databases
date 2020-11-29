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
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).
-- -----------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------
-- Критерий активности сумма балов:
-- 1 - пост (posts) - 10 баллов;
-- 1 - лайк (likes) - 1 балл;
-- 1 - сообщение (messages) - 3 балла;
-- 1 - медиа-файл (media) - 5 баллов;
-- 1 - заявка на дружбу (friendship) - 3 балла.

SHOW TABLES;

-- Пользователи проявляющие наименьшую активность 
-- Активность расчитывается в балах (поле activities)
SELECT user_id,
	   SUM(post_bulls) + SUM(media_bulls) + SUM(messages_bulls) + SUM(likes_bulls) + SUM(friendship_bulls) + SUM(fri_1_bulls) AS activites,
      (SELECT CONCAT( first_name, ' ', last_name) FROM users WHERE id = tbl.user_id) AS fio
FROM 
	(
		SELECT user_id, COUNT(1) * 10 AS post_bulls, 0 AS media_bulls, 0 AS messages_bulls, 0 AS likes_bulls, 0 AS friendship_bulls, 0 AS fri_1_bulls
		FROM posts
		GROUP BY user_id
		 	UNION ALL
		SELECT user_id, 0 AS post_bulls, COUNT(1) * 5 AS media_bulls, 0 AS messages_bulls, 0 AS likes_bulls, 0 AS friendship_bulls, 0 AS fri_1_bulls
		FROM media
		GROUP BY user_id
		 	UNION ALL
		SELECT from_user_id AS user_id, 0 AS post_bulls, 0 AS media_bulls, COUNT(1) * 3 AS messages_bulls, 0 AS likes_bulls, 0 AS friendship_bulls, 0 AS fri_1_bulls
		FROM messages
		GROUP BY from_user_id
			UNION ALL
		SELECT user_id, 0 AS post_bulls, 0 AS media_bulls, 0 AS messages_bulls, COUNT(1)  AS likes_bulls, 0 AS friendship_bulls, 0 AS fri_1_bulls
		FROM likes
		GROUP BY user_id
			UNION ALL
		SELECT user_id, 0 AS post_bulls, 0 AS media_bulls, 0 AS messages_bulls, 0 AS likes_bulls, COUNT(1) * 3 AS friendship_bulls, 0 AS fri_1_bulls
		FROM friendship
		GROUP BY user_id
			UNION ALL
		SELECT friend_id AS user_id, 0 AS post_bulls, 0 AS media_bulls, 0 AS messages_bulls, 0 AS likes_bulls, 0 AS friendship_bulls, COUNT(1) * 3 AS fri_1_bulls
		FROM friendship fr_1
		GROUP BY fr_1.friend_id
	) AS tbl
GROUP BY user_id 
ORDER BY activites, fio LIMIT 10;

-- Вариант с JOIN
SELECT user_id, SUM(likes_id) AS activites, fio
FROM 
(	SELECT users.id AS user_id, CONCAT(users.first_name, ' ', users.last_name) AS fio, IF (likes.id IS NULL, likes.id, 1) AS likes_id
	  FROM users
	  	   LEFT JOIN likes ON likes.user_id = users.id
	UNION ALL 	
	SELECT users.id AS user_id, CONCAT(users.first_name, ' ', users.last_name) AS fio, IF (posts.id IS NULL, posts.id, 10) AS post_id
	  FROM users
		   LEFT JOIN posts ON posts.user_id = users.id
	UNION ALL
	SELECT users.id AS user_id, CONCAT(users.first_name, ' ', users.last_name) AS fio, IF (media.id IS NULL, media.id, 5) AS media_id
	  FROM users
		   LEFT JOIN media ON media.user_id = users.id
	UNION ALL
	SELECT users.id AS user_id, CONCAT(users.first_name, ' ', users.last_name) AS fio, IF (messages.id IS NULL, messages.id, 3) AS messages_id
	  FROM users
	  	   LEFT JOIN messages ON messages.from_user_id = users.id
	UNION ALL
	SELECT users.id AS user_id, CONCAT(users.first_name, ' ', users.last_name) AS fio, IF (fsh_1.user_id IS NULL, fsh_1.user_id, 3) AS fr_user_id
	  FROM users
		   LEFT JOIN friendship fsh_1 ON fsh_1.user_id = users.id
	UNION ALL
    SELECT users.id AS user_id, CONCAT(users.first_name, ' ', users.last_name) AS fio, IF (fsh_2.friend_id IS NULL, fsh_2.friend_id, 3) AS friendship_id
	  FROM users
	  	   LEFT JOIN friendship fsh_2 ON fsh_2.friend_id = users.id
) AS tbl_1 
GROUP BY user_id, fio  
ORDER BY activites, fio LIMIT 10;


-- -------------------------------------------------------------------------------------- --
-- 
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети 
-- 
SELECT 
  CONCAT(first_name, ' ', last_name) AS fio, 
	(SELECT COUNT(*) FROM likes WHERE likes.user_id = users.id) + 
	(SELECT COUNT(*) FROM media WHERE media.user_id = users.id) + 
	(SELECT COUNT(*) FROM messages WHERE messages.from_user_id = users.id) AS overall_activity 
	  FROM users
ORDER BY overall_activity, fio
LIMIT 10;
	 
-- Вариант с JOIN
SELECT CONCAT(first_name, ' ', last_name) AS fio,
	   COUNT(likes.id) + COUNT(media.id) + COUNT(messages.id) AS activity 
  FROM users
  	LEFT JOIN likes ON likes.user_id = users.id
  	LEFT JOIN media ON media.user_id = users.id
  	LEFT JOIN messages ON messages.from_user_id = users.id
GROUP BY fio
ORDER BY activity, fio LIMIT 10;

-- Вариант с JOIN
SELECT fio, SUM(activity) AS activity
FROM 
(	SELECT CONCAT(first_name, ' ', last_name) AS fio,
		   IF (likes.id IS NULL, 0, 1) + 
		   IF (media.id IS NULL, 0, 1) +
		   IF (messages.id IS NULL, 0, 1) AS activity
	  FROM users
	  	LEFT JOIN likes ON likes.user_id = users.id
	  	LEFT JOIN media ON media.user_id = users.id
	  	LEFT JOIN messages ON messages.from_user_id = users.id
	ORDER BY CONCAT(first_name, ' ', last_name)
) AS tbl
GROUP BY fio 
ORDER BY activity, fio LIMIT 10;
