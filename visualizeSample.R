# Visualize SMART and IO from disk of C2 servers                                                                                            
# plot important SMART attributes and all IO attributes from June 1st to Auguest 1st for each server/disk
# Author: yiyusheng
# Date: 2016-07-19
rm(list = ls())
source('head.R')
require('ggplot2')
load(file.path(dir_data,'getSampleF.Rda'))
load(file.path(dir_data,'getSampleN.Rda'))
source(file.path(dir_code,'visualizeSampleFunc.R'))
smartName <- names(SMARTF)[7:21]
ioName <- c('read','write','util')
####################################
# # S1. sort and split for plot
# IOF1 <- subset(IOF,time > as.POSIXct('2014-06-01',tz = 'UTC') & time < as.POSIXct('2014-08-01',tz = 'UTC'))
# IOF1 <- factorX(IOF1[order(IOF1$svrid,IOF1$time),])
# SMARTF1<- subset(SMARTF,time > as.POSIXct('2014-06-01',tz = 'UTC') & time < as.POSIXct('2014-08-01',tz = 'UTC'))
# SMARTF1 <- factorX(SMARTF1[order(SMARTF1$svrid,SMARTF1$time),])
# IOFsplit <- split(IOF1,IOF1$svrid)
# SMARTFsplit <- split(SMARTF1,SMARTF1$svrid)
# 
# ION1 <- subset(ION,time > as.POSIXct('2014-06-01',tz = 'UTC') & time < as.POSIXct('2014-08-01',tz = 'UTC'))
# ION1 <- factorX(ION1[order(ION1$svrid,ION1$time),])
# SMARTN1<- subset(SMARTN,time > as.POSIXct('2014-06-01',tz = 'UTC') & time < as.POSIXct('2014-08-01',tz = 'UTC'))
# SMARTN1 <- factorX(SMARTN1[order(SMARTN1$svrid,SMARTN1$time),])
# IONsplit <- split(ION1,ION1$svrid)
# SMARTNsplit <- split(SMARTN1,SMARTN1$svrid)
# 
# # S2. generate and save figure
# IOFp <- list2matrix(lapply(IOFsplit,plotIOSample))
# SMARTFp <- list2matrix(lapply(SMARTFsplit,plotSMARTattr))
# IOFp$svrid <- names(IOFsplit)
# SMARTFp$svrid <- names(SMARTFsplit)
# names(IOFp) <- c(ioName,'svrid')
# names(SMARTFp) <- c(smartName,'svrid')
# 
# IONp <- list2matrix(lapply(IONsplit,plotIOSample))
# SMARTNp <- list2matrix(lapply(SMARTNsplit,plotSMARTattr))
# IONp$svrid <- names(IONsplit)
# SMARTNp$svrid <- names(SMARTNsplit)
# names(IONp) <- c(ioName,'svrid')
# names(SMARTNp) <- c(smartName,'svrid')
# save(IOFp,SMARTFp,IONp,SMARTNp,file = file.path(dir_data,'visualizeSample.RDa'))

# S3. plot figure with multiplot
load(file.path(dir_data,'visualizeSample.RDa'))
svridSetF <- intersect(IOFp$svrid,SMARTFp$svrid)
IOFp <- subset(IOFp, svrid %in% svridSetF)
SMARTFp <- subset(SMARTFp,svrid %in% svridSetF)
IOFp <- IOFp[order(IOFp$svrid),]
SMARTFp <- SMARTFp[order(IOFp$svrid),]

svridSetN <- intersect(IONp$svrid,SMARTNp$svrid)
IONp <- subset(IONp, svrid %in% svridSetN)
SMARTNp <- subset(SMARTNp,svrid %in% svridSetN)
IONp <- IONp[order(IONp$svrid),]
SMARTNp <- SMARTNp[order(IONp$svrid),]

require(doParallel)
ck <- makeCluster(40, outfile = '')
registerDoParallel(ck)
rF <- foreach(i = svridSetF,.combine = rbind,.verbose = T) %dopar% svridPlotF(i)
rN <- foreach(i = svridSetN,.combine = rbind,.verbose = T) %dopar% svridPlotN(i)
stopCluster(ck) 
