-- Урок 10.
-- 
-- Практическое задание по теме “Транзакции, переменные, представления. Администрирование. Хранимые процедуры и функции, триггеры"
-- (Инлексы, Оконные функции)
-- 
-- 
-- Задания на БД vk:
-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.
-- 2. Задание на оконные функции. Построить запрос, который будет выводить следующие столбцы:
-- - имя группы;
-- - среднее количество пользователей в группах;
-- - самый молодой пользователь в группе;
-- - самый старший пользователь в группе;
-- - общее количество пользователей в группе;
-- - всего пользователей в системе;
-- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.

USE vk;

-- -----------------------------------------------------------------------------------------------------------------------
-- 2. Задание на оконные функции.
-- Построить запрос, который будет выводить следующие столбцы:
-- - имя группы;
-- - среднее количество пользователей в группах;
-- - самый молодой пользователь в группе;
-- - самый старший пользователь в группе;
-- - общее количество пользователей в группе;
-- - всего пользователей в системе;
-- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
-- -----------------------------------------------------------------------------------------------------------------------
       
-- SELECT ROUND(4.51)

-- Применяем чистые оконные функции
SELECT   name
	   , AVG(group_total) OVER() AS average -- среднее количество пользователей в группах;
 	   , first -- самый молодой пользователь в группе;
 	   , last -- самый старший пользователь в группе;
 	   , total -- всего пользователей в системе;
 	   , group_total -- всего пользователей в группе;
 	   , `%%` 	  -- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
FROM 
(
	SELECT DISTINCT cm_u.community_id, cm.name -- , cm_u.user_id, prf.birthday
	 	  , FIRST_VALUE(prf.birthday) OVER w AS 'first' -- самый молодой пользователь в группе;
	 	  , LAST_VALUE(birthday) OVER w1 AS 'last' -- самый старший пользователь в группе;
		  -- , COUNT(community_id) OVER() AS total_1 -- всего пользователей в системе;
	 	  , SUM(1) OVER() AS total -- всего пользователей в системе;
	      , SUM(1) OVER w1 AS group_total -- всего пользователей в группе;
		  , SUM(1) OVER w1 / SUM(1) OVER() * 100 AS "%%" -- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
	  FROM communities_users cm_u
			JOIN communities cm ON cm.id = cm_u.community_id
			JOIN profiles prf ON prf.user_id = cm_u.user_id
			WINDOW w  AS (PARTITION BY cm_u.community_id ORDER BY cm_u.community_id, birthday)
		 		 , w1 AS (PARTITION BY cm_u.community_id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
) tbl;
	

SELECT /*DISTINCT*/ cm_u.community_id, cm.name , cm_u.user_id, prf.birthday
 	  , FIRST_VALUE(prf.birthday) OVER w AS 'first' -- самый молодой пользователь в группе;
 	  , LAST_VALUE(birthday) OVER w1 AS 'last' -- самый старший пользователь в группе;
	  -- , COUNT(community_id) OVER() AS total_1 -- всего пользователей в системе;
 	  , SUM(1) OVER() AS total -- всего пользователей в системе;
      , SUM(1) OVER w1 AS group_total -- всего пользователей в группе;
	  , SUM(1) OVER w1 / SUM(1) OVER() * 100 AS "%%" -- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
  FROM communities_users cm_u
		JOIN communities cm ON cm.id = cm_u.community_id
		JOIN profiles prf ON prf.user_id = cm_u.user_id
		WINDOW w  AS (PARTITION BY cm_u.community_id ORDER BY cm_u.community_id, birthday)
	 		 , w1 AS (PARTITION BY cm_u.community_id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)


     
-- windowing_clause												Description
-- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW			Последняя строка в окне изменяется с изменением текущей строки (по умолчанию)
-- RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING			Первая строка в окне изменяется с изменением текущей строки
-- RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING	Все строки включены в окно независимо от текущей строки