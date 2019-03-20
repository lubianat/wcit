
library(data.table)

url <- 'http://biocc.hrbmu.edu.cn/CellMarker/download/Human_cell_markers.txt'
CellMarkers <- fread(url)

save(CellMarkers, file = './data/CellMarkers.RData')
