## Fonction qui affiche le réseau de personnage

# debug
# fichierindex <- "test-adj.csv"
# fichierattr1 <- "test-attr.csv"
# fichierattr2 <- "1953.Fahrenheit451-attr2.csv"
# seuil <- 3

plotnetwork <- function(fichierindex,fichierattr1,fichierattr2,seuil){
  rep <- "analyse/"
  
  ## On teste si les attributs secondaires sont présents
  ## procédure débile qui engendre 3 create graphs à la suite
  g <- create_graph(	fichier = paste (rep,fichierindex,sep=""), 
                       seuil = seuil, 
                      connexe = TRUE)    
  if (!is.null (fichierattr1)) {
    g <- create_graph(	fichier = paste (rep,fichierindex,sep=""), 
                       attr1 = paste (rep,fichierattr1,sep=""),
                       seuil = seuil, 
                       connexe = TRUE)    
  }
  if (!is.null (fichierattr2)) {
    g <- create_graph(	fichier = paste (rep,fichierindex,sep=""), 
                       attr1 = paste (rep,fichierattr1,sep=""),
                       attr2 = paste (rep,fichierattr2,sep=""), 
                       seuil = seuil, 
                       connexe = TRUE)    
  }
  
  ############
  ### PLOT ###
  ############
  
  # On récupère le nom de l'oeuvre
  oeuvre <- substr (fichierindex,6,nchar(fichierindex)-8)
  date <- substr (fichierindex,1,4)
  titre <- paste (oeuvre," (",date,")", sep="")
  
  # Ici on crée le fichier où va arriver le visuel
  # On lui donne les dimensions qu'on veut
  # Cela crée une sorte de tunnel qui enregistrera tous nos ajouts
  # Et qu'on ferme à la fin avec la fonction dev.off()

  # on automatise le nom de fichier en fonction du nombre d'attributs
  if (g$windows == 0) {nomfichier <- paste (date,".",oeuvre,".s",seuil,".a0.pdf",sep="")}
  if (g$windows > 0) {nomfichier <- paste (date,".",oeuvre,".s",seuil,".a1.pdf",sep="")}
  if (g$windows > 1) {nomfichier <- paste (date,".",oeuvre,".s",seuil,".a2.pdf",sep="")}
  
  pdf(nomfichier,height = 14 + g$windows, width = 19.8)
  
  layout(matrix(1:(1+g$windows), nrow = 1+g$windows), widths = rep(1,1+g$windows), heights = c(10,rep(1,g$windows)))
  
  # À ce stade et pour mémoire, le tunnel est ouvert
  # Ce qu'on fait ici est de dire qu'il n'y a aucune marge sauf à droite
  # et que le graphe doit prendre toute la place
  par(mar=c(1,0,3,0))
  
  # Là on dessine le graphe, avec plein d'ajustements…
  # Pour plus de renseignements, taper dans la console la commande suivant :
  # ?igraph.plotting
  
  # On enregistre les noms, s'ils sont trop longs, on réduit à 20 caractères suivi d'un point
  vertex.label <- ifelse (nchar (V(g)$name) > 20, paste(substr(V(g)$name, 1, 20), ".", sep=""), 
          V(g)$name)
  
  # La taille des sommets : plusieurs mesures de centralité sont utilisables
  vertex.size <- log2(degree(g)+1)*2
  # centralization
  # centralization.degree(g)$res = degree (g) / degré de centralisation
  # centralization.degree(g)$centralization donne score global
  
  # betweenness centralization
  # centralization.betweenness(g)
  # centralization.betweenness(g)$centralization
  vertex.size2 <- log2(centralization.betweenness(g)$res+1)*2
  
  # eigen vector centralization
  # centralization.evcent(g)
  # centralization.evcent(g)$centralization
  vertex.size3 <- log2(centralization.evcent(g)$vector+1)*10
  
  # coreness"centralité",
  # vertex.size4 <- log2(graph.coreness(g)+1)*2
  
  # Une couleur par défaut
  vertex.color <- "firebrick2"
  # vertex.color <- "seashell2"
  
  # S'il existe un premier attribut (attr1), on distribue des couleurs aux sommets
  # On réordonne les attributs pour respecter l'ordre Science, Technique, Politique, Autres
  # De façon à fixer les couleurs sur le graph
  # Check orthographe science -> Science
  
  if (!is.null(V(g)$id1))	{
    V(g)$id1 <- paste (toupper(substr(V(g)$id1,1,1)),substr(V(g)$id1,2,nchar(V(g)$id1)), sep="")
    nonSTP <- levels (factor(V(g)$id1, exclude = c("Science", "Technique", "Politique")))
    STP <- factor((V(g)$id1), order=TRUE,
                  levels=c("Science", "Technique", "Politique",nonSTP))
    # vertex.color <- brewer.pal(length(unique((STP))), "Set1")[STP]
    vertex.color <- brewer.pal(length (levels (STP)),"Set1")[STP]
    }
  
  # Une forme par défaut
  vertex.shape <- "circle"
  
  # S'il existe un second attribut (attr2), on distribue des formes aux sommets
  if (!is.null(V(g)$id2)) {vertex.shape <- c("circle","square","losange","triangle","star","sphere")[factor(V(g)$id2)]}
  
  # La couleur du texte
  vertex.label.color <- "black"
  # vertex.label.color <- "midnightblue"
  
  # La distance des labels dépend des tailles
  # d'où ça foire quand on change de taille pour les cercle avec betweenness par ex. 
  vertex.label.dist <- (log2(degree(g)+5))/15
  
  # L'angle où s'affiche le label
  vertex.label.degree <- -pi/2
  
  # Le choix de la police
  vertex.label.family <- "mono"
  
  # La taille de la police
  vertex.label.cex <- 1.8
  
  # La largeur des arêtes, normalisée entre 0 et 1
  weight.normalised <- (E(g)$weight-(min(E(g)$weight+1)))/(max(E(g)$weight)-(min(E(g)$weight)+1))
  
  # La largeur des arêtes, avec minimum égal à 0*8+2 = 2 et maximum égal à 1*8+2 = 10
  edge.width <- weight.normalised*8+2
  
  # On définit une palette de gris pour faire un dégradé sur les arêtes
  gris <- grey(0:(1.2*max(E(g)$weight))/(2.4*max(E(g)$weight))+0.5)
  
  # La couleur des arêtes
  edge.color <- gris[max(E(g)$weight)-(E(g)$weight-min(E(g)$weight)+1)]
  
  # Et ici on dessine le graphe ! L'instance appelle les paramètres sauvés ci-dessus.
  plot(g,
       vertex.label = vertex.label,
       vertex.size = vertex.size,
       vertex.color = vertex.color,
       vertex.shape = vertex.shape,
       vertex.label.color = vertex.label.color,
       vertex.label.dist = vertex.label.dist,
       vertex.label.degree = vertex.label.degree,
       vertex.label.family = vertex.label.family, 
       vertex.label.cex = vertex.label.cex,
       edge.width = edge.width,
       edge.color = edge.color
  )
  
  # On ajoute un titre
  # titre <- paste (oeuvre, " | seuil ",seuil, sep="")
  title (main = titre, cex.main = 3, family ="mono")
  
  # Indicateurs pour graph sans attributs secondaires
  if (g$windows == 0) {		
    par(mar=c(5,0,0,0))
    nbperso <- nrow (read.csv(paste (rep,fichierindex, sep="")))
    nbpages <- ncol (read.csv(paste (rep,fichierindex, sep="")))
    indicateurs <- paste ("seuil :", seuil, "|",
                          nbperso, "personnages |",
                          round (nbperso/nbpages,2), "perso/page", "\n",
                          "centr. :", round (centralization.degree(g)$centralization,2),
                          "| betweenness :", round (centralization.betweenness(g)$centralization,2),
                          "| eigen :", round (centralization.evcent(g)$centralization,2),
                          sep=" ")
    title (sub = indicateurs, cex.sub = 2, family ="mono")
    }  
  
  # la légende pour le premier attribut (la couleur)
  if (g$windows > 0) {		plot.new()
    par(mar=c(0,0,0,0))
    legend(	x="center", 
            legend = levels(STP),
            pch = 21, 
            col = "black", 
            pt.bg = brewer.pal(length (levels (STP)),"Set1"),
            cex = g$windows + 1, 
            title = g$attr1, 
            bty = "n", 
            horiz = TRUE, 
            pt.cex = 4)}
  
  # la légende pour le second attribut (la forme)
  # faire correspondre les pch aux formes employées
  
  if (g$windows > 1) {	plot.new()
    par(mar=c(0,0,0,0))
    legend(	x="center", 	
            legend = levels(factor(V(g)$id2)), 
            pch = c(19,15,18,17,11,10)[1:length(levels(factor(V(g)$id2)))], 
            col = "black", 
            cex = 3, 
            title = g$attr2, 
            bty = "n", 
            horiz = TRUE, 
            pt.cex = 4)}
  if (!is.null(V(g)$id2)) {vertex.shape <- c("circle", "square", "losange","rectangle","csquare","sphere")[factor(V(g)$id2)]}
  
  # Et on ferme le tunnel
  dev.off()
  
  
  ## Version du pdf avec les histogrammes en supplément pour attr STP
  
  if (g$windows == 1) {
    nomfichier <- paste (date,".",oeuvre,".s",seuil,".a1.hist.pdf",sep="")
    pdf(nomfichier,height = 14 + g$windows, width = 19.8)
    # on détermine la disposition des graphs
    graphprop <- matrix(c(1, 2, 1, 3, 4, 4), nrow = 3, ncol = 2, byrow = TRUE)
    layout (graphprop,
            widths = c(5,1), heights = c(5,5,1))
    # le réseau principal
    par(mar=c(0,0,3,0))
    plot(g,
         vertex.label = vertex.label,
         vertex.size = vertex.size,
         vertex.color = vertex.color,
         vertex.shape = vertex.shape,
         vertex.label.color = vertex.label.color,
         vertex.label.dist = vertex.label.dist,
         vertex.label.degree = vertex.label.degree,
         vertex.label.family = vertex.label.family, 
         vertex.label.cex = vertex.label.cex,
         edge.width = edge.width,
         edge.color = edge.color
    )
    title (main = titre, cex.main = 3, family ="mono")
    # les histogrammes sur le côté
    par(mar=c(1,0,3,1))
    barplot (table (STP), col = brewer.pal (length (levels (STP)),"Set1"),
             names.arg = "", cex.main =2,family ="mono",
             main = "Répartition STP")
    par(mar=c(0,0,3,1))
    STPcentr <- data.frame (attr = STP,deg = as.numeric (degree(g)))
    rez <- aggregate(STPcentr$deg, by=list(STPcentr$attr), FUN=sum)
    barplot (rez$x,
             #names.arg = rez$Group.1, 
             col = brewer.pal (length (levels (rez$Group.1)),"Set1"),
             names.arg = "", cex.main =2,family ="mono",
             main ="STP * centralité")
    # la légende pour le premier attribut (la couleur)
    plot.new()
    par(mar=c(0,0,0,0))
    legend(	x="center", 
            legend = levels(STP),
              pch = 21, 
              col = "black", 
              pt.bg = brewer.pal(length(unique((STP))), "Set1"), 
              cex = g$windows + 1, 
              title = g$attr1, 
              bty = "n", 
              horiz = TRUE, 
              pt.cex = 4)
    # Et on ferme le tunnel
    dev.off()
    
  }
  
  # Le résultat est assez illisible, et devra être amélioré au cas par cas
  # par exemple avec tkplot pour choisir un meilleur emplacement pour les noeuds
  # ou alors en changeant tailles, couleurs, etc.
  
  # À étudier : les différentes possibilités d'export en D3…
  
  
}
