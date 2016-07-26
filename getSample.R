# Get Data Samples from all failed C1 servers. 
# We get SMART samples and IO samples
# Author: yiyusheng
# Date: 2016-07-19
rm(list = ls())
source('head.R')

####################################
# S1. get cmdb and data.f
load('/home/yiyusheng/Data/SMART/load_ftr_attridOld.Rda')
source('/home/yiyusheng/Code/R/SMART/dataPrepareOld.R')
data.fC1 <- subset(tmp.f,dev_class_id == 'C1')
data.nC1 <- subset(tmp.cmdb,dev_class_id == 'C1' & !(svrid %in% tmp.f$svrid))
data.nC1 <- data.nC1[sample(1:nrow(data.nC1),500),]

# S2. get smart
dir_smart <- '/home/yiyusheng/Data/SMART/smart5k'
fname <- paste('smart_',seq(1,31),'.Rda',sep='')
getSMART <- function(fn,df){
  load(file.path(dir_smart,fn))
  SMARTsend <- subset(smart,svrid %in% df$svrid)
}

require(doParallel)
ck <- makeCluster(40, outfile = '')
registerDoParallel(ck)

rf1 <- foreach(i = fname,.combine = rbind,.verbose = T) %dopar% getSMART(i,data.fC1)
SMARTF <- factorX(rf1)

rn1 <- foreach(i = fname,.combine = rbind,.verbose = T) %dopar% getSMART(i,data.nC1)
SMARTN <- factorX(rn1)


# S3. get IO
dir_IO <- '/home/yiyusheng/Data/allIOMerge/merge_5k'
fname <- paste('data',1:25,'.Rda',sep='')
getIO <- function(fn,df){
  load(file.path(dir_IO,fn))
  IOF <- subset(data,svrid %in% df$svrid)
}

rf2 <- foreach(i = fname,.combine = rbind,.verbose = T) %dopar% getIO(i,data.fC1)
IOF <- factorX(rf2)
names(IOF) <- c('svrid','time','timepoint','read','write','util')
IOF$time <- as.POSIXct(as.character(IOF$time),tz = 'UTC',format = '%Y%m%d')
IOF$time <- IOF$time + IOF$timepoint*5*60
IOF$timepoint <- NULL

rn2 <- foreach(i = fname,.combine = rbind,.verbose = T) %dopar% getIO(i,data.nC1)
ION <- factorX(rn2)
names(ION) <- c('svrid','time','timepoint','read','write','util')
ION$time <- as.POSIXct(as.character(ION$time),tz = 'UTC',format = '%Y%m%d')
ION$time <- ION$time + ION$timepoint*5*60
ION$timepoint <- NULL

stopCluster(ck) 

# S4. Statistic
staSMART <- data.frame(svrid = levels(SMARTF$svrid),
                       count = as.numeric(tapply(SMARTF$svrid,SMARTF$svrid,length)))
staIO <- data.frame(svrid = levels(IOF$svrid),
                       count = as.numeric(tapply(IOF$svrid,IOF$svrid,length)))

# S5. Save
save(data.fC1,SMARTF,IOF,staSMART,staIO,file = file.path(dir_data,'getSampleF.Rda'))
save(data.nC1,SMARTN,ION,file = file.path(dir_data,'getSampleN.Rda'))