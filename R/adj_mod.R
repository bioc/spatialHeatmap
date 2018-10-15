adj.mod <- function(data, type, minSize) {

  library(WGCNA); library(flashClust)
  if (!dir.exists("local_mode_result")) dir.create("local_mode_result")

  if (type=="signed") sft <- 12; if (type=="unsigned") sft <- 6
  data <- t(data[, grep("__", colnames(data)), drop=F])
  adj=adjacency(data, power=sft, type=type); diag(adj)=0
  tom <- TOMsimilarity(adj, TOMType="signed")
  dissTOM=1-tom; tree.hclust=flashClust(as.dist(dissTOM), method="average")
  mcol <- NULL
  for (ds in 2:3) {

    tree <- cutreeHybrid(dendro=tree.hclust, pamStage=F, minClusterSize=(minSize-3*ds),
    cutHeight=0.99, deepSplit=ds, distM=dissTOM)
    mcol <- cbind(mcol, tree$labels)

  }; colnames(mcol) <- as.character(2:3); rownames(mcol) <- 1:nrow(mcol)
  write.table(adj, paste0("./local_mode_result/", "adj.txt"), sep="\t", row.names=T, col.names=T)
  write.table(mcol, paste0("./local_mode_result/", "mod.txt"), sep="\t", row.names=T, col.names=T)
  adj.mod <- list(adj=adj, mod=mcol); return(adj.mod)

}






