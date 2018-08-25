this.dir <- dirname(parent.frame(2)$ofile)

setwd(this.dir)

pipeline <- c("utils.R","00-load.R","01-prepare.R","02-clean.R","03-eda.R")
              # "genera_data_frec_cand.R","genera_data_wc.R","genera_data_frec.R",
              # "genera_data_frecgea_agrup.R")

sapply(pipeline, source)