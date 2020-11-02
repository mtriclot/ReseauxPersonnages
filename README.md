# Belfort

Voici un support de scripts pour l'analyse de réseaux de personnages.

1. Choisir une oeuvre.
2. Récolter les données.
3. Les transformer en un réseau.
4. L'analyser.
 
# Comment ça marche ?

0. Installer [le langage R](https://www.r-project.org/) et [RStudio](http://www.rstudio.com/) 
1. Récupérer ce dossier "Belfort" sur son ordinateur : cliquer à droite sur le bouton vert "Code", puis "Download zip" ; extraire le zip dans un endroit choisi sur votre ordinateur
2. Copiez vos fichiers de données dans le répertoire "reprojetrseauxdepersonnages". Vous pouvez supprimer les autres fichiers de données déjà présent dans le repertoire sur les autres oeuvres déjà codées.
3. Ouvrir le fichier [PourEtudiants_2020.R](https://github.com/mtriclot/Belfort/blob/master/PourEtudiants_2020.R) qui devrait lancer automatiquement RStudio. Si ça n'est pas le cas, alors d'abord lancer RStudio et ouvrir le fichier ensuite. Pour exécuter le code ligne à ligne, le raccourci est ctrl+enter dans RStudio. Au premier lancement, assurez-vous d'être connecté à internet, le script commandant l'installation d'un certain nombre de packages additionnels (il faut être patient).
4. À la [ligne 36](https://github.com/mtriclot/Belfort/blob/master/PourEtudiants_2020.R#L36) du document, remplacer ce qu'il y a entre les guillemets (par défaut wd <- ("~/Documents/Projets R/Belfort-master") qui correspond à l'emplacement du dossier Belfort sur ma propre machine) par l'emplacement du dossier sur votre propre machine, c'est-à-dire l'endroit où vous l'avez dézippé. Pour obtenir le chemin dans la syntaxe de votre système d'exploitation, vous pouvez utiliser Session > Set Working Directory > To Source File Location dans RStudio. La commande et son résultat s'affichent dans la fenêtre en bas à gauche. Copiez-collez le chemin dans le script?
5. Une fois que c'est fait, il vous reste à indiquer le nom du fichier à traiter à la [ligne 77](https://github.com/mtriclot/Belfort/blob/master/PourEtudiants_2020.R#L77) en remplacement de l'exemple ("2015.Seul_sur_Mars").
6. Aux lignes 80, 99 et 117, vous pouvez faire varier le seuil (par défaut fixé à 3) et obtenir dans la foulée une visualisation dans la fenêtre de RStudio. Les images s'enregistrent dans le dossier "viz".
