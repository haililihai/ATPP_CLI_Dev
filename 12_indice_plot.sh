#! /bin/bash

pipeline=$1
shift
WD=$1
shift
PART=$1
shift
SUB_LIST=$1
shift
VOX_SIZE=$1
shift
MAX_CL_NUM=$1
shift
LEFT=$1
shift
RIGHT=$1
shift
split_half=$1
shift
pairwise=$1
shift
leave_one_out=$1
shift
cont=$1
shift
hi_vi=$1
shift
silhouette=$1
shift
tpd=$1


matlab -nodisplay -nosplash -r "addpath('${pipeline}');addpath('${pipeline}/export_fig');indice_plot('${WD}','${PART}','${SUB_LIST}',${VOX_SIZE},${MAX_CL_NUM},${LEFT},${RIGHT},${split_half},${pairwise},${leave_one_out},${cont},${hi_vi},${silhouette},${tpd});exit"
