#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=64
#SBATCH --mem=128g
#SBATCH -t 48:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=simmo536@umn.edu
#SBATCH -p amdsmall
#SBATCH -o %j.out
#SBATCH -e %j.err

cd ~/2021Q3-PTO-archetecture-sizing
module load matlab
matlab -nodisplay -r "study_PTOsizing_contour"

# sbatch study_PTOsizing_contour.sh
# dos2unix  study_PTOsizing_contour.sh
