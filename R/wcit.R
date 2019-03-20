#' @imports dplyr
NULL

#' A "which cell is that" function.
#'
#' This function allows you to infer the cell identity from a list of putative markers
#' @param markers A vector containing the gene markers in Gene Symbol format, for humans
#' @param panglao A boolean determining if panglaoDB is going to be used or not. Defaults to TRUE
#' @keywords single-cell
#' @export
#' @examples
#' set.seed(3)
#'
#' data(panglaoDB)
#' markers <- panglaodb$official.gene.symbol[c(1:10, sample(x = 1:7000,size = 10))]
#' wcit(markers)


wcit <- function(markers, panglao = T){
  data("panglaodb")
  marker_hits <- dplyr::filter(panglaoDB, official.gene.symbol %in% markers)

  cell_rank <- table(marker_hits$cell.type)

  cell_rank <- sort(cell_rank, decreasing = T)

  head(cell_rank)


}
