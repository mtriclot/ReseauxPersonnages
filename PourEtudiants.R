### Script accompagnant l'article de 
### Mathieu Triclot et Yannick Rochat
### soumis à la revue ReS Futurae
### à l'été 2017


### RESTE A FAIRE 
### inclure occurrences
### fixer les personnages
### + voir les issues sur github


rm(list = ls())

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


### working directory 

wd <- "~/Documents/Projets R/Belfort-master"
setwd(wd)
source("sources/create_graph.R")


setwd("reprojetrseauxdepersonnages")


### Identification de l'emplacement des données des réseaux

list_of_sources <- list.files()

list_of_adjacency_sources <-
  list_of_sources %>%
  str_detect("adj.csv") %>%
  list_of_sources[.]


### Chargement des données et création des réseaux

get_attr1 <- function(x) {
  attr1 <- x %>% 
    str_replace("-adj.csv", "") %>% 
    str_c("-attr.csv")
  if(attr1 %in% list_of_sources) {
    return(attr1)
  } else {
    return("")
  }
}

get_attr2 <- function(x) {
  attr2 <- x %>% 
    str_replace("-adj.csv", "") %>% 
    str_c("-attr2.csv")
  if(attr2 %in% list_of_sources) {
    return(attr2)
  } else {
    return("")
  }
}


# Seuil à 3, tous les sommets
g_3_unconnected <- lapply(list_of_adjacency_sources,
                          function(x)
                            create_graph(x,
                                         attr1 = get_attr1(x),
                                         attr2 = get_attr2(x),
                                         connexe = FALSE,
                                         seuil = 3))

# Seuil à 10, tous les sommets
g_10_unconnected <- lapply(list_of_adjacency_sources,
                           function(x)
                             create_graph(x,
                                          attr1 = get_attr1(x),
                                          attr2 = get_attr2(x),
                                          connexe = FALSE,
                                          seuil = 10))

# Seuil à 3, composante géante
g_3_connected <- lapply(list_of_adjacency_sources,
                        function(x)
                          create_graph(x,
                                       attr1 = get_attr1(x),
                                       attr2 = get_attr2(x),
                                       connexe = TRUE,
                                       seuil = 3))

# Seuil à 10, composante géante
g_10_connected <- lapply(list_of_adjacency_sources,
                         function(x)
                           create_graph(x,
                                        attr1 = get_attr1(x),
                                        attr2 = get_attr2(x),
                                        connexe = TRUE,
                                        seuil = 10))

# Seuil à 20, composante géante
g_20_connected <- lapply(list_of_adjacency_sources,
                         function(x)
                           create_graph(x,
                                        attr1 = get_attr1(x),
                                        attr2 = get_attr2(x),
                                        connexe = TRUE,
                                        seuil = 20))

# Chargement des titres des réseaux
titles <- str_replace_all(string = list_of_adjacency_sources,
                          pattern = "-adj.csv",
                          replacement = "")

setwd(wd)


### Définition d'une fonction calculant le degré

get_degree <- function(g) {
  res <- list(length(g))
  
  for (i in 1:length(g)) {
    res[[i]] <- as_tbl_graph(g[[i]])
    V(res[[i]])$degree <- degree(res[[i]])
  }
  
  return(res)
}

g_3_unconnected <- g_3_unconnected %>% get_degree
g_10_unconnected <- g_10_unconnected %>% get_degree
g_3_connected <- g_3_connected %>% get_degree
g_10_connected <- g_10_connected %>% get_degree


### Définition d'une fonction insérant le titre 
### dans les données du réseau

get_title <- function(g) {
  res <- g
  
  for (i in 1:length(g)) {
    res[[i]]$title <- titles[i]
  }
  
  return(res)
}

g_3_unconnected <- g_3_unconnected %>% get_title
g_10_unconnected <- g_10_unconnected %>% get_title
g_3_connected <- g_3_connected %>% get_title
g_10_connected <- g_10_connected %>% get_title


### Dessiner les réseaux

draw <- function(g) {
  ggraph(g) +
  geom_node_point(aes(size = degree(g))) +
  geom_edge_link(aes(width = weight)) +
  scale_edge_width_continuous(range = c(.1, 2), "Poids") +
  geom_node_label(
    aes(label = name),
    size = 2,
    repel = TRUE,
    label.size = .1,
    family = "Helvetica",
    alpha = .8,
    segment.colour = "pink"
  ) +
  scale_size_area(max_size = 5, "Degré")
}


##################
###            ###
### CHAPITRE 2 ###
###            ###
##################

### Dessiner le réseau sans attributs

mon_oeuvre <- "Blade"

nom_fichier <- which(str_detect(titles, mon_oeuvre))
plot_3 <- draw(g_3_connected[[nom_fichier]])
plot_10 <- draw(g_10_connected[[nom_fichier]])
plot_20 <- draw(g_20_connected[[nom_fichier]])

# graph.density(g_3_connected[[metro_2033]])

ggsave (paste ("viz/",mon_oeuvre,".3.png", sep=""), plot_3, width = 10, height = 7)
ggsave (paste ("viz/",mon_oeuvre,".10.png", sep=""), plot_10, width = 10, height = 7)
ggsave (paste ("viz/",mon_oeuvre,".20.png", sep=""), plot_20, width = 10, height = 7)

##################
###            ###
### CHAPITRE 3 ###
###            ###
##################


### Dessiner les réseaux avec des attributs

draw2 <- function(g) {
  ggraph(g) +
    geom_edge_link(aes(width = weight)) +
    geom_node_point(aes(size = degree(g), color = id1, shape = id2)) +
    scale_edge_width_continuous(range = c(.1, 2), "Poids") +
    geom_node_label(
      aes(label = name),
      size = 2,
      repel = TRUE,
      label.size = .1,
      family = "Helvetica",
      alpha = .8,
      segment.colour = "pink"
    ) +
    scale_size_area(max_size = 5, "Degré") + 
    scale_shape_manual(values = c(15, 16, 17, 18, 4, 8), "Attribut secondaire") +
    scale_color_brewer(palette = "Set1", "Type")
}


### ILE MYSTERIEUSE AVEC ATTRIBUTS 2

plot_attr_3 <- draw2(g_3_connected[[nom_fichier]])
plot_attr_10 <- draw2(g_10_connected[[nom_fichier]])
plot_attr_20 <- draw2(g_20_connected[[nom_fichier]])

ggsave (paste ("viz/",mon_oeuvre,".attr.3.png", sep=""), plot_attr_3, width = 10, height = 7)
ggsave (paste ("viz/",mon_oeuvre,".attr.10.png", sep=""), plot_attr_10, width = 10, height = 7)
ggsave (paste ("viz/",mon_oeuvre,".attr.20.png", sep=""), plot_attr_20, width = 10, height = 7)

