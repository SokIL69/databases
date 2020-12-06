USE vk;

-- 1 вариант. При таком способе объединения таблиц в отчёт не попадут группы без пользователей и пользователи, которые не входят ни в одну из групп.
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
	 		 

-- 2 вариант. В отчёт включены все группы, в том числе группы без пользователей и пользователи, которые не входят ни в одну из групп.
-- 
-- INSERT INTO vk.users (first_name, last_name, email, phone) VALUES('Иван', 'Иванов', 'ii@mail.ru', '8-(999)-78986563');
-- INSERT INTO vk.profiles (user_id, gender, birthday, city, country, created_at, updated_at) VALUES(101, 'M', '1999-11-13', 'Moscow', 'Russia', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- INSERT INTO vk.communities (name, created_at, updated_at) VALUES('Машинное обучение, AI, нейронные сети, Big Data', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
-- 	 	

SELECT   name
	   , AVG(group_total) OVER() AS average -- среднее количество пользователей в группах;
 	   , first -- самый молодой пользователь в группе;
 	   , last -- самый старший пользователь в группе;
 	   , total -- всего пользователей в системе;
 	   , group_total -- всего пользователей в группе;
 	   , `%%` 	  -- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
FROM 
(	 		 
SELECT DISTINCT id, name
 	  , FIRST_VALUE(birthday) OVER w AS 'first' -- самый молодой пользователь в группе;
 	  , LAST_VALUE(birthday) OVER w1 AS 'last' -- самый старший пользователь в группе;
	  , COUNT(user_id) OVER() AS total -- всего пользователей в системе;
      , COUNT(user_id) OVER w1 AS group_total -- всего пользователей в группе;
	  , COUNT(user_id) OVER w1 / COUNT(user_id) OVER() * 100 AS "%%" -- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
  FROM
		(
		SELECT prf.user_id, prf.birthday, cm_u.community_id, cm.id, cm.name
			FROM profiles prf 
				LEFT JOIN communities_users cm_u ON prf.user_id = cm_u.user_id
				LEFT JOIN communities cm ON cm.id = cm_u.community_id
		UNION ALL
		SELECT prf.user_id, prf.birthday, cm_u.community_id, cm.id, cm.name
			FROM profiles prf 
				LEFT JOIN communities_users cm_u ON prf.user_id = cm_u.user_id
				RIGHT JOIN communities cm ON cm.id = cm_u.community_id
			WHERE prf.user_id IS NULL
		) tbl
		WINDOW w  AS (PARTITION BY tbl.id ORDER BY tbl.id),
	 		 w1 AS (PARTITION BY tbl.id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
-- ORDER BY id DESC; -- , birthday, user_id DESC;
) tbl_1;
-- Результат
-- ---------------------------------------------------------------------------------------- --
-- 9	Машинное обучение, AI, нейронные сети, Big Data			101	0	0.0000 -- Группа не содержащая ни одного пользователя
-- 8	Лаборатория 3D-моделирования ПГНИУ	1977-10-09	2017-10-31	101	10	9.9010
-- 7	Основы интеллектуальных систем, компьютерного зрения	1971-08-18	2009-11-14	101	10	9.9010
-- 6	Центр робототехники и интеллектуальных систем	1972-04-11	2015-11-04	101	12	11.8812
-- 5	Raspberry Pi	1973-10-22	2018-07-20	101	21	20.7921
-- 4	Ардуино Arduino Пермь	1972-08-14	2016-06-04	101	13	12.8713
-- 3	Сетевой ИТ-Университет	1971-10-18	2020-03-30	101	16	15.8416
-- 2	GeekBrains	1970-05-11	2011-04-27	101	11	10.8911
-- 1	Занимательная робототехника	1970-02-19	2015-05-12	101	7	6.9307
-- 		1999-11-13	1999-11-13	101	1	0.9901 								-- Пользователь не вошедший ни в одну группу
-- ---------------------------------------------------------------------------------------- -- 

-- 
-- Проверка
-- 
SELECT /*DISTINCT*/ id, name, user_id, birthday
 	  , FIRST_VALUE(birthday) OVER w AS 'first' -- самый молодой пользователь в группе;
 	  , LAST_VALUE(birthday) OVER w1 AS 'last' -- самый старший пользователь в группе;
	  , COUNT(user_id) OVER() AS total -- всего пользователей в системе;
      , COUNT(user_id) OVER w1 AS group_total -- всего пользователей в группе;
	  , COUNT(user_id) OVER w1 / COUNT(user_id) OVER() * 100 AS "%%" -- - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100.
  FROM
		(
		SELECT prf.user_id, prf.birthday, cm_u.community_id, cm.id, cm.name
			FROM profiles prf 
				LEFT JOIN communities_users cm_u ON prf.user_id = cm_u.user_id
				LEFT JOIN communities cm ON cm.id = cm_u.community_id
		UNION ALL
		SELECT prf.user_id, prf.birthday, cm_u.community_id, cm.id, cm.name
			FROM profiles prf 
				LEFT JOIN communities_users cm_u ON prf.user_id = cm_u.user_id
				RIGHT JOIN communities cm ON cm.id = cm_u.community_id
			WHERE prf.user_id IS NULL
		) tbl
		WINDOW w  AS (PARTITION BY tbl.id ORDER BY tbl.id)
	 		 , w1 AS (PARTITION BY tbl.id RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
ORDER BY id DESC, birthday, user_id DESC;

-- В запрос включены группы без пользователей и пользователи, которые не входят ни в одну из групп 	 
SELECT prf.user_id, prf.birthday, cm_u.community_id, cm.id, cm.name
	FROM profiles prf 
		LEFT JOIN communities_users cm_u ON prf.user_id = cm_u.user_id
		LEFT JOIN communities cm ON cm.id = cm_u.community_id
UNION ALL
SELECT prf.user_id, prf.birthday, cm_u.community_id, cm.id, cm.name
	FROM profiles prf 
		LEFT JOIN communities_users cm_u ON prf.user_id = cm_u.user_id
		RIGHT JOIN communities cm ON cm.id = cm_u.community_id
	WHERE prf.user_id IS NULL
ORDER BY id, user_id DESC;

		
