-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3307
-- Généré le : mer. 16 avr. 2025 à 20:30
-- Version du serveur : 10.10.2-MariaDB
-- Version de PHP : 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `reservation_hotel`
--

DROP TABLE IF EXISTS `chambres`;
CREATE TABLE IF NOT EXISTS `chambres` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `id_hotel` int(11)  UNSIGNED NOT NULL,
  `id_type` int(11)  UNSIGNED NOT NULL,
  `numero` varchar(6) NOT NULL,
  `commentaire` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id_hotel` (`id_hotel`,`numero`),
  KEY `FK_Chambres_Hotels` (`id_hotel`),
  KEY `FK_Chambres_TypesChambre` (`id_type`)
) ENGINE=InnoDb AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


DROP TABLE IF EXISTS `chambre_types`;
CREATE TABLE IF NOT EXISTS `chambre_types` (
  `id` int(11) UNSIGNED NOT NULL,
  `nom` varchar(50) NOT NULL,
  `description` varchar(250) NOT NULL,
  `id_salle_de_bain` int(4) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_salle_de_bain` (`id_salle_de_bain`)
) ENGINE=InnoDb DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Structure de la table `chambre_type_couchage`
--

DROP TABLE IF EXISTS `chambre_type_couchage`;
CREATE TABLE IF NOT EXISTS `chambre_type_couchage` (
  `id_type` int(10) UNSIGNED NOT NULL,
  `id_couchage` int(10) UNSIGNED NOT NULL,
  `qte` int(3) UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (`id_type`,`id_couchage`),
  KEY `chambre_type_couchage_ibfk_2` (`id_couchage`)
) ENGINE=InnoDb DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `couchages`
--

DROP TABLE IF EXISTS `couchages`;
CREATE TABLE IF NOT EXISTS `couchages` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(20) NOT NULL,
  `nb_places` int(3) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`),
  UNIQUE KEY `nom_2` (`nom`)
) ENGINE=InnoDb AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

--
-- Structure de la table `hotels`
--

DROP TABLE IF EXISTS `hotels`;
CREATE TABLE IF NOT EXISTS `hotels` (
  `id` int(10) UNSIGNED NOT NULL,
  `libelle` varchar(50) NOT NULL COMMENT 'unique',
  `etoile` varchar(5) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `Libelle` (`libelle`)
) ENGINE=InnoDb DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

--
-- Structure de la table `salles_de_bain`
--

DROP TABLE IF EXISTS `salles_de_bain`;
CREATE TABLE IF NOT EXISTS `salles_de_bain` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nom` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDb AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- --------------------------------------------------------

--
-- Structure de la table `tarifs`
--

DROP TABLE IF EXISTS `tarifs`;
CREATE TABLE IF NOT EXISTS `tarifs` (
  `id` int(11) UNSIGNED NOT NULL,
  `id_hotel` int(11) UNSIGNED DEFAULT NULL,
  `id_type` int(11) UNSIGNED DEFAULT NULL,
  `date_debut` date DEFAULT NULL,
  `prix` decimal(7,2) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_Tarifs_Hotels` (`id_hotel`),
  KEY `FK_Tarifs_TypesChambre` (`id_type`)
) ENGINE=InnoDb DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
CREATE TABLE IF NOT EXISTS `utilisateurs` (
  `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `prenom` varchar(50) NOT NULL,
  `date_creation` timestamp NOT NULL DEFAULT current_timestamp(),
  `date_modification` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDb DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Contraintes pour la table `chambres`
--
ALTER TABLE `chambres`
  ADD CONSTRAINT `chambres_ibfk_1` FOREIGN KEY (`id_type`) REFERENCES `chambre_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `chambres_ibfk_2` FOREIGN KEY (`id_hotel`) REFERENCES `hotels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Contraintes pour la table `chambre_types`
--
ALTER TABLE `chambre_types`
  ADD CONSTRAINT `chambre_types_ibfk_1` FOREIGN KEY (`id_salle_de_bain`) REFERENCES `salles_de_bain` (`id`);

--
-- Contraintes pour la table `chambre_type_couchage`
--
ALTER TABLE `chambre_type_couchage`
  ADD CONSTRAINT `chambre_type_couchage_ibfk_1` FOREIGN KEY (`id_type`) REFERENCES `chambre_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `chambre_type_couchage_ibfk_2` FOREIGN KEY (`id_couchage`) REFERENCES `couchages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;


--
-- Contraintes pour la table `tarifs`
--
ALTER TABLE `tarifs`
  ADD CONSTRAINT `tarifs_ibfk_1` FOREIGN KEY (`id_hotel`) REFERENCES `hotels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `tarifs_ibfk_2` FOREIGN KEY (`id_type`) REFERENCES `chambre_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
