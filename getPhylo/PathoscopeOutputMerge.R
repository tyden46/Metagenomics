suppressMessages(suppressWarnings(require(plyr)))
suppressMessages(suppressWarnings(require(stringr)))
suppressMessages(suppressWarnings(require(dplyr)))
library(plyr)
library(stringr)
library(dplyr)
args <- commandArgs(trailingOnly = TRUE)
listOfFiles=list.files(pattern="*.tsv")
tableExists=FALSE
counter=1
for(x in listOfFiles){
  fileName=str_remove_all(x,".tsv")
  thisAbundance=read.delim(x,skip=1)
  row.names(thisAbundance)=thisAbundance$Genome
  thisAbundance=as.data.frame(thisAbundance[,2], row.names=row.names(thisAbundance))
  colnames(thisAbundance)="Final.Guess"
  if(tableExists){
    combinedTable=full_join(tibble::rownames_to_column(combinedTable),
                            tibble::rownames_to_column(thisAbundance),
                            by = "rowname")
    combinedTable=as.data.frame(combinedTable[,2:(counter+1)],
                                row.names=combinedTable$rowname)
    colnames(combinedTable)[counter]=fileName
  }else{
    combinedTable=as.data.frame(thisAbundance$Final.Guess, row.names = row.names(thisAbundance))
    colnames(combinedTable)=fileName
    tableExists=TRUE
  }
  counter=counter+1
}
combinedTable[is.na(combinedTable)]=0
write.table(combinedTable,file="CombinedTable.tsv",sep='\t',quote=FALSE,row.names = TRUE)
write.table(names(which(rowSums(combinedTable)>args[1])),file="SubsetOfGenomes.txt",sep='\n',row.names = FALSE,col.names = FALSE)
length(which(rowSums(combinedTable)>args[1]))
for(y in row.names(combinedTable)){
  print(y)
}
