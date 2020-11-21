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
SELECT DATABASE();

USE vk;

-- -----------------------------------------------------------------------------------------------------------------------
-- 2. Создать все необходимые внешние ключи и диаграмму отношений.
-- -----------------------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
SHOW TABLES;
-- 

-- Добавляем внешние ключи
DESCRIBE profiles;

ALTER TABLE profiles 
	ADD CONSTRAINT profiles_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id)ON DELETE CASCADE;

DESCRIBE messages;
DESCRIBE media_types;

ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk FOREIGN KEY (to_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_media_id_fk FOREIGN KEY (media_id) REFERENCES media(id);
 
DESCRIBE communities; 
DESCRIBE communities_users;

ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_community_id_fk FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT communities_users_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);


DESCRIBE friendship; 
DESCRIBE friendship_statuses;

ALTER TABLE friendship
  ADD CONSTRAINT friendship_community_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_community_friend_id_fk FOREIGN KEY (friend_id) REFERENCES users(id),
  ADD CONSTRAINT friendship_status_id_fk FOREIGN KEY (status_id) REFERENCES friendship_statuses(id);

 
DESCRIBE media; 
DESCRIBE media_types;

ALTER TABLE media
  ADD CONSTRAINT media_media_type_id_fk FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  ADD CONSTRAINT media_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);
 

DESCRIBE posts; 
DESCRIBE communities;

ALTER TABLE posts
  ADD CONSTRAINT posts_community_id_fk FOREIGN KEY (community_id) REFERENCES communities(id),
  ADD CONSTRAINT posts_media_id_fk FOREIGN KEY (media_id) REFERENCES media(id),
  ADD CONSTRAINT posts_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);
 
DESCRIBE likes; 
DESCRIBE target_types;

ALTER TABLE likes
  ADD CONSTRAINT likes_target_type_id_fk FOREIGN KEY (target_type_id) REFERENCES target_types(id),
  ADD CONSTRAINT likes_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);

 -- Смотрим диаграмму отношений в DBeaver (ERDiagram) файл - "vk_persisit_diagram.png"


-- Если нужно удалить
ALTER TABLE table_name DROP FOREIGN KEY posts_user_id_fk;