-- Описание проекта GeekBrains.

CREATE DATABASE geekbrains;

USE geekbrains;

-- faculty таблица хронящая в себе все программы обучения (справочник)

CREATE TABLE faculty (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- идентификатор факультета/профессии
	name_faculty VARCHAR (255) UNIQUE, -- название факультета/профессии
	descrition_faculty_id INT UNSIGNED NOT NULL, -- ссылка на документ описание факультета/профессии (media)
	icon_faculty_id INT UNSIGNED NOT NULL -- ссылка на логотип факультета/профессии (media)
	)
	
-- course в этой таблице хранятся все курсы которые имеются на сервисе

CREATE TABLE course (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- идентификатор курса
	faculty_id INT UNSIGNED NOT NULL, -- к какому факультету или профессии привязан курс
	name VARCHAR (255) UNIQUE, --  название курса
	description_course_id INT UNSIGNED NOT NULL, -- ссылка на документ описание курса (media)
	teacher_id INT UNSIGNED NOT NULL, -- ссылка на профиль преподователя курса
	visibility ENUM ('Y','N'), -- видимость курса для пользователей (случай внедрения или приостановки курса)
	icon_course_id INT UNSIGNED NOT NULL -- ссылка на логотип курса (media)
	)
	 

-- программа обучения каждой профессии или факультета

CREATE TABLE groups_gb (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- индентификатор группы
	course_id INT UNSIGNED NOT NULL, -- идентификатор курса обучения
	curator_id INT UNSIGNED NOT NULL, -- ссылка на куратора группы
	created_at DATETIME DEFAULT NOW(), -- время создания группы
	start_at DATE -- старт обучения
	)

-- уроки всех курсов

CREATE TABLE lesson (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	course_id INT UNSIGNED NOT NULL, -- ссылка на курс
	video_id INT UNSIGNED NOT NULL, -- ссылка на видео урок (media)
	description_id INT UNSIGNED NOT NULL, -- ссылка на описание инструкции прикрепленные к уроку (media)
	doc_id INT UNSIGNED NOT NULL, -- ссылка на методичку (media)
	start_at DATETIME DEFAULT NULL, -- старт урока
	time_lesson INT NOT NULL -- время на сдачу задания в днях (сутках)
	)

-- все пользователи проекта

CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR (255), -- имя
	last_name VARCHAR (255), -- фамилия
	patronymic VARCHAR (255), -- отчество
	town VARCHAR (255), -- город проживания
	country VARCHAR (255), -- страна проживания
	email VARCHAR (255), -- электронный адрес
	birthday DATE, -- день рождения
	phone INT UNSIGNED NOT NULL, -- номер телефона
	gender ENUM ('M','W'), -- пол
	status ENUM ('ticher','student', 'curator'),  /* статус пользователя :
	                                            учитель, ученик, куратор группы */
	groups_gb_id INT UNSIGNED NOT NULL, -- ссылка на группу в которой учится пользователь (если он студент)
	photo_id INT UNSIGNED NOT NULL, -- ссылка на фото пользователя (media)
	created_at DATETIME DEFAULT NOW(), -- когда создана учетная запись
	update_at DATETIME DEFAULT NOW() ON UPDATE NOW(), -- последнее изменение данных пользователя
	last_visit DATETIME DEFAULT NULL -- последний визит пользователя
	)

-- таблица медиа файлов на сервисе

CREATE TABLE media (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	media_type_id INT UNSIGNED NOT NULL, -- тип файла из справочника типов media_types
	user_id INT UNSIGNED NOT NULL, -- пользователь прикрепивщий файл
	metadata JSON, -- данные о файле в формате JSON
	size_file INT UNSIGNED NOT NULL, -- размер файла
	file_name VARCHAR (255), -- название файла
	created_at DATETIME DEFAULT NOW(), -- время отправки файла
	update_at DATETIME DEFAULT NOW() ON UPDATE NOW() -- время обновления файла
	)

-- таблица справочник по типам медиа файлов

CREATE TABLE media_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name_media_types VARCHAR (255) NOT NULL UNIQUE-- название типа файла
	)
	
-- новости для студентов

CREATE TABLE news (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	theme VARCHAR (255) NOT NULL, -- тема новости
	body_id INT UNSIGNED NOT NULL, -- -- ссылка на текстовый файл (media)
	news_media INT UNSIGNED NOT NULL, -- -- медиа файл (media)
	autor_news INT UNSIGNED NOT NULL, -- -- ссылка на пользователя
	created_at DATETIME DEFAULT NOW() -- дата создания/обновления
	)

-- обмен сообщениями на сервисе между участниками проекта	

CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	from_user_id INT UNSIGNED NOT NULL, -- автор сообщения
	to_user_id INT UNSIGNED NOT NULL, -- адресат
	body VARCHAR (255), -- текст сообщения
	is_important BOOLEAN, -- статус прочтения сообщения
	is_delivered BOOLEAN, -- статус доставки сообщения
	created_at DATETIME DEFAULT NOW(), -- время написания сообщения
	read_at DATETIME DEFAULT NULL, -- время прочтения сообщения
	edited_at DATETIME DEFAULT NULL -- время последнего редактирования
	)

-- таблица для фиксации прохождения урока учеником и деталей урока

CREATE TABLE actions_students (
	user_id INT UNSIGNED NOT NULL, -- ссылка на пользователя
	lesson_id INT UNSIGNED NOT NULL, -- ссылка к лекции
	comments_lesson VARCHAR (255), -- комментарии к лекции
	comments_practice VARCHAR (255), -- комментарии к заданию
	assessment TINYINT NULL,  -- оценка студенту
	teacher_id INT UNSIGNED NOT NULL, -- кто оценивал задание
	media_id INT UNSIGNED NOT NULL, -- прикрепленный файл к заданию
	lesson_end DATETIME DEFAULT NOW(), -- время сдачи задания
	PRIMARY KEY (lesson_id, user_id)
	)


-- Добавляем внешние ключи

ALTER TABLE users
  ADD CONSTRAINT users_groups_gb_id_fk 
    FOREIGN KEY (groups_gb_id) REFERENCES groups_gb(id),
  ADD CONSTRAINT users_photo_id_fk 
    FOREIGN KEY (photo_id) REFERENCES media(id);


ALTER TABLE news
  ADD CONSTRAINT news_body_id_fk 
    FOREIGN KEY (body_id) REFERENCES media(id),
  ADD CONSTRAINT news_photo_id_fk 
    FOREIGN KEY (news_media) REFERENCES media(id),
  ADD CONSTRAINT news_autor_news_fk
 	FOREIGN KEY (autor_news) REFERENCES users(id);

 
ALTER TABLE messages 
  ADD CONSTRAINT messages_from_user_id_fk 
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messegea_to_users_id_fk 
    FOREIGN KEY (to_user_id) REFERENCES users(id);


ALTER TABLE media 
  ADD CONSTRAINT media_media_type_id_fk 
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
  ADD CONSTRAINT media_users_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id);

   
ALTER TABLE lesson 
  ADD CONSTRAINT lesson_course_id_fk 
    FOREIGN KEY (course_id) REFERENCES course(id),
  ADD CONSTRAINT lesson_video_id_fk 
    FOREIGN KEY (video_id) REFERENCES media(id),
  ADD CONSTRAINT lesson_description_id_fk 
    FOREIGN KEY (description_id) REFERENCES media(id),
  ADD CONSTRAINT lesson_doc_id_fk 
    FOREIGN KEY (doc_id) REFERENCES media(id);


ALTER TABLE faculty
  ADD CONSTRAINT faculty_icon_faculty_id_fk 
    FOREIGN KEY (icon_faculty_id) REFERENCES media(id);
   
   
ALTER TABLE groups_gb
  ADD CONSTRAINT groups_gb_course_id_fk 
    FOREIGN KEY (course_id) REFERENCES course(id),
  ADD CONSTRAINT groups_gb_curator_id_fk 
    FOREIGN KEY (curator_id) REFERENCES users(id);
   
   
ALTER TABLE course 
  ADD CONSTRAINT course_faculty_id_fk 
    FOREIGN KEY (faculty_id) REFERENCES faculty(id),
  ADD CONSTRAINT course_description_course_id_fk 
    FOREIGN KEY (description_course_id) REFERENCES media(id),
  ADD CONSTRAINT course_teacher_id_fk 
    FOREIGN KEY (teacher_id) REFERENCES users(id),
  ADD CONSTRAINT course_icon_course_id_fk 
    FOREIGN KEY (icon_course_id) REFERENCES media(id);


ALTER TABLE actions_students 
  ADD CONSTRAINT action_students_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT action_students_lesson_id_fk 
    FOREIGN KEY (lesson_id) REFERENCES lesson(id),
  ADD CONSTRAINT action_teacher_id_fk 
    FOREIGN KEY (teacher_id) REFERENCES users(id),
  ADD CONSTRAINT action_students_media_id_fk 
    FOREIGN KEY (media_id) REFERENCES media(id);