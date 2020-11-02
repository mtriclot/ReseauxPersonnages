### Traitement des fichiers source

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

### Identification de l'emplacement des données des réseaux

# list_of_sources <- list.files()

# list_of_adjacency_sources <-
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

# 
g_connected <- function (seuil) {
  lapply(list_of_adjacency_sources,
         function(x)
           create_graph(x,
                        attr1 = get_attr1(x),
                        attr2 = get_attr2(x),
                        connexe = TRUE,
                        seuil = seuil))  
}
  
# Chargement des titres des réseaux
titles <- str_replace_all(string = list_of_adjacency_sources,
                          pattern = "-adj.csv",
                          replacement = "")

### Définition d'une fonction calculant le degré
get_degree <- function(g) {
  res <- list(length(g))
  
  for (i in 1:length(g)) {
    res[[i]] <- as_tbl_graph(g[[i]])
    V(res[[i]])$degree <- degree(res[[i]])
  }
  
  return(res)
}

### Définition d'une fonction insérant le titre 
### dans les données du réseau

get_title <- function(g) {
  res <- g
  
  for (i in 1:length(g)) {
    res[[i]]$title <- titles[i]
  }
  
  return(res)
}

### Dessiner les réseaux
### layout: stress, par défaut mais fr marche pas mal
### c'est le Fruchterman and Reingold qu'on utilisait avant

draw <- function(g) {
  ggraph(g, layout ="fr") +
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

### Dessiner les réseaux avec l'attribut STP seul
# fr ou stress (défaut)

draw2 <- function(g) {
  ggraph(g, layout = "fr") +
    geom_edge_link(aes(width = weight)) +
    geom_node_point(aes(size = degree(g), color = id1)) +
    scale_edge_width_continuous(range = c(.1, 1.7), "Poids") +
    geom_node_label(
      aes(label = name),
      size = 2.3,
      repel = TRUE,
      label.size = .1,
      family = "Helvetica",
      alpha = 1,
      segment.colour = "grey"
    ) +
    scale_colour_brewer(palette = "Set1", "Type") +
    # scale_fill_grey(start = 1, end = 0.1, "Attribut secondaire") +
    scale_size_area(max_size = 8, "Degré") +
    guides (fill = guide_legend(order = 1, override.aes=list(shape=21)), # spécifier shape 
            shape = guide_legend(order = 2),
            size = guide_legend(order = 3),
            range = guide_legend (order = 4))
}

### Dessiner les réseaux avec les 2 attributs 
# fr ou stress (défaut)

draw3 <- function(g) {
  ggraph(g, layout = "fr") +
    geom_edge_link(aes(width = weight)) +
    geom_node_point(aes(size = degree(g), fill = id2, shape = id1)) +
    scale_edge_width_continuous(range = c(.1, 1.7), "Poids") +
    geom_node_label(
      aes(label = name),
      size = 2.3,
      repel = TRUE,
      label.size = .1,
      family = "Helvetica",
      alpha = 1,
      segment.colour = "grey"
    ) +
    #scale_shape_manual(values = c(15, 16, 17, 18, 5, 8), "Type") +
    scale_shape_manual(values = c(21, 22, 23, 24, 25, 8), "Type") +
    #scale_colour_brewer(palette = "Greys", "Type") +
    scale_fill_grey(start = 1, end = 0.1, "Attribut secondaire") +
    scale_size_area(max_size = 8, "Degré") +
    guides (fill = guide_legend(order = 1, override.aes=list(shape=21)), # spécifier shape 
            shape = guide_legend(order = 2),
            size = guide_legend(order = 3),
            range = guide_legend (order = 4))
}
