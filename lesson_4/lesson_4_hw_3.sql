-- Урок 4
-- 
-- Практическое задание по теме “CRUD - операции”
-- 
-- 3(по желанию) Предложить свою реализацию лайков и постов.

-- Для реализации данной функции интернет магазина предлагаю создать таблицу

-- Сокращения:
-- УИД - уникальный идентификатор

DROP DATABASE IF EXISTS TEMP_vk;

CREATE DATABASE TEMP_vk;
USE TEMP_vk

-- 1 - вариант
-- Реализация Оценки товаров, отзывы для интернет магазина

-- Создаём таблицу "Оценки товаров, отзывы"
CREATE TABLE ratings_feedback (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД оценки, отзыва", 
  customer_id int NOT NULL COMMENT "Идентификатор покупателя",
  goods_id int NOT NULL COMMENT "Идентификатор товара",
  estimate  int NOT NULL COMMENT "Оценка (число) от 0 до 5", # нужно добавить ограничение 0 <= estimate <= 5
  feedback VARCHAR(255) NOT NULL COMMENT "Отзыв",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Оценки товаров, отзывы";


-- 2 - вариант
-- Реализация лайков и постов
DROP TABLE IF EXISTS user_contents;

-- Создаём таблицу User Generated Content - это все посты, комментарии, рецензии, отзывы, обзоры, которые оставляют посетители сайта.
CREATE TABLE user_contents (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД пользовательского контента",
  parent_id INT NOT NULL DEFAULT 0 COMMENT "Идентификатор контента (значение поля id этой таблицы). Если 0 - это новость, а не коментарий (самый верхний уровень)",
  user_id INT NOT NULL COMMENT "Идентификатор пользователя",
  content VARCHAR(1024) NOT NULL COMMENT "Текст контента (новости, комментария и др)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Пользовательский контент (новости, комментарии и др)";

DROP TABLE IF EXISTS likes;

-- Создаём таблицу лайков
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД новости",
  user_news_id int NOT NULL COMMENT "Идентификатор новости",
  user_id int NOT NULL COMMENT "Идентификатор пользователя",
  likes BOOLEAN NOT NULL DEFAULT 0 COMMENT "лайк пользователя (1 - нравится/ 0 - иначе)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Лайки";

-- User Generated Content - это все посты, комментарии, рецензии, отзывы, фотографии и обзоры, которые оставляют посетители вашего сайта или подписчики группы в социальных сетях.
