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
-- 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети
-- (критерии активности необходимо определить самостоятельно).
-- -----------------------------------------------------------------------------------------------------------------------
-- Критерий активности сумма балов:
-- 1 пост (posts) - 10 баллов;
-- 1 - лайк (likes) - 1 балл;
-- 1 - сообщение (messages) - 3 балла;
-- 1 - медиа-файл (media) - 5 баллов;
-- 1 - заявка на дружбу (friendship) - 3 балла.

SHOW TABLES;

-- Пользователи проявляющие наименьшую активность 
-- Активность расчитывается в балах (поле activities)
SELECT user_id,
	   SUM(post_bulls) + SUM(media_bulls) + SUM(messages_bulls) + SUM(likes_bulls) + SUM(friendship_bulls) AS activites,
      (SELECT CONCAT( first_name, ' ', last_name) FROM users WHERE id = tbl.user_id) AS fio
-- SELECT user_id, SUM(post_count), SUM(post_bulls), SUM(media_count), SUM(media_bulls), SUM(messages_count), SUM(messages_bulls), SUM(likes_count), SUM(likes_bulls), SUM(friendship_count), SUM(friendship_bulls)
FROM 
	(
		SELECT user_id, COUNT(1) AS post_count, COUNT(1) * 10 AS post_bulls, 0 AS media_count, 0 AS media_bulls, 0 AS messages_count, 0 AS messages_bulls, 0 AS likes_count, 0 AS likes_bulls, 0 AS friendship_count, 0 AS friendship_bulls
		FROM posts
		GROUP BY user_id
		 	UNION ALL
		SELECT user_id, 0 AS post_count, 0 AS post_bulls, COUNT(1) AS media_count, COUNT(1) * 5 AS media_bulls, 0 AS messages_count, 0 AS messages_bulls, 0 AS likes_count, 0 AS likes_bulls, 0 AS friendship_count, 0 AS friendship_bulls
		FROM media
		GROUP BY user_id
		 	UNION ALL
		SELECT from_user_id AS user_id, 0 AS post_count, 0 AS post_bulls, 0 AS media_count, 0 AS media_bulls, COUNT(1) AS messages_count, COUNT(1) * 3 AS messages_bulls, 0 AS likes_count, 0 AS likes_bulls, 0 AS friendship_count, 0 AS friendship_bulls
		FROM messages
		GROUP BY from_user_id
			UNION ALL
		SELECT user_id, 0 AS post_count, 0 AS post_bulls, 0 AS media_count, 0 AS media_bulls, 0 AS messages_count, 0 AS messages_bulls, COUNT(1) AS likes_count, COUNT(1)  AS likes_bulls, 0 AS friendship_count, 0 AS friendship_bulls
		FROM likes
		GROUP BY user_id
			UNION ALL
		SELECT user_id, 0 AS post_count, 0 AS post_bulls, 0 AS media_count, 0 AS media_bulls, 0 AS messages_count, 0 AS messages_bulls, 0 AS likes_count, 0 AS likes_bulls, COUNT(1) AS friendship_count, COUNT(1) * 3 AS friendship_bulls
		FROM friendship
		GROUP BY user_id
	) AS tbl
GROUP BY user_id
ORDER BY activites
LIMIT 10;