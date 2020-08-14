library(reshape2)
library(ggplot2)
library(RColorBrewer)
library(grid)
library(gridExtra)

g_legend<-function(a.gplot) {
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

grays <- brewer.pal(8, "Greys")

colors <- brewer.pal(6, "Paired")
mapped_colors <- c("full_throttle"=grays[8],
                   "full_throttle silent"=grays[7],
                   "managed"=grays[6],
                   "managed silent"=grays[5],
                   "energy_saver"=grays[4],
                   "energy_saver silent"=grays[3])

benchmarks = c("sunflow","jspider","pagerank","findbugs","crypto","batik")

for (b in benchmarks) {

  dat = paste("dat/baware_",b,"_consumed.dat", sep="")
  dta <- read.table(dat, sep="\t", quote="\"", head=T)

  dta$context <- factor(dta$context, levels = dta$context[order(dta$order)])

  out = paste("dat/battery_exception_",b,"_consumed.pdf", sep="")

  pdf(out)

  title = b

  p <- ggplot(data=dta, aes(x=data,y=energy,fill=context)) +
       geom_bar(stat="identity", position=position_dodge()) +
       scale_fill_brewer(palette="Paired",direction=-1) +
       xlab("Workload Mode") +
       ylab("Energy (J)") +
       scale_fill_manual(name="Boot Mode",values=mapped_colors) +
       ggtitle(title) +
       theme_gray(base_size=16) +
       theme(
           axis.title=element_text(size=12),
           axis.text=element_text(color="black"),
           plot.margin=unit(c(0.3,0.5,0.1,0.0),"cm"),
           legend.position="bottom",
           legend.text = element_text(size=12) 
           ) +
       scale_x_discrete(limits=c("energy_saver","managed","full_throttle"))

  if (b == "sunflow") {
    p1 <- p
  } else if (b == "jspider") {
    p2 <- p
  } else if (b == "pagerank") {
    p3 <- p
  } else if (b == "findbugs") {
    p4 <- p
  } else if (b == "crypto") {
    p5 <- p
  } else if (b == "batik") {
    p6 <- p
  }


  print(p)
  dev.off()
}

leg <- g_legend(p1)

pdf("battery_exception_grid.pdf", width=13,height=4)
grid.arrange(
  arrangeGrob(p1 + theme(legend.position="none"),             
              p2 + theme(legend.position="none"),
              p3 + theme(legend.position="none"),
              p4 + theme(legend.position="none"),
              p5 + theme(legend.position="none"),
              p6 + theme(legend.position="none"),
              nrow=2),
             leg, nrow=2, heights=c(2.8,0.5))
dev.off()




