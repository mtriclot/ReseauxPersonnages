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
3. Ouvrir le fichier [PourEtudiants.R](https://github.com/mtriclot/Belfort/blob/master/PourEtudiants.R) qui devrait lancer automatiquement RStudio. Si ça n'est pas le cas, alors d'abord lancer RStudio et ouvrir le fichier ensuite. Pour exécuter le code ligne à ligne, le raccourci est ctrl+enter dans RStudio. Au premier lancement, assurez-vous d'être connecté à internet, le script commandant l'installation d'un certain nombre de packages additionnels (il faut être patient).
4. Une fois que c'est fait, il vous reste à indiquer le nom du fichier à traiter à la [ligne 77](https://github.com/mtriclot/Belfort/blob/master/PourEtudiants.R#L67) en remplacement de l'exemple ("1878.500millions_Begum").
5. Vous pouvez faire varier le seuil (par défaut fixé à 3) et obtenir dans la foulée une visualisation dans la fenêtre de RStudio. Les images s'enregistrent dans le dossier "visualisations".
