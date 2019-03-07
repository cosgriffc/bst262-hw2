#!/bin/bash
#SBATCH -J hw2
#SBATCH -n 1 
#SBATCH --ntasks-per-node=1 
#SBATCH -o odyssey_home1.out 
#SBATCH -e odyssey_home1.err
#SBATCH -t 100
#SBATCH -p serial_requeue
#SBATCH --mem=4096 
#SBATCH --mail-type=END     
#SBATCH --mail-user=ccosgriff@hsph.harvard.edu

source new-modules.sh
module load geos/3.4.3-fasrc01
module load gdal/2.2.0-fasrc01
module load R/3.4.2-fasrc01
export R_LIBS_USER=$HOME/apps/R:$R_LIBS_USER

Rscript pm25-stateMeans.R $1
