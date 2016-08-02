function validation_split_half(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOL_SIZE,N_ITER,GROUP_THRES,MPM_THRES,LorR)
% split half strategy

    if LorR == 1
        LR='L';
    elseif LorR == 0
        LR='R';
    end

    sub=textread(SUB_LIST,'%s');
    sub_num=length(sub);

    if ~exist('N_ITER','var') | isempty(N_ITER)
        N_ITER=100;
    end
    if ~exist('MPM_THRES','var') | isempty(MPM_THRES)
        MPM_THRES=0.25;
    end

    GROUP_THRES=GROUP_THRES*100;
    MASK_FILE=strcat(PWD,'/group_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_roimask_thr',num2str(GROUP_THRES),'.nii.gz');
    MASK_NII=load_untouch_nii(MASK_FILE);
    MASK=MASK_NII.img; 

    half=floor(sub_num/2);
    
    dice=zeros(N_ITER,MAX_CL_NUM);
    nminfo=zeros(N_ITER,MAX_CL_NUM);
    vi=zeros(N_ITER,MAX_CL_NUM);
    cv=zeros(N_ITER,MAX_CL_NUM);
    
    % before MATLAB R2013b
    if matlabpool('size')==0
        matlabpool(POOL_SIZE);
    end; 

    for kc=2:MAX_CL_NUM
        list1_sub={};
        list2_sub={};
        dice_k=zeros(N,1);
        nmi_k=zeros(N,1);
        vi_k=zeros(N,1);
        cv_k=zeros(N,1);
        
        parfor ti=1:N_ITER
            tmp=randperm(sub_num);
            list1_sub={sub{tmp(1:half)}}';
            list2_sub={sub{tmp(half+1:sub_num)}}';
            mpm_cluster1=cluster_mpm_validation(PWD,PREFIX,PART,list1_sub,METHOD,VOX_SIZE,kc,MPM_THRES,LorR);
            mpm_cluster2=cluster_mpm_validation(PWD,PREFIX,PART,list2_sub,METHOD,VOX_SIZE,kc,MPM_THRES,LorR);
            mpm_cluster1=mpm_cluster1.*MASK;
            mpm_cluster2=mpm_cluster2.*MASK;
            
            %compute dice coefficent
            dice_k(ti)=v_dice(mpm_cluster1,mpm_cluster2,kc);
            
            %compute the normalized mutual information and variation of information
            [nmi_k(ti),vi_k(ti)]=v_nmi(mpm_cluster1,mpm_cluster2);
            
            %compute cramer V
            cv_k(ti)=v_cramerv(mpm_cluster1,mpm_cluster2);
            
            disp(['split_half: ',PART,'_',LR,' kc=',num2str(kc),' ',num2str(ti),'/',num2str(N_ITER)]);
        end

        dice(:,kc)=dice_k;
        nminfo(:,kc)=nmi_k;
        vi(:,kc)=vi_k;
        cv(:,kc)=cv_k;
    end
    
   %matlabpool close

    if ~exist(strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm')) 
        mkdir(strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm'));
    end
    save(strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_split_half.mat'),'dice','nminfo','cv','vi');

    fp=fopen(strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_split_half.txt'),'at');
    if fp
        for kc=2:MAX_CL_NUM
            fprintf(fp,'%s','cluster num = ');
            fprintf(fp,'%d',kc);
            fprintf(fp,'\n');
            fprintf(fp,'%s','  dice: mean = ');
            fprintf(fp,'%f  %f',nanmean(dice(:,kc)));
            fprintf(fp,'%s',' , std = ');
            fprintf(fp,'%f  %f',nanstd(dice(:,kc)));
            fprintf(fp,'\n');
            fprintf(fp,'%s','  normalized mutual info: mean = ');
            fprintf(fp,'%f  %f',nanmean(nminfo(:,kc)));
            fprintf(fp,'%s',' , std = ');
            fprintf(fp,'%f  %f',nanstd(nminfo(:,kc)));
            fprintf(fp,'\n');
            fprintf(fp,'%s','  variation of info: mean = ');
            fprintf(fp,'%f  %f',nanmean(vi(:,kc)));
            fprintf(fp,'%s',' , std = ');
            fprintf(fp,'%f  %f',nanstd(vi(:,kc)));
            fprintf(fp,'\n');
            fprintf(fp,'%s','  cramer V: mean = ');
            fprintf(fp,'%f  %f',nanmean(cv(:,kc)));
            fprintf(fp,'%s',' , std = ');
            fprintf(fp,'%f  %f',nanstd(cv(:,kc)));
            fprintf(fp,'\n');
            fprintf(fp,'\n');
        end
    end
    fclose(fp);


