library(reshape2)
library(ggplot2)
library(RColorBrewer)

colors <- brewer.pal(6, "Paired")
grays <- brewer.pal(6, "Greys")

#mapped_colors <- c("full_throttle"=colors[5],"managed"=colors[3],"energy_saver"=colors[1])
mapped_colors <- c("full_throttle"=grays[5],"managed"=grays[3],"energy_saver"=grays[1])

dta <- read.table("dat/all_badapt_consumed.dat", sep="\t", head=T)

xvals <- c()
xlbls <- c()

for (i in 1:nrow(dta)) {
  xvals <- c(xvals,dta$xcord[i])
  #lbl <- paste(dta$bench[i], dta$data[i], sep="_")
  #xlbls <- c(xlbls,lbl)
  if ((i %% 3) == 2) {
    lbl <- paste(dta$bench[i], "", sep="")
  } else {
    lbl <- ""
  }
  xlbls <- c(xlbls,lbl)
}


for (i in 1:nrow(dta)) {
  if ((i %% 3) != 0) {
    dta$mid_percent_saved[i] <- ""
    dta$low_percent_saved[i] <- ""
  }
}

dta$vj1 <- rep(c(0,0,0), length.out=45)
dta$vj2 <- rep(c(0,0,0), length.out=45)

pdf("all_battery_casing.pdf", width=16,height=7)

d=data.frame(xint=c(5.7,10.7))
d2=data.frame(xsys=c(0.5,6.5,11.5), systems=c("System A", "System B", "System C"))

print(dta)

for (i in 1:18) {
  dta$vj1[i] <- 0
  dta$vj2[i] <- 1.2
}
for (i in seq(from=19,to=33,by=3)) {
  dta$vj1[i] <- 0
  dta$vj1[i+1] <- -0.2
  dta$vj1[i+2] <- -0.4

  dta$vj2[i] <- 2.0
  dta$vj2[i+1] <- 1.4
  dta$vj2[i+2] <- 1.3
}


dta$vj2[1] <- dta$vj2[1] + 1
dta$vj2[2] <- dta$vj2[2] + 1

dta$vj1[6] <- dta$vj1[6] - 1
dta$vj1[12] <- dta$vj1[12] - 1

dta$vj1[31] <- 2.5
dta$vj1[32] <- 1.0
dta$vj1[33] <- 0 

dta$vj2[31] <- 4.5
dta$vj2[32] <- 3.0
dta$vj2[33] <- 2 

p <- ggplot(data=dta, aes(xcord)) +
     geom_bar(aes(y=full_throttle,fill="full_throttle"),
              stat="identity", 
              width=0.15) +
     geom_bar(aes(y=managed,fill="managed"), 
              stat="identity", 
              width=0.15) +
     geom_bar(aes(y=energy_saver,fill="energy_saver"), 
              stat="identity", 
              width=0.15) + 

     geom_text(aes(y=managed,label=mid_percent_saved,vjust=vj1),colour="black",size=6.5) +

     geom_text(aes(y=energy_saver,label=low_percent_saved,vjust=vj2),colour="black",size=6.5) +

     geom_vline(data=d, aes(xintercept=xint), colour="red3", linetype = "longdash") +
     geom_text(data=d2, aes(x=xsys,y=1.05,label=systems), colour="black", size=7.5) +

     scale_fill_manual(name="Boot Mode",values=mapped_colors) +
     xlim(0.0,16) +
     xlab("Benchmark") +
     ylab("Energy") +
     theme_gray(base_size=20) +
     theme(
           axis.text=element_text(color="black"),
           axis.text.x=element_text(angle=60, hjust = 1), 
           legend.position="bottom",
           plot.margin=unit(c(0.2,0.5,0.0,0.0),"cm")) +
     scale_x_continuous(breaks=xvals,labels=xlbls) +
     ggtitle("Battery-Casing Runs")


print(p)

dev.off()
  
#  +
#    geom_bar(data=timetable, aes(x=dateValues, y=inHospital),
#                        stat="identity", fill="grey", colour="blue")
