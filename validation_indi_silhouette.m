function validation_indi_silhouette(PWD,PREFIX,PART,SUB_LIST,METHOD,VOX_SIZE,MAX_CL_NUM,POOL_SIZE,MPM_THRES,LorR)
    if LorR == 1
        LR='L';
    elseif LorR == 0
        LR='R';
    end

    sub=textread(SUB_LIST,'%s');
    sub_num=length(sub);

    if ~exist('MPM_THRES','var') | isempty(MPM_THRES)
        MPM_THRES=0.25;
    end

    % before MATLAB R2013b
    if matlabpool('size')==0
        matlabpool(POOL_SIZE);
    end; 

    % individual-level silhouette
    indi_sil=zeros(MAX_CL_NUM,sub_num);
    parfor ti=1:sub_num
        matrix_file=strcat(PWD,'/',sub{ti},'/',PREFIX,'_',sub{ti},'_',PART,'_',LR,'_matrix/connection_matrix.mat');
        con_matrix=load(matrix_file);
        sum_matrix=sum(con_matrix.matrix,2);
        matrix=con_matrix.matrix./sum_matrix(:,ones(1,size(con_matrix.matrix,2)));
        distance=pdist(con_matrix.matrix,'cosine');

        for kc=2:MAX_CL_NUM
            nii_file=strcat(PWD,'/',sub{ti},'/',PREFIX,'_',sub{ti},'_',PART,'_',LR,'_',METHOD,'/',PART,'_',LR,'_',num2str(kc),'.nii');
            nii=load_untouch_nii(nii_file);
            tempimg=nii.img;
            [xx,yy,zz]=size(tempimg);    
            label=zeros(length(con_matrix.xyz),1);
            for n=1:length(con_matrix.xyz)
                label(n,1)=tempimg(con_matrix.xyz(n,1)+1,con_matrix.xyz(n,2)+1,con_matrix.xyz(n,3)+1);
            end
            s=silhouette([],label,distance);
            indi_sil(kc,ti)=nanmean(s);
            disp(['indi_silhouette: ',PART,'_',LR,' kc=',num2str(kc),' ',num2str(ti)]);
        end
    end


    if ~exist(strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm')) mkdir(strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm'));end
    save(strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_indi_silhouette.mat'),'indi_sil');

    fp=fopen(strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_indi_silhouette.txt'),'at');
    if fp for kc=2:MAX_CL_NUM
            fprintf(fp,'cluster_num: %d\navg_indi_silhouette: %f\nstd_indi_silhouette: %f\nmedian_indi_silhouette: %f\n\n',kc,nanmean(indi_sil(kc,:)),nanstd(indi_sil(kc,:)),nanmedian(indi_sil(kc,:)));
        end
    end
    fclose(fp);

