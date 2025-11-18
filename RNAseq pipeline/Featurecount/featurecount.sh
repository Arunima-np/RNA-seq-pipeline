

#Count reads per gene
featureCounts -T 4 -a Homo_sapiens.GRCh38.113.chr.gtf -o counts.txt sample1_Aligned.sortedByCoord.out.bam sample2_Aligned.sortedByCoord.out.bam
