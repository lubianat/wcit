
#' An integration of the wcit package to the Seurat framework
#'
#' This function allows you to infer the Seurat clusters identity from a list of putative markers
#'
#' @param seurat_object A seurat object already clusterized.
#' @param number_of_markers Number of markers extracted from the FindAllMarkers
#' function that will be used for calculation. Defaults to 10.
#' @import Seurat
#' @import dplyr
#' @keywords single-cell
#' @export

wcit_magic <- function (seurat_object, number_of_markers = 10 ){

  markers <- Seurat::FindAllMarkers(seurat_object)
  les_marcadeurs <- markers %>% group_by(cluster) %>% top_n(number_of_markers, avg_logFC)

  guesses <- c()

  for (i in levels(les_marcadeurs$cluster)){

    selected_markers <- les_marcadeurs$gene[les_marcadeurs$cluster==i]
    wcit_result <-wcit(selected_markers)
    guesses <- c(guesses, names(wcit_result[['panglaoDB']][1]))
  }

  current.cluster.ids <- levels(seurat_object@ident)
  new.cluster.ids <- guesses
  seurat_object@ident <- plyr::mapvalues(x = seurat_object@ident, from = current.cluster.ids, to = new.cluster.ids)
  TSNEPlot(object = seurat_object, do.label = TRUE, pt.size = 0.5)
  return(seurat_object)
}
