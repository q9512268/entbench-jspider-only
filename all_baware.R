library(reshape2)
library(ggplot2)
library(RColorBrewer)

dta <- read.table("dat/all_baware_consumed.dat", sep="\t", head=T)

colors <- brewer.pal(6, "Paired")
grays <- brewer.pal(6, "Greys")

#mapped_colors <- c("managed"=colors[4],"managed silent"=colors[3],"full_throttle"=colors[6], "full_throttle silent"=colors[5]) 
#mapped_colors <- c("ent"=colors[2],"silent"=colors[1])
mapped_colors <- c("ent"=grays[5],"silent"=grays[3])

xvals <- c()
xlbls <- c()

for (i in 1:nrow(dta)) {
  xvals <- c(xvals,dta$xcord[i])
  if ((i %% 3) == 2) {
    lbl <- paste(dta$bench[i], "", sep="")
  } else {
    lbl <- ""
  }
  xlbls <- c(xlbls,lbl)
  #lbl <- paste(dta$bench[i], dta$data[i], sep="_")
  #xlbls <- c(xlbls,lbl)
}


for (i in 1:nrow(dta)) {
  if ((i %% 3) != 0) {
    dta$percent_saved[i] <- ""
    dta$percent_saved[i] <- ""
  }
}

pdf("all_battery_exception_saved.pdf", width=16,height=7)


d=data.frame(xint=c(5.7,10.7))
d2=data.frame(xsys=c(0.5,6.5,11.5), systems=c("System A", "System B", "System C"))

dta$vj1 <- rep(c(0,0,0), length.out=45)
dta$vj2 <- rep(c(0,0,0), length.out=45)

for (i in 1:45) {
  dta$vj2[i] <- -1
}

p <- ggplot(data=dta, aes(xcord)) +
     geom_bar(aes(y=java_managed,fill="silent"),
              stat="identity", 
              width=0.15) +
     geom_bar(aes(y=ent_managed,fill="ent"), 
              stat="identity", 
              width=0.15) +


     geom_bar(aes(y=java_full,fill="silent"),
              stat="identity", 
              width=0.15) +
     geom_bar(aes(y=ent_full,fill="ent"), 
              stat="identity", 
              width=0.15) +

     #geom_text(aes(y=ent_managed,label=percent_saved,vjust=vj1),colour="red2",size=5.5) +

     geom_text(aes(y=ent_full,label=percent_saved,vjust=vj2),colour="black",size=6.5) +

     geom_vline(data=d, aes(xintercept=xint), colour="red3", linetype = "longdash") +
     geom_text(data=d2, aes(x=xsys,y=1.10,label=systems), colour="black", size=7.5) +

     scale_fill_manual(name="Boot Mode",values=mapped_colors) +

     scale_y_continuous(breaks=c(0.0, 0.25, 0.50, 0.75, 1.0)) +

     xlim(0.0,16) +
     xlab("Benchmark") +
     ylab("Normalized Energy") +
     theme_gray(base_size=20) +
     theme(
           panel.grid.minor = element_blank(), 
           panel.grid.minor.x = element_blank(), 
           axis.text=element_text(color="black"),
           axis.text.x=element_text(angle=60, hjust = 1), 
           legend.position="bottom",
           plot.margin=unit(c(0.5,1.0,0.0,0.0),"cm")) +


     scale_x_continuous(breaks=xvals,labels=xlbls)


print(p)

dev.off()
  
