downloadFromURLAndUnzip <- function  (fileUrl="http://dir.csv", workdirPath=".", fileName="dataFile")
# 3 parameters:
  # 1. url to download
  # 2. the target directory to dump the information
  # 3. the name of the file
  
{
  ## Step 0: Checking for and creating directories
  if(!file.exists(workdirPath))
  {
    dir.create(workdirPath)
  }
  
  ## Step 1: download the data file
  fileAndPath=paste(workdirPath,fileName,sep="/")
  if(!file.exists(fileAndPath))
  {
    download.file(fileUrl, destfile=fileAndPath,method="curl")
    unzip(zipfile=fileAndPath, exdir=dataDir) 
    dateDownloaded <- date()
    print(paste("INFO: the data file downloaded on: ", dateDownloaded))
  }
}