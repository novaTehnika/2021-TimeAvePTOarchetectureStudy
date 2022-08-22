#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --mem=128g
#SBATCH -t 72:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=simmo536@umn.edu
#SBATCH -p amdsmall
#SBATCH -o %A.out
#SBATCH -e %A.err

cd ~/2021Q3-PTO-archetecture-sizing
module load matlab
matlab -nodisplay -r \
"parpool('local',$SLURM_JOB_CPUS_PER_NODE); \
iiPTO = $PTOlb:$PTOub; \
study_PTOsizing_contour"

# sbatch --export=PTOlb=1,PTOub=3 study_PTOsizing_contour.sh
# dos2unix  study_PTOsizing_contour.sh

