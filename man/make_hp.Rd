% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/make_hp_v4_Commented.R
\name{make_hp}
\alias{make_hp}
\title{Create historical population}
\usage{
make_hp(hpsize, ng, genome, h2, d2, phen_var, mutr, laf, sel_seq_qtl,
  sel_seq_mrk, saveAt)
}
\arguments{
\item{hpsize}{Size of historical population. Range: \eqn{0<\code{hpsize} \leq 10000}.}

\item{ng}{Number of generations. Range: \eqn{0 \leq \code{ng} \leq 10000}.}

\item{genome}{\code{data.frame} specifying genome parameters with dimension \eqn{n*p}  where n is number of chromosomes and p={6} are columns defined as following:\cr
  "chr" Chromosome id starting from {1} to the number of specified chromosomes (Max={100}). \cr
  "len" Chromosome length in cM in range \eqn{0< \code{len} \leq 10000}.\cr
  "nmrk" Number of markers in each chromosome in range \eqn{1\leq \code{nmrk} \leq 10000}.\cr
  "mpos" Marker position along chromosome with options:
\itemize{
\code{'rnd'} - samples marker positions from uniform distribution.\cr
\code{'even'} - markers are evenly spaced.
}
  "nqtl" Number of qtl in each chromosome in range \eqn{1\leq \code{nqtl} \leq 2000}.\cr
  "qpos" QTL position along chromosome with options: \code{'rnd'} and \code{'even'} similar to "mpos".\cr}

\item{h2}{Narrow sense heritability. Range: \eqn{0< \code{h2} \leq 1}.}

\item{d2}{Ratio of dominance variance to phenotypic variance. Range: \eqn{0\leq \code{d2} \leq 1}.}

\item{phen_var}{Phenotypic variance. Range: \eqn{0< \code{x} \leq 10000}.}

\item{mutr}{Mutation rate. Range: \eqn{0\leq \code{mutr} \leq 0.01}.}

\item{laf}{\emph{Optional} Loci (marker and qtl) allele frequencies in the first historical generation with options:
\itemize{
\item{"rnd"}  {where allele frequencies will be sampled from uniform distribution}.
\item{0 < \code{laf} <1}  {where all loci allele frequencies will be equal to \code{laf}}.
}
Default: "rnd"}

\item{sel_seq_qtl}{\emph{Optional} Select segregating qtl in the last historical generation. QTL with minor allele frequency larger than or equal to \code{sel_seq_qtl}  will be selected.  Range: \eqn{0\leq \code{x} \leq 0.4999}. Default: {0}}

\item{sel_seq_mrk}{\emph{Optional} Select segregating markers in the last historical generation. Markers with minor allele frequency larger than or equal to \code{sel_seq_mrk}  will be selected. Range: \eqn{0\leq \code{x} \leq 0.4999}. Default: {0}}

\item{saveAt}{\emph{Optional} (\code{character}). Name to be used to save output files.}
}
\value{
\code{list} with data of last generation of historical population.\cr
\describe{
\item{$hploci}{Genotype (both marker (SNP) and QTL) of individuals. Coded as {11,12,21,22} where first allele is always paternal allele}. 
\item{$hp_mrk}{Marker genotye of individuals}.  
\item{$hp_qtl}{QTL genotye of individuals}.  
\item{$freqQTL}{QTL allele frequency}.  
\item{$freqMrk}{Marker allele frequency}.
\item{$linkage_map_qtl}{Linkage map for qtl}.  
\item{$linkage_map_mrk}{Linkage map for marker}.
\item{$linkage_map_qtl_mrk}{Integrated linkage map for both marker and qtl}.
\item{$allele_effcts}{QTL allelic effects}.
\item{$hp_data}{Individuals data except their genotypes}.
\item{$trait}{Trait specifications}.
\item{$mut_data}{Mutation data.}
}
}
\description{
Simulates historical generations to establish mutation-drift equilibrium and create linkage disequilibrium.
}
\details{
\bold{Historical population} \cr
In order to create initial linkage disequilibrium (LD)  and to establish mutation-drift equilibrium, a historical population is simulated by considering only two evolutionary forces: mutation and drift. Mutation constantly introduces new variation and genetic drift shifts the variation to fixation. Offspring are produced by random union of gametes, each from the male and female gametic pools. Population size is constant over discrete generations with equal number of males and females. \cr
\cr 
\bold{Genome} \cr
A wide range of parameters can be specified for simulating the genome, such as: number of chromosomes, markers and QTL, location of markers and QTL, mutation rate and initial allelic frequencies. This flexibility permits for a wide variety of genetic architectures to be considered. No allelic effects are simulated for markers, so they are treated as neutral. For QTL, additive allelic effects are sampled from gamma distribution with shape and scale parameters of {0.4} and {1.66}, respectively. This provided an L-shaped distribution of QTL effects. To simulate dominance effects, first dominance degrees \eqn{h_i}  are sampled from normal distribution (\eqn{N(0.5,1)}) then absolute dominance effects are considered as \eqn{d_i=h_i.|a_i|} where \eqn{|a_i|} is the absolute value of the additive effect. Thus, additive and dominance effects are dependent. Next, additive and dominance effects are scaled such that user defined \eqn{h^2} and \eqn{d^2} are met. Trait phenotypes are simulated by adding a standard normal residual effect to the genotypic value of each individual. \cr
\cr 
One important aspect of genome simulation is to model the recombination appropriately to produce realistic level of LD, given the recent and past population structures. \code{make_hp} models crossover process, using a Poisson model. This is done by sampling the number of crossovers from a Poisson distribution and then the crossovers are located randomly across the chromosome. Because the input map is in centiMorgan it is straightforward to take into account the pattern of recombination hotspots and cold spots along the genome by adjusting the distances between markers. To establish mutation-drift equilibrium in the historical generations recurrent mutation model is used. The recurrent mutation model assumes that a mutation alters an allelic state to another and does not create a new allele. In the recurrent model, transition probabilities from one allelic state to another are assumed equal. Different mutation rates for simulated loci can be specified. The number of mutations is sampled from a Poisson distribution and it is assumed that mutation rates are equal for all loci. \cr 
\cr 
In conclusion the main features for \code{make_hp} are as following:
\itemize{
 \item{}{Multiple chromosomes with similar or different genome length in cM, each with different or similar density of markers and QTL maps, can be generated.}
 \item{}{Trait of interest can be controlled by additive or both additive and dominance effects.}
}
}
\examples{
# # # EXAMPLE 1 Simulation of a historical population 
#for an additive trait (h2=0.3) for 10 generations.
# Two  chromosome with different parameters

genome<-data.frame(matrix(NA, nrow=2, ncol=6))
names(genome)<-c("chr","len","nmrk","mpos","nqtl","qpos")
genome$chr<-c(1,2)
genome$len<-c(100,200)	
genome$nmrk<-c(100,100)
genome$mpos<-c("rnd","even")	
genome$nqtl<-c(50,50)
genome$qpos<-c("even","rnd")	
genome

hp<-make_hp(hpsize=100,
 ng=10,h2=0.3,phen_var=1 ,genome=genome,
 mutr=2.5e-4,saveAt="hp1")

head(hp$hp_data)
head(hp$freqQTL)
head(hp$linkage_map_qtl_mrk)


# # # EXAMPLE 2 Simulation of a historical population for a trait with both additive and
# dominance effects (h2=0.3, d2=0.1). 
# All loci will have the same allele frequencies in the first generation. 
# Segregating markers and qtl with MAF>0.1 will be selected in the last historical population.

genome<-data.frame(matrix(NA, nrow=3, ncol=6))
names(genome)<-c("chr","len","nmrk","mpos","nqtl","qpos")
genome$chr<-c(1,2,3)
genome$len<-c(12,8,11)	
genome$nmrk<-c(140,80,73)
genome$mpos<-c("rnd","even","even")	
genome$nqtl<-c(40,65,24)
genome$qpos<-rep("rnd",3)	
genome

hp2<-make_hp(hpsize=100,
  ng=10,h2=0.3,d2=0.1,phen_var=1 ,genome=genome,
  mutr=2.5e-4,sel_seq_qtl=0.1,sel_seq_mrk=0.1,
  laf=0.1,saveAt="hp2")

head(hp2$hp_data)
head(hp2$freqQTL)
head(hp2$linkage_map_qtl_mrk)
}
