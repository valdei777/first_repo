-- �������� ������� GeekBrains.

CREATE DATABASE geekbrains;

USE geekbrains;

-- faculty ������� �������� � ���� ��� ��������� �������� (����������)

CREATE TABLE faculty (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- ������������� ����������/���������
	name_faculty VARCHAR (255) UNIQUE, -- �������� ����������/���������
	descrition_faculty_id INT UNSIGNED NOT NULL, -- ������ �� �������� �������� ����������/��������� (media)
	icon_faculty_id INT UNSIGNED NOT NULL -- ������ �� ������� ����������/��������� (media)
	)
	
-- course � ���� ������� �������� ��� ����� ������� ������� �� �������

CREATE TABLE course (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- ������������� �����
	faculty_id INT UNSIGNED NOT NULL, -- � ������ ���������� ��� ��������� �������� ����
	name VARCHAR (255) UNIQUE, --  �������� �����
	description_course_id INT UNSIGNED NOT NULL, -- ������ �� �������� �������� ����� (media)
	teacher_id INT UNSIGNED NOT NULL, -- ������ �� ������� ������������� �����
	visibility ENUM ('Y','N'), -- ��������� ����� ��� ������������� (������ ��������� ��� ������������ �����)
	icon_course_id INT UNSIGNED NOT NULL -- ������ �� ������� ����� (media)
	)
	 

-- ��������� �������� ������ ��������� ��� ����������

CREATE TABLE groups_gb (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- �������������� ������
	course_id INT UNSIGNED NOT NULL, -- ������������� ����� ��������
	curator_id INT UNSIGNED NOT NULL, -- ������ �� �������� ������
	created_at DATETIME DEFAULT NOW(), -- ����� �������� ������
	start_at DATE -- ����� ��������
	)

-- ����� ���� ������

CREATE TABLE lesson (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	course_id INT UNSIGNED NOT NULL, -- ������ �� ����
	video_id INT UNSIGNED NOT NULL, -- ������ �� ����� ���� (media)
	description_id INT UNSIGNED NOT NULL, -- ������ �� �������� ���������� ������������� � ����� (media)
	doc_id INT UNSIGNED NOT NULL, -- ������ �� ��������� (media)
	start_at DATETIME DEFAULT NULL, -- ����� �����
	time_lesson INT NOT NULL -- ����� �� ����� ������� � ���� (������)
	)

-- ��� ������������ �������

CREATE TABLE users (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR (255), -- ���
	last_name VARCHAR (255), -- �������
	patronymic VARCHAR (255), -- ��������
	town VARCHAR (255), -- ����� ����������
	country VARCHAR (255), -- ������ ����������
	email VARCHAR (255), -- ����������� �����
	birthday DATE, -- ���� ��������
	phone INT UNSIGNED NOT NULL, -- ����� ��������
	gender ENUM ('M','W'), -- ���
	status ENUM ('ticher','student', 'curator'),  /* ������ ������������ :
	                                            �������, ������, ������� ������ */
	groups_gb_id INT UNSIGNED NOT NULL, -- ������ �� ������ � ������� ������ ������������ (���� �� �������)
	photo_id INT UNSIGNED NOT NULL, -- ������ �� ���� ������������ (media)
	created_at DATETIME DEFAULT NOW(), -- ����� ������� ������� ������
	update_at DATETIME DEFAULT NOW() ON UPDATE NOW(), -- ��������� ��������� ������ ������������
	last_visit DATETIME DEFAULT NULL -- ��������� ����� ������������
	)

-- ������� ����� ������ �� �������

CREATE TABLE media (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	media_type_id INT UNSIGNED NOT NULL, -- ��� ����� �� ����������� ����� media_types
	user_id INT UNSIGNED NOT NULL, -- ������������ ������������ ����
	metadata JSON, -- ������ � ����� � ������� JSON
	size_file INT UNSIGNED NOT NULL, -- ������ �����
	file_name VARCHAR (255), -- �������� �����
	created_at DATETIME DEFAULT NOW(), -- ����� �������� �����
	update_at DATETIME DEFAULT NOW() ON UPDATE NOW() -- ����� ���������� �����
	)

-- ������� ���������� �� ����� ����� ������

CREATE TABLE media_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name_media_types VARCHAR (255) NOT NULL UNIQUE-- �������� ���� �����
	)
	
-- ������� ��� ���������

CREATE TABLE news (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	theme VARCHAR (255) NOT NULL, -- ���� �������
	body_id INT UNSIGNED NOT NULL, -- -- ������ �� ��������� ���� (media)
	news_media INT UNSIGNED NOT NULL, -- -- ����� ���� (media)
	autor_news INT UNSIGNED NOT NULL, -- -- ������ �� ������������
	created_at DATETIME DEFAULT NOW() -- ���� ��������/����������
	)

-- ����� ����������� �� ������� ����� ����������� �������	

CREATE TABLE messages (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	from_user_id INT UNSIGNED NOT NULL, -- ����� ���������
	to_user_id INT UNSIGNED NOT NULL, -- �������
	body VARCHAR (255), -- ����� ���������
	is_important BOOLEAN, -- ������ ��������� ���������
	is_delivered BOOLEAN, -- ������ �������� ���������
	created_at DATETIME DEFAULT NOW(), -- ����� ��������� ���������
	read_at DATETIME DEFAULT NULL, -- ����� ��������� ���������
	edited_at DATETIME DEFAULT NULL -- ����� ���������� ��������������
	)

-- ������� ��� �������� ����������� ����� �������� � ������� �����

CREATE TABLE actions_students (
	user_id INT UNSIGNED NOT NULL, -- ������ �� ������������
	lesson_id INT UNSIGNED NOT NULL, -- ������ � ������
	comments_lesson VARCHAR (255), -- ����������� � ������
	comments_practice VARCHAR (255), -- ����������� � �������
	assessment TINYINT NULL,  -- ������ ��������
	teacher_id INT UNSIGNED NOT NULL, -- ��� �������� �������
	media_id INT UNSIGNED NOT NULL, -- ������������� ���� � �������
	lesson_end DATETIME DEFAULT NOW(), -- ����� ����� �������
	PRIMARY KEY (lesson_id, user_id)
	)


-- ��������� ������� �����

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