#'
BiocManager::install("monocle")

Arm(list = ls())  # Clear the environment
options(warn=-1) # Turn off warning message globally
library(monocle) # Load Monocle
cds <- readRDS(gzcon(url("http://trapnell-lab.gs.washington.edu/public_share/valid_subset_GSE72857_cds2.RDS")))

pData(cds)$cell_type2 <- plyr::revalue(as.character(pData(cds)$cluster),
                                       c("1" = 'Erythrocyte',
                                         "2" = 'Erythrocyte',
                                         "3" = 'Erythrocyte',
                                         "4" = 'Erythrocyte',
                                         "5" = 'Erythrocyte',
                                         "6" = 'Erythrocyte',
                                         "7" = 'Multipotent progenitors',
                                         "8" = 'Megakaryocytes',
                                         "9" = 'GMP',
                                         "10" = 'GMP',
                                         "11" = 'Dendritic cells',
                                         "12" = 'Basophils',
                                         "13" = 'Basophils',
                                         "14" = 'Monocytes',
                                         "15" = 'Monocytes',
                                         "16" = 'Neutrophils',
                                         "17" = 'Neutrophils',
                                         "18" = 'Eosinophls',
                                         "19" = 'lymphoid'))
