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

    CREATE VIEW vue_chambre_types AS
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

## tâche 3.2 Proposer une vue, en précisant les colonnes, et en expliquant votre choix.

Voici la vue que je propose : L'idée est de compléter la vue précédente d'un point de vue qualité et prix, c'est à dire une vue axée client. J'ai donc retiré l'index, ajouté tout à gauche le nom de l'hôtel et son nombre d'étoile, et tout à droite le prix global et un prix par personne. Le but est d'offrir une vue logique et naturelle, permettant de comparer les lignes facilement pour le client.
- Les colonnes centrales permettent au client de trouver facilement selon son besoin (lit simple, double, sanitaire)
- Ceux qui veulent uniquement voir le prix en premier l'auront tout à droite, par ordre croissant.

    CREATE view vue_chambres_hotel_prix AS
    SELECT  hotels.libelle,
    hotels.etoile,
    chambre_types.nom as type,
    salles_de_bain.nom as sanitaire,
    concat(chambre_type_couchage.qte, 'x' ,couchages.nom ) as details,
    couchages.nb_places * chambre_type_couchage.qte as nb_personnes,
    tarifs.prix,
    ROUND(tarifs.prix / (couchages.nb_places * chambre_type_couchage.qte), 2) as prix_personne

    FROM `chambre_types`
    JOIN salles_de_bain
    ON id_salle_de_bain = salles_de_bain.id
    JOIN chambre_type_couchage
    ON id_type = chambre_types.id
    JOIN couchages
    ON couchages.id = chambre_type_couchage.id_couchage
    JOIN tarifs
    ON tarifs.id_type = chambre_types.id
    JOIN hotels
    ON tarifs.id_hotel = hotels.id
    ORDER BY hotels.etoile

L'idéal serait d'utiliser GETDATE() afin de comparer automatiquement la date avec les tarifs.date_debut, et ainsi automatiquement afficher les bons tarifs selon la période. On pourra alors appeler cette vue et toujours avec le bon montant en fonction de la période actuelle.
