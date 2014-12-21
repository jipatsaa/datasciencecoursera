readTable <-function(dir,fileName){
  fileAndPath=paste(dir,fileName,sep="/")
  result<-read.table(fileAndPath)
}