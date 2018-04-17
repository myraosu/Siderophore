source ~/.bashrc
basefolder=/raid1/home/micro/klingesj/grace/MB599_siderophores/housekeeping_genes/

for file in ${basefolder}/16s_split/*.fsa; do
	filename=$(basename $file)
	line="$(head -1 $file)"
	seqid=${line%|start*}
	{ sed '1d' ${basefolder}16s_split/$filename; sed '1d' ${basefolder}gyrB_split/$filename; sed '1d' ${basefolder}rpoD_split/$filename; sed '1d' ${basefolder}rpoB_split/$filename; } > ${basefolder}concatenated_genes/$filename
	tr -d '\n' < ${basefolder}concatenated_genes/$filename > temp.fsa && mv temp.fsa ${basefolder}concatenated_genes/$filename
	sed -i "1i $seqid" ${basefolder}concatenated_genes/$filename
done
