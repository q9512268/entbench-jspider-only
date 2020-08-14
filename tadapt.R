library(reshape2)
library(ggplot2)
library(RColorBrewer)
library(grid)
library(gridExtra)

colors <- brewer.pal(2, "Dark2")
grays <- brewer.pal(6, "Greys")

mapped_colors <- c("ent"=grays[6],"java"=grays[4])

g_legend<-function(a.gplot) {
  tmp <- ggplot_gtable(ggplot_build(a.gplot))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  legend <- tmp$grobs[[leg]]
  return(legend)
}

benchmarks = c("sunflow","jython","xalan","findbugs","pagerank")

for (b in benchmarks) {

  dat = paste("dat/3dtadapt_",b,"_temps.dat", sep="")
  dta <- read.table(dat, sep="\t", head=T)

  out = paste("dat/temperature_",b,".pdf", sep="")

  pdf(out)

  title = b

  p <- ggplot(data=dta, aes(x=time)) +
       geom_line(aes(y=ent,colour="ent")) +
       geom_line(aes(y=java,color="java")) +
       scale_fill_brewer() +
       #xlab("Time") +
       ylab("Temp (C)") +
       scale_colour_manual(name="Run",values=mapped_colors) +
       ggtitle(title) +
       theme_gray(base_size=16)+
       theme(legend.position="bottom",
             plot.margin=unit(c(0.2,0.5,0.0,0.0),"cm"))
       
  if (b == "sunflow") {
    p1 <- p
  } else if (b == "jython") {
    p2 <- p
  } else if (b == "xalan") {
    p3 <- p
  } else if (b == "findbugs") {
    p4 <- p
  } else if (b == "pagerank") {
    p5 <- p
  }

  print(p)
  dev.off()
}

leg <- g_legend(p1)

pdf("temperature_casing_grid.pdf", width=14,height=4)
grid.arrange(
  arrangeGrob(p1 + theme(legend.position="none"),             
              p2 + theme(legend.position="none"),
              p3 + theme(legend.position="none"),
              p4 + theme(legend.position="none"),
              p5 + theme(legend.position="none"),
              nrow=2),
             leg, nrow=2, heights=c(2.8,0.5))
dev.off()




