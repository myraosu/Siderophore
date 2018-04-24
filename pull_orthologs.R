library(data.table)
library(stringr)
library(dplyr)

# Given annotated genome and gene ID, locate occurences and build data.table with each genome, 
# gene, # occurences, and positions
pull_orthologs <- function(gene, genome, gtf_table){
  extracted_rows_ortholog <- gtf_table %>% filter(str_detect(gtf_table$V9, gene))
  N_orthologs <- nrow(extracted_rows_ortholog)
  each_start_end_position <- data.table()
  for (i in 1:N_orthologs){
    each_start_end_position <- paste0(each_start_end_position, 
                                      (paste0(extracted_rows_ortholog$V4[i], "-", 
                                              extracted_rows_ortholog$V5[i])), " ")
  }
  if (N_orthologs > 0) {
    each_start_end_position <- paste(unlist(each_start_end_position))
    summary_this_pseudomonad <- cbind(tools::file_path_sans_ext(basename(genome)),
                                      as.character(gene), N_orthologs, each_start_end_position)
    # just for viewing while running
    cat(summary_this_pseudomonad, "\n")
    return(summary_this_pseudomonad)
  }
}

loop_genes_genomes <- function(gene_table, genomes, output_file){
  master_output <- data.frame()
  gene_table <- (data.frame(read.table(gene_table), stringsAsFactors = F))[,"V1"]
  genomes <- list.files(path=genomes, pattern="*.gtf", full.names=T, recursive=FALSE)
  for (each_genome in genomes){
    gtf_table <- read.table(each_genome, sep="\t")
    for (each_gene in gene_table){
      this_output <- pull_orthologs(each_gene, each_genome, gtf_table)
      master_output <- rbind(master_output, this_output)
    }
  }
  colnames(master_output) <- c("genome", "gene", "N_orthologs", "positions")
  WriteXLS(master_output, output_file)
}


# 3 arguments are paths to gene list* (1 gene per row text),  
#  folder of gtf's (available from http://pseudomonas.com/downloads/pseudomonas/pgd_r_17_2/Pseudomonas/complete/gtf-complete.tar.gz) 
# and path, filename of output file to create (.xlsx)
# *gene list needs py of each gene with first letter in uppercase and lowercase
# due to inconsistency in .gtf's
loop_genes_genomes("/Users/user/Box Sync/Lab-box/GROUP2_Siderophore/gene_list.txt", 
                   "/Users/user/Box Sync/Lab-box/GROUP2_Siderophore/gtf/",
                   "pull_orthologs_test_master_4.14.18.xlsx")