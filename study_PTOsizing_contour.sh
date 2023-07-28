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

cd ~/2021-TimeAvePTOarchetectureStudy
module load matlab
matlab -nodisplay -r \
"parpool('local',$SLURM_JOB_CPUS_PER_NODE); \
iiPTO = $PTOlb:$PTOub; \
study_PTOsizing_contour"

# sbatch --export=PTOlb=1,PTOub=1 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=2,PTOub=2 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=3,PTOub=3 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=4,PTOub=4 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=5,PTOub=5 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=6,PTOub=6 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=7,PTOub=7 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=8,PTOub=8 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=9,PTOub=9 study_PTOsizing_contour.sh
# sbatch --export=PTOlb=10,PTOub=10 study_PTOsizing_contour.sh
# dos2unix  study_PTOsizing_contour.sh

