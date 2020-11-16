-- Урок 4
-- Практическое задание по теме “CRUD - операции”
-- 
-- 1. Повторить все действия по доработке БД vk.
-- 
-- 
-- 1. Внесены изменения в данные и структуру таблиц выполненные на уроке по теме “CRUD - операции”
-- 2. Осуществленны следующие дополнительные действия:
-- 2.1 Таблица messages (-- 1.) исправлена отправка сообщений пользователя самому себе from_user_id = to_user_id
-- 2.2 Таблица media (-- 2.) добиваемся совпадения расширения файла с типом медиа media_type_id .
-- 2.3 Таблица friendship (-- 3.) -- Устанавливаем правильные даты:
--  status_id = 1 ('Requested'): confirmed_at = NULL, updated_at = created_at;
--  status_id = 2 ('Confirmed'): updated_at = confirmed_at, created_at < confirmed_at;
--  status_id = 3 ('Rejected'): confirmed_at = NULL, created_at < updated_at.
-- 

-- Доработки и улучшения структуры БД vk
USE vk;

-- Вариант 1
-- В таблице friendship значение поля requested_at ("Время отправления приглашения дружить"),
-- всегда равно значению поля created_at ("Время создания строки"),
-- одно из них можно исключить из таблицы.

-- Выполняем на БД vk
ALTER TABLE friendship DROP COLUMN requested_at;

-- Выполняем на БД vk
ALTER TABLE messages ADD COLUMN media_id INT UNSIGNED AFTER body; -- добавить файл в сообщение

-- Вариант 5
-- Изменить тип данных для пола в профилях на ENUM
DESC profiles;
SELECT DISTINCT gender FROM profiles;

-- Вносим изменения
ALTER TABLE profiles MODIFY COLUMN gender ENUM('M', 'F') NOT NULL;


-- Дорабатываем тестовые данные
-- Смотрим все таблицы
SHOW TABLES;

-- Анализируем данные пользователей
SELECT * FROM users LIMIT 10;

-- Смотрим структуру таблицы пользователей
DESC users;

-- Приводим в порядок временные метки
UPDATE users SET updated_at = NOW() WHERE updated_at < created_at;        
		 SELECT * FROM users

-- Смотрим структуру профилей
DESC profiles;

-- Анализируем данные
UPDATE profiles SET updated_at = NOW() WHERE updated_at < created_at;

-- Поправим столбец пола
CREATE TEMPORARY TABLE genders (name CHAR(1));

INSERT INTO genders VALUES ('M'), ('F'); 

SELECT * FROM genders;

-- Обновляем пол
UPDATE profiles 
  SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);
 
SELECT * FROM profiles;

-- Все таблицы
SHOW TABLES;

-- Смотрим структуру таблицы сообщений
DESC messages;

-- Анализируем данные
SELECT * FROM messages LIMIT 10;

-- Обновляем значения ссылок на отправителя и получателя сообщения
UPDATE messages SET 
  from_user_id = FLOOR(1 + RAND() * 100), -- FLOOR - отбросить дробную часть
  to_user_id = FLOOR(1 + RAND() * 100);


-- 
-- 1. Исправляем отправку сообщений пользователя самому себе
-- 
SELECT * FROM messages WHERE from_user_id = to_user_id;

UPDATE messages SET 
 	   from_user_id = FLOOR(1 + RAND() * 100)
 WHERE from_user_id = to_user_id;
-- 
-- END 1.
-- 


-- Добавляем ссылки на медиафайлы
UPDATE messages SET  media_id = FLOOR(1 + RAND() * 100);

-- Анализируем типы медиаконтента
SELECT * FROM media_types;

-- Удаляем все типы
-- DELETE FROM media_types;
TRUNCATE media_types;

-- Добавляем нужные типы
INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

-- Смотрим структуру таблицы медиаконтента 
DESC media;

-- Анализируем данные
SELECT * FROM media LIMIT 10;

-- Обновляем ссылку на пользователя - владельца
UPDATE media SET user_id = FLOOR(1 + RAND() * 100);

-- Создаём временную таблицу форматов медиафайлов
CREATE TEMPORARY TABLE extensions (name VARCHAR(10));

-- Заполняем значениями
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');

-- Проверяем
SELECT * FROM extensions;


-- 
-- 2. Добиваемся совпадения расширения файла с типом медиа (обновляем media_type_id)
-- 

-- Создаём вспомогательный столбец
ALTER TABLE media ADD COLUMN extension VARCHAR(10) AFTER filename; 
-- ALTER TABLE media MODIFY COLUMN extention varchar(10) NULL;
-- ALTER TABLE media CHANGE extention extension varchar(10) NULL;

-- Добиваемся совпадения расширения файла с типом медиа (обновляем media_type_id)
UPDATE media SET media_type_id = CASE
	WHEN extension = 'jpeg' OR extension = 'png' THEN 1
	WHEN extension = 'mpeg' THEN 3
	WHEN extension = 'avi'  THEN 2
	ELSE 2
	END
;
	
-- Обновляем ссылку на файл
UPDATE media SET filename = CONCAT(
  'http://dropbox.net/vk/',
  filename,
  '.',
  extension
  -- (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);

UPDATE media SET filename =  REPLACE(`filename` , '..', '.');

-- Удаляем вспомогательный столбец
ALTER TABLE media DROP COLUMN extension;

-- 
-- END 2.
-- 


-- Обновляем размер файлов
UPDATE media SET size = FLOOR(10000 + (RAND() * 1000000)) WHERE size < 1000;

-- Заполняем метаданные
UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');  

-- Возвращаем столбцу метеданных правильный тип
ALTER TABLE media MODIFY COLUMN metadata JSON;

-- Анализируем данные 
SELECT * FROM friendship_statuses;

-- Очищаем таблицу
TRUNCATE friendship_statuses;

-- Вставляем значения статусов дружбы
INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');

-- Смотрим структуру таблицы дружбы
DESC friendship;

-- Анализируем данные
SELECT * FROM friendship LIMIT 10;

-- Обновляем ссылки на друзей
UPDATE friendship SET 
	   user_id = FLOOR(1 + RAND() * 100),
	   friend_id = FLOOR(1 + RAND() * 100);

-- Исправляем случай когда user_id = friend_id
UPDATE friendship SET friend_id = friend_id + 1
 WHERE user_id = friend_id;
  
-- Обновляем ссылки на статус 
UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3); 


-- 
-- 3. Устанавливаем правильные даты
-- 

UPDATE friendship SET confirmed_at = NULL, updated_at = created_at WHERE status_id = 1;

UPDATE friendship SET confirmed_at = NULL, updated_at = ADDDATE(created_at, INTERVAL FLOOR(1 + RAND() * 30) DAY) WHERE status_id = 3;

UPDATE friendship SET confirmed_at = ADDDATE(created_at, INTERVAL FLOOR(1 + RAND() * 30) DAY) WHERE status_id = 2;

UPDATE friendship SET updated_at = confirmed_at WHERE status_id = 2;

/*UPDATE friendship SET updated_at = CASE
	WHEN status_id = 2 THEN confirmed_at
	ELSE confirmed_at
	END; --*/

-- 
-- END 3.
-- 


-- Смотрим структуру таблицы групп
DESC communities;

-- Анализируем данные
SELECT * FROM communities;

-- Удаляем часть групп
DELETE FROM communities WHERE id > 20;

-- Анализируем таблицу связи пользователей и групп
SELECT * FROM communities_users;

-- Обновляем значения community_id
UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 8);

DELETE FROM communities_users WHERE community_id > 100;