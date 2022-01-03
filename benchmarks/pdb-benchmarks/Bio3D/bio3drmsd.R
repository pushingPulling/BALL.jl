library(bio3d)
library(microbenchmark)

pdb_filepath <- "1ake.pdb"
struc <- read.pdb(pdb_filepath, multi=TRUE)
struc2 <- read.pdb(pdb_filepath, multi=TRUE)

rm <-function() {
return(rmsd(a=struc, b=struc2, fit=FALSE))
}
cat(rm())
bench <- microbenchmark(rm,times=100, unit=c("us"))
cat(bench$time / 10^9,"\n", sep="")
