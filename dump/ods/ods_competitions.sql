-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: localhost    Database: ods
-- ------------------------------------------------------
-- Server version	5.7.20-log

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
-- Table structure for table `competitions`
--

DROP TABLE IF EXISTS `competitions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `competitions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  `sport` varchar(45) NOT NULL,
  `country` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `idCompetion_UNIQUE` (`id`),
  KEY `fk_Competitions_Countries1_idx` (`country`),
  KEY `name` (`name`),
  CONSTRAINT `fk_Competitions_Countries1` FOREIGN KEY (`country`) REFERENCES `countries` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3663 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `competitions`
--

LOCK TABLES `competitions` WRITE;
/*!40000 ALTER TABLE `competitions` DISABLE KEYS */;
INSERT INTO `competitions` VALUES (3332,'Belgium Jupiler League','football',2821),(3333,'France Ligue 1','football',2875),(3334,'Germany 1. Bundesliga','football',2882),(3335,'Italy Serie A','football',2909),(3336,'Netherlands Eredivisie','football',2956),(3337,'Poland Ekstraklasa','football',2976),(3338,'Primeira Liga','football',2977),(3340,'Spain LIGA BBVA','football',3008),(3341,'Switzerland Super League','football',3015),(3342,'England Premier League','football',3034),(3343,'Scotland Scottish Premier League','football',3034),(3599,'AR Open','tennis',2810),(3600,'AU Open','tennis',2813),(3601,'AT Open','tennis',2814),(3602,'BR Open','tennis',2831),(3603,'BG Open','tennis',2834),(3604,'CA Open','tennis',2839),(3605,'CL Open','tennis',2844),(3606,'CN Open','tennis',2845),(3607,'CO Open','tennis',2848),(3608,'HR Open','tennis',2855),(3609,'EC Open','tennis',2864),(3610,'FR Open','tennis',2875),(3611,'DE Open','tennis',2882),(3612,'IN Open','tennis',2902),(3613,'IT Open','tennis',2909),(3614,'JP Open','tennis',2911),(3615,'MY Open','tennis',2934),(3616,'MX Open','tennis',2943),(3617,'MC Open','tennis',2946),(3618,'MA Open','tennis',2950),(3619,'NL Open','tennis',2956),(3620,'NZ Open','tennis',2958),(3621,'PL Open','tennis',2976),(3622,'PT Open','tennis',2977),(3623,'QA Open','tennis',2979),(3624,'RO Open','tennis',2981),(3625,'RU Open','tennis',2982),(3626,'RS Open','tennis',2996),(3627,'ZA Open','tennis',3005),(3628,'ES Open','tennis',3008),(3629,'SE Open','tennis',3014),(3630,'CH Open','tennis',3015),(3631,'TH Open','tennis',3020),(3632,'TR Open','tennis',3027),(3633,'AE Open','tennis',3033),(3634,'GB Open','tennis',3034),(3635,'US Open','tennis',3035),(3662,'BE Open','tennis',2821);
/*!40000 ALTER TABLE `competitions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-02-09 18:31:35
