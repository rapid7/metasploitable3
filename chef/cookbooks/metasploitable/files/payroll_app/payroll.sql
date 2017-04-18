-- phpMyAdmin SQL Dump
-- version 3.5.8
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Apr 10, 2017 at 04:42 PM
-- Server version: 5.5.54-0ubuntu0.14.04.1
-- PHP Version: 5.4.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `payroll`
--

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `username` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `first_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(40) COLLATE utf8mb4_unicode_ci NOT NULL,
  `salary` int(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`username`, `first_name`, `last_name`, `password`, `salary`) VALUES
('luke_skywalker', 'Luke', 'Skywalker', 'password', 102000),
('leia_organa', 'Leia', 'Organa', 'obiwan', 95600),
('han_solo', 'Han', 'Solo', 'sh00t-first', 12000),
('artoo_detoo', 'Artoo', 'Detoo', 'beep_b00p', 22000),
('c_three_pio', 'C', 'Threepio', 'pr0t0c0l', 32000),
('ben_kenobi', 'Ben', 'Kenobi', 'thats_no_moon', 1000000),
('darth_vader', 'Darth', 'Vader', 'd@rk_sid3', 666000),
('anakin_skywalker', 'Anakin', 'Skywalker', 'yipp33!!', 0),
('jarjar_binks', 'Jar-Jar', 'Binks', 'mesah_p@ssw0rd', 2000),
('lando_calrissian', 'Lando', 'Calrissian', 'b@ckstab', 4000000),
('boba_fett', 'Boba', 'Fett', 'mandalorian1', 2000000),
('jabba_hutt', 'Jabba', 'The Hutt', 'not-a-slug12', 10000000),
('greedo', 'Greedo', 'Rodian', 'hanShotFirst!', 500000),
('chewbacca', 'Chewbacca', '', 'rwaaaaawr5', 4500),
('kylo_ren', 'Kylo', 'Ren', 'daddy_issues1', 66600);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
