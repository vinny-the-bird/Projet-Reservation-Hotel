# Partie 1 : Importation
# Tâche 1. 1 Expliquer votre démarche

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


Partie 2 : peuplement

Tâche 1. 2 Expliquer sur quel point il faut être vigilant

Tâche 1. 3 Expliquer comment vous feriez