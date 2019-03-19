-- MySQL dump 10.14  Distrib 5.5.60-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: gtep_test
-- ------------------------------------------------------
-- Server version	5.5.60-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `state` (
  `state_code` varchar(2) NOT NULL COMMENT 'Two-letter unique state code',
  `name` varchar(255) NOT NULL,
  `type_of_primary` varchar(45) DEFAULT NULL,
  `delegates_at_play` int(11) DEFAULT NULL,
  `population` int(8) DEFAULT NULL,
  `current_winner` int(4) DEFAULT NULL,
  PRIMARY KEY (`state_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
INSERT INTO `state` VALUES ('AK','Alaska','Open',18,738432,5),('AL','Alabama','Closed',58,4858979,10),('AR','Arkansas','Open',37,2978204,3),('AS','American Samoa','N/A',10,55679,7),('AZ','Arizona','Semi-closed',75,6828065,4),('CA','California','Top-two',476,39144818,6),('CO','Colorado','Semi-closed',77,5456574,9),('CT','Connecticut','Closed',65,3590886,6),('DC','DC','N/A',37,693972,11),('DE','Delaware','Closed',27,945934,4),('FL','Florida','Closed',238,20271272,9),('GA','Georgia','Open',112,10214860,9),('GU','Guam','N/A',11,164229,6),('HI','Hawaii','Open',31,1431603,3),('IA','Iowa','Open',54,3123899,9),('ID','Idaho','Semi-closed',24,1654930,3),('IL','Illinois','Open',190,12859995,8),('IN','Indiana','Open',79,6619680,10),('KS','Kansas','Semi-closed',37,2911641,2),('KY','Kentucky','Closed',53,4425092,3),('LA','Louisiana','Top-two',61,4670724,6),('MA','Massachusetts','Semi-closed',121,6794422,1),('MD','Maryland','Closed',105,6006401,8),('ME','Maine','Closed',30,1329328,3),('MI','Michigan','Open',152,9922576,2),('MN','Minnesota','Open',94,5489594,2),('MO','Missouri','Open',88,6083672,4),('MP','Northern Mariana Islands','N/A',11,55144,2),('MS','Mississippi','Open',41,2992333,6),('MT','Montana','Open',22,1032949,2),('NC','North Carolina','Semi-closed',120,10042802,5),('ND','North Dakota','Open',19,756927,5),('NE','Nebraska','Semi-closed',31,1896190,1),('NH','New Hampshire','Semi-closed',32,1330608,9),('NJ','New Jersey','Semi-closed',126,8958013,11),('NM','New Mexico','Closed',38,2085109,6),('NV','Nevada','Closed',39,2890845,8),('NY','New York','Closed',277,19795791,8),('OH','Ohio','Open',165,11613423,4),('OK','Oklahoma','Semi-closed',42,3911338,8),('OR','Oregon','Closed',64,4028977,5),('PA','Pennsylvania','Closed',181,12802503,11),('PR','Puerto Rico','N/A',58,3337000,7),('RI','Rhode Island','Semi-closed',31,1056298,1),('SC','South Carolina','Open',57,4896146,7),('SD','South Dakota','Semi-closed',20,858469,7),('TN','Tennessee','Open',77,6600299,6),('TX','Texas','Open',237,27469114,6),('UT','Utah','Semi-closed',28,2995919,1),('VA','Virginia','Open',112,8382993,8),('VI','Virgin Islands','N/A',11,107268,6),('VT','Vermont','Open',23,626042,3),('WA','Washington','Top-two',102,7170351,9),('WI','Wisconsin','Open',89,5771337,3),('WV','West Virginia','Semi-closed',35,1844128,9),('WY','Wyoming','Open',17,586107,4);
/*!40000 ALTER TABLE `state` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-03-19  0:38:47
