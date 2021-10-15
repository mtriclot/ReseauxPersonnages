create_graph <-
  function(fichier = "exemple/assomoir-adj.csv",
           attr1 = "",
           attr2 = "",
           seuil = 3,
           connexe = TRUE) {
    ############################
    ### CONSTRUIRE LE RÉSEAU ###
    ############################
    
    # On importe le csv sous forme de matrice d'incidence
    mat <-
      read.csv(fichier,
               header = TRUE,
               check.names = FALSE,
               sep = ",")
    
    # On donne comme noms de ligne les noms de la première colonne
    rownames(mat) <- mat[, 1]
    
    # Puis on la supprime
    mat <- mat[, -1]
    # Maintenant la matrice n'est plus composée que de 0 et de 1
    
    # On crée un graphe biparti à partir de cette matrice d'incidence
    g0 <- graph.incidence(mat, 
                          multiple = TRUE)
    
    # On extrait la liste des arêtes, et on la copie deux fois
    tab <- get.edgelist(g0)
    tab2 <- tab1 <- tab
    
    # Ici, chaque page n se transforme en couple de pages (n-1, n)
    tab1[, 2] <-
      paste(
        sprintf("%03i", 
                as.numeric(tab[, 2]) - 1), 
        sprintf("%03s", tab[, 2]), 
        sep = ""
        )
    
    # Ici, chaque page n se transforme en couple de pages (n, n+1)
    tab2[, 2] <-
      paste(
        sprintf("%03s",
                tab[, 2]), 
        sprintf("%03i",
                as.numeric(tab[, 2]) + 1), 
        sep = ""
        )
    
    # On réunit ces deux listes d'arêtes
    tab0 <- rbind(tab1, tab2)
    
    # On supprime les doublons créés par un nom sur des pages consécutives
    tab0 <- tab0[!duplicated(tab0), ]
    
    # On crée le graphe, qui est déjà biparti
    g0 <- graph.edgelist(tab0, directed = FALSE)
    
    # Ceci est nécessaire pour pouvoir faire la projection et
    # obtenir le réseau de personnages (deux persos sont connectés
    # s'ils apparaissent sur les mêmes couples de pages)
    V(g0)$type <- bipartite.mapping(g0)$type
    
    # Et l'étudiant introduira un fichier avec les attributs secondaires
    # À noter que les sommets apparaissent dans le même ordre que dans la matrice
    if (nchar(attr1) > 0) {
      id1 <-
        read.csv(
          file = attr1,
          header = TRUE,
          check.names = FALSE,
          sep = ",",
          stringsAsFactors = FALSE
        )
      V(g0)$id1 <- id1[, 2][match(V(g0)$name, id1[, 1])]
    }
    
    if (nchar(attr2) > 0) {
      id2 <-
        read.csv(
          file = attr2,
          header = TRUE,
          check.names = FALSE,
          sep = ",",
          stringsAsFactors = FALSE
        )
      V(g0)$id2 <- id2[, 2][match(V(g0)$name, id2[, 1])]
    }
    
    # Voilà la projection…
    g <- bipartite.projection(g0)$proj1
    
    # On compte le nombre d'attributs
    g$windows <- 0
    
    if (nchar(attr1) > 0) {
      g$attr1 <- colnames(id1)[2]
      g$windows <- g$windows + 1
    }
    if (nchar(attr2) > 0) {
      g$attr2 <- colnames(id2)[2]
      g$windows <- g$windows + 1
    }
    
    # Et voilà le produit final !
    # À noter que le choix d'un seuil égal à 3 peut être modifié
    # Un nombre (entier) plus bas permettra d'inclure plus d'arêtes
    # Un nombre (entier) plus grand permettra d'inclure moins d'arêtes
    g <- g - E(g)[weight < seuil]
    
    # Si giant est égal à TRUE, nous ne conservons que la composante géante
    if (connexe == TRUE) {
      g <-
        induced.subgraph(g, vids = which(clusters(g)$membership == which.max(clusters(g)$csize)))
    }
    
    # On fixe un layout
    # g$layout <- layout.norm(layout.fruchterman.reingold(g, repulserad = vcount(g)^3.5), -1, 1, -1, 1)
    g$layout <-
      layout.norm(layout.fruchterman.reingold(g),-1, 1,-1, 1)
    return(g)
  }


#############
### DEBUG ###
#############

# g0 <- graph.edgelist(rbind(cbind(letters[sample(10, 20, TRUE)], sample(10, 20, TRUE)), cbind(LETTERS[sample(8, 20, TRUE)], sample(8, 20, TRUE)+20)), directed = FALSE)
# g0 <- simplify(g0)
# V(g0)$type <- bipartite.mapping(g0)$type
# write.csv(get.incidence(g0), file = "debug/debug.csv")

# fichier <- "debug/debug.csv"

# create_graph(fichier = "debug/debug.csv", seuil = 2, connexe = FALSE)