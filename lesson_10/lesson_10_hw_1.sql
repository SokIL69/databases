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
-- 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения
-- и добавить необходимые индексы.
-- -----------------------------------------------------------------------------------------------------------------------
-- На первичные и внешние ключи, а также уникальные значения индексы строятся автоматически

-- Таблица users
SHOW INDEX FROM users;
CREATE INDEX users_last_name_first_name_idx ON users (last_name, first_name);
-- users	0	PRIMARY	1	id	A	100				BTREE			YES	
-- users	0	email	1	email	A	100				BTREE			YES	
-- users	0	phone	1	phone	A	100				BTREE			YES	
-- users	1	users_last_name_first_name_idx	1	last_name	A	92				BTREE			YES	
-- users	1	users_last_name_first_name_idx	2	first_name	A	100				BTREE			YES	

-- Таблица profiles
SHOW INDEX FROM profiles;
CREATE INDEX profiles_country_city_idx ON profiles (country, city);
CREATE INDEX profiles_birthday_idx ON profiles (birthday);
-- profiles	0	PRIMARY	1	user_id	A	100				BTREE			YES	
-- profiles	1	profiles_country_city_idx	1	country	A	81			YES	BTREE			YES	
-- profiles	1	profiles_country_city_idx	2	city	A	100			YES	BTREE			YES	
-- profiles	1	profiles_birthday_idx	1	birthday	A	100			YES	BTREE			YES	

-- Таблица profiles
SHOW INDEX FROM media;
CREATE INDEX media_filename_idx ON media (filename);
-- media	0	PRIMARY	1	id	A	173				BTREE			YES	
-- media	1	media_media_type_id_fk	1	media_type_id	A	3				BTREE			YES	
-- media	1	media_user_id_fk	1	user_id	A	81				BTREE			YES	
-- media	1	media_filename_idx	1	filename	A	173				BTREE			YES	

-- Таблица profiles
SHOW INDEX FROM likes;
SELECT id, user_id, target_id, target_type_id, created_at FROM likes;
-- likes	0	PRIMARY	1	id	A	250				BTREE			YES	
-- likes	1	likes_target_type_id_fk	1	target_type_id	A	4				BTREE			YES	
-- likes	1	likes_user_id_fk	1	user_id	A	93				BTREE			YES	

-- Таблица posts
SHOW INDEX FROM posts;
-- posts	0	PRIMARY	1	id	A	100				BTREE			YES	
-- posts	1	posts_community_id_fk	1	community_id	A	8			YES	BTREE			YES	
-- posts	1	posts_media_id_fk	1	media_id	A	65			YES	BTREE			YES	
-- posts	1	posts_user_id_fk	1	user_id	A	68				BTREE			YES	

-- Для остальных таблиц достаточно индексов созданных автоматически


