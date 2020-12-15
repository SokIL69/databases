USE web_shop;

-- Здравствуйте Игорь,
-- 1. Хорошая описательная часть.

-- 2. В таблице продуктов product_types_id - не принципимально, но лучше product_type_id, так как это ссылка на один конкретный тип.
-- product_types_id - это опечатка. Исправил.
ALTER TABLE products CHANGE product_types_id product_type_id int UNSIGNED NOT NULL COMMENT "Идентификатор типа товара";
ALTER TABLE web_shop.products DROP FOREIGN KEY products_product_types_id_fk;
ALTER TABLE products 
	ADD CONSTRAINT products_product_type_id_fk FOREIGN KEY (product_type_id) REFERENCES product_types(id);

-- 3. tel varchar(75) - лучше не сокращайте, не экономьте буквы, делайте код более читаемым.
ALTER TABLE shops CHANGE tel phone varchar(75) NOT NULL COMMENT "Телефон";

-- 4. В таблице книг genre_id - так может быть определён только один жанр, в реальности часто необходимо задать комбинацию.
-- 
-- Создаём таблицу "Книги_Жанры"
CREATE TABLE books_genres (
  book_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  genre_id int UNSIGNED NOT NULL COMMENT "Идентификатор жанра",
  PRIMARY KEY (`book_id`,`genre_id`) COMMENT 'Составной первичный ключ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Книги_Жанры";

ALTER TABLE books_genres
	ADD CONSTRAINT books_genres_book_id_fk FOREIGN KEY (book_id) REFERENCES books(id),	
	ADD CONSTRAINT books_genres_genre_id_fk FOREIGN KEY (genre_id) REFERENCES product_types(id);

-- TRUNCATE TABLE books_genres;
-- Заполняем данными таблицу books_genres. Повторить несколько раз.
INSERT INTO books_genres (book_id, genre_id)
	SELECT book_id, gender_id 
	FROM (
		SELECT DISTINCT
		   FLOOR(1 + RAND() * 250) AS book_id,
		   FLOOR(37 + RAND() * 14) AS gender_id
		FROM
			(SELECT id AS book_id FROM books) b_id
	)tbl 
	WHERE book_id NOT IN (SELECT book_id FROM books_genres
	);

-- Форматированный вывод для удобства восприятия информации.
SELECT id AS book_id, name, '' AS product_type
FROM books
UNION ALL
SELECT  book_id, '' AS name, pt.product_type
  FROM books_genres bg
  	   JOIN product_types pt ON pt.id = bg.genre_id
 ORDER BY book_id, name DESC;

-- 5. Аналогично для авторов книг.Плюс авторов желательно вынести в отдельную таблицу.
-- 
-- Содаём таблицу "Авторы"
CREATE TABLE authors (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "УИД автора",
  name_brief varchar(255) NOT NULL COMMENT "Автор, краткий формат",
  name_full varchar(255) NOT NULL COMMENT "Автор, полный формат",
  description varchar(255) NULL COMMENT "Описание"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Книги_Жанры";

-- Создаём таблицу "Книги_Авторы"
CREATE TABLE books_authors (
  book_id int UNSIGNED NOT NULL COMMENT "Идентификатор товара",
  author_id int UNSIGNED NOT NULL COMMENT "Идентификатор автора",
  PRIMARY KEY (`book_id`,`author_id`) COMMENT 'Составной первичный ключ'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Книги_Авторы";

ALTER TABLE books_authors
	ADD CONSTRAINT books_authors_book_id_fk FOREIGN KEY (book_id) REFERENCES books(id),	
	ADD CONSTRAINT books_authors_author_id_fk FOREIGN KEY (author_id) REFERENCES authors(id);

-- Заполняем данными таблицу authors используя  файл "5_19 Заполняем данными authors.sql"

-- Заполняем данными books_authors
-- TRUNCATE TABLE books_genres;
INSERT INTO books_authors (book_id, author_id)
	SELECT book_id, author_id 
	FROM (
		SELECT DISTINCT
		   FLOOR(1 + RAND() * 250) AS book_id,
		   FLOOR(1 + RAND() * 250) AS author_id
		FROM
			(SELECT id AS book_id FROM books) b_id
	)tbl 
	WHERE book_id NOT IN (SELECT book_id FROM books_authors
	);

SELECT bk.id, name AS title, name_brief AS author
FROM books bk
	LEFT JOIN books_authors ba ON ba.book_id = bk.id
    LEFT JOIN authors au ON au.id = ba.author_id
 ORDER BY bk.id, name DESC;

-- 6. cover_type text также просится в справочник или ENUM.
CREATE TABLE cover_types (
  id int UNSIGNED PRIMARY KEY NOT NULL COMMENT "УИД типа обложки",
  name varchar(100) COMMENT "Тип обложки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Типы облодки";

INSERT INTO cover_types (id, name) VALUES
(0, 'Твердая глянцевая'),
(1, 'Твердая бумажная'),
(2, 'Суперобложка'),
(3, 'Мягкая бумажная');
SELECT id, name FROM cover_types;

ALTER TABLE books ADD cover_type_id int UNSIGNED NULL;

UPDATE books SET cover_type_id=
	CASE 
		WHEN cover_type = 'Твердая глянцевая' THEN 0
		WHEN cover_type = 'Твердая бумажная' THEN 1
		WHEN cover_type = 'Суперобложка' THEN 2
		WHEN cover_type = 'Мягкая бумажная' THEN 3
	END;
-- или
UPDATE books SET cover_type_id = (SELECT id FROM cover_types ORDER BY RAND() LIMIT 1);

ALTER TABLE books MODIFY cover_type_id int UNSIGNED NOT NULL;
ALTER TABLE books DROP COLUMN cover_type;
ALTER TABLE books 
	ADD CONSTRAINT books_cover_type_id_fk FOREIGN KEY (cover_type_id) REFERENCES cover_types(id);

SELECT DISTINCT cover_type_id FROM books;

-- 7. new bit - для таких полей лучше применить BOOLEAN. На результат не повлияет, но логически более правильно.
ALTER TABLE books MODIFY `new` BOOLEAN NOT NULL, MODIFY miniature BOOLEAN NOT NULL;

-- 8. Для products_promotons вероятно ещё нужны даты начала и завершения.
-- 
-- Поля "Дата начала" и "Дата завершения" находятся в таблице promotions.
-- 
CREATE TABLE promotions (
  id int UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор акции",
  start_date DATETIME NOT NULL COMMENT "Дата начала акции",
  end_date DATETIME NOT NULL COMMENT "Дата завершения акции",
  discount int NOT NULL COMMENT "% скидки",
  bonuse int NOT NULL COMMENT "Бонусы",
  description varchar(255) NOT NULL COMMENT "Описание",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT "Акции";


-- 9. login char(25) - почему не строка?
ALTER TABLE users MODIFY login VARCHAR(25) NOT NULL;

-- 10. fio - старайтесь не использовать транслитерацию, это выглядит непрофессионально.
ALTER TABLE users CHANGE fio name VARCHAR(255) NOT NULL;

-- 11. birsday - опечатка.
ALTER TABLE users CHANGE birsday birthday DATE NOT NULL;

-- 12. sequrity - пишется иначе.
RENAME TABLE seqсurity TO seсurity;
ALTER TABLE seсurity DROP FOREIGN KEY security_user_id_fk;
ALTER TABLE seсurity
	ADD CONSTRAINT security_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- 13. state int COMMENT "Состояние записи (0-заблокирована, 1-активна)", - будет достаточно BOOLEAN.
ALTER TABLE seсurity MODIFY state BOOLEAN NOT NULL;

-- 14. estimate int NULL COMMENT "Оценка" - тут можно использовать ENUM.
ALTER TABLE ratings MODIFY COLUMN estimate ENUM('0','1','2','3','4','5') NOT NULL;

-- 15. Не совсем понятна логика feedback_recipients - кто эти таинственные получатели ответов?
-- 
-- feedbacks - это сообщения для связи с конкретными службами web-магазина (feedback_recipients)
-- и адресуется лицам ответственным за данный вопрос.
-- Список ограничен и не предполагается его частое изменение.
-- Сделано по аналогии с сайтом https://www.chitai-gorod.ru/contacts/ (Книжный магазин/Обратная связь)
-- 
SELECT id, recipient, description FROM web_shop.feedback_recipients;
/*
1	Написать руководству федеральной книжной сети	Оставьте отзывы и пожелания по работе интернет-магазина. Ваше мнение важно для нас.
2	Написать руководству федеральной книжной сети	Поделитесь впечатлением о качестве обслуживания в магазине. Мы всегда готовы совершенствоваться.
3	Praesentium blanditiis voluptatem saepe omnis repellat quod inventore magnam.	Deserunt voluptatem libero aut esse qui enim. Repellat sed est tempora. Voluptas eveniet id nobis.
4	Est deleniti vel voluptas eum nobis cumque.	Iste blanditiis unde qui atque. Rerum labore id asperiores quae omnis.
5	Предложить сотрудничество	Предложите нам новые товары для хобби и творчества. Наши покупатели любят все, что делает их жизнь интереснее.
6	Предложить сотрудничество	Познакомьте нас с новинками и трендами рынка канцтоваров. В наших магазинах хорошо продаются не только книги.
7	Предложить сотрудничество	Порадуйте нас лучшими образцами своей сувенирной продукции. Наши покупатели ищут яркие подарки для себя и друзей.
8	Предложить сотрудничество	Получите комментарий для публикации в СМИ. Пригласите нас к участию в грандиозных PR-проектах. Мы открыты для сотрудничества.
9	Предложить сотрудничество	Предложите нам новые технологии в области рекламы. Мы приветствуем современные решения и профессионалов своего дела.
10	Предложить сотрудничество	Отправьте нам предложение по аренде торговых площадей. Мы откроем у вас книжный европейского уровня.
11	Предложить сотрудничество	Расскажите нам о своих товарах и производстве. Мы найдем им новое применение и реализуем классные идеи.
12	Предложить сотрудничество	Обращайтесь по всем остальным вопросам, для которых нет специального раздела. Найдем решение вместе.
*/

-- 16. Заполнение данными можно свести в один файл.
-- 
-- Изначально так и было.
-- Разбито на разные файлы для лучшего понимания того что происходит

-- 17. Запрос Наличие товара в разрезе категорий товаров:
-- IF(available > 0, равнозначно IF(available,
-- Испраленно.

-- 18. Запрос Подробная инфорамация о объекте книга:
-- Серию вероятно нужно присоединять внешним объединением.
-- 
SELECT sr.id, 
	   ph.name AS publishing_house,
	   sr.name AS serias,
	   -- ph.description,
	   bk.name AS book,
	   bk.author,
	   bk.`year` 
FROM series sr
	 JOIN publishing_houses ph ON ph.id = sr.publishing_house_id
	 LEFT OUTER JOIN books bk ON bk.series_id = sr.id
ORDER BY publishing_house, serias;

-- 19. Плюс за большое количество выборок.
-- 20. Плюс за использование оконных функцй.

-- 21. Триггер check_available_insert не понадобится если на уровне таблицы установить для столбца значение по умолчанию.
-- 
ALTER TABLE products MODIFY available int NOT NULL DEFAULT 0 COMMENT "Доступно (общее количество товара)";
-- Тригер check_available_insert создан на случай,
-- если будет попытка добавления в таблицу products нового товара,
-- с количеством товара available отличным от нуля.

-- 22. В триггере check_users_products__products_count_insert вероятно нужно также проверять чтобы не было задано больше товара, чем естьв остатке.
-- ----------------------------------------------------------------------------------------------
-- 5. Создаём триггеры на таблицу users_products (Корзина покупателя)
-- ----------------------------------------------------------------------------------------------
DROP TRIGGER IF EXISTS check_users_products__products_count_insert;
DELIMITER //

CREATE TRIGGER check_users_products__products_count_insert BEFORE INSERT ON users_products
FOR EACH ROW
-- При добавлении новой записи в таблицу users_products, должно проверяется доступное количество товара.
-- Если количество доступного товара = 0, выдаётся сообщение об ошибке.
BEGIN 
	-- 3. При добавлении новой записи в таблицу users_products, должно проверяется доступное количество товара.
	DECLARE num INT;
	SELECT available FROM products WHERE id = NEW.product_id INTO num;
  	IF num <= 0 THEN 
  	 	-- Ошибка. Товар отсутствует.
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ITEM IS NOT EVALABLE';
	ELSE
	  	IF num > product_count(NEW.product_id) THEN 
	  	 	-- Ошибка. Товар отсутствует.
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ITEM QUANTITY NOT ENOUGH FOR ORDER';
		ELSE
			SET NEW.product_count = num;
		END IF;
	END IF;
END//

DELIMITER ;

-- В целом проект реализован грамотно и на хорошем уровне. Если будете выкладывать проект в портфолио, рекомендую доработать по замечаниям.
-- Отличная работа!
-- Поздравляю с успешным завершением курса!


-- ALTER TABLE tbl_Country DROP COLUMN IsDeleted;
-- ALTER TABLE tbl_Country MODIFY IsDeleted tinyint(1) NOT NULL;
-- ALTER TABLE tbl_Country CHANGE IsDeleted IsDeleted tinyint(1) NOT NULL;