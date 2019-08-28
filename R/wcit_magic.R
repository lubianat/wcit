
#' An integration of the wcit package to the Seurat framework
#'
#' This function allows you to infer the Seurat clusters identity from a list of putative markers
#'
#' @param seurat_markers A dataframe returned by Seurat's 3.0 FindAllMarkers function
#' @param number_of_markers Number of markers extracted from the FindAllMarkers
#' function that will be used for calculation. Defaults to 20.
#' @param search_literature If true, it will perform a literature search to indicate which,
#' among the 3 top hits, is most likely to be the one of interest. Defaults to FALSE.
#' @import PubScore
#' @import Seurat
#' @import dplyr
#' @keywords single-cell

wcit_guess_seurat <- function (seurat_object, number_of_markers = 20 ){

  markers <- Seurat::FindAllMarkers(seurat_object)
  les_marcadeurs <- markers %>% group_by(cluster) %>% top_n(number_of_markers, avg_logFC)

  guesses <- data.frame(0,0,0)
  guesses <- guesses[-1,]

  top_markers <- pbmc_markers %>% group_by(cluster) %>% top_n(number_of_markers, avg_logFC)

  for (i in levels(top_markers$cluster)){
    print(i)
    selected_markers <- top_markers$gene[top_markers$cluster==i]
    wcit_result<- wcit(selected_markers, CellMarkers = F)
    guesses_now <- as.data.frame(wcit_result[['panglaoDB']])[1:3,]
    names(guesses_now) <- c('wcit_guess', 'panglaoDB')
    guesses_now$cluster <- rep(i,3)
    guesses <- rbind(guesses, guesses_now)
  }

  if(!search_literature){
    return(guesses)
  }
  if(search_literature){
    guesses$pubscore <- rep(NA,nrow(guesses))

    for (i in levels(as.factor(guesses$cluster))){
      guesses_for_this_cluster <- guesses$wcit_guess[guesses$cluster == i]
      selected_markers <- top_markers$gene[top_markers$cluster==i]


      for (j in guesses_for_this_cluster){
        pubscore_genes <- PubScore::get_literature_score(gene = selected_markers, terms_of_interest = j, is.list=T)
        pubscore_base <-  PubScore::get_literature_score(gene = "", terms_of_interest = j, is.list=F)
        pubscore_ratio <- pubscore_genes$list_literature_score / pubscore_base$gene_literature_score
        this_guess <- pubscore_ratio
        guesses$pubscore[which(guesses$cluster == i & guesses$wcit_guess == j)] <- this_guess
      }
      }


    return(guesses)
  }


  return(seurat_object)
}
