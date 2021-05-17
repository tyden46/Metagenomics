library(vroom)
library(dplyr)
taxaAndRanks=as.data.frame(vroom("taxaAndRanks.txt"))
counter=1
for(x in 1:length(row.names(taxaAndRanks))){
  taxa=strsplit(taxaAndRanks[x,2][1],";")[[1]]
  rank=strsplit(taxaAndRanks[x,3][1],";")[[1]]
  if(length(which(rank=="no rank"))>1){
    counter2=1
    noRankCounter=2
    for(y in rank){
      if(y=="no rank" & counter2!=1){
        rank[counter2]=paste("no rank", noRankCounter, sep="")
        noRankCounter=noRankCounter+1
      }
      counter2=counter2+1
    }
  }
  if(length(which(rank=="clade"))>1){
    counter2=1
    noRankCounter=2
    for(y in rank){
      if(y=="clade" & counter2!=1){
        rank[counter2]=paste("clade", noRankCounter, sep="")
        noRankCounter=noRankCounter+1
      }
      counter2=counter2+1
    }
  }
  if(counter==1){
    myTable=as.data.frame(t(c(taxaAndRanks[x,1][1],taxa)))
    colnames(myTable)=c("ID",rank)
  }else{
    myTable2=as.data.frame(t(c(taxaAndRanks[x,1][1],taxa)))
    colnames(myTable2)=c("ID",rank)
    myTable=full_join(myTable,myTable2)
  }
  counter=counter+1
}
write.table(myTable,file="LineageTable.tsv",sep='\t',quote=FALSE,row.names = FALSE)

