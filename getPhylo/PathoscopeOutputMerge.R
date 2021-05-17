library(taxize)
library(myTAI)
library(plyr)
library(stringr)
library(dplyr)
args <- commandArgs(trailingOnly = TRUE)
listOfFiles=list.files(pattern="N.*.tsv")
tableExists=FALSE
counter=1
for(x in listOfFiles){
  fileName=str_extract(x,"NJ-BioR-[0-9]{3}")
  thisAbundance=read.delim(x,skip=1)
  #if(length(row.names(thisAbundance))>=10){
    #thisAbundance=as.data.frame(thisAbundance[1:10,])
  #}else{
    #thisAbundance=as.data.frame(thisAbundance[1:length(row.names(thisAbundance)),])
  #}
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
write.table(names(which(rowSums(combinedTable)>0.01)),file="SumGreaterThan0.01.txt",sep='\n',row.names = FALSE,col.names = FALSE)
length(which(rowSums(combinedTable)>0.01))
for(y in row.names(combinedTable)){
  print(y)
}
