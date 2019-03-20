
library(data.table)

url <- 'http://biocc.hrbmu.edu.cn/CellMarker/download/Human_cell_markers.txt'
CellMarkersDB <- data.frame(fread(url))

save(CellMarkersDB, file = './data/CellMarkersDB.RData')
