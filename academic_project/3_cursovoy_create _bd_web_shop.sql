-- Базы данных. Курсовой проект.
-- В качестве сервиса для курсовой работы выбран интернет-магазин "Читай-город" - https://www.chitai-gorod.ru/
-- Предварительный анализ ресурса показывает возможность создания не менее 10 таблиц:
-- 
-- Создание БД основе интернет-магазин "Читай-город" - https://www.chitai-gorod.ru/
-- 

CREATE DATABASE web_shop;
ALTER DATABASE web_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE web_shop;

-- Даталогическая модель Базы Данных.

-- Используемые сокращения:
-- УИД - уникальный идентификатор

/*
1. Справочник тип_товара
- УИД типа товара
- Предок
- Наименование типа товара
- Уровень типа товара (0, 1, 2, 3)
*/

DROP TABLE IF EXISTS product_types;

-- 1. Создаём таблицу "Справочник типы товаров"
CREATE TABLE product_types (
-- id SERIAL PRIMARY KEY
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД типа товара",
  parent_id INT UNSIGNED NOT NULL DEFAULT 0 COMMENT "Предок - идентификатор типа товара более высокого уровня. Для верхнего уровня - 0.",
  `level` INT NOT NULL DEFAULT 0 COMMENT "Уровень типа (0-4).",
  product_type  VARCHAR(255) NOT NULL COMMENT "Наименование типа товара",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Справочник типы товаров";
-- ALTER TABLE web_shop.product_types ADD `level` INT DEFAULT 0 NULL COMMENT 'Уровень (0-4)';
DESCRIBE product_types;


/*
2. Товары
- УИД товара;
- Идентификатор типа товара  # Связь с таблицей "Типы товаров"
- Описание товара;
- Размер/Формат(25.5 x 25.5 x 6.3 /20.5 x 13 x 3)
- Вес, г
- Анотация
- Доступно (общее количество товара)
- Цена
- Наличие в магазинах
*/
-- 2. Создаём таблицу "Товары (Товарная позиция)"
CREATE TABLE products (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД товара",
  product_types_id int UNSIGNED NOT NULL COMMENT "Идентификатор типа товара",
  name varchar(255) NOT NULL COMMENT "Название",
  description text NOT NULL COMMENT "Описание",
  format  varchar(25) NOT NULL COMMENT "Размер/Формат(25.5 x 25.5 x 6.3)",
  weight int NOT NULL COMMENT "Вес, г",
  anotation	varchar(1024) COMMENT "Анотация",
  available int NOT NULL COMMENT "Доступно (общее количество товара)",
  price decimal(11, 2) NOT NULL	COMMENT "Цена",
  -- availability in stores	-- Наличие в магазинах (таблица Товары_Магазины),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Товары (Товарная позиция)";

DESCRIBE products;
-- ALTER TABLE web_shop.products MODIFY COLUMN product_types_id int UNSIGNED NOT NULL COMMENT 'Идентификатор типа товара';
ALTER TABLE products 
	ADD CONSTRAINT products_product_types_id_fk FOREIGN KEY (product_types_id) REFERENCES product_types(id);

/*
3. Фотографии товаров
- Идентификатор товара # Связь с таблицей "Товары"
- Путь к файлу с изображением товара
- Имя файла
- Метаданные файла
- Размер
*/
-- 3. Создаём таблицу "Фотографии товаров"
CREATE TABLE photos (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД фотографии товара",
  product_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  file_name varchar(255) NOT NULL COMMENT "Путь к файлу",
  metadata json NOT NULL COMMENT "Метаданные файла",
  size int NOT NULL COMMENT "Размер",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Фотографии товаров";

DESCRIBE photos;

ALTER TABLE photos 
	ADD CONSTRAINT photos_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id)ON DELETE CASCADE;
/*
4. Магазины
- УИД магазина
- Название магазина
- Город
- Адрес
- Время работы
- Телефон
- Описание
 */
-- 4. Создаём таблицу "Магазины"
CREATE TABLE shops (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД магазина",
  name varchar(255) NOT NULL COMMENT "Название",
  city varchar(255) NOT NULL COMMENT "Город",
  address varchar(255) NOT NULL COMMENT "Адрес",
  time_work varchar(75) NOT NULL COMMENT "Время работы",
  tel varchar(75) NOT NULL COMMENT "Телефон",
  description varchar(255) NOT NULL COMMENT "Описание",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Магазины";

DESCRIBE shops;

/*
5. Товары_Магазины # Связь между таблицами "Товары" и "Магазины"
- Идентификатор товара
- Идентификатор магазина
- Количество товара в магазине
*/
DROP TABLE IF EXISTS  products_shops;
-- 5. Создаём таблицу "Товары_Магазины"
CREATE TABLE products_shops (
  product_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  shop_id int UNSIGNED NOT NULL COMMENT "Идентификатор магазина",
  product_count int NOT NULL COMMENT "Количество товара",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (`product_id`,`shop_id`) COMMENT 'Составной первичный ключ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Товары_Магазины";

DESCRIBE products_shops;

ALTER TABLE products_shops 
	ADD CONSTRAINT products_shops_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id);
ALTER TABLE products_shops 
	ADD CONSTRAINT shops_shop_id_fk FOREIGN KEY (shop_id) REFERENCES shops(id);


/*
6. Издательства
- УИД издательства
- Название издательства
- Описание
*/
-- 6. Создаём таблицу "Издательства"
CREATE TABLE publishing_houses (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД Издательства",
  name varchar(255) NOT NULL COMMENT "Название",
  description varchar(255) NOT NULL COMMENT "Описание",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Издательства";

DESCRIBE publishing_houses;
/*
7. Серии
- УИД серии
- Идентификатор издательства
- Название серии
- Описание
*/
-- 7. Создаём таблицу "Серии"
CREATE TABLE series (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД серии",
  publishing_house_id int UNSIGNED NOT NULL COMMENT "Идентификатор издательства",
  name varchar(255) NOT NULL COMMENT "Название",
  description varchar(255) NOT NULL COMMENT "Описание",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Серии";

DESCRIBE series;

ALTER TABLE series 
	ADD CONSTRAINT series_publishing_house_id_fk FOREIGN KEY (publishing_house_id) REFERENCES publishing_houses(id);


/*
8. Жанры
- УИД жанра
- Идентификатор жанра
- Название жанра
- Описание
*/
DROP TABLE IF EXISTS genres;
-- 8. Создаём таблицу "Жанры"
-- Таблицу не используем !!! - это разделы каталога товаров
/*CREATE TABLE genres (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД серии",
  name varchar(255) NOT NULL COMMENT "Название",
  description varchar(255) NOT NULL COMMENT "Описание",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Жанры";

DESCRIBE genres;*/
/*
9. Книги # Связь один-к-одному с таблицей товары по полю УИД товара
- УИД товара
- Идентификатор издательства # связь с таблицей "Издательства"
- Идентификатор серии  # связь с таблицей "Серии"
- Автор
- Язык
- Год издания
- ISBN
- Кол-во страниц
- Тип обложки
- Тираж
- Новинка (Да/Нет)
- Миниатюрное идание (Да/Нет)
*/
DROP TABLE IF EXISTS books; 
CREATE TABLE books (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД книги",
  product_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  publishing_house_id int UNSIGNED NOT NULL COMMENT "Идентификатор издательства",
  series_id int UNSIGNED NULL COMMENT "Идентификатор серии",
  genre_id int UNSIGNED NOT NULL COMMENT "Идентификатор жанра",
  author varchar(255) NOT NULL COMMENT "Автор",
  name varchar(255) NOT NULL COMMENT "Название",
  `language` varchar(5) NOT NULL COMMENT "Язык",
  `year` int NOT NULL COMMENT "Год издания",
  isbn varchar(35) NOT NULL COMMENT "ISBN", -- 978-5-517-02130-4
  number_pages int NOT NULL COMMENT "Кол-во страниц",
  cover_type text NOT NULL COMMENT "Тип обложки",
  circulation  int NOT NULL COMMENT "Тираж",
  `new` bit NOT NULL DEFAULT 0 COMMENT "Новинка (Да/Нет)",
  miniature bit NOT NULL DEFAULT 0 COMMENT "Миниатюрное идание (Да/Нет)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Книги";

DESCRIBE books;

ALTER TABLE books 
	ADD CONSTRAINT books_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id),
	ADD CONSTRAINT books_publishing_house_id_fk FOREIGN KEY (publishing_house_id) REFERENCES publishing_houses(id),
	ADD CONSTRAINT books_series_id_fk FOREIGN KEY (series_id) REFERENCES series(id),
	ADD CONSTRAINT books_genre_id_fk FOREIGN KEY (genre_id) REFERENCES product_types(id);


/*
10. Акции
- Идентификатор типа товара
- Дата начала акции
- Дата окончания акции
- % скидки
- Бонусы
- Описание
*/
DROP TABLE IF EXISTS promotions;
-- 10. Создаём таблицу "Акции"
CREATE TABLE promotions (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор акции",
  start_date DATETIME NOT NULL COMMENT "Дата начала акции",
  end_date DATETIME NOT NULL COMMENT "Дата окончания акции",
  discount int NOT NULL COMMENT "% скидки",
  bonuse int NOT NULL COMMENT "Бонусы",
  description varchar(255) NOT NULL COMMENT "Описание",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Акции";

DESCRIBE promotions;

/*
11. Товары_Акции # Связь между таблицами "Товары" и "Акции"
- Идентификатор товара
- Идентификатор акции
*/
DROP TABLE IF EXISTS products_promotons;
-- 11. Создаём таблицу "Товары_Акции"
CREATE TABLE products_promotons (
  product_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  promotion_id int UNSIGNED NOT NULL COMMENT "Идентификатор акции",
  PRIMARY KEY (`product_id`,`promotion_id`) COMMENT 'Составной первичный ключ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Товары_Акции";


DESCRIBE products_promotons;
ALTER TABLE products_promotons
	ADD CONSTRAINT products_promotons_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id),	
	ADD CONSTRAINT products_promotons_promotion_id_fk FOREIGN KEY (promotion_id) REFERENCES promotions(id);
/*
11. Распродажи  -- Не создаём слишком много таблиц 
- Идентификатор товара
- Дата начала распродажи
- Дата окончания распродажи
- % скидки
- Описание
*/

/*
12. Покупатели (клиенты)
- УИД покупателя
- Login
- ФИО покупателя
- День рождения
- Дата регистрации
- E-mail
- Телефон
- Хочу быть в курсе скидок, новинок и секретных акций (Да/Нет)
*/
DROP TABLE IF EXISTS users; 
-- 12. Создаём таблицу "Покупатели (клиенты)"
CREATE TABLE users (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД покупателя",
  login char(25) NOT NULL UNIQUE COMMENT "Логин",
  fio char(255) NOT NULL UNIQUE COMMENT "ФИО покупателя",
  birsday DATE NOT NULL COMMENT "День рождения",
  email varchar(255) NOT NULL COMMENT "E-mail",
  phone varchar(100) NOT NULL COMMENT "Телефон",
  сonsent bit NOT NULL DEFAULT 0 COMMENT "Хочу быть в курсе скидок, новинок и секретных акций (Да/Нет)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Покупатели (клиенты)";

DESCRIBE users;


/*
13. Sequrity
- УИД покупателя 
- ХЭШ пароля
- Дата смены пароля
- Состояние записи
*/
DROP TABLE IF EXISTS sequrity; 
-- 13. Создаём таблицу "Sequrity"
CREATE TABLE sequrity (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД записи",
  user_id int UNSIGNED NOT NULL COMMENT "Идентификатор покупателя",
  pwd varchar(100) COMMENT "ХЭШ пароля",
  state int COMMENT "Состояние записи (0-заблокирована, 1-активна)",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Sequrity";

DESCRIBE sequrity;

ALTER TABLE sequrity 
	ADD CONSTRAINT sequrity_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

/*
14. Корзины покупателей
- Идентификатор покупателя
- Идентификатор товара
- Количество товара
*/
DROP TABLE IF EXISTS users_products;
-- 14. Создаём таблицу "Корзины покупателей"
CREATE TABLE users_products  (
  product_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  user_id int UNSIGNED NOT NULL COMMENT "Идентификатор покупателя",
  product_count int NOT NULL DEFAULT 1 COMMENT "Количество товара",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата создания строки",
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (`product_id`,`user_id`) COMMENT 'Составной первичный ключ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Корзины покупателей";

DESCRIBE users_products;

ALTER TABLE users_products
	ADD CONSTRAINT users_products_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id),
	ADD CONSTRAINT users_products_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);

/* -- Не создаём
15. Закладки покупателей
- Идентификатор покупателя
- Идентификатор товара
*/

/*
16. Заказы
- УИД заказа
- Номер заказа
- Идентификатор клиента
- Идентификатор товара
- Количество товара
- Дата оформления заказа
- Адрес доставки
- Стоимость заказа
- Идентификатор службы доставки
- Состояние заказа  (0-не оплачен, 1-оплачен, 2-формируется на складе, 3-доставляется, 4-доставлен, 5-завершён.)
- Дата оплаты
- Дата доставки
- Реквизиты заказа
*/
DROP TABLE IF EXISTS orders;
-- 16. Создаём таблицу "Заказы"
CREATE TABLE orders (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД заказа",
  user_id int UNSIGNED NOT NULL COMMENT "Идентификатор покупателя",
  -- product_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  -- product_count int NOT NULL DEFAULT 1 COMMENT "Количество товара",
  order_number varchar(25) NOT NULL COMMENT "Номер заказа",
  order_date datetime NOT NULL COMMENT "Дата оформления заказа",
  address varchar(255) NOT NULL COMMENT "Адрес доставки",
  cost decimal(11, 2) NOT NULL	COMMENT "Стоимость заказа",
  delivery_service varchar(255) NOT NULL COMMENT "Идентификатор службы доставки",
  -- delivery_service_id int NOT NULL COMMENT "Идентификатор службы доставки",
  state int NOT NULL DEFAULT(0)COMMENT "Состояние заказа (0-не оплачен, 1-оплачен, 2-формируется на складе, 3-доставляется, 4-доставлен, 5-завершён.)",
  payment_date datetime NOT NULL COMMENT "Дата оплаты",
  delivary_date datetime NOT NULL COMMENT "Дата доставки",
  order_ditails varchar(255) NOT NULL COMMENT "Реквизиты заказа",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Заказы";

DESCRIBE orders;

ALTER TABLE orders
	ADD CONSTRAINT orders_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id),
	ADD CONSTRAINT orders_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);

/*
14.1 Заказы_Товары
- Идентификатор заказа
- Идентификатор продукта
- Количество продукта
*/
CREATE TABLE orders_products (
  order_id int UNSIGNED NOT NULL COMMENT "Идентификатор заказа",
  product_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  product_count int NOT NULL COMMENT "Количество товара",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  PRIMARY KEY (order_id, product_id) COMMENT 'Составной первичный ключ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Заказы_Товары";

DESCRIBE orders_products;

ALTER TABLE orders_products
	ADD CONSTRAINT orders_products_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id),
	ADD CONSTRAINT orders_products_order_id_fk FOREIGN KEY (order_id) REFERENCES orders(id);


/*
17. Оценки, отзывы
- УИД оценки, отзыва
- Идентификатор покупателя
- Идентификатор товара
- Оценка (число)
- Отзыв
*/
DROP TABLE IF EXISTS ratings;
-- 17. Создаём таблицу "Оценки, отзывы"
CREATE TABLE ratings (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД оценки, отзыва",
  user_id int UNSIGNED NOT NULL COMMENT "Идентификатор покупателя", 
  product_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  estimate int NULL COMMENT "Оценка",
  feedback varchar(255) NULL COMMENT "Отзыв",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Оценки, отзывый";

DESCRIBE ratings;

ALTER TABLE ratings
	ADD CONSTRAINT ratings_product_id_fk FOREIGN KEY (product_id) REFERENCES products(id),
	ADD CONSTRAINT ratings_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id);

/*
 18. Получатели обратной связи
- УИД получателя обратной связи
- Получатель обратной связи
- Description
- E-mail
*/
DROP TABLE IF EXISTS feedback_recipients;
-- 18. Создаём таблицу "Получатели обратной связи"
CREATE TABLE feedback_recipients (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД получателя",
  recipient varchar(100) NOT NULL COMMENT "Получатель",
  email varchar(255) NOT NULL COMMENT "E-mail",
  description text NOT NULL COMMENT "Описание",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Получатели обратной связи";

DESCRIBE feedback_recipients;

/*
19. Обратная связь
- УИД связи
- Город
- Имя
- E-mail
- Текст сообщения
- Кому предназначено # связь с таблицей получателей сообщения
*/
DROP TABLE IF EXISTS feedbacks;
-- 19. Создаём таблицу "Обратная связь"
CREATE TABLE feedbacks (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД связи",
  user_id int UNSIGNED NOT NULL COMMENT "Идентификатор покупателя", 
  city varchar(100) NOT NULL COMMENT "Город",
  name varchar(100) NOT NULL COMMENT "Имя",
  email varchar(255) NOT NULL COMMENT "E-mail",
  message text NOT NULL COMMENT "Текст сообщения",
  recipient_id int UNSIGNED NOT NULL COMMENT "Идентификатор получателя (кому предназначено)", # связь с таблицей Адресаты обратной связи",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Дата создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Обратная связь";

DESCRIBE feedbacks;

ALTER TABLE feedbacks
	ADD CONSTRAINT feedbacks_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id),
	ADD CONSTRAINT feedbacks_recipient_id_fk FOREIGN KEY (recipient_id) REFERENCES feedback_recipients(id);
