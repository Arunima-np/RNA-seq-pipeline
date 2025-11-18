#Adaptor trimming using Trimmomatic tool

    java -jar trimmomatic-0.39.jar -version
    java -jar trimmomatic-0.39.jar SE -phred33 sample1.fastq.gz sample1_trimmed.fastq.gz MINLEN:36
    java -jar trimmomatic-0.39.jar SE -phred33 sample2.fastq.gz sample2_trimmed.fastq.gz MINLEN:36


