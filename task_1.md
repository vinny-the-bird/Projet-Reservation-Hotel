# Partie 1 : Importation

## Tâche 1.1 Expliquer votre démarche

Importation du fichier reservation_hotel_exercice.sql dans phpmyadmin.
Erreur retournée : #1072 - La clé 'numChambre' n'existe pas dans la table

Je vérifie la table 'chambres' : elle possède l'attribut `numero` varchar(6) NOT NULL
Mais la clé unique est créé en utilisant 'numChambre' : UNIQUE KEY `id_hotel` (`id_hotel`,`numChambre`)
Je remplace numChambre par numero

2e tentative d'importation
Erreur :
"Analyse statique :
#1064 - Erreur de syntaxe près de 'KEY (`id_type`) REFERENCES `chambre_types` (`id`) ON DELETE CASCADE ON UPDATE CA' à la ligne 5

La ligne 5 ne me donne pas d'infos. Je fais un ctrl+f sur l'extrait SQL pour le retrouver<. Voici la table :

ALTER TABLE `chambres`
ADD CONSTRAINT `chambres_ibfk_1` KEY (`id_type`) REFERENCES `chambre_types` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `chambres_ibfk_2` KEY (`id_hotel`) REFERENCES `hotels` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

Il manque en fait le terme FOREIGN deux fois : FOREIGN KEY (`id_type`) et FOREIGN KEY (`id_hotel`). J'édite le code.

3e tentative : erreur similaire mais sur une autre ligne :
#1064 - Erreur de syntaxe près de 'KEY (`id_type`) REFERENCES `chambre_types` (`id`) ON DELETE CASCADE ON UPDATE CA' à la ligne 5

Je fais une recherche dans tout le fichier en utilisant le mot "KEY" et vérifie chaque ligne qui pourrait manquer du mot FOREIGN.
J'en trouve aux lignes 158, 159, 166, 167. J'édite le code.

4e tentative : SUCCES la base de données est correctement importée.

# Partie 2 : peuplement

Tentative d'importation du fichier reservation_hotel-peuplement.sql.
Une erreur est retournée :
#1054 - Champ 'description' inconnu dans field list

Il s'agit de la table "chambre_types" qui dispose d'un description, mais ce champs n'existe pas en base de données. J'édite le fichier de la base de données pour intégrer un champs "description" en varchar. Après avoir vérifier le contenu, un varchar 250 classique sera suffisant, et j'ajoute NOT NULL, car dans l'échantillon la description n'est jamais vide :
`description` varchar(250) NOT NULL

2e tentative :
Erreur :
INSERT INTO `tarifs` (`id`, `id_hotel`, `id_type`, `date_debut`, `prix`) VALUES
(8, 2, 1, '2021-12-15', '57.49'),
#1054 - Champ 'date_debut' inconnu dans field list

Après vérification, le champs dans la table tarifs se nomme dateDebut. Tous les autres champs sont bien nommés avec un séparateur "\_", il y a eu non-respect de la convention de nommage coté base de données. J'édite le fichier en utilisant le champs "date_debut".
Avec le screenshot du schéma de base de données via le concepteur, j'en profite pour vérifier tous les champs. A priori, c'était la dernière faute.

3e tentative : SUCCES, toutes les données sont correctement importées.

Ajout 1 (fix) : Impossible d'afficher la vue avec les relations et elles sont également manquantes dans le schéma. Bien que la base de données soit bien importée, la section avec les relations n'est pas prise en compte car le moteur est MyIsam. Changement du code pour que tout soit en InnoDB.

Un autre problème émerge alors maintenant que les contraintes sont bien prises en compte et appliquées : l'incompatibilité entre les données utilisées pour les id. Certaines sont en int ou tinyint, et certaines sont unsigned. J'ai tout harmonisé de la manière suivante :

- tout en int, qui peut le plus peut le moins
- unsigned appliqué à tous (on ne prend pas de valeurs négatives)
- conservation du nombre de characteres maximum originaux

Ajout 2 (fix) : L'import du fichier de données ne passe et renvoie l'erreur suivante :
#1452 - Cannot add or update a child row: a foreign key constraint fails (reservation_hotel.chambres, CONSTRAINT chambres_ibfk_2 FOREIGN KEY (id_hotel) REFERENCES hotels (id) ON DELETE CASCADE ON UPDATE CASCADE)

A cause des contraintes, les tables doivent être créées dans un ordre précis. On ne peut pas réclamer en clé étrangère un id d'une table qui n'a pas encore été insérée. J'ai pris un screenshot du schéma de la base de données avec les liaisons (disponible dans les fichiers) et ai réorganisé le fichier de données, en commençant par la fin, c'est à dire d'abord les tables qui n'ont pas de clés étrangères (couchages, salle de bain, hotels) puis celles qui ont besoin de clés étrangères

L'import des données fonctionne à nouveau correctement.

## Tâche 1.2 Expliquer sur quel point il faut être vigilant

Il est nécessaire de réaliser une convention de nommage, afin que toute l'équipe la respecte et puisse travailler de manière autonome, sans risques de créer des erreurs ou conflits. Cela couvre notamment la langue, les séparateurs et les majuscules, minuscules. Se référer aux différentes conventions déjà existantes (camelCase, snake_case, etc)

# Cas particulier

## Tâche 1.3 Expliquer comment vous feriez

Le plus simple est l'ajout d'un champs "est_disponible" en booléen, permettant de savoir si une chambre doit être affichée dans les disponibilités ou non.
Si le client souhaite afficher les chambres même quand elles sont indisponibles, MAIS ne pas du tout afficher les chambres quand elles sont en travaux par exemple, dans ce cas un champs 'ne_pas_afficher' en booléen peut aussi être une solution.
