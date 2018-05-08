infile=/raid1/home/micro/klingesj/grace/MB599_siderophores/housekeeping_genes/blastn_result_pseudomonas_rpoD.fasta
outfile=/raid1/home/micro/klingesj/grace/MB599_siderophores/housekeeping_genes/blastn_result_pseudomonas_rpoD_new.fasta
sed -e '/^>/s/$/@/' -e 's/^>/#/' ${infile} | tr -d '\n' | tr "#" "\n" | tr "@" "\t" | sort -u -k1,1 | sed -e 's/^/>/' -e 's/\t/\n/' > ${outfile}
