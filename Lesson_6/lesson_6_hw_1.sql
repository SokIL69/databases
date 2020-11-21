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
-- 1. Создать и заполнить таблицы лайков и постов.
-- -----------------------------------------------------------------------------------------------------------------------
-- 
-- Подготовка данных
-- 
SHOW TABLES;
-- 
-- Вариант 7 (финальный)
-- Применим вариант с таблицей типов лайков
-- (применяем к базе vk только этот вариант!)

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор автора лайка",
  target_id INT UNSIGNED NOT NULL COMMENT "Идентификатор строки",
  target_type_id INT UNSIGNED NOT NULL COMMENT "Идентификатор типов лайков (таблицы где хранится строка на которую указывает target_id)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "" COMMENT "Время создания"
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE COMMENT "Таблица где хранится строка на которую указывает target_id)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания"
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

DESCRIBE target_types;
SELECT * FROM target_types;

TRUNCATE TABLE likes;

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, -- id берётся из таблицы messages
    FLOOR(1 + (RAND() * 100)), -- Случайное значение от 0 до 100 
    FLOOR(1 + (RAND() * 100)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM messages;

-- Проверим
SELECT * FROM likes; -- LIMIT 10;

-- Создадим таблицу постов
DROP TABLE IF EXISTS posts;
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL COMMENT "Идентификатор автор поста",
  community_id INT UNSIGNED COMMENT "Идентификатор на сообщество в рамках которой создан пост",
  head VARCHAR(255) COMMENT "Заголовок поста",
  body TEXT NOT NULL COMMENT "Текст поста", 
  media_id INT UNSIGNED COMMENT "Идентификатор прикреплённого медиа-файла",
  is_public BOOLEAN DEFAULT TRUE COMMENT "Публичный/Непубличный",
  is_archived BOOLEAN DEFAULT FALSE COMMENT "Активен/неактивен",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP  COMMENT "Время создания",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT "Время обновления"
);

-- Добавление в таблицу постов записей сгенерированных на сайте-фэйкере "http://filldb.info/dummy/step1" -->  файл "Insert into post.sql"
-- Правка записей таблицы постов

UPDATE vk.posts
SET user_id = FLOOR(1 + (RAND() * 100)), -- от 0 до 100  
	community_id = FLOOR(1 + (RAND() * 8)), -- от 0 до 8
	media_id = FLOOR(1 + (RAND() * 100)),
	is_public = FLOOR(ROUND(RAND())), -- 0 или 1
	is_archived = FLOOR(ROUND(RAND()));

SELECT * FROM posts LIMIT 10;