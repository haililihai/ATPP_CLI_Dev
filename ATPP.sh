#! /bin/bash

# Automatic Tractography-based Parcellation Pipeline (ATPP)
#
# ---- Multi-ROI oriented brain parcellation
# ---- Automatic parallel computing
# ---- Modular and flexible structure
# ---- Simple and easy-to-use settings
#
# Usage: bash ATPP.sh batch_list.txt
# Hai Li (hai.li@nlpr.ia.ac.cn)
# ATPP V2.0


#==============================================================================
# Prerequisites:
# 1) Tools: FSL (with FDT toolbox), SGE and MATLAB (with SPM8)
# 2) Data files:
#    > T1 image for each subject
#    > b0 image for each subject
#    > images preprocessed by FSL(BedpostX) for each subject
#
# Directory structure:
#	  Working_dir
#     |-- sub1
#     |   |-- T1_sub1.nii
#     |   `-- b0_sub1.nii
#     |-- ...
#     |-- subN
#     |   |-- T1_subN.nii
#     |   `-- b0_subN.nii
#     |-- ROI
#     |   |-- ROI_L.nii
#     |   `-- ROI_R.nii
#     `-- log 
#==============================================================================

# usage function
show_usage() {
    cat << EOF
Automatic Tractography-based Parcellation Pipeline (ATPP)
    
    Usage: bash ATPP.sh batch_list.txt

Please refer the instructions in ATPP.sh for detailed info
EOF
    exit 1
}

#==============================================================================
# batch processing parameter list
# DO NOT FORGET TO EDIT batch_list.txt to include the appropriate parameters
#==============================================================================
# batch_list.txt contains the following 7 parameters in order in each line:
# - data directory, e.g. /DATA/233/hli/Data/chengdu
# - list of subjects, e.g. /DATA/233/hli/Data/chengdu/sub_CD.txt
# - working directory, e.g. /DATA/233/hli/Amyg
# - brain region name, e.g. Amyg
# - maximum cluster number , e.g. 6
#==============================================================================

if [ $# -ne 1 ]; then
    show_usage
elif [ -f $1 ]; then 
    BATCH_LIST=$1
else
    echo "ERROR: $1 not found!"
    show_usage
    exit 1
fi


#==============================================================================
# Global configuration file
# Before running the pipeline, you NEED to modify parameters in the file.
#==============================================================================

if [ -f "./config.sh" ]; then
	source ./config.sh
else
	echo "ERROR: Cannot find the configuration file!"
	exit 1
fi

#==============================================================================
#----------------------------START OF SCRIPT-----------------------------------
#------------NO EDITING BELOW UNLESS YOU KNOW WHAT YOU ARE DOING---------------
#==============================================================================

# show header info 
if [ -f "${PIPELINE}/header.txt" ]; then
	cat ${PIPELINE}/header.txt 
fi

while read line
do

# 1. cut specific parameters from batch_list
DATA_DIR=$( echo $line | cut -d ' ' -f1 )
SUB_LIST=$( echo $line | cut -d ' ' -f2 )
WD=$( echo $line | cut -d ' ' -f3 )
PART=$( echo $line | cut -d ' ' -f4 )
MAX_CL_NUM=$( echo $line | cut -d ' ' -f5 )

# 2. make a proper bash script 
mkdir -p ${WD}/log
LOG_DIR=${WD}/log
LOG=${LOG_DIR}/ATPP_log_$(date +%m-%d_%H-%M-%S).txt

echo "\
#!/bin/bash
#$ -V
#$ -cwd
#$ -N ATPP_${PART}
#$ -o ${LOG_DIR}
#$ -e ${LOG_DIR}

bash ${PIPELINE}/pipeline.sh ${PIPELINE} ${WD} ${DATA_DIR} ${PART} ${SUB_LIST} ${MAX_CL_NUM} >${LOG} 2>&1"\
>${LOG_DIR}/ATPP_${PART}_qsub.sh

# 3. submit the task
echo "================ ATPP is running for ${PART} ================="

${COMMAND_QSUB} ${WD}/log/ATPP_${PART}_qsub.sh

echo "=========================================================="
echo "log: ${LOG_DIR}/ATPP_log_$(date +%m-%d_%H-%M-%S).txt" 

# waiting for a proper host
sleep 3s 

done < ${BATCH_LIST} 

echo "=========================================================="
echo "==== Please type 'qstat' to show the status of job(s) ===="

#================================ END =======================================
