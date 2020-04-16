-- Описание проекта GeekBrains.

CREATE DATABASE geekbrains;

USE geekbrains;

-- faculties таблица хранящая в себе все программы обучения (справочник)
drop table faculties;
CREATE TABLE `faculties` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,  -- идентификатор факультета/профессии
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, -- название факультета/профессии
  `description_id` int(10) unsigned NOT NULL, -- ссылка на документ описание факультета/профессии (media)
  `icon_id` int(10) unsigned NOT NULL,-- ссылка на логотип факультета/профессии (media)
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
	
-- courses в этой таблице хранятся все курсы которые имеются на сервисе

CREATE TABLE `courses` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,  -- идентификатор курса
  `faculty_id` int(10) unsigned NOT NULL, -- к какому факультету или профессии привязан курс
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, --  название курса
  `description_id` int(10) unsigned NOT NULL, -- ссылка на документ описание курса (media)
  `teacher_id` int(10) unsigned NOT NULL, -- ссылка на профиль преподователя курса
  `visibility` boolean default false, -- видимость курса для пользователей (случай внедрения или приостановки курса)
  `icon_id` int(10) unsigned NOT NULL, -- ссылка на логотип курса (media)
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- программа обучения каждой профессии или факультета

CREATE TABLE `groups_gb` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,  -- индентификатор группы
  `course_id` int(10) unsigned NOT NULL, -- идентификатор курса обучения
  `curator_id` int(10) unsigned NOT NULL, -- ссылка на куратора группы
  `created_at` datetime DEFAULT current_timestamp(), -- время создания группы
  `start_at` date DEFAULT NULL, -- старт обучения
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- уроки всех курсов

CREATE TABLE `lessons` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT, 
  `course_id` int(10) unsigned NOT NULL,  -- ссылка на курс
  `video_id` int(10) unsigned NOT NULL, -- ссылка на видео урок (media)
  `description_id` int(10) unsigned NOT NULL, -- ссылка на описание инструкции прикрепленные к уроку (media)
  `doc_id` int(10) unsigned NOT NULL, -- ссылка на методичку (media)
  `start_at` datetime DEFAULT NULL, -- старт урока
  `time_lesson` int(11) NOT NULL, -- время на сдачу задания в днях (сутках)
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=251 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- все пользователи проекта

CREATE TABLE `users` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,  -- имя
  `last_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,  -- фамилия
  `patronymic` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,  -- отчество
  `town` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, -- город проживания
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, -- страна проживания
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, -- электронный адрес
  `birthday` date DEFAULT NULL, -- день рождения
  `phone` int(10) unsigned NOT NULL, -- номер телефона
  `gender` enum('M','W') COLLATE utf8_unicode_ci DEFAULT NULL,  -- пол
  `role` enum('ticher','student','curator') COLLATE utf8_unicode_ci DEFAULT NULL,  /* статус пользователя :
	                                                                              учитель, ученик, куратор группы */
  `groups_gb_id` int(10) unsigned NOT NULL,  -- ссылка на группу в которой учится пользователь (если он студент)
  `photo_id` int(10) unsigned NOT NULL, -- ссылка на фото пользователя (media)
  `created_at` datetime DEFAULT current_timestamp(), -- когда создана учетная запись
  `update_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),  -- последнее изменение данных пользователя
  `last_visit` datetime DEFAULT NULL, -- последний визит пользователя
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- таблица медиа файлов на сервисе

CREATE TABLE `media` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `media_type_id` int(10) unsigned NOT NULL, -- тип файла из справочника типов media_types
  `user_id` int(10) unsigned NOT NULL,  -- пользователь прикрепивший файл
  `metadata` JSON,  -- данные о файле в формате JSON
  `size_file` int(10) unsigned NOT NULL,  -- размер файла
  `file_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,  -- название файла 
  `created_at` datetime DEFAULT current_timestamp(),  -- время отправки файла
  `update_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(), -- время обновления файла
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=501 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- таблица справочник по типам медиа файлов

CREATE TABLE `media_types` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name_media_types` varchar(255) COLLATE utf8_unicode_ci NOT NULL, -- название типа файла
  PRIMARY KEY (`id`),
  UNIQUE KEY `name_media_types` (`name_media_types`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- новости для студентов

CREATE TABLE `news` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `theme` varchar(255) COLLATE utf8_unicode_ci NOT NULL, -- тема новости
  `body_id` int(10) unsigned NOT NULL, -- ссылка на текстовый файл (media)
  `news_media` int(10) unsigned NOT NULL, -- медиа файл (media)
  `autor_news` int(10) unsigned NOT NULL, -- ссылка на пользователя
  `created_at` datetime DEFAULT current_timestamp(), -- дата создания/обновления
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- обмен сообщениями на сервисе между участниками проекта	

CREATE TABLE `messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `from_user_id` int(10) unsigned NOT NULL, -- автор сообщения
  `to_user_id` int(10) unsigned NOT NULL,  -- адресат
  `body` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL, -- текст сообщения
  `is_important` tinyint(1) DEFAULT NULL, -- статус прочтения сообщения
  `is_delivered` tinyint(1) DEFAULT NULL, -- статус доставки сообщения
  `created_at` datetime DEFAULT current_timestamp(), -- время написания сообщения
  `read_at` datetime DEFAULT NULL, -- время прочтения сообщения
  `edited_at` datetime DEFAULT NULL, -- время последнего редактирования
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1001 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- таблица для фиксации прохождения урока учеником и деталей урока

CREATE TABLE `actions_students` (
  `user_id` int(10) unsigned NOT NULL, -- ссылка на пользователя
  `lesson_id` int(10) unsigned NOT NULL, -- ссылка к лекции
  `comments_lesson` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,  -- комментарии к лекции
  `comments_practice` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,  -- комментарии к заданию
  `assessment` tinyint(1) unsigned DEFAULT NULL, -- оценка студенту
  `teacher_id` int(10) unsigned NOT NULL, -- кто оценивал задание
  `media_id` int(10) unsigned NOT NULL,  -- прикрепленный файл к заданию
  `lesson_end` datetime DEFAULT current_timestamp(),  -- время сдачи задания
  PRIMARY KEY (`lesson_id`,`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


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

   
ALTER TABLE lessons 
  ADD CONSTRAINT lesson_course_id_fk 
    FOREIGN KEY (course_id) REFERENCES courses(id),
  ADD CONSTRAINT lesson_video_id_fk 
    FOREIGN KEY (video_id) REFERENCES media(id),
  ADD CONSTRAINT lesson_description_id_fk 
    FOREIGN KEY (description_id) REFERENCES media(id),
  ADD CONSTRAINT lesson_doc_id_fk 
    FOREIGN KEY (doc_id) REFERENCES media(id);

select * from faculties; 
ALTER TABLE faculties
  ADD CONSTRAINT faculty_icon_id_fk 
    FOREIGN KEY (icon_id) REFERENCES media(id),
  add constraint faculty_description_id_fk
    foreign key (description_id) references media(id);
   
ALTER TABLE groups_gb
  ADD CONSTRAINT groups_gb_course_id_fk 
    FOREIGN KEY (course_id) REFERENCES courses(id),
  ADD CONSTRAINT groups_gb_curator_id_fk 
    FOREIGN KEY (curator_id) REFERENCES users(id);

   
ALTER TABLE courses 
  ADD CONSTRAINT courses_faculties_id_fk 
    FOREIGN KEY (faculty_id) REFERENCES faculties(id),
  ADD CONSTRAINT courses_description_courses_id_fk 
    FOREIGN KEY (description_id) REFERENCES media(id),
  ADD CONSTRAINT course_teacher_id_fk 
    FOREIGN KEY (teacher_id) REFERENCES users(id),
  ADD CONSTRAINT course_icon_courses_id_fk 
    FOREIGN KEY (icon_id) REFERENCES media(id);


ALTER TABLE actions_students 
  ADD CONSTRAINT action_students_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id),
  ADD CONSTRAINT action_students_lesson_id_fk 
    FOREIGN KEY (lesson_id) REFERENCES lessons(id),
  ADD CONSTRAINT action_teacher_id_fk 
    FOREIGN KEY (teacher_id) REFERENCES users(id),
  ADD CONSTRAINT action_students_media_id_fk 
    FOREIGN KEY (media_id) REFERENCES media(id);
