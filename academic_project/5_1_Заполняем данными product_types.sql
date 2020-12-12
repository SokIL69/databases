-- Заполняем данными "Справочник типы товаров"
-- Справочник "Типы товаров" - содержит может содержать до 4 уровней.
USE web_shop;

TRUNCATE TABLE product_types;

/*1*/
INSERT INTO product_types (parent_id, product_type, level) VALUES
(0, 'Канцтовары', 0),
(0, 'Сувениры', 0),
(0, 'Игры и игрушки', 0),
(0, 'Творчество', 0),
(0, 'Книги', 0);
-- (0, 'Канцтовары', 0),
-- (0, 'Канцтовары', 0);

/*2*/
INSERT INTO product_types (parent_id, product_type, level) VALUES
-- Канцтовары # Содержит следующие категории:
(1, 'Бумажные изделия', 1),
(1, 'Галантерея', 1),
(1, 'Прочие канцтовары', 1),
(1, 'Упаковка', 1),
(1, 'Товары для художников', 1),
(1, 'Электротовары', 1),
(1, 'Пеналы', 1),
(1, 'Офисные принадлежности', 1),
(1, 'Письменные принадлежности', 1),
(1, 'Чертежные принадлежности', 1),
(1, 'Школьные товары', 1),
-- Сувениры # Содержит следующие категории:
(2, 'Сувениры к празднику', 1),
(2, 'Дом, Быт, Декор', 1),
(2, 'Игры и Игрушки', 1),
(2, 'Личные вещи', 1),
(2, 'Мелочи сувенирные', 1),
(2, 'Предсказания, пожелания, астрология, эзотерика', 1),
(2, 'Сувенирные канцелярские и офисные принадлежности', 1),
(2, 'Поздравительная атрибутика', 1),
(2, 'Открытки и постеры', 1),
(2, 'Календари на 2021 год', 1),
-- Игры и игрушки  # Содержит следующие категории:
(3, 'Игры', 1),
-- - Настольные и семейные игры'
-- - Пазлы
-- - Конструкторы
-- - Сборные модели
-- - Интеллектуальные наборы
(3, 'Игрушки', 1),
-- - Развивающие игрушки для маленьких
-- - - Кубики, пирамидки
-- - - Магнитные доски, игры на магнитах
-- - - Рыбалки
-- - Мягкие игрушки
-- - Заводные игрушки
-- - Калейдоскопы, бинокли
-- - Транспорт
-- - Игры на природе
-- - Фигурки
-- - Игры в профессии
-- Творчество # Содержит следующие категории:
(4, 'Наборы для детского творчества', 1),
(4, 'Наборы для взрослого творчества', 1),
(4, 'Заготовки', 1),
(4, 'Инструменты и приспособления', 1),
(4, 'Расходные материалы', 1),
(4, 'Фурнитура для изготовления украшений', 1),
(4, 'Декорирование', 1),
(4, 'Бижутерия', 1),
-- Книги # Содержит следующие категории (жанры):
(5, 'Художественная литература', 1),
(5, 'Книги для детей', 1),
(5, 'Образование', 1),
(5, 'Наука и техника', 1),
(5, 'Общество', 1),
(5, 'Деловая литература', 1),
(5, 'Красота. Здоровье. Спорт', 1),
(5, 'Увлечения', 1),
(5, 'Психология', 1),
(5, 'Эзотерика', 1),
(5, 'Философия и религия', 1),
(5, 'Искусство', 1),
(5, 'Подарочные издания', 1),
(5, 'Книги на иностранных языках', 1);
-- ...
/*3*/
SELECT @game_id := id  FROM product_types WHERE product_type = 'Игры';
SELECT @toys_id := id  FROM product_types WHERE product_type = 'Игрушки';
INSERT INTO product_types (parent_id, product_type, level) VALUES
-- Игры и игрушки  # Содержит следующие категории:
-- (3, 'Игры'),
(@game_id, 'Настольные и семейные игры', 2),
(@game_id, 'Пазлы', 2),
(@game_id, 'Конструкторы', 2),
(@game_id, 'Сборные модели', 2),
(@game_id, 'Интеллектуальные наборы', 2),
-- (3, 'Игрушки'),
(@toys_id, 'Развивающие игрушки для маленьких', 2),
(@toys_id, 'Мягкие игрушки', 2),
(@toys_id, 'Заводные игрушки', 2),
(@toys_id, 'Калейдоскопы, бинокли', 2),
(@toys_id, 'Транспорт', 2),
(@toys_id, 'Игры на природе', 2),
(@toys_id, 'Фигурки', 2),
(@toys_id, 'Игры в профессии', 2);

/*4*/
SELECT @toys_for_litle_id := id  FROM product_types WHERE product_type = 'Развивающие игрушки для маленьких';
INSERT INTO product_types (parent_id, product_type, level) VALUES
-- (3, 'Игрушки'),
-- (30, 'Развивающие игрушки для маленьких'),
(@toys_for_litle_id, 'Кубики, пирамидки', 3),
(@toys_for_litle_id, 'Магнитные доски, игры на магнитах', 3),
(@toys_for_litle_id, 'Рыбалки', 3);


SELECT * FROM product_types;

-- SELECT id, product_type, level, parent_id 
SELECT @i:=@i+1 num, id, product_type 
FROM (
		SELECT id,
			id AS id_3,
			parent_id,
			-- IF(parent_id = 0, id, parent_id) AS parent_id_1,
			IF(parent_id = 0, id, id) AS parent_id_1,
			IF(parent_id = 0, id, parent_id) AS prnt,
			level,
			IF(parent_id = 0, product_type, CONCAT('. ', product_type)) AS product_type			
		FROM product_types
		WHERE level < 2
		-- ORDER BY parent_id_1, id;
		UNION
		SELECT id,
			id AS id_3,
			parent_id, 
			IF(parent_id = 0, id, parent_id) AS parent_id_1,
			(SELECT parent_id FROM product_types pt_1 WHERE pt_1.id = pt.parent_id) AS prnt,
			level,
			IF(parent_id = 0, product_type, CONCAT('. . ', product_type)) AS product_type
		FROM product_types pt
		WHERE level = 2
		UNION 
		SELECT id,
		    IF(level = 3, parent_id , id) AS id_3,
			parent_id, 
			(SELECT parent_id FROM product_types pt_1 WHERE pt_1.id = pt.parent_id) AS parent_id_1,
			(
			  SELECT parent_id 
			    FROM product_types pt_2
			   WHERE pt_2.id IN (
						SELECT parent_id 
						  FROM product_types pt_1 
						 WHERE pt_1.id = pt.parent_id
					 )
			) AS prnt,
			level,
			IF(parent_id = 0, product_type, CONCAT('. . . ', product_type)) AS product_type
		FROM product_types pt, (SELECT @i:=0) X
		WHERE level = 3
		ORDER BY prnt, level, parent_id_1
		) AS tbl
-- WHERE prnt = 3
-- ORDER BY prnt, parent_id_1, id_3, level;
ORDER BY num;


