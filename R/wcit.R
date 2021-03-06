#' A "which cell is that" function.
#'
#' This function allows you to infer the cell identity from a list of putative markers
#' @param markers A vector containing the gene markers in Gene Symbol format, for humans
#' @param panglao A boolean determining if panglaoDB is going to be used or not. Defaults to TRUE
#' @param CellMarkers A boolean determining if CellMarkersDB is going to be used or not. Defaults to TRUE
#' @return A list of putative cell types
#' @keywords single-cell
#' @export
#' @examples
#' # B cell markers
#'   markers <- c("CD79A", "CD79B", "MS4A1")
#'   marker_hits <- wcit(markers)

wcit <- function(markers, panglao = TRUE, CellMarkers = TRUE ){
  ranks <- list()
  if (panglao == TRUE){
    data("panglaoDB")
    marker_hits <- panglaoDB[panglaoDB$`official gene symbol` %in% markers,]
    cell_rank <- table(marker_hits$`cell type`)
    cell_rank <- sort(cell_rank, decreasing = TRUE)
    ranks$panglaoDB <-cell_rank
    print(paste("Top cell types according to", 'panglaoDB', ':'))
    print(head(cell_rank, 3))
  }
  if (CellMarkers == TRUE){

## Note that many cell types are not being considered due to the way the database was constructed
    # options
    # (1) Reshape and clean the database
    # (2) Query the dirty database in a more rational way.

    data("CellMarkersDB")
    marker_hits <-data.frame()
    for (gene in markers){
      marker_hits <- rbind(marker_hits,CellMarkersDB[grep(gene, CellMarkersDB$geneSymbol),])
    }
    cell_rank <- table(marker_hits$cellName)
    cell_rank <- sort(cell_rank, decreasing = TRUE)
    ranks$CellMarkersDB <-cell_rank
    print(paste("Top cell types according to", 'CellMarkersDB', ':'))
    print(head(cell_rank, 3))
  }

  return(ranks)


}
