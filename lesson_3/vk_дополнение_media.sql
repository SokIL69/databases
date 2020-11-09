--
-- Данное разбиение имеет смысл если фалы хранятся непосредственно в самой таблице
--

-- Таблица тип записи медиаконтента 
CREATE TABLE media_content_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  name VARCHAR(10) NOT NULL COMMENT "Тип медиа контента" -- id = 0/1 => name = "файл"/"ссылка"
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Тип медиа контента";

-- Таблица медиа
CREATE TABLE media (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки",
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на пользователя, который создал медиазапись",
  media_type_id INT UNSIGNED NOT NULL COMMENT "Ссылка на тип контента",
  media_content_type_id int NOT NULL COMMENT "Cсылка на тип записи медиаконтента" -- media_content_type_id = 0/1 => media_content_type = "файл"/"ссылка"
  description VARCHAR(255) COMMENT "Комментарии пользователя к записи"
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Медиа";

-- Таблица медиафайлов загруженных пользователем
--
-- Данное разбиение имеет смысл если фалы хранятся непосредственно в самой таблице
--
CREATE TABLE media_files (
  media_id INT UNSIGNED NOT NULL COMMENT "Ссылка media-запись созданную пользователем",
  filename VARCHAR(255) NOT NULL COMMENT "Путь к файлу",
  -- extantion VARCHAR(4) NOT NULL COMMENT "Расширение файла",
  size INT NOT NULL COMMENT "Размер файла",
  file_data BLOB NOT NULL COMMENT "Содержимое файла",
  metadata JSON COMMENT "Метаданные файла",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Медиафайлы";


-- Таблица ссылок на медиаресурсы в web
CREATE TABLE media_files (
  media_id INT UNSIGNED NOT NULL COMMENT "Ссылка media-запись созданную пользователем",
  link VARCHAR(255) NOT NULL COMMENT "Ссылка на медиаресурс в web",
  metadata JSON COMMENT "Метаданные медиаресурса",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Медиассылки";

