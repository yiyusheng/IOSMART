# F1. func for IO
plotIOSample <- function(data){
  p <- list()
  p[[1]] <- ggplot(data,aes(x = time,y = log2(read)))+ 
    geom_line(size = 0.5) + geom_point(size = 0.2) + ylab('') + xlab(paste('read',data$svrid[1],sep=''))
  p[[2]]<- ggplot(data,aes(x = time,y = log2(write))) + 
    geom_line(size = 0.5) + geom_point(size = 0.2) + ylab('')+ xlab('write')
  p[[3]] <- ggplot(data,aes(x = time,y = util)) + 
    geom_line(size = 0.5) + geom_point(size = 0.2)+ xlab('util') +ylab('')
  p
}

# F2. func for SMART
plotSMARTattr <- function(data){
  p <- list()
  for(i in 1:length(smartName)){
    data[[smartName[i]]] <- c(0,-diff(data[[smartName[i]]]))
    eval(parse(text = sprintf("p[[i]] <- ggplot(data,aes(x = time,y = %s)) +
                              geom_line(size = 0.5) + geom_point(size = 0.35) + 
                              xlab('%s') +ylab('')",smartName[i],smartName[i]))) 
  }
  p
}

# F3. make list to matrix
list2matrix <- function(list){
  rlen <- length(list)
  clen <- length(list[[1]])
  mat <- matrix(list(),nrow = rlen,ncol = clen)
  for(i in 1:rlen){
    for(j in 1:clen){
      mat[i,j] <- list[[i]][j]
    }
  }
  mat <- data.frame(mat)
  mat$svrid <- names(list)
  mat
}                    

#F4. plot all IO attr and five SMART attr in a jpeg for one server
svridPlotF <- function(sid){
  currIO <- subset(IOFp, svrid == sid)
  currSMART <- subset(SMARTFp, svrid == sid)
  dn <- 'failed'
  if(nrow(currIO) == 0 | nrow(currSMART) == 0){
    return(0)
  }else{
    jpeg(filename = file.path(dir_data,'figure','visualizeSample',dn,paste(sid,'-A.jpg',sep='')),width = 1440, height = 900, 
         bg = "white", res = NA)
    multiplot(currIO[[ioName[1]]][[1]],currIO[[ioName[2]]][[1]],currIO[[ioName[3]]][[1]],
              currSMART[[smartName[1]]][[1]],currSMART[[smartName[2]]][[1]],currSMART[[smartName[3]]][[1]],
              currSMART[[smartName[4]]][[1]],currSMART[[smartName[5]]][[1]])
    dev.off()
    
    jpeg(filename = file.path(dir_data,'figure','visualizeSample',dn,paste(sid,'-B.jpg',sep='')),width = 1440, height = 900, 
         bg = "white", res = NA)
    multiplot(currIO[[ioName[1]]][[1]],currIO[[ioName[2]]][[1]],currIO[[ioName[3]]][[1]],
              currSMART[[smartName[1+5]]][[1]],currSMART[[smartName[2+5]]][[1]],currSMART[[smartName[3+5]]][[1]],
              currSMART[[smartName[4+5]]][[1]],currSMART[[smartName[5+5]]][[1]])
    dev.off()
    
    jpeg(filename = file.path(dir_data,'figure','visualizeSample',dn,paste(sid,'-C.jpg',sep='')),width = 1440, height = 900, 
         bg = "white", res = NA)
    multiplot(currIO[[ioName[1]]][[1]],currIO[[ioName[2]]][[1]],currIO[[ioName[3]]][[1]],
              currSMART[[smartName[1+10]]][[1]],currSMART[[smartName[2+10]]][[1]],currSMART[[smartName[3+10]]][[1]],
              currSMART[[smartName[4+10]]][[1]],currSMART[[smartName[5+10]]][[1]])
    dev.off()
    return(1)
  }
}

svridPlotN <- function(sid){
  currIO <- subset(IONp, svrid == sid)
  currSMART <- subset(SMARTNp, svrid == sid)
  dn <- 'normal'
  
  if(nrow(currIO) == 0 | nrow(currSMART) == 0){
    return(0)
  }else{
    jpeg(filename = file.path(dir_data,'figure','visualizeSample',dn,paste(sid,'-A.jpg',sep='')),width = 1440, height = 900, 
         bg = "white", res = NA)
    multiplot(currIO[[ioName[1]]][[1]],currIO[[ioName[2]]][[1]],currIO[[ioName[3]]][[1]],
              currSMART[[smartName[1]]][[1]],currSMART[[smartName[2]]][[1]],currSMART[[smartName[3]]][[1]],
              currSMART[[smartName[4]]][[1]],currSMART[[smartName[5]]][[1]])
    dev.off()
    
    jpeg(filename = file.path(dir_data,'figure','visualizeSample',dn,paste(sid,'-B.jpg',sep='')),width = 1440, height = 900, 
         bg = "white", res = NA)
    multiplot(currIO[[ioName[1]]][[1]],currIO[[ioName[2]]][[1]],currIO[[ioName[3]]][[1]],
              currSMART[[smartName[1+5]]][[1]],currSMART[[smartName[2+5]]][[1]],currSMART[[smartName[3+5]]][[1]],
              currSMART[[smartName[4+5]]][[1]],currSMART[[smartName[5+5]]][[1]])
    dev.off()
    
    jpeg(filename = file.path(dir_data,'figure','visualizeSample',dn,paste(sid,'-C.jpg',sep='')),width = 1440, height = 900, 
         bg = "white", res = NA)
    multiplot(currIO[[ioName[1]]][[1]],currIO[[ioName[2]]][[1]],currIO[[ioName[3]]][[1]],
              currSMART[[smartName[1+10]]][[1]],currSMART[[smartName[2+10]]][[1]],currSMART[[smartName[3+10]]][[1]],
              currSMART[[smartName[4+10]]][[1]],currSMART[[smartName[5+10]]][[1]])
    dev.off()
  }
}