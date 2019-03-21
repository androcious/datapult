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
  `locked` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`state_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `state`
--

LOCK TABLES `state` WRITE;
/*!40000 ALTER TABLE `state` DISABLE KEYS */;
INSERT INTO `state` VALUES ('AK','Alaska','Open',18,738432,3,0),('AL','Alabama','Closed',58,4858979,15,0),('AR','Arkansas','Open',37,2978204,8,0),('AS','American Samoa','N/A',10,55679,9,0),('AZ','Arizona','Semi-closed',75,6828065,3,0),('CA','California','Top-two',476,39144818,5,0),('CO','Colorado','Semi-closed',77,5456574,13,0),('CT','Connecticut','Closed',65,3590886,7,0),('DC','DC','N/A',37,693972,8,0),('DE','Delaware','Closed',27,945934,3,0),('FL','Florida','Closed',238,20271272,8,0),('GA','Georgia','Open',112,10214860,14,0),('GU','Guam','N/A',11,164229,3,0),('HI','Hawaii','Open',31,1431603,14,0),('IA','Iowa','Open',54,3123899,3,0),('ID','Idaho','Semi-closed',24,1654930,4,0),('IL','Illinois','Open',190,12859995,7,0),('IN','Indiana','Open',79,6619680,9,0),('KS','Kansas','Semi-closed',37,2911641,8,0),('KY','Kentucky','Closed',53,4425092,11,0),('LA','Louisiana','Top-two',61,4670724,3,0),('MA','Massachusetts','Semi-closed',121,6794422,11,0),('MD','Maryland','Closed',105,6006401,14,0),('ME','Maine','Closed',30,1329328,9,0),('MI','Michigan','Open',152,9922576,2,0),('MN','Minnesota','Open',94,5489594,11,0),('MO','Missouri','Open',88,6083672,4,0),('MP','Northern Mariana Islands','N/A',11,55144,3,0),('MS','Mississippi','Open',41,2992333,1,0),('MT','Montana','Open',22,1032949,12,0),('NC','North Carolina','Semi-closed',120,10042802,11,0),('ND','North Dakota','Open',19,756927,2,0),('NE','Nebraska','Semi-closed',31,1896190,8,0),('NH','New Hampshire','Semi-closed',32,1330608,4,0),('NJ','New Jersey','Semi-closed',126,8958013,11,0),('NM','New Mexico','Closed',38,2085109,11,0),('NV','Nevada','Closed',39,2890845,5,0),('NY','New York','Closed',277,19795791,10,0),('OH','Ohio','Open',165,11613423,1,0),('OK','Oklahoma','Semi-closed',42,3911338,7,0),('OR','Oregon','Closed',64,4028977,2,0),('PA','Pennsylvania','Closed',181,12802503,2,0),('PR','Puerto Rico','N/A',58,3337000,2,0),('RI','Rhode Island','Semi-closed',31,1056298,6,0),('SC','South Carolina','Open',57,4896146,6,0),('SD','South Dakota','Semi-closed',20,858469,13,0),('TN','Tennessee','Open',77,6600299,15,0),('TX','Texas','Open',237,27469114,6,0),('UT','Utah','Semi-closed',28,2995919,14,0),('VA','Virginia','Open',112,8382993,7,0),('VI','Virgin Islands','N/A',11,107268,6,0),('VT','Vermont','Open',23,626042,9,0),('WA','Washington','Top-two',102,7170351,12,0),('WI','Wisconsin','Open',89,5771337,4,0),('WV','West Virginia','Semi-closed',35,1844128,11,0),('WY','Wyoming','Open',17,586107,13,0);
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

-- Dump completed on 2019-03-20 23:48:49
