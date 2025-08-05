-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
-- 
-- Хост: localhost
-- Время создания: Апр 19 2025 г., 12:21
-- Версия сервера: 10.3.34-MariaDB-0+deb10u1
-- Версия PHP: 7.3.31-1~deb10u1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: gs279471
--

-- --------------------------------------------------------

--
-- Структура таблицы users
--

CREATE TABLE users (
  id int(11) NOT NULL,
  name varchar(32) NOT NULL,
  password varchar(20) NOT NULL,
  email varchar(32) NOT NULL,
  age int(11) NOT NULL,
  gender int(11) NOT NULL,
  cash int(11) NOT NULL DEFAULT 500,
  level int(11) NOT NULL DEFAULT 1,
  skin int(11) NOT NULL,
  tutorial_completed INT DEFAULT 0,
  regdata varchar(20) NOT NULL,
  regip varchar(20) NOT NULL,
  lastdata varchar(20) NOT NULL,
  check_reg int(11) NOT NULL,
  admin int(11) NOT NULL,
  admin_password varchar(20) NOT NULL,
  admin_login int(11) NOT NULL,
  health float NOT NULL DEFAULT 100,
  armour float NOT NULL DEFAULT 0,
  minutes int(11) NOT NULL,
  exp int(11) NOT NULL DEFAULT 0,
  admin_rating int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Дамп данных таблицы users
--

INSERT INTO users (id, name, password, email, age, gender, cash, level, skin, regdata, regip, lastdata, check_reg, admin, admin_password, admin_login, health, armour, minutes, exp, admin_rating) VALUES
(7, 'Pavel_Pandochkin', 'ko11ko12', 'kapp34@yandex.ru', 24, 1, 100010501, 1, 19, '14.01.2022 21:55:38', '92.244.238.42', '14.01.2022 22:03:36', 1, 8, 'ko11ko12', 1, 100, 0, 0, 0, 0),
(8, 'Semen_Elsukov', 'abobus333', 'semtab111@gmail.com', 0, 1, 500, 80, 28, '16.04.2025 20:31:11', '176.59.100.245', '19.04.2025 12:16:25', 1, 8, 'abobus333', 1, 10, 0, 0, 80, 0),
(9, 'Matteo_Test', '12345678', 'dedededede@gmail.com', 0, 1, 500, 1, 28, '17.04.2025 16:05:13', '85.140.6.23', '17.04.2025 16:06:37', 1, 0, '', 0, 100, 0, 0, 0, 0);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы users
--
ALTER TABLE users
  ADD PRIMARY KEY (id);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы users
--
ALTER TABLE users
  MODIFY id int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

-- ��������� ����� �������
ALTER TABLE users
  ADD last_x FLOAT DEFAULT 0.0,
  ADD last_y FLOAT DEFAULT 0.0,
  ADD last_z FLOAT DEFAULT 0.0,
  ADD last_interior INT DEFAULT 0,
  ADD last_vw INT DEFAULT 0,
  ADD house_x FLOAT DEFAULT 0.0,
  ADD house_y FLOAT DEFAULT 0.0,
  ADD house_z FLOAT DEFAULT 0.0,
  ADD garage_x FLOAT DEFAULT 0.0,
  ADD garage_y FLOAT DEFAULT 0.0,
  ADD garage_z FLOAT DEFAULT 0.0,
  ADD faction_x FLOAT DEFAULT 0.0,
  ADD faction_y FLOAT DEFAULT 0.0,
  ADD faction_z FLOAT DEFAULT 0.0;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;