/*CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'УИД покупателя',
  `login` char(25) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Логин',
  `fio` char(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'ФИО покупателя',
  `birsday` date NOT NULL COMMENT 'День рождения',
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'E-mail',
  `phone` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Телефон',
  `сonsent` bit(1) NOT NULL DEFAULT b0 COMMENT 'Хочу быть в курсе скидок, новинок и секретных акций (Да/Нет)',
  `created_at` datetime DEFAULT current_timestamp() COMMENT 'Дата создания строки',
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp() COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `login` (`login`),
  UNIQUE KEY `fio` (`fio`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Покупатели (клиенты)';*/

DESCRIBE users;
-- 
-- Заполняем данными таблицу "Покупатели (клиенты)".
-- 
-- 
-- Обновить инфорамацмю в таблице "Покупатели (клиенты)", после вставки данных.
-- 
-- Заполняем время работы
UPDATE users SET time_work = 'from 09:00 to 18:00';
-- 
-- Обновляем дату создания записи
UPDATE users SET created_at=DATE_FORMAT(created_at,'2020-%m-%d %T');
-- 
-- Обновляем день рождения
UPDATE users SET birsday = DATE_FORMAT(birsday,'1997-%m-%d') WHERE YEAR(birsday) > 2010;
-- 
-- Обновляем поле Хочу быть в курсе скидок, новинок и секретных акций (Да/Нет
UPDATE users SET сonsent  = FLOOR(RAND() * 2); -- FLOOR - отбросить дробную часть

SELECT * FROM users;

INSERT INTO `users` (`id`, `login`, `fio`, `birsday`, `email`, `phone`, `сonsent`, `created_at`, `updated_at`) VALUES
  (1, 'aut', 'Nya Schultz', '1995-04-11', 'rosalinda.stanton@example.com', '1-346-118-0760', 0, '1970-01-14 09:32:10', '1995-12-27 05:15:17')
, (2, 'repudiandae', 'Charley Hilpert V', '1997-12-12', 'gusikowski.randy@example.net', '06812325643', 0, '1980-07-08 20:46:22', '2013-11-09 19:12:19')
, (3, 'nihil', 'Jadyn Zboncak DDS', '1976-06-23', 'fay.sammy@example.net', '1-944-892-6874x63565', 0, '2009-05-17 18:57:34', '1996-01-21 01:19:17')
, (4, 'qui', 'Cassandre Schoen', '1972-01-14', 'marcelo.bartoletti@example.org', '391.448.2821x297', 0, '1980-06-25 08:15:22', '2004-06-18 13:14:59')
, (5, 'temporibus', 'Linwood Kunze II', '1976-06-01', 'yweimann@example.com', '206.584.8625', 0, '1979-07-05 19:04:47', '2010-08-26 17:03:38')
, (6, 'placeat', 'Cicero Treutel', '1981-11-26', 'forn@example.com', '04241814878', 0, '2018-04-28 08:31:22', '1998-04-13 14:59:12')
, (7, 'omnis', 'Trystan Hammes', '1997-04-15', 'xmiller@example.org', '(372)706-5353', 0, '2001-03-28 01:51:31', '2014-09-27 22:55:02')
, (8, 'libero', 'Alden Homenick', '1997-02-08', 'eunice68@example.net', '131-638-6119x35253', 0, '2008-06-10 07:43:43', '2001-02-11 08:02:32')
, (9, 'voluptatum', 'Nikki Gusikowski', '1996-10-16', 'grath@example.net', '(857)516-1847x56630', 0, '2011-10-15 03:13:54', '2002-10-23 01:53:34')
, (10, 'doloribus', 'Dixie Gleichner', '1997-06-19', 'walter.herman@example.net', '+81(5)1324880100', 0, '2011-11-11 23:28:39', '2010-10-11 16:26:44')
, (11, 'nulla', 'Loma Tillman', '2012-04-25', 'emard.santos@example.com', '669.109.6821', 0, '2015-10-03 02:21:00', '2004-06-01 03:48:20')
, (12, 'mrmb', 'Mr. Murphy Balistreri', '2001-07-27', 'quentin.corwin@example.net', '+61(0)8571228505', 0, '2014-04-16 20:51:46', '2001-07-26 22:04:39')
, (13, 'incidunt', 'Ali Brown DVM', '1997-06-05', 'horacio50@example.org', '(110)053-3487x452', 0, '1990-04-27 17:01:10', '1991-05-22 09:24:45')
, (14, 'amet', 'Arvel Kerluke', '1977-10-02', 'sarai.oberbrunner@example.com', '880.121.4244x969', 0, '1984-01-24 07:56:23', '1980-02-15 03:52:37')
, (15, 'culpa', 'Mr. Reinhold Grant I', '1986-07-04', 'xwuckert@example.net', '854.520.8206x2151', 0, '1996-12-26 05:27:26', '2020-05-08 17:08:39')
, (16, 'distinctio', 'Ms. Jeanette Lakin Sr.', '1983-12-01', 'qkassulke@example.net', '142-803-0814x0657', 0, '2020-03-21 20:55:06', '2019-03-07 17:52:18')
, (17, 'porro', 'Alfredo Pagac', '1975-11-01', 'kabernathy@example.net', '1-565-738-5734', 0, '1985-06-04 23:17:48', '2012-09-03 22:03:59')
, (18, 'recusandae', 'Enrique Weimann DDS', '2003-01-17', 'caden.nitzsche@example.org', '(685)839-5183', 0, '1977-05-18 02:03:56', '2011-01-15 07:38:24')
, (19, 'enim', 'Eugene Harber', '1993-08-21', 'nreinger@example.net', '(367)104-1063x10944', 0, '2017-06-28 21:53:46', '2010-11-10 20:10:53')
, (20, 'non', 'Melba Harber', '1979-04-10', 'rwalsh@example.net', '145.770.1078x4785', 0, '1971-03-17 14:04:18', '2006-10-06 01:47:51')
, (21, 'laboriosam', 'Josefina Hilll', '1978-10-22', 'brenda.lehner@example.net', '738-013-0360', 0, '2000-05-09 15:04:03', '1981-09-18 10:10:43')
, (22, 'illum', 'Imogene Jacobi', '1997-08-11', 'rmertz@example.net', '764.453.2758x027', 0, '1974-01-21 14:42:01', '1995-09-18 13:19:41')
, (23, 'quod', 'Mr. Ferne Rippin Sr.', '1986-12-16', 'rhand@example.com', '1-235-106-1291x2078', 0, '2008-10-28 13:21:04', '1980-08-09 07:40:36')
, (24, 'eius', 'Maynard Osinski DDS', '1981-07-10', 'giuseppe38@example.com', '1-782-696-0631', 0, '2001-02-11 21:44:10', '2006-08-19 04:28:48')
, (25, 'uteh', 'Esperanza Hoppe', '1997-01-26', 'reggie.rutherford@example.org', '256-433-0117x95610', 0, '1987-10-27 15:25:31', '1984-06-03 03:16:22')
, (26, 'ipsum', 'Miss Allene Yost', '1986-09-22', 'treva36@example.org', '849.627.1288x201', 0, '1974-07-19 18:55:47', '1989-02-06 05:21:42')
, (27, 'quis', 'Dr. Lavina Schneider DVM', '2015-07-03', 'thompson.jaylen@example.net', '1-407-368-4908x2100', 0, '1974-01-30 00:06:21', '1993-02-19 20:58:38')
, (28, 'inmr', 'Prof. Maximus Rowe', '1996-02-14', 'claud.toy@example.net', '003-140-8688', 0, '2019-02-10 08:04:03', '1987-08-12 01:46:44')
, (29, 'idjs', 'Jerome Stehr', '1985-09-24', 'zita72@example.com', '860-031-6676', 0, '1983-09-17 08:22:07', '2017-01-18 07:39:16')
, (30, 'occaecati', 'Miss Jayne Bartoletti Sr.', '2007-06-20', 'jeramy20@example.net', '620-055-7154', 0, '1995-02-09 15:34:52', '1999-11-03 12:55:11')
, (31, 'nam', 'Dr. Alexis Waelchi III', '2003-10-24', 'xander58@example.net', '635.428.7701x36398', 0, '2018-07-07 23:31:22', '1995-04-05 23:00:29')
, (32, 'rerum', 'Prof. Edd Walter', '1997-05-25', 'rowe.brook@example.net', '+84(2)3982446668', 0, '1974-01-22 09:50:44', '2016-06-06 01:26:15')
, (33, 'adcr', 'Curtis Rolfson', '1979-12-15', 'rosalee16@example.org', '823-197-4762x43358', 0, '2005-11-04 12:16:53', '1986-02-12 02:24:30')
, (34, 'exercitationem', 'Prof. Cleta Roob', '1970-09-15', 'pluettgen@example.com', '1-059-506-2185', 0, '2003-03-04 14:02:19', '2006-03-07 12:26:45')
, (35, 'ullam', 'Norma Kuhic DVM', '1971-11-21', 'eeffertz@example.org', '1-937-213-0368x342', 0, '1977-09-07 07:19:14', '2003-12-09 03:51:19')
, (36, 'sit', 'Tobin Hauck', '1997-03-04', 'brooklyn88@example.org', '581-564-6017', 0, '1992-12-17 08:23:12', '2001-09-10 22:16:27')
, (37, 'iure', 'Wilhelm Monahan', '2000-02-14', 'reba.nienow@example.com', '966.668.5989x407', 0, '1989-09-03 17:21:51', '2008-03-08 09:13:28')
, (38, 'provident', 'Jerel Morar DDS', '1985-11-08', 'jmckenzie@example.com', '293.408.6130x700', 0, '2009-08-16 06:52:14', '2012-06-05 07:00:27')
, (39, 'quidem', 'Prof. Alexis Miller Sr.', '2019-11-25', 'beer.phoebe@example.net', '(107)066-1082', 0, '2001-03-21 00:07:30', '1978-03-08 15:56:28')
, (40, 'dignissimos', 'Ressie Braun', '1998-03-10', 'herzog.jailyn@example.com', '316.825.1190', 0, '1973-03-16 02:25:27', '2015-12-31 02:36:35')
, (41, 'impedit', 'Bert Renner', '2003-10-10', 'shane53@example.net', '008-190-3187x6817', 0, '1991-01-26 13:02:39', '1997-01-06 12:39:27')
, (42, 'atque', 'Jonathan Bins', '1992-03-04', 'considine.celia@example.com', '(030)626-5083x83426', 0, '2011-10-18 11:39:48', '1974-05-02 09:58:18')
, (43, 'voluptas', 'Derrick Koch', '1982-09-17', 'spencer76@example.com', '415.835.6627', 0, '1987-10-27 11:24:22', '1979-03-07 04:38:09')
, (44, 'fuga', 'Kaleb Heidenreich', '1974-02-12', 'tatum.walter@example.net', '1-722-386-7901', 0, '1989-04-28 02:34:59', '2001-07-07 06:32:16')
, (45, 'est', 'Alda Gutkowski MD', '1991-11-04', 'vrice@example.org', '338-026-2214', 0, '1990-01-09 08:35:34', '1977-04-14 00:01:27')
, (46, 'perspiciatis', 'Dr. Keanu Krajcik', '1987-04-20', 'ysenger@example.org', '865-129-8444x97432', 0, '1974-12-08 15:23:45', '1987-02-09 02:50:46')
, (47, 'soluta', 'Prof. Bettye Herzog III', '2001-09-08', 'cletus72@example.net', '782.924.3495', 0, '1976-11-08 20:43:48', '1991-07-05 00:29:11')
, (48, 'veniam', 'Mrs. Abigail Connelly IV', '1997-08-29', 'tianna.bogan@example.com', '05917646998', 0, '2006-10-21 23:03:19', '1996-02-13 17:08:46')
, (49, 'sed', 'Prof. Ken Sauer I', '1986-06-30', 'marian33@example.com', '1-426-373-1942x7219', 0, '1985-12-08 17:04:00', '1973-12-15 03:51:46')
, (50, 'tenetur', 'Prof. Marcelo Bosco', '1985-08-16', 'xauer@example.org', '+39(5)2185540201', 0, '2006-01-14 14:01:25', '1971-03-31 21:37:04')
, (51, 'maiores', 'Prof. Luis Becker', '1973-10-29', 'antwan.champlin@example.org', '445.268.7257x5911', 0, '2011-01-03 18:47:26', '2009-04-01 15:33:13')
, (52, 'ipsam', 'Mrs. Eulah Herman Sr.', '1982-04-05', 'luna90@example.com', '1-165-547-8476x359', 0, '2010-04-11 14:22:02', '1982-02-27 00:37:57')
, (53, 'autem', 'Brett Kub', '1970-07-04', 'trace40@example.org', '1-403-754-3754', 0, '2000-02-14 18:17:33', '2003-09-24 04:58:40')
, (54, 'magnam', 'Clovis Windler', '1991-02-25', 'prosacco.cierra@example.net', '974.295.3572x986', 0, '1991-02-08 23:44:29', '2007-11-07 05:04:17')
, (55, 'odio', 'Mr. Chauncey Treutel', '1989-08-28', 'clifford.kub@example.net', '(614)315-1876', 0, '1970-08-02 10:40:09', '2016-06-17 03:16:32')
, (56, 'abcde', 'Geoffrey Bruen', '1997-08-29', 'kessler.ellie@example.org', '049.088.2736x4587', 0, '1987-08-22 01:57:22', '1981-03-15 21:33:34')
, (57, 'nemo', 'Mr. Merlin Witting', '1997-07-10', 'beer.susana@example.org', '997.606.4621', 0, '1989-02-20 02:13:14', '1992-04-22 11:29:40')
, (58, 'aliquam', 'Stuart Emmerich III', '1970-09-22', 'trantow.neil@example.net', '03332296571', 0, '1985-02-01 09:51:25', '1993-08-10 16:46:52')
, (59, 'optio', 'Maureen Stiedemann V', '1997-01-14', 'carole.parker@example.net', '949.502.6088', 0, '2000-01-19 22:19:44', '1978-12-07 06:55:52')
, (60, 'tempora', 'Carmel Lowe', '1994-01-26', 'jordon.dare@example.net', '+49(3)2262717552', 0, '2018-09-05 12:15:44', '1990-06-08 21:40:54')
, (61, 'eligendi', 'Mrs. Maddison Pouros PhD', '1992-11-18', 'crystel69@example.net', '(277)230-1282', 0, '2007-04-09 18:31:22', '1972-09-26 17:37:31')
, (62, 'molestias', 'Christina Wyman II', '1971-06-21', 'izulauf@example.net', '1-568-352-3281', 0, '1978-11-08 14:05:15', '1976-05-05 21:10:47')
, (63, 'quos', 'Penelope Ebert', '1979-04-19', 'henderson.pollich@example.com', '+45(2)2516921208', 0, '1991-12-22 05:34:15', '1986-07-19 11:29:33')
, (64, 'magni', 'Breanna Homenick', '1982-10-24', 'herman.buddy@example.com', '1-434-055-2016x304', 0, '1973-01-24 19:15:32', '2013-02-28 18:06:06')
, (65, 'asperiores', 'Flavie Cole', '1998-11-18', 'harber.wilber@example.com', '1-538-279-2462', 0, '2012-03-12 04:04:21', '1995-04-23 12:12:48')
, (66, 'assumenda', 'Ana Casper', '1977-01-28', 'vicky.kuphal@example.com', '(725)022-6316x19323', 0, '1980-05-31 04:23:52', '2008-11-14 21:36:31')
, (67, 'earum', 'Porter Farrell', '1997-12-26', 'ciara29@example.org', '1-843-869-4100x1593', 0, '2009-10-24 21:39:49', '1987-08-07 22:08:20')
, (68, 'cum', 'Prof. Kellen Schultz DVM', '1997-04-30', 'carlotta.kunde@example.com', '294-470-2335x8761', 0, '1988-08-29 21:05:14', '1972-01-13 23:57:20')
, (69, 'minus', 'Prof. Gardner Carter', '1974-09-02', 'clement.price@example.org', '1-433-517-2502x654', 0, '1979-11-16 02:10:08', '1971-08-21 08:58:07')
, (70, 'dolorem', 'Carlotta Gottlieb II', '1975-08-02', 'legros.stephania@example.net', '334.590.6989x4962', 0, '2017-05-28 17:30:25', '1996-12-19 23:18:35')
, (71, 'eaque', 'Mr. Merritt Wolf', '1997-12-07', 'ayden97@example.net', '(897)543-0320x0610', 0, '1995-03-25 05:36:07', '2010-01-28 20:22:06')
, (72, 'ratione', 'Maybelle Wiza', '1994-01-24', 'fjacobs@example.org', '977-612-8891', 0, '1988-05-29 09:04:03', '2003-01-03 11:39:05')
, (73, 'totam', 'Heather Dickens DVM', '1997-09-27', 'teresa34@example.com', '822-722-5706', 0, '2012-08-02 00:55:58', '2019-04-12 14:13:45')
, (74, 'laborum', 'Augustine Raynor PhD', '1974-02-14', 'leffler.kailey@example.org', '(816)674-4907x95072', 0, '1973-08-31 11:38:55', '2019-05-18 06:22:29')
, (75, 'unde', 'Van Macejkovic', '1972-09-17', 'ykris@example.net', '(918)042-2804x87845', 0, '1971-01-01 21:05:24', '1971-12-01 07:18:22')
, (76, 'quia', 'Catherine Rohan', '2003-03-12', 'stanton.cyril@example.com', '+56(5)7352375611', 0, '2003-08-12 01:55:51', '2020-07-04 10:44:49')
, (77, 'reprehenderit', 'Hershel Koss', '1998-12-31', 'llewellyn.jacobson@example.com', '00154607938', 0, '1996-12-09 12:34:15', '2005-04-06 21:44:04')
, (78, 'sint', 'Tina Pagac IV', '1992-07-28', 'cruz71@example.com', '592.169.2094x899', 0, '2017-08-08 11:56:01', '1998-01-12 12:49:35')
, (79, 'eveniet', 'Lenny Morissette', '1975-05-23', 'khauck@example.com', '03577338331', 0, '1973-05-27 05:56:33', '1979-10-19 05:48:34')
, (80, 'quo', 'Alberta Barton', '1980-01-29', 'frederique.mcglynn@example.com', '06640660524', 0, '1997-12-20 00:07:55', '1990-05-23 03:06:03')
, (81, 'vero', 'Alec Stroman DVM', '1987-06-19', 'hgerhold@example.com', '1-266-505-9179x80401', 0, '2010-05-10 11:04:44', '2003-09-12 00:23:41')
, (82, 'tempore', 'Mrs. Claudie Crona', '1997-06-03', 'malika73@example.net', '(459)732-7960x567', 0, '1973-09-27 06:42:23', '1999-02-02 00:06:20')
, (83, 'molestiae', 'Dr. Candelario Kiehn Sr.', '2005-06-02', 'eloy.schmeler@example.org', '078.842.0280', 0, '2004-12-04 03:53:58', '1983-02-18 13:46:59')
, (84, 'neque', 'Prof. Benton Kirlin', '2001-04-30', 'joannie.gorczany@example.com', '174.223.5291', 0, '1979-11-07 02:58:27', '2020-01-12 14:38:48')
, (85, 'illo', 'Savannah Thiel', '2012-06-28', 'krajcik.mary@example.org', '(554)024-5939x6583', 0, '2015-02-25 09:43:51', '1982-11-26 23:11:14')
, (86, 'voluptatibus', 'Esperanza Dickinson', '2000-06-08', 'jovani27@example.org', '432.103.4127', 0, '1997-02-27 14:48:35', '2000-08-05 07:50:32')
, (87, 'modi', 'Verlie Dickens', '1986-01-04', 'philip42@example.net', '1-087-132-7542x017', 0, '1998-01-11 16:15:58', '2002-04-25 17:28:26')
, (88, 'velit', 'Petra Schroeder', '1997-04-16', 'jaiden.kub@example.net', '(701)231-2312x9101', 0, '1981-07-25 23:11:48', '2006-10-16 18:20:19')
, (89, 'alias', 'Russell Becker', '2005-12-16', 'dgraham@example.com', '502.163.0754', 0, '2008-04-22 09:54:09', '2010-11-12 17:31:54')
, (90, 'debitis', 'Lucio Kuvalis', '1996-10-27', 'shemar99@example.org', '823.745.1927x595', 0, '1997-05-17 22:45:28', '2013-05-27 01:58:09')
, (91, 'eos', 'Lee Kertzmann', '1987-09-30', 'stoltenberg.shanel@example.org', '(650)389-0311', 0, '1985-10-06 16:40:27', '1975-12-04 18:51:12')
, (92, 'aliquid', 'Jameson Hintz', '1996-11-08', 'osborne.murray@example.com', '08255990973', 0, '1977-01-27 10:34:20', '1980-06-27 22:10:27')
, (93, 'deserunt', 'Susan Wilderman', '1997-06-14', 'bartholome.mann@example.net', '570.478.0649', 0, '2000-04-25 23:33:18', '2015-02-20 02:45:18')
, (94, 'vel', 'Ms. Coralie Labadie IV', '1997-07-14', 'runolfsdottir.antonette@example.com', '1-501-781-8535x46595', 0, '1976-04-24 12:12:07', '1977-10-09 03:17:01')
, (95, 'architecto', 'Jackeline Simonis V', '1972-01-07', 'anderson.hope@example.com', '+24(7)1599903946', 0, '1974-07-24 08:07:38', '1990-02-23 04:30:44')
, (96, 'ducimus', 'Adrien Wyman', '1991-07-29', 'fgrimes@example.org', '242.739.8037', 0, '1979-10-21 01:58:15', '2003-05-01 05:39:50')
, (97, 'nesciunt', 'David Macejkovic', '1983-03-18', 'vincenza.durgan@example.com', '1-000-809-8891x70458', 0, '1999-12-05 09:38:54', '2013-01-03 12:28:53')
, (98, 'consequatur', 'Prof. Augustus Fay IV', '1997-06-15', 'ilene.beatty@example.net', '848-960-9232', 0, '2004-03-30 09:00:39', '2012-05-15 22:32:25')
, (99, 'excepturi', 'Domenica Bradtke I', '1997-07-14', 'vhand@example.com', '717.142.6020', 0, '2018-07-11 01:30:46', '2003-02-07 12:46:54')
, (100, 'quam', 'Aubree Fay PhD', '2001-11-23', 'madilyn.anderson@example.com', '(482)518-3217', 0, '2000-09-28 16:34:33', '1979-05-19 14:55:17')
, (101, 'corrupti', 'Christian Mitchell', '1997-02-27', 'millie.kassulke@example.org', '+99(5)8080360231', 0, '2009-10-29 15:29:11', '2011-04-24 12:01:46')
, (102, 'error', 'Miss Justina Reinger I', '1996-06-30', 'lewis10@example.net', '1-254-049-8762x216', 0, '1993-11-29 15:56:50', '1983-11-05 17:53:44')
, (103, 'quisquam', 'Jesse Osinski', '1997-05-11', 'robel.veronica@example.org', '+56(7)3608995722', 0, '2001-12-11 08:58:44', '1974-08-01 06:35:30')
, (104, 'pariatur', 'Sedrick Willms', '1996-08-04', 'durgan.melisa@example.com', '(260)911-9041x9487', 0, '1975-12-02 09:25:35', '2002-11-14 02:17:42')
, (105, 'harum', 'Noble Lakin', '1974-12-27', 'carlee.jenkins@example.com', '755.595.8383x679', 0, '1995-06-24 08:03:42', '1972-11-08 21:32:52')
, (106, 'reiciendis', 'Marjorie Hartmann', '1980-04-21', 'libbie.gulgowski@example.net', '462-685-1715', 0, '1987-09-10 23:35:35', '1972-08-14 19:03:26')
, (107, 'itaque', 'Miss Cindy Gutkowski Sr.', '1982-11-13', 'hahn.rory@example.com', '082-724-5429x67699', 0, '1979-01-01 04:49:28', '2014-03-23 12:14:22')
, (108, 'doloremque', 'Junius Grimes', '1995-04-07', 'beatty.kirsten@example.com', '06674074686', 0, '2015-07-11 10:37:31', '1990-12-21 12:50:00')
, (109, 'consectetur', 'Verdie Gerlach', '1979-11-15', 'kub.cesar@example.net', '246.652.8309x331', 0, '2015-11-23 00:03:06', '1995-09-15 18:40:22')
, (110, 'commodi', 'Alan Kiehn IV', '1974-11-28', 'kohler.akeem@example.com', '(570)475-9031x7249', 0, '1993-03-29 04:13:03', '1980-05-08 08:22:28')
, (111, 'sapiente', 'Lucienne Osinski', '1997-08-14', 'ruthie58@example.com', '1-818-451-8480', 0, '1997-07-22 20:00:32', '1993-03-24 02:15:53')
, (112, 'explicabo', 'Felipe Auer II', '1997-02-25', 'ezequiel.kiehn@example.net', '(842)315-8438x16578', 0, '1983-08-07 02:47:38', '1998-04-10 05:40:56')
, (113, 'cupiditate', 'Miss Isabell Pfeffer PhD', '1982-02-25', 'rdibbert@example.net', '(915)209-4819x84866', 0, '1980-10-04 19:28:39', '1970-07-30 04:35:08')
, (114, 'quasi', 'Jeanette Macejkovic', '1982-09-08', 'vincent.mosciski@example.net', '1-023-453-6503x45235', 0, '2002-10-21 09:01:07', '1977-11-22 17:50:56')
, (115, 'saepe', 'Arturo Cormier', '1987-11-28', 'vhayes@example.com', '(275)537-6436x304', 0, '1995-06-14 00:04:11', '1986-01-23 17:27:48')
, (116, 'possimus', 'Roel Kautzer', '1994-07-09', 'madaline90@example.org', '1-327-358-4537x910', 0, '2010-03-19 03:52:51', '2000-01-26 11:52:25')
, (117, 'veritatis', 'Daisha Nienow', '1985-12-05', 'annabell39@example.com', '05009805339', 0, '2009-10-16 23:58:36', '2020-02-28 11:06:20')
, (118, 'eum', 'Noble Beer', '1991-05-07', 'plarkin@example.net', '806.805.1367x1982', 0, '2010-10-20 04:05:08', '2019-08-02 16:17:04')
, (119, 'mollitia', 'Mrs. Estrella Donnelly', '1971-06-02', 'bahringer.destini@example.com', '1-303-054-7834', 0, '2008-03-18 12:41:24', '1995-10-15 13:18:26')
, (120, 'natus', 'Elvie Heaney', '1997-07-07', 'vesta42@example.net', '335-626-2967', 0, '2019-10-23 03:34:07', '1974-02-03 12:14:47')
, (121, 'cumque', 'Dr. Braulio Yundt', '1993-08-25', 'amiya78@example.com', '1-825-056-1281x82283', 0, '2016-07-09 18:31:45', '1972-04-19 04:26:54')
, (122, 'facere', 'Emanuel McKenzie', '1985-12-09', 'lonie.rempel@example.org', '145.245.1942x942', 0, '2020-10-28 06:14:46', '1997-09-19 13:46:21')
, (123, 'quibusdam', 'Trycia Bruen', '1980-12-08', 'hunter.harber@example.net', '1-725-278-3803', 0, '1977-04-06 02:32:44', '2009-06-14 16:57:31')
, (124, 'numquam', 'Mr. Izaiah Price', '1986-02-06', 'kkuhlman@example.com', '(402)538-0943', 0, '1997-06-14 00:49:26', '2004-12-21 18:24:28')
, (125, 'consequuntur', 'Arjun Rodriguez', '1974-04-05', 'jonatan92@example.org', '1-874-510-4302x33980', 0, '1972-07-07 13:03:45', '1982-05-15 18:33:57')
, (126, 'laudantium', 'Lucy Veum', '2005-03-03', 'kspinka@example.net', '446-177-1522x1200', 0, '2018-03-12 07:26:29', '1985-11-07 01:56:44')
, (127, 'facilis', 'Ignatius Halvorson', '1984-09-27', 'trice@example.net', '1-193-757-4214x6348', 0, '2005-05-18 02:33:13', '1970-02-03 06:27:12')
, (128, 'dolor', 'Pamela Streich', '1973-12-04', 'deckow.jackeline@example.com', '1-415-551-1456x039', 0, '2006-02-23 15:14:46', '1974-12-23 15:58:28')
, (129, 'quaerat', 'Maximo Feest', '1988-06-22', 'deron20@example.net', '(785)917-3807x7744', 0, '2005-05-08 06:23:25', '2011-12-13 23:50:04')
, (130, 'accusamus', 'Kathryn Kertzmann', '1998-02-15', 'hblock@example.org', '091-335-9203x957', 0, '1980-02-27 08:45:35', '1973-06-13 07:46:21')
, (131, 'voluptates', 'Oliver Legros', '1989-06-10', 'barrows.keith@example.com', '+32(4)9831393320', 0, '1992-03-23 03:00:46', '1987-12-03 15:31:07')
, (132, 'ipsa', 'Prof. Thaddeus Deckow DDS', '1985-11-26', 'erich74@example.org', '1-659-389-5320x249', 0, '2008-04-24 23:46:49', '2000-12-05 23:22:17')
, (133, 'quas', 'Dr. Elmo Hermann', '1972-01-01', 'psteuber@example.com', '+83(0)5194562349', 0, '2003-02-01 18:11:59', '1970-11-26 21:40:27')
, (134, 'mpadberg', 'Zena Grady', '2006-03-05', 'mpadberg@example.org', '1-625-908-8587x9901', 0, '1976-07-03 14:57:06', '1999-08-14 07:31:05')
, (135, 'iste', 'Ashlynn Parker', '1988-04-26', 'gutkowski.ora@example.com', '+25(1)8237368026', 0, '2010-11-15 11:41:48', '2008-12-21 04:52:36')
, (136, 'officiis', 'Alexandrea Reichel', '1975-05-17', 'wprice@example.net', '156-504-1378', 0, '1978-10-06 12:56:31', '1979-12-25 23:44:51')
, (137, 'suscipit', 'Orlo Parker Jr.', '1991-06-20', 'dthiel@example.net', '(034)884-8874', 0, '2006-11-16 15:23:14', '2007-09-23 11:54:55')
, (138, 'delectus', 'Burdette Bosco', '1997-08-15', 'alejandrin57@example.com', '1-836-445-4094x6768', 0, '1982-09-19 19:11:38', '2012-07-06 23:09:25')
, (139, 'beatae', 'Mr. Sean Carroll Jr.', '2009-03-29', 'ymertz@example.com', '07956212692', 0, '1985-03-11 02:07:03', '2016-06-08 22:10:27')
, (140, 'nobis', 'Yesenia Hintz Jr.', '1997-02-24', 'asa24@example.org', '1-461-148-7112x929', 0, '2014-09-05 21:34:03', '1972-02-13 18:12:51')
, (141, 'dicta', 'Prof. Dennis Dare IV', '1994-01-02', 'fhayes@example.org', '510-304-8120', 0, '1975-02-19 07:13:42', '1991-09-25 10:55:02')
, (142, 'necessitatibus', 'Miss Libbie Rutherford Sr.', '1984-01-25', 'sophie17@example.org', '027.371.3973x2855', 0, '1986-08-12 15:07:07', '1975-11-29 12:42:42')
, (143, 'perferendis', 'Haleigh Farrell', '1991-11-14', 'sallie43@example.org', '356.008.8683x903', 0, '2004-06-08 00:18:16', '1999-06-03 11:00:33')
, (144, 'sequi', 'Ms. Shyanne Legros DDS', '1992-06-29', 'hilll.heloise@example.net', '(535)609-5352x66542', 0, '2007-10-06 11:58:00', '1981-08-24 21:51:54')
, (145, 'esse', 'Annie Grant', '1984-08-01', 'beer.kari@example.net', '919.345.1492x824', 0, '2020-09-20 17:48:48', '1999-12-11 03:19:42')
, (146, 'minima', 'Fletcher O\'Kon II', '1974-06-16', 'nicolas.audra@example.org', '452-019-3939', 0, '1987-09-08 20:43:13', '1995-03-11 10:54:23')
, (147, 'similique', 'Dr. Nettie Crooks DDS', '2005-05-26', 'borer.carmen@example.org', '1-571-106-5768x03384', 0, '1989-12-27 19:21:35', '1999-08-28 09:24:52')
, (148, 'maxime', 'Prof. Cruz Reilly IV', '2001-04-02', 'jschroeder@example.net', '500.058.8684x23738', 0, '1982-03-14 17:44:09', '2007-04-14 17:51:17')
, (149, 'adipisci', 'Dr. Nicole Botsford', '1978-09-13', 'hodkiewicz.caroline@example.net', '704-845-4437', 0, '1993-11-04 17:38:21', '2014-12-01 20:14:00')
, (150, 'dolorum', 'Conor Hackett I', '1997-07-31', 'swift.delaney@example.org', '786.394.4562', 0, '2012-02-16 22:17:50', '2005-07-13 17:41:30');

