# Partie 2 : Type de chambre

## Requête 1

SELECT chambre_types.id,
chambre_types.nom as type, 
salles_de_bain.nom as sanitaire
FROM `chambre_types`
JOIN salles_de_bain
ON id_salle_de_bain = salles_de_bain.id

## Requête 2
SELECT chambre_types.id,
chambre_types.nom, 
salles_de_bain.nom,
chambre_type_couchage.qte,
couchages.nom,
couchages.nb_places

FROM `chambre_types`
JOIN salles_de_bain
ON id_salle_de_bain = salles_de_bain.id
JOIN chambre_type_couchage
ON id_type = chambre_types.id
JOIN couchages
ON couchages.id = chambre_type_couchage.id_couchage

## Requête 3

SELECT chambre_types.id,
chambre_types.nom as type, 
salles_de_bain.nom as sanitaire,
concat(chambre_type_couchage.qte, 'x' ,couchages.nom ) as details,
couchages.nb_places * chambre_type_couchage.qte as nb_personnes

FROM `chambre_types`
JOIN salles_de_bain
ON id_salle_de_bain = salles_de_bain.id

JOIN chambre_type_couchage
ON id_type = chambre_types.id

JOIN couchages
ON couchages.id = chambre_type_couchage.id_couchage
ORDER BY chambre_types.id


Erreurs détectées : 
- Dans la table "chambre_type_couchage", l'id 7 est manquant, il est noté id 6 à la place. Modification ok.
- Dans la table "couchage", le lit superposé ne comptait qu'une place au lieu de deux. Modification de la quantié ok.

## Tâche 3.1 Donner le script de la vue vue_chambre_types

T
## tâche 3.2 Proposer une vue, en précisant les colonnes, et en expliquant votre choix.
