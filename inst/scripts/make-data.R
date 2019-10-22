#The raw data are stored in three diferents files. The first is the reference genomo for
#Myxococcus xanthus DK 1622 from Refseq. To obtain this file, I searched in the NCBI 
#(https://www.ncbi.nlm.nih.gov/genome/?term=Myxococcus+xanthus) Myxococcus xanthus in the Genome
#database. Then, I downloaded the representative genome (DK 1622) from Refseq in GFF format (the
#last version from October 2019). This file is called genome_data The second file is a tabular one where each gene of Myxococcus
#xanthus is mapped with its corresponding GO terms. For this, I have searched in the QuickGO databes
#all the GO annotations for Myxococcus xanthus DK 1622. Then, I downloaded the results in a TSV
#file (called GO_data.tsv). Finally, the last tabular file relates all the ID proteins for 
#Myxococcus xanthus from Uniprot with its Refseq ID. The first step is to search in UniprotKB 
#(https://www.uniprot.org/) all the Myxococcus xanthus DK 1622 proteins and download the IDs 
#in a listformat. Then, this IDs are mapped with their corresponding Refseq IDs and are stored
#in a TSV file (up_data).


#I read the reference genome of Refseq and a file obtained from QuickGO with all the
#gene products with their respective GO annotations

library("readr")
library("AnnotationForge")

genome_myxo <- read_tsv("genome_data", col_names = FALSE)
genome_myxo <- genoma_myxo[genoma_myxo$"X1" == "NC_008095.1",]
GO_myxo <- read_tsv("GO_data.tsv")

#I read a file obtained from uniprot which is the result of mapping all the ID of 
#uniprot with the respective RefSeq for proteins

up_refseq <- read_tsv("up_data")


proteins <- up_refseq$To
cds <- genome_myxo[genome_myxo$"X3" == "CDS",]
genes <- genome_myxo[genome_myxo$"X3" == "gene",]
descriptions_cds <- cds$"X9"
descriptions_genes <- genes$"X9"

product <-  c()
id_protein <- c()

#I create a data.frame that associates the ID of each gene in the RefSeq file with its corresponding
#Refseq protein ID

for (d in descriptions_cds){
  d <- strsplit(d, ";")
  product <- c(product,substring(d[[1]][4],6))
  id_protein <- c(id_protein,substring(d[[1]][2],8))

}

proteins <- data.frame(id=id_protein,protein=product)

mxanes <- c()
id_mxan <- c()

#I get the mxan code and add it to the data frame genes (associates every ID of the gene with its MXAN)

for (d in descriptions_genes){
  d <- strsplit(d, ";")
  mxanes <- c(mxanes,substring(d[[1]][2],6))
  id_mxan <- c(id_mxan,substring(d[[1]][1],4))
  
}

genes <- data.frame(id=id_mxan,gene=mxanes)

#I associate each MXAN with its protein in RefSeq

proteins_genes <- merge(proteins,genes)

names(up_refseq)[c(1)] <-c("ID")
names(up_refseq)[c(2)] <-c("protein")
names(GO_myxo)[c(2)] <-c("ID")

#I create a data frame where I associate every ID of uniprot with that of RefSeq and his antoations GO
#The primary key would be the column GO TERM

GO_Ref <- merge(GO_myxo, up_refseq)
GO_Ref <- GO_Ref[,c(1,5,15,8)]

#All the information is saved in a single database

final_database <- merge(GO_Ref,proteins_genes)

#Annotationforge requires that the ID of each gene be a number of 1 until the number of genes
#A frame data is created that associates the different genes ID across the genome. It is called
#universe (following the clusterProfiler nomenclature)

gene_info <- data.frame(ID = proteins_genes$id, SYMBOL = proteins_genes$gene)
gene_info <- gene_info[!duplicated(gene_info), ]
gene_info$GID <- c(1:length(gene_info$ID))

#Annotationforge needs 3 dataframes . The first associates each gene ID (the number) with its
#chromosomal. In this case there is only one chromosome so I had to repeat its name  

n <- length(proteins_genes$id)

chromosome <- data.frame(GID = proteins_genes$id, CHROMOSOME = rep("NC_008095.1", n))
chromosome <- chromosome[!duplicated(chromosome), ]
chromosome$GID <- c(1:length(chromosome$GID))

#The second is a data frame in which each term GO is associated with each gene. Actually,
#the real key is the term GO, but I  it is necessary to put always the ID of the gene
#in the first coumn.

go <- data.frame( ID = final_database$"id", "GO TERM" = final_database$"GO TERM", EVIDENCE = final_database$"GO EVIDENCE CODE")
go <- go[!duplicated(go), ]
go <- merge(go, gene_info)
go <- data.frame(GID = go$GID, GO = go$GO.TERM, EVIDENCE = go$EVIDENCE)

#From the universe, I take only the ID and a column called symbol (MXAN ID)

gene_info <- data.frame(GID = gene_info$GID, SYMBOL = gene_info$SYMBOL)
gene_info <- gene_info[!(is.na(gene_info$SYMBOL)), ]

#The package is created and the .sql file (org.Mxanthus.eg.db/inst/exdata) is stored

makeOrgPackage(gene_info=gene_info, chromosome=chromosome, go=go,
               version="0.1",
               maintainer="Eduardo Illueca Fernandez",
               author="Eduardo Illueca Fernandez",
               outputDir = ".",
               tax_id="246197",
               genus="Myxococcus",
               species="xanthus",
               goTable="go")

