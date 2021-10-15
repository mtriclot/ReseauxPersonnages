### Script pour la génération des graphes 
### UV PH02 / UTBM
### Mathieu Triclot
### 14/10/2021

### TODO
### Simplifier dossiers : ok
### Virer Stringr : ok
### Résoudre polices
### Couleur

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
wd <- dirname (rstudioapi::getActiveDocumentContext()$path)
setwd (wd)

###############################################
### INSTALLATION ET CHARGEMENT DES PACKAGES ###
###############################################

# Lors du premier lancement du script, assurez vous d'être connectés à internet
# il installera automatiquement les packages additionnels requis
# ça peut prendre un peu de temps, mais ça n'a lieu qu'une fois

packages <- c("igraph","RColorBrewer","networkD3","ggraph","readr",
              "tidygraph","gridExtra","extrafont")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
  install.packages(setdiff(packages, rownames(installed.packages())))  
}

library(igraph)
library(ggraph)
library(readr)
library(tidygraph)
library(gridExtra)

set_graph_style(plot_margin = margin(1, 1, 1, 1))

source("scripts/create_graph.R")
source("scripts/fonctions_en_vrac.R")

#####################
###               ###
### RESEAU SIMPLE ###
###               ###
#####################

### Dessiner le réseau sans attributs

mon_oeuvre <- "2015.Seul_sur_Mars" # indiquer le nom de votre fichier source
nom_fichier <- which(str_detect(titles, mon_oeuvre))

seuil <- 20 # choisir un seuil pour votre graph

plot_simple <- draw(g_connected(seuil)[[nom_fichier]])

# prévisualiser le résultat dans RStudio
plot_simple

# le graph est enregistré dans le dossier Viz
ggsave (paste (wd,"/visualisations/",mon_oeuvre,".",seuil,".png", sep=""), plot_simple, width = 10, height = 7)


#################################
###                           ###
### RESEAU AVEC ATTRIBUTS STP ###
###                           ###
#################################

# si vous avez fourni le fichier -attr

seuil <- 8 # choisir un seuil pour votre graph

plot_attr <- draw2(g_connected(seuil)[[nom_fichier]])

# prévisualiser le résultat dans RStudio
plot_attr

# le graph est enregistré dans le dossier Viz
ggsave (paste (wd,"/visualisations/",mon_oeuvre,".attr.",seuil,".png", sep=""), plot_attr, width = 10, height = 7)

##########################################
###                                    ###
### RESEAU AVEC ATTRIBUTS STP + SECOND ###
###                                    ###
##########################################

# si vous avez fourni le fichier -attr2

seuil <- 20 # choisir un seuil pour votre graph

plot_attr2 <- draw3(g_connected(seuil)[[nom_fichier]])

# prévisualiser le résultat dans RStudio
plot_attr2

# le graph est enregistré dans le dossier Viz
ggsave (paste (wd,"/visualisations/",mon_oeuvre,".attr2.",seuil,".png", sep=""), plot_attr2, width = 10, height = 7)

