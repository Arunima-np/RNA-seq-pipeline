#Downloading the reference genome and annotation files

    wget https://ftp.ensembl.org/pub/release-113/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
    wget https://ftp.ensembl.org/pub/release-113/gtf/homo_sapiens/Homo_sapiens.GRCh38.113.chr.gtf.gz
    gunzip Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz



#Indexing the reference genome
 STAR --runThreadN 2 \
--runMode genomeGenerate \
--genomeDir /mnt/d/genome_index \
--genomeFastaFiles /mnt/d/Homo_sapiens.GRCh38.dna.primary_assembly.fa \
--sjdbGTFfile /mnt/d/Homo_sapiens.GRCh38.113.chr.gtf \
--sjdbOverhang 100



#Mapping with the reference genome identifying transcripts mapped to human genome
STAR --runThreadN 4 \
     --genomeDir /mnt/d/genome_index/ \
     --readFilesIn sample1_trimmed.fastq.gz \
     --readFilesCommand zcat \
     --outFileNamePrefix output/sample1_ \
     --outSAMtype BAM SortedByCoordinate



#Mapping with the reference genome identifying transcripts mapped to human genome
STAR --runThreadN 4 \
     --genomeDir /mnt/d/genome_index/ \
     --readFilesIn sample2_trimmed.fastq.gz \
     --readFilesCommand zcat \
     --outFileNamePrefix output/sample2_ \
     --outSAMtype BAM SortedByCoordinate




#To check star alignment summary
cat sample1_Log.final.out
cat sample2_Log.final.out


#INDEX THE BAM FILE  (BAM files are indexed to enable faster and more efficient analysis of large genomic alignment datasets)
samtools index sample1_Aligned.sortedByCoord.out.bam
 samtools index sample2_Aligned.sortedByCoord.out.bam


