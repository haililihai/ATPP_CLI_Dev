function validation(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,N_ITER,POOLSIZE,GROUP_THRES,MPM_THRES,LEFT,RIGHT,split_half,pairwise,leave_one_out,cont,hi_vi,sil,tpd)

if split_half==1

    if LEFT==1
        validation_split_half(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,N_ITER,POOLSIZE,GROUP_THRES,MPM_THRES,1);
    end
    if RIGHT==1
        validation_split_half(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,N_ITER,POOLSIZE,GROUP_THRES,MPM_THRES,0);
    end
end

if leave_one_out==1

    if LEFT==1
        validation_leave_one_out(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES,1);
    end
    if RIGHT==1
        validation_leave_one_out(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES,0);
    end
end

if pairwise==1

    if LEFT==1
        validation_pairwise(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES,1);
    end
    if RIGHT==1
        validation_pairwise(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES,0);
    end
end

if hi_vi==1

    if LEFT==1
        validation_group_hi_vi(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,MPM_THRES,1);
        validation_indi_hi_vi(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES,1);
    end
    if RIGHT==1
        validation_group_hi_vi(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,MPM_THRES,0);
        validation_indi_hi_vi(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES,0);
    end
end

if tpd==1
    validation_group_tpd(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,MPM_THRES);
    validation_indi_tpd(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES);
end

if sil==1

    if LEFT==1
        validation_group_silhouette(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,MPM_THRES,1);
        validation_indi_silhouette(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,MPM_THRES,1);
    end
    if RIGHT==1
        validation_group_silhouette(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,MPM_THRES,0);
        validation_indi_silhouette(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,MPM_THRES,0);
    end
end

if cont==1

    if LEFT==1
        validation_group_cont(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,MPM_THRES,1);
        validation_indi_cont(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES,1);
    end
    if RIGHT==1
        validation_group_cont(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,MPM_THRES,0);
        validation_indi_cont(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOLSIZE,GROUP_THRES,MPM_THRES,0);
    end
end

% close pool
if exist('parpool')
    delete(p);
else
    matlabpool close;
end

