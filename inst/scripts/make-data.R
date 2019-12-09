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

up_refseq_env <- new.env()
i <- 1

for(u in up_refseq$To){
  
  up_refseq_env[[u]] <- up_refseq$From[i]
  i <- i+1
  
}

proteins <- up_refseq$To
cds <- genome_myxo[genome_myxo$"X3" == "CDS",]
gene <- genome_myxo[genome_myxo$"X3" == "gene",]
descriptions_cds <- cds$"X9"
descriptions_genes <- gene$"X9"

product <-  c()
id_protein <- c()
name <- c()

#I create a data.frame that associates the ID of each gene in the RefSeq file with its corresponding
#Refseq protein ID

for (d in descriptions_cds){
  d <- strsplit(d, ";")
  product <- c(product,substring(d[[1]][4],6))
  id_protein <- c(id_protein,substring(d[[1]][2],8))
  
  if(grepl("product",substring(d[[1]][7],1))){
    
    name <- c(name,substring(d[[1]][7],9) )

  } else{
    
    name <- c(name,substring(d[[1]][8],9) )
    
  }
  
}

proteins <- data.frame(id=id_protein,protein=product,gene_name=as.character(name))

mxanes <- c()
id_mxan <- c()
old_mxan <- c()
locus_tag <- c()


#I get the mxan code and add it to the data frame genes (associates every ID of the gene with its MXAN)

for (d in descriptions_genes){
  d <- strsplit(d, ";")
  mxanes <- c(mxanes,substring(d[[1]][2],6))
  id_mxan <- c(id_mxan,substring(d[[1]][1],4))
  
  
  if(grepl("MXAN",substring(d[[1]][5],11))){
    
    locus_tag <- c(locus_tag,substring(d[[1]][5],11))
    
  } else {
    
    locus_tag <- c(locus_tag,substring(d[[1]][6],11))
    
  }
  if(grepl("old",substring(d[[1]][6],1))){
    
    old <- substring(d[[1]][6],15)
    if(is.na(old)){
      
      old_mxan <- c(old_mxan,"No old locus tag")
      
    } else{
      
      old_mxan <- c(old_mxan,old)
      
    }
    
    
  } else{
    
    old <- substring(d[[1]][7],15)
    
    if(is.na(old)){
      
      old_mxan <- c(old_mxan,"No old locus tag")
      
    } else{
      
      old_mxan <- c(old_mxan,old)
      
    }
    
  }
}

genes <- data.frame(id=id_mxan,gene=mxanes,locus_tag=locus_tag, old=old_mxan)

genes$start <- gene$X4

genes$end <- gene$X5

#I associate each MXAN with its protein in RefSeq

proteins_genes <- merge(proteins,genes)

up_id <- c()
i <- 1

for (w in proteins_genes$protein ){
  
  print (up_refseq_env[[w]])
  if(is.null(up_refseq_env[[w]])){
    
    up_id <- c(up_id, "No Uniprot ID")
    
  } else {
    
    up_id <- c(up_id, up_refseq_env[[w]])
    
  }
  
    i <- i+1
  
}

proteins_genes$up_id <- up_id

names(up_refseq)[c(1)] <-c("ID")
names(up_refseq)[c(2)] <-c("protein")
names(GO_myxo)[c(2)] <-c("ID")

#I create a data frame where I associate every ID of uniprot with that of RefSeq and his antoations GO
#The primary key would be the column GO TERM

GO_Ref <- merge(GO_myxo, up_refseq)
GO_Ref <- GO_Ref[,c(1,5,6,15,8)]

#All the information is saved in a single database

final_database <- merge(GO_Ref,proteins_genes)

#Annotationforge requires that the ID of each gene be a number of 1 until the number of genes
#A frame data is created that associates the different genes ID across the genome. It is called
#universe (following the clusterProfiler nomenclature)

gene_info <- data.frame(ID = proteins_genes$id, SYMBOL = proteins_genes$gene, LOCUS_TAG = proteins_genes$locus_tag, NAME = proteins_genes$gene_name, REFSEQ_PROTEIN = proteins_genes$protein, UNIPROT = proteins_genes$up_id, OLD_MXAN = proteins_genes$old, START = proteins_genes$start, END = proteins_genes$end, PARENT = proteins_genes$id)
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

go <- data.frame( ID = final_database$"id", "GO TERM" = final_database$"GO TERM", "GO NAME" = final_database$"GO NAME", EVIDENCE = final_database$"GO EVIDENCE CODE")
go <- go[!duplicated(go), ]
go <- merge(go, gene_info)
go <- data.frame(GID = go$GID, GO = go$GO.TERM, EVIDENCE = go$EVIDENCE)



#From the universe, I take only the ID and a column called symbol (MXAN ID)

gene_info <- data.frame(GID = gene_info$GID, SYMBOL = gene_info$SYMBOL, LOCUS_TAG = gene_info$LOCUS_TAG, NAME = as.character(gene_info$NAME), REFSEQ_PROTEIN = gene_info$REFSEQ_PROTEIN, UNIPROT = gene_info$UNIPROT, OLD_MXAN = gene_info$OLD_MXAN, START = gene_info$START, END = gene_info$END, PARENT = gene_info$ID, stringsAsFactors = FALSE)
gene_info <- gene_info[!(is.na(gene_info$SYMBOL)), ]

#Finally, some NAMEs values are corrected.

for (g in gene_info[grepl("=",gene_info$NAME),]$GID){
  
  gene_info[gene_info$GID == g,]$NAME <- as.character(gene_info[gene_info$GID == g,]$SYMBOL)
  
} 





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

