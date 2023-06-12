-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jun 12, 2023 at 06:55 PM
-- Server version: 10.3.38-MariaDB-cll-lve
-- PHP Version: 8.1.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `uumitpro_barterit_leon`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_items`
--

CREATE TABLE `tbl_items` (
  `item_id` int(6) NOT NULL,
  `user_id` int(6) NOT NULL,
  `item_name` varchar(100) NOT NULL,
  `item_desc` varchar(750) NOT NULL,
  `item_price` float NOT NULL,
  `item_delivery` float NOT NULL,
  `item_qty` int(6) NOT NULL,
  `item_state` varchar(30) NOT NULL,
  `item_local` varchar(100) NOT NULL,
  `item_lat` varchar(15) NOT NULL,
  `item_lng` varchar(15) NOT NULL,
  `item_date` datetime(6) NOT NULL DEFAULT current_timestamp(6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_items`
--

INSERT INTO `tbl_items` (`item_id`, `user_id`, `item_name`, `item_desc`, `item_price`, `item_delivery`, `item_qty`, `item_state`, `item_local`, `item_lat`, `item_lng`, `item_date`) VALUES
(4, 1, 'Pocket Screwdriver Set', 'A screwdriver set which has 4 flat heads and 2 phillips heads', 16.99, 1.2, 1, 'Perak', 'Jalan Muli, Kamunting', '4.8851283', '100.7420817', '2023-06-12 18:53:22.626888');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(5) NOT NULL,
  `user_email` varchar(50) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `user_phone` varchar(12) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `user_address` varchar(400) NOT NULL,
  `user_datereg` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `otp` int(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `user_email`, `user_name`, `user_phone`, `user_password`, `user_address`, `user_datereg`, `otp`) VALUES
(1, 'ewe.leon@yahoo.com.my', 'Leon', '0172529219', '21c357d6dd4a0d91e7f0f595b9941cc72c2b3f20', 'na', '2023-05-15 20:15:17.701812', 51244),
(2, 'chong123@gmail.com', 'Chong', '0123456789', 'bcf81c0ba89c6452e55038d410df808fec2e2a9e', 'na', '2023-05-19 23:05:25.705351', 54929),
(3, 'ali123@gmail.com', 'Ali', '01233882244', '5d210094dbd7c236266cd3d5b7e5a1d3257970bb', 'na', '2023-05-19 23:28:52.210723', 52485);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_items`
--
ALTER TABLE `tbl_items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `user_email` (`user_email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_items`
--
ALTER TABLE `tbl_items`
  MODIFY `item_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
