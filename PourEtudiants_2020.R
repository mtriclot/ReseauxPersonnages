### Script pour la génération des graphes 
### UV PH02 / UTBM
### Mathieu Triclot
### 02/11/2020

### TODO : 
### résoudre le bazar avec les switchs de dossier
### séparer proprement les fonctions et nettoyer les appels de fonctions dans les sources
### réinclure les titres ?

#####################
### MODE D'EMPLOI ###
#####################

# Placer vos fichiers de données dans le repertoire "reprojetrseauxdepersonnages"
# En respectant la syntaxe dans le nom de fichier 
# -adj.csv pour le fichier "principal"
# -attr.csv pour les attributs "STP"
# -attr2.csv pour l'attribut secondaire
# exemples : "1971.OrangeMeca-adj.csv" ; "1971.OrangeMeca-attr.csv" ; "1971.OrangeMeca-attr2.csv"

# Vous n'avez plus ensuite qu'à exécuter le script ligne ligne
# ctrl+entrée dans RStudio

######################################
### CHOIX DU REPERTOIRE DE TRAVAIL ###
######################################

rm(list = ls()) # on vide la mémoire de RStudio

# Ici on définit l'espace de travail. MODIFIEZ-LE pour que cela corresponde 
# à l'emplacement sur votre propre ordinateur
# pour récupérer l'adresse du répertoire, dans RStudio
# Session > Set Working Directory > To Source file location

wd <- ("~/Documents/Projets R/Belfort-master")
setwd (wd)

# une fois que c'est fait, vous n'avez plus à y toucher

###############################################
### INSTALLATION ET CHARGEMENT DES PACKAGES ###
###############################################

# Lors du premier lancement du script, assurez vous d'être connectés à internet
# il installera automatiquement les packages additionnels requis
# ça peut prendre un peu de temps, mais ça n'a lieu qu'une fois

packages <- c("igraph","RColorBrewer","networkD3","stringr","ggraph","readr",
              "tidygraph","gridExtra","extrafont")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

library(igraph)
library(stringr)
library(ggraph)
library(readr)
library(tidygraph)
library(gridExtra)
library(extrafont)
loadfonts()

set_graph_style(plot_margin = margin(1, 1, 1, 1))

source("sources/create_graph.R")
source("sources/fonctions_en_vrac.R")

#####################
###               ###
### RESEAU SIMPLE ###
###               ###
#####################

### Dessiner le réseau sans attributs

mon_oeuvre <- "2015.Seul_sur_Mars" # indiquer le nom de votre fichier source
nom_fichier <- which(str_detect(titles, mon_oeuvre))

seuil <- 3 # choisir un seuil pour votre graph

plot_simple <- draw(g_connected(seuil)[[nom_fichier]])

# prévisualiser le résultat dans RStudio
plot_simple

# le graph est enregistré dans le dossier Viz
ggsave (paste (wd,"/viz/",mon_oeuvre,".",seuil,".png", sep=""), plot_simple, width = 10, height = 7)


#################################
###                           ###
### RESEAU AVEC ATTRIBUTS STP ###
###                           ###
#################################

# si vous avez fourni le fichier -attr

seuil <- 3 # choisir un seuil pour votre graph

plot_attr <- draw2(g_connected(seuil)[[nom_fichier]])

# prévisualiser le résultat dans RStudio
plot_attr

# le graph est enregistré dans le dossier Viz
ggsave (paste (wd,"/viz/",mon_oeuvre,".attr.",seuil,".png", sep=""), plot_attr, width = 10, height = 7)

##########################################
###                                    ###
### RESEAU AVEC ATTRIBUTS STP + SECOND ###
###                                    ###
##########################################

# si vous avez fourni le fichier -attr2

seuil <- 3 # choisir un seuil pour votre graph

plot_attr2 <- draw3(g_connected(seuil)[[nom_fichier]])

# prévisualiser le résultat dans RStudio
plot_attr2

# le graph est enregistré dans le dossier Viz
ggsave (paste (wd,"/viz/",mon_oeuvre,".attr2.",seuil,".png", sep=""), plot_attr2, width = 10, height = 7)

