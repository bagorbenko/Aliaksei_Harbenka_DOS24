-- MySQL dump 10.13  Distrib 8.0.40, for Linux (x86_64)
--
-- Host: localhost    Database: lab_tests
-- ------------------------------------------------------
-- Server version	8.0.40-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Analysis`
--

DROP TABLE IF EXISTS `Analysis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Analysis` (
  `an_id` int NOT NULL AUTO_INCREMENT,
  `an_name` varchar(255) DEFAULT NULL,
  `an_cost` decimal(10,2) DEFAULT NULL,
  `an_price` decimal(10,2) DEFAULT NULL,
  `an_group` int DEFAULT NULL,
  PRIMARY KEY (`an_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Analysis`
--

LOCK TABLES `Analysis` WRITE;
/*!40000 ALTER TABLE `Analysis` DISABLE KEYS */;
INSERT INTO `Analysis` VALUES (1,'Общий анализ крови',750.32,1613.07,1),(2,'Биохимический анализ крови',1868.07,1856.00,1),(3,'МРТ головного мозга',661.76,4054.09,3),(4,'Рентген грудной клетки',1356.54,3878.48,2),(5,'Тест на глюкозу',852.72,2955.07,5),(6,'Анализ мочи',1065.76,2660.37,2),(7,'УЗИ брюшной полости',652.97,3749.22,5),(8,'ЭКГ сердца',1799.28,661.34,1),(9,'Общий анализ крови',210.16,4961.67,1),(10,'Биохимический анализ крови',1265.22,3846.19,3);
/*!40000 ALTER TABLE `Analysis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Groups`
--

DROP TABLE IF EXISTS `Groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Groups` (
  `gr_id` int NOT NULL AUTO_INCREMENT,
  `gr_name` varchar(255) DEFAULT NULL,
  `gr_temp` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`gr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Groups`
--

LOCK TABLES `Groups` WRITE;
/*!40000 ALTER TABLE `Groups` DISABLE KEYS */;
INSERT INTO `Groups` VALUES (1,'Гематология','-8°C'),(2,'Биохимия','-4°C'),(3,'Радиология','0°C'),(4,'Иммунология','4°C8°C'),(5,'Микробиология','12°C');
/*!40000 ALTER TABLE `Groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `ord_id` int NOT NULL AUTO_INCREMENT,
  `ord_datetime` datetime DEFAULT NULL,
  `ord_an` int DEFAULT NULL,
  PRIMARY KEY (`ord_id`),
  KEY `ord_an` (`ord_an`),
  CONSTRAINT `Orders_ibfk_1` FOREIGN KEY (`ord_an`) REFERENCES `Analysis` (`an_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (1,'2024-01-16 08:51:29',8),(2,'2024-12-02 06:37:45',5),(3,'2023-12-31 09:48:16',1),(4,'2024-02-05 09:35:17',9),(5,'2024-01-18 22:35:05',1),(6,'2024-07-30 06:10:41',9),(7,'2023-12-29 17:17:06',6),(8,'2024-02-26 08:18:46',5),(9,'2024-04-24 01:47:46',7),(10,'2024-01-07 04:45:12',3),(11,'2024-12-08 19:07:46',8),(12,'2023-12-24 21:35:28',9),(13,'2024-07-09 14:00:06',9),(14,'2024-05-22 03:17:04',2),(15,'2024-09-14 23:18:40',8),(16,'2024-01-26 06:11:36',5),(17,'2024-02-21 18:27:49',2),(18,'2024-05-01 00:38:46',1),(19,'2024-02-05 19:40:53',1),(20,'2023-12-30 18:05:17',4);
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-12-11 23:34:39
