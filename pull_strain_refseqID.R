# MATCH NCBI ID with Pseudomonas strain ID
# required so we can match dendrograms up with cluster maps from Gecko3
# for use in genoPlotR
# This script pulls the Pseudomonas ID and refseq ID from the GFF file for each
library(data.table)
library(tools)
files <- list.files(path="/Users/user/Box Sync/Lab-box/GROUP2_Siderophore/gff3/")

# need empty table to add rows to
pseudo_refseq_dict <- data.table(NA, NA)
for (GFF in files){
  this_pseudomonad <- fread(GFF, fill = TRUE)
  # refseq ID is in row 2, column 9 after the LAST : and there are more : in some
  id_split <- strsplit(as.character(this_pseudomonad[2,9]), ":")
  refseq_ID <- id_split[[1]][length(unlist(id_split))]
  # prepare a mini-table with strain and refseq ID for this one, then add to dictionary
  this_pseudo_and_refseq_ID <- transpose(data.table(c(file_path_sans_ext(filein), refseq_ID)))
  pseudo_refseq_dict <- rbind(pseudo_refseq_dict, this_pseudo_and_refseq_ID)
}

write.table(pseudo_refseq_dict[-1,], file = "pseudo_refseq_dict.txt")
