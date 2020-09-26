-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Sep 07, 2020 at 06:25 AM
-- Server version: 8.0.18
-- PHP Version: 7.4.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `sangeethagroups`
--

-- --------------------------------------------------------

--
-- Table structure for table `customer_details`
--

DROP TABLE IF EXISTS `customer_details`;
CREATE TABLE IF NOT EXISTS `customer_details` (
  `cname` varchar(40) NOT NULL DEFAULT '',
  `ccode` varchar(12) NOT NULL,
  `cnum` varchar(30) NOT NULL DEFAULT '',
  `caddress` tinytext,
  `caddate` varchar(11) NOT NULL DEFAULT '',
  `amountbl` varchar(8) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`ccode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `customer_details`
--

INSERT INTO `customer_details` (`cname`, `ccode`, `cnum`, `caddress`, `caddate`, `amountbl`, `del`) VALUES
('Dd agency', 'DA195U', '9854123478', 'Tup', '03-08-2020', '360', ''),
('Kannan Waters', 'KW427P', '9524215179', 'Tupp', '01-09-2020', '8500', ''),
('naveen waters', 'NW835C', '9524215179', 'cbe', '05-09-2020', '300', '');

-- --------------------------------------------------------

--
-- Table structure for table `employee_details`
--

DROP TABLE IF EXISTS `employee_details`;
CREATE TABLE IF NOT EXISTS `employee_details` (
  `ename` varchar(40) NOT NULL DEFAULT '',
  `ecode` varchar(12) NOT NULL DEFAULT '',
  `enum` varchar(30) NOT NULL DEFAULT '',
  `eaddress` tinytext,
  `eaddate` varchar(12) NOT NULL DEFAULT '',
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`ecode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `employee_details`
--

INSERT INTO `employee_details` (`ename`, `ecode`, `enum`, `eaddress`, `eaddate`, `del`) VALUES
('Kavin Kumar', 'SG23TK', '9587469812', 'Tirupur', '28-07-2020', ''),
('Naveen Kumar', 'SG97BNK', '9787284456', 'SR Nagar', '28-07-2020', ''),
('Kannan S', 'SG77WK', '9542354698', 'Banglore', '29-07-2020', '');

-- --------------------------------------------------------

--
-- Table structure for table `material_details`
--

DROP TABLE IF EXISTS `material_details`;
CREATE TABLE IF NOT EXISTS `material_details` (
  `mname` varchar(30) NOT NULL DEFAULT '',
  `mcode` varchar(10) NOT NULL,
  `munit` varchar(15) NOT NULL DEFAULT '',
  `mpriceperunit` varchar(10) NOT NULL DEFAULT '',
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`mcode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `material_details`
--

INSERT INTO `material_details` (`mname`, `mcode`, `munit`, `mpriceperunit`, `del`) VALUES
('Jelly 20mm', 'J23Q', 'Load', '1150', ''),
('Cement', 'C57E', 'Bag', '145', '');

-- --------------------------------------------------------

--
-- Table structure for table `material_purchase`
--

DROP TABLE IF EXISTS `material_purchase`;
CREATE TABLE IF NOT EXISTS `material_purchase` (
  `mpcode` varchar(10) NOT NULL,
  `scode` varchar(12) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `date` varchar(11) NOT NULL,
  `billno` varchar(40) NOT NULL,
  `mcode` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `quantity` varchar(10) NOT NULL,
  `unitprice` varchar(10) NOT NULL DEFAULT '',
  `price` varchar(12) NOT NULL,
  `remarks` tinytext,
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`mpcode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `material_purchase`
--

INSERT INTO `material_purchase` (`mpcode`, `scode`, `date`, `billno`, `mcode`, `quantity`, `unitprice`, `price`, `remarks`, `del`) VALUES
('K5038ZX', 'DC956A', '2020-07-21', 'AW56R', 'C57E', '6', '149', '894', 'NIL', ''),
('X4181VC', 'DC956A', '2020-07-28', 'HT56J', 'C57E', '8', '145', '1160', 'NONE', '');

-- --------------------------------------------------------

--
-- Table structure for table `production_details`
--

DROP TABLE IF EXISTS `production_details`;
CREATE TABLE IF NOT EXISTS `production_details` (
  `pdcode` varchar(12) NOT NULL,
  `date` varchar(12) NOT NULL DEFAULT '',
  `pcode` varchar(10) NOT NULL DEFAULT '',
  `ecode` varchar(12) NOT NULL DEFAULT '',
  `sps` varchar(10) NOT NULL DEFAULT '',
  `nos` varchar(10) NOT NULL DEFAULT '',
  `nosps` varchar(12) NOT NULL DEFAULT '',
  `salary` varchar(10) NOT NULL DEFAULT '',
  `remarks` tinytext,
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`pdcode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `production_details`
--

INSERT INTO `production_details` (`pdcode`, `date`, `pcode`, `ecode`, `sps`, `nos`, `nosps`, `salary`, `remarks`, `del`) VALUES
('A3212PE', '2020-08-06', 'HB2S74P', 'SG23TK', '200', '1', '300', '200', '', ''),
('N4339RH', '2020-08-02', 'HB4S64O', 'SG77WK', '400', '5', '100', '2000', '', '1'),
('K2234CG', '2020-08-01', 'HB4S64O', 'SG97BNK', '400', '5', '100', '2000', '', '1');

-- --------------------------------------------------------

--
-- Table structure for table `product_details`
--

DROP TABLE IF EXISTS `product_details`;
CREATE TABLE IF NOT EXISTS `product_details` (
  `pname` varchar(30) NOT NULL DEFAULT '',
  `pcode` varchar(10) NOT NULL,
  `salaryps` varchar(10) NOT NULL DEFAULT '',
  `nosps` varchar(10) NOT NULL DEFAULT '',
  `sunit` varchar(15) NOT NULL DEFAULT '',
  `pricepersunit` varchar(10) NOT NULL DEFAULT '',
  `nospsunit` varchar(10) NOT NULL DEFAULT '',
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`pcode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `product_details`
--

INSERT INTO `product_details` (`pname`, `pcode`, `salaryps`, `nosps`, `sunit`, `pricepersunit`, `nospsunit`, `del`) VALUES
('Hollow Block 40\" Solid', 'HB4S64O', '400', '100', 'Load', '150', '1', ''),
('Hollow block 20\" solid', 'HB2S74P', '200', '300', 'Load', '120', '1', '');

-- --------------------------------------------------------

--
-- Table structure for table `sales_details`
--

DROP TABLE IF EXISTS `sales_details`;
CREATE TABLE IF NOT EXISTS `sales_details` (
  `slcode` varchar(12) NOT NULL,
  `ccode` varchar(12) NOT NULL DEFAULT '',
  `date` varchar(12) NOT NULL DEFAULT '',
  `billno` varchar(40) NOT NULL DEFAULT '',
  `pcode` varchar(15) NOT NULL DEFAULT '',
  `quantity` varchar(10) NOT NULL DEFAULT '',
  `pricepersunit` varchar(12) NOT NULL DEFAULT '',
  `price` varchar(12) NOT NULL DEFAULT '',
  `remarks` varchar(100) NOT NULL DEFAULT '',
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`slcode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sales_details`
--

INSERT INTO `sales_details` (`slcode`, `ccode`, `date`, `billno`, `pcode`, `quantity`, `pricepersunit`, `price`, `remarks`, `del`) VALUES
('S1594GQ', 'DA195U', '2020-08-13', '44FG4', 'HB4S64O', '9', '150', '1350', 'Hey', ''),
('J3285SS', 'DA195U', '2020-08-14', '54s', 'HB4S64O', '5', '4000', '20000', '', ''),
('Y216BR', 'DA195U', '2020-08-20', '58po', 'HB2S74P', '320', '120', '38400', '', ''),
('G5187NS', 'DA195U', '2020-08-14', '5', 'HB2S74P', '89', '120', '10680', '', ''),
('E7688QX', 'DA195U', '2020-08-13', '5', 'HB4S64O', '5', '150', '750', '', ''),
('A1364NL', 'DA195U', '2020-09-15', 'd', 'HB4S64O', '6', '150', '900', '', ''),
('J2534RF', 'KW427P', '2020-09-26', '56', 'HB4S64O', '5', '150', '750', '', ''),
('K8419ZH', 'KW427P', '2020-09-12', '568', 'HB4S64O', '52', '150', '7800', '', ''),
('Z5803MJ', 'KW427P', '2020-09-11', 'we', 'HB4S64O', '23', '150', '3450', '', ''),
('S8137KQ', 'KW427P', '2020-09-10', '7', 'HB2S74P', '10', '120', '1200', '', ''),
('Z6745BK', 'KW427P', '2020-09-12', 'j', 'HB2S74P', '5', '120', '850', '', ''),
('L7834DA', 'KW427P', '2020-09-10', '568', 'HB4S64O', '20', '150', '3000', '', ''),
('P1581JC', 'DA195U', '2020-09-03', 'sd', 'HB2S74P', '3', '120', '360', '', ''),
('F2848NC', 'NW835C', '2020-09-10', '568', 'HB4S64O', '2', '150', '300', '', '');

-- --------------------------------------------------------

--
-- Table structure for table `sales_py_entry`
--

DROP TABLE IF EXISTS `sales_py_entry`;
CREATE TABLE IF NOT EXISTS `sales_py_entry` (
  `spycode` int(7) NOT NULL AUTO_INCREMENT,
  `ccode` varchar(12) NOT NULL,
  `date` varchar(11) NOT NULL,
  `amount` varchar(7) NOT NULL,
  `mop` varchar(12) NOT NULL,
  PRIMARY KEY (`spycode`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `sales_py_entry`
--

INSERT INTO `sales_py_entry` (`spycode`, `ccode`, `date`, `amount`, `mop`) VALUES
(1, 'df', '12', '236', 'ff');

-- --------------------------------------------------------

--
-- Table structure for table `stock_details`
--

DROP TABLE IF EXISTS `stock_details`;
CREATE TABLE IF NOT EXISTS `stock_details` (
  `pcode` varchar(30) NOT NULL,
  `cstock` varchar(15) NOT NULL DEFAULT '',
  `rstock` varchar(15) NOT NULL DEFAULT '',
  `tstock` varchar(15) NOT NULL DEFAULT '',
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`pcode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `stock_details`
--

INSERT INTO `stock_details` (`pcode`, `cstock`, `rstock`, `tstock`, `del`) VALUES
('HB2S74P', '2576', '-3', '2573', ''),
('HB4S64O', '2685', '-2', '2683', '');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_details`
--

DROP TABLE IF EXISTS `supplier_details`;
CREATE TABLE IF NOT EXISTS `supplier_details` (
  `sname` varchar(40) NOT NULL DEFAULT '',
  `scode` varchar(12) NOT NULL DEFAULT '',
  `snum` varchar(30) NOT NULL DEFAULT '',
  `saddress` tinytext CHARACTER SET utf8 COLLATE utf8_unicode_ci,
  `saddate` varchar(11) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `del` varchar(5) NOT NULL DEFAULT '',
  PRIMARY KEY (`scode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `supplier_details`
--

INSERT INTO `supplier_details` (`sname`, `scode`, `snum`, `saddress`, `saddate`, `del`) VALUES
('Dharun Cements', 'DC956A', '9875469854', 'Tirupur', '29-07-2020', '');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
