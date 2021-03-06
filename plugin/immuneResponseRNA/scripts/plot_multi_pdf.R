# Copyright (C) 2015 Ion Torrent Systems, Inc. All Rights Reserved
library(RColorBrewer)

args <- commandArgs(trailingOnly=TRUE)

nFileIn  <- ifelse(is.na(args[1]),"pdfplot.xls",args[1])
nFileOut <- ifelse(is.na(args[2]),"pdfplot.png",args[2])
nBarcode <- ifelse(is.na(args[3]),0,args[3])
title    <- ifelse(is.na(args[4]),"Frequency Plot",args[4])

if( !file.exists(nFileIn) ) {
    write(sprintf("ERROR: Could not locate input file %s\n",nFileIn),stderr())
    q(status=1)
}

col_bkgd = "#E5E5E5"

# read in matrix file and check expected format
data <- read.table(nFileIn, header=TRUE, sep="\t", as.is=TRUE, check.names=F, comment.char="")
ncols = ncol(data)
if( ncols < 2 ) {
    write(sprintf("ERROR: Expected at least 2 columns of data, including row ID field from bcmatrix file %s\n",nFileIn),stderr())
    q(status=1)
}
nrows = nrow(data)
if( nrows < 1 ) {
    write(sprintf("ERROR: Expected at least 1 row of data plus header line bcmatrix file %s\n",nFileIn),stderr())
    q(status=1)
}

# Remove first column and any (annotation) columns after barcode data and take log2(x+1) of counts
# grab row names and strip extra columns
data <- data[,-c(1,2),drop=FALSE]
if( nBarcode > 0 ) {
    data <- data[,1:nBarcode,drop=FALSE]
}
ncols <- ncol(data)
if( ncols < 1 ) {
    write(sprintf("ERROR: Expected at least 1 data column after removing annotation columns in %s\n",nFileIn),stderr())
    q(status=1)
}
data <- log2(data + 1)

nplot <- ncol(data)
if( nplot > 1 ) {
    hgt <- 600
    mrg <- 5.5
    # shaded color sets are hard to distinguish, most qualative brewer sets limited to 8 or 12
    #colors <- c(rainbow(7),"#3F3F3F",brewer.pal(12,"Paired"),brewer.pal(8,"Set2"),brewer.pal(8,"Dark2"))
    colors <- c("#3F3F3F",brewer.pal(10,"Paired"), 'cyan', 'green', 'blue', 'brown', 'orange')
    #colors <- c("#3F3F3F",brewer.pal(10,"Set3"), 'cyan', 'green', 'blue', 'brown', 'orange')
} else {
    hgt <- 600
    mrg <- 0.5
    colors <- "black"
}
lgd <- 0.005 - 0.001 * nplot

lnames <- colnames(data)

xmax = as.integer(max(data) + 0.95)
ymax = 0
for( i in 1:nplot) {
    ym <- max( density(data[[i]])$y )
    if( ym > ymax ) { ymax = ym }
}
ymax = (ymax + 0.001) * 1.05

png(nFileOut,width=700,height=hgt)
par(mfrow=c(1,1),mar=(c(3.4,2,3,mrg)),cex=2)
plot( data[[1]], type="n", xlim=c(0,xmax), ylim=c(0,ymax), yaxt='n', xlab="", col=colors[1], main="" )
rect(par("usr")[1],par("usr")[3],par("usr")[2],par("usr")[4],col=col_bkgd)
grid( col="white", lwd=1, lty=1 )
title(main = title, cex.main = 0.75)
mtext("Frequency",side=2,line=0.6,cex=1.25)
mtext("log2(counts)",side=1,line=2,cex=1.25)
box()

for( i in 1:nplot) {
    lines( density(data[[i]]), type="l", col=colors[i], lwd=2 )
}
if( nplot > 1 ) {
    legend( legend=lnames, xpd=T, x="topright",cex=0.6,inset=c(-0.28,lgd),fill=colors,bty="n",x.intersp=0.5 )
}
dev.off()

q()
