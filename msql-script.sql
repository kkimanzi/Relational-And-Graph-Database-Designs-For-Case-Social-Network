-- Create Database --
DROP DATABASE IF EXISTS mydeveloperdb; 
CREATE DATABASE mydeveloperdb;

-- Use this database
USE mydeveloperdb;

-- Create Tables --
CREATE TABLE Developer (
	id int NOT NULL AUTO_INCREMENT,
	email varchar(100) NOT NULL,
	first_name varchar(50),
	last_name varchar(50),
	experience int,
	date_joined datetime DEFAULT CURRENT_TIMESTAMP,
	date_left datetime,
	PRIMARY KEY (id)
);

CREATE TABLE Field (
	id int NOT NULL AUTO_INCREMENT,
	name varchar(100),
	PRIMARY KEY (id)
);

CREATE TABLE Developer_Field (
	id int NOT NULL AUTO_INCREMENT,
	developer_id int,
	field_id int,
	PRIMARY KEY (id),
	FOREIGN KEY (developer_id) REFERENCES Developer(id),
	FOREIGN KEY (field_id) REFERENCES Field(id)
);

CREATE TABLE Post (
	id int NOT NULL AUTO_INCREMENT,
	developer_id int,
	field_id int,
	title TEXT,
	description TEXT,
	time_posted datetime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	FOREIGN KEY (developer_id) REFERENCES Developer(id),
	FOREIGN KEY (field_id) REFERENCES Field(id)
);

CREATE TABLE Like_ (
	post_id int NOT NULL,
	developer_id int NOT NULL,
	time_liked datetime DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_like PRIMARY KEY (post_id,developer_id),
	FOREIGN KEY (post_id) REFERENCES Post(id),
	FOREIGN KEY (developer_id) REFERENCES Developer(id)
);

CREATE TABLE Follower (
	follower_id int NOT NULL,
	followed_id int NOT NULL,
	time_followed datetime DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_follwer PRIMARY KEY (follower_id, followed_id),
	FOREIGN KEY (follower_id) REFERENCES Developer(id),
	FOREIGN KEY (followed_id) REFERENCES Developer(id)
);

CREATE TABLE Question (
	id int NOT NULL AUTO_INCREMENT,
	title TEXT,
	description TEXT,
	developer_id int,
	field_id int,
	time_posted datetime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	FOREIGN KEY (developer_id) REFERENCES Developer(id),
	FOREIGN KEY (field_id) REFERENCES Field(id)
);

CREATE TABLE Answer (
	id int NOT NULL AUTO_INCREMENT,
	question_id int,
	developer_id int,
	time_posted datetime DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (id),
	FOREIGN KEY (question_id) REFERENCES Question(id),
	FOREIGN KEY (developer_id) REFERENCES Developer(id)
);



-- Creating Test Data --
-- Insert Test Fields
INSERT INTO Field (id, name) 
VALUES 
(1, "Python"),
(2, "Java");

-- Insert Test Developers
INSERT INTO Developer (id, email, first_name, last_name, experience)
VALUES 
(1, "joe123@gmail.com", "joe", "justin", 4),
(2, "randomartin@gmail.com", "randy", "martin", 7),
(3, "danieljoe@gmail.com", "daniel", "joe", 4);

-- Insert fields of expertise of developers
INSERT INTO Developer_Field (developer_id, field_id)
VALUES 
(1, 1),
(2, 2),
(3, 1);

-- Insert posts
INSERT INTO Post (id, developer_id, field_id, title, description)
VALUES 
(1, 1, 1, "Tuples", "Tuples provide a way to store data that is ..."),
(2, 1, 1, "TKinter", "TKinter allows you to create GUI in Python ..."),
(3, 1, 1, "The Good, the Bad, the Ugly: Python", "There has been a growing demand for Python developers...."),
(4, 2, 2, "Java EE", "Java EE provides a collection of tools that enable you create ...");

-- Insert likes
INSERT INTO Like_ (post_id, developer_id)
VALUES
(1, 2),
(1, 3),
(2, 2),
(3, 1);

-- Queries --
-- List member with most posts
SELECT developer_id, MAX(post_count.count) AS number_of_posts
FROM
	(SELECT developer_id, COUNT(*) AS count 
	FROM Post 
	GROUP BY developer_id) post_count;

-- Count number of likes for posts
SELECT Developer.first_name, Developer.last_name, x.Post, x.Date_Posted, x.Likes
FROM Developer
INNER JOIN
	(SELECT Like_.developer_id, COUNT(*) AS Likes, Post.title AS Post, Post.time_posted AS Date_Posted 
	FROM Like_
	INNER JOIN Post ON Like_.post_id = Post.id
	GROUP BY Like_.post_id) x
ON Developer.id = x.developer_id;