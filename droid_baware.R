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

colors <- brewer.pal(6, "Paired")
mapped_colors <- c("full_throttle"=colors[1],
                   "full_throttle silent"=colors[2],
                   "managed"=colors[3],
                   "managed silent"=colors[4],
                   "energy_saver"=colors[5],
                   "energy_saver silent"=colors[6])


benchmarks = c("NewPipe", "duckduckgo", "SoundRecorder", "MaterialLife")

for (b in benchmarks) {

  dat = paste("droid_dat/baware_",b,"_consumed.dat", sep="")
  dta <- read.table(dat, sep="\t", head=T)

  dta$context <- factor(dta$context, levels = dta$context[order(dta$order)])

  out = paste("droid_dat/baware_",b,"_consumed.pdf", sep="")

  pdf(out)

  title = paste(b, "Battery Exception Runs")

  p <- ggplot(data=dta, aes(x=data,y=energy,fill=context)) +
       geom_bar(stat="identity", position=position_dodge()) +
       scale_fill_brewer(palette="Paired",direction=-1) +
       #ylab("Energy") +
       scale_fill_manual(name="Boot Mode",values=mapped_colors) +
       ggtitle(title) +
       theme_gray(base_size=16) +
       theme(
           axis.title.y=element_blank(),
           axis.title.x=element_blank(),
           plot.margin=unit(c(0.3,0.5,0.1,0.0),"cm"),
           legend.position="bottom",
           legend.text = element_text(size=12) 
           ) +
       scale_x_discrete(limits=c("energy_saver","managed","full_throttle"))



  if (b == "NewPipe") {
    p1 <- p
  } else if (b == "duckduckgo") {
    p2 <- p
  } else if (b == "SoundRecorder") {
    p3 <- p
  } else if (b == "MaterialLife") {
    p4 <- p
  } 



  print(p)
  dev.off()
}

leg <- g_legend(p1)

pdf("droid_baware_grid.pdf", width=13,height=5)
grid.arrange(
  arrangeGrob(p1 + theme(legend.position="none"),             
              p2 + theme(legend.position="none"),
              p3 + theme(legend.position="none"),
              p4 + theme(legend.position="none"),
              nrow=2),
             leg, nrow=2, heights=c(3.8,0.5))

dev.off()
