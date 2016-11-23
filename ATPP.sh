#! /bin/bash

# Automatic Tractography-based Parcellation Pipeline (ATPP)
#
# ---- Multi-ROI oriented brain parcellation
# ---- Automatic parallel computing
# ---- Modular and flexible structure
# ---- Simple and easy-to-use settings
#
# Usage: sh ATPP.sh batch_list.txt
# Hai Li (hai.li@nlpr.ia.ac.cn)


#==============================================================================
# Prerequisites:
# 1) Tools: FSL (with FDT toolbox), SGE and MATLAB (with SPM8)
# 2) Data files:
#    > T1 image for each subject
#    > b0 image for each subject
#    > images preprocessed by FSL(BedpostX) for each subject
# 3) Directory structure:
#	  Working_dir
#     |-- sub1
#     |   |-- T1_sub1.nii
#     |   |-- b0_sub1.nii
#     |-- sub2
#     |-- ...
#     |-- subN
#     |-- ROI
#     |   |-- ROI_L.nii
#     |   `-- ROI_R.nii
#     `-- log 
#==============================================================================

#===============================================================================
# Global configuration file
# Before running the pipeline, you NEED to modify parameters in the file.
#===============================================================================

source ./config.sh

#====================================================================================
# batch processing parameter list
# DO NOT FORGET TO EDIT batch_list.txt itself to include the appropriate parameters
#====================================================================================
# batch_list.txt contains the following 7 parameters in order in each line:
# - Data directory , e.g. /DATA/233/hli/Data/chengdu
# - Prefix of data , e.g. CD
# - List of subjects , e.g. /DATA/233/hli/Data/chengdu/sub_CD.txt
# - working directory , e.g. /DATA/233/hli/Amyg
# - Brain region name , e.g. Amyg
# - Maximum cluster number , e.g. 6
# - Cluster number , e.g. 3
#====================================================================================

test -e $1 && BATCH_LIST=$1 || BATCH_LIST=${PIPELINE}/batch_list.txt


#===============================================================================
#----------------------------START OF SCRIPT------------------------------------
#===============================================================================

# show header info 
cat ${PIPELINE}/header.txt 

while read line
do

# 1. cut specific parameters from batch_list
DATA_DIR=$( echo $line | cut -d ' ' -f1 )
PREFIX=$( echo $line | cut -d ' ' -f2 )
SUB_LIST=$( echo $line | cut -d ' ' -f3 )
WD=$( echo $line | cut -d ' ' -f4 )
PART=$( echo $line | cut -d ' ' -f5 )
MAX_CL_NUM=$( echo $line | cut -d ' ' -f6 )
CL_NUM=$( echo $line | cut -d ' ' -f7 )

# 2. make a proper bash script 

mkdir -p ${WD}/log
LOG_DIR=${WD}/log
LOG=${LOG_DIR}/ATPP_log_$(date +%m-%d_%H-%M).txt

echo "\
#!/bin/bash
#$ -V
#$ -cwd
#$ -N ATPP
#$ -o ${LOG_DIR}
#$ -e ${LOG_DIR}

bash ${PIPELINE}/pipeline.sh ${PIPELINE} ${WD} ${DATA_DIR} ${PREFIX} ${PART} ${SUB_LIST} ${MAX_CL_NUM} ${CL_NUM} >>${LOG} 2>${LOG}"\
>${LOG_DIR}/ATPP_qsub.sh

# 3. do the processing
echo "=============== ATPP is running for ${PART} ================"

qsub ${WD}/log/ATPP_qsub.sh

echo "========================================================"
echo "log: ${LOG_DIR}/ATPP_log_$(date +%m-%d_%H-%M).txt" 

# waiting for a proper host
sleep 3s 

done < ${BATCH_LIST} 

echo "========================================================"
echo "=== Please type 'qstat' to show status of the job(s) ==="
