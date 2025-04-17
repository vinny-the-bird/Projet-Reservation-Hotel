# Partie 2 : Delete on cascade


## Tâche 2.1 Expliquer ce que vous constatez

Test de la commande suivante : 
    DELETE FROM hotels WHERE `hotels`.`id` = 1

Avant je vérifie combien de lignes seront impactés avec la commande 
    SELECT * FROM `chambres` WHERE id_hotel=1
Résultat : les chambres 1, 3, 4, 29, 6

Après exécution de la première commande, l'hotel id=1 a bien bien été supprimé de la base de données, ainsi que les 5 chambres qui lui étaient rattachées.

Le système de CASCADE comme son nom l'indique, permet donc de modifier un élément qui aura ensuite un impact sur d'autres en fonction de leurs relations.

ON DELETE RESTRICT : plus contraignant mais plus sécurisé. Impossible de supprimer s'il y a un enfant au parent visé. Peut être une contrainte quand il y a de nombreux enfants.

ON DELETE NULL : permet la suppression du parent, tous les enfants ayant alors leur parent à NULL. Intéressant dans le cadre d'un remplacement par un nouveau parent, par exemple.

## Tâche 2.2 Expliquer ce que vous constatez

Le test avec ON DELETE CASCADE a déjà été réalisé dans la tâche 2.1.

## Tâche 2.3 Expliquer ce que vous constatez

ON UPDATE CASCADE permet de transmettre les modifications aux enfants.

Par exemple: UPDATE hotels SET id = 5 WHERE id = 4
Ici, je modifie l'id de l'hôtel de 4 à 5. Quand je vérifie les chambres, toutes les chambres appartiennent désormais à l'hôtel id=5 (chambres.id_hotel)

ON DELETE NULL renvoie une erreur : 
    ALTER TABLE `chambres` ADD  CONSTRAINT `chambres_ibfk_2` FOREIGN KEY (`id_hotel`) REFERENCES `hotels`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
    #1830 - Column 'id_hotel' cannot be NOT NULL: needed in a foreign key constraint 'chambres_ibfk_2' SET NULL

L'erreur indique que les élements concernés sont définis comme NOT NULL. Donc même si rien ne se passe actuellement, cela ira à l'encontre de la logique de la base de données.


## Tâche 2.4 A votre avis, est-ce que la suppression est permise ou non ?

Dans ce cas hôtel id possède deux relation différentes avec chambres (CASCADE) et tarifs (RESTRICT). Dans ce cas, c'est la plus contraignante qui prend le dessus. De manière logique : RESTRICT agira avant l'effet de ON DELETE CASCADE.
Dans cette relation, on peut voir que tant qu'au moins un tarif est lié à cet hôtel, rien ne bouge. S'il n'y a plus aucun tarif, on peut alors faire une suppresion en cascade de l'hôtel, puis de toutes ses chambres. La combinaison des deux types a du sens pour un cas d'usage (usecase) de gérant d'hôtels.