function plot_pairwise(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,LorR)

    if LorR == 1
        LR='L';
    elseif LorR == 0
        LR='R';
    end

    sub=textread(SUB_LIST,'%s');
    sub_num=length(sub);

    file=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_pairwise.mat');
    load(file);
    x=2:MAX_CL_NUM;

    mat_cv=[];
    mat_dice=[];
    mat_nmi=[];
    mat_vi=[];
    mask=triu(ones(sub_num),1); % upper triangular part
    for kc=2:MAX_CL_NUM
        col_cv=cv(:,:,kc);
        mat_cv(:,kc)=col_cv(find(mask));
        col_dice=dice(:,:,kc);
        mat_dice(:,kc)=col_dice(find(mask));
        
        col_nmi=nminfo(:,:,kc);     
        mat_nmi(:,kc)=col_nmi(find(mask));
        col_vi=vi(:,:,kc); 
        mat_vi(:,kc)=col_vi(find(mask));
    end

    hold on;
    errorbar(x,mean(mat_dice(:,2:kc)),std(mat_dice(:,2:kc)),'-r','Marker','*');
    errorbar(x,mean(mat_nmi(:,2:kc)),std(mat_nmi(:,2:kc)),'-b','Marker','*');
    errorbar(x,mean(mat_cv(:,2:kc)),std(mat_cv(:,2:kc)),'-g','Marker','*');
    hold off;

    set(gca,'XTick',x);
    legend('Dice','NMI','CV','Location','SouthWest');
    xlabel('Number of clusters','FontSize',14);ylabel('Indice','FontSize',14);
    title(strcat(PART,'.',LR,' pairwise'),'FontSize',14);

    output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_pairwise.jpg');
    hgexport(gcf,output,hgexport('factorystyle'),'Format','jpeg');

    close;

    % VI with non-significant label
    errorbar(x,mean(mat_vi(:,2:kc)),std(mat_vi(:,2:kc)),'-r','Marker','.');
    for k=2:MAX_CL_NUM-1
        h=ttest2(vi(:,k),vi(:,k+1),0.05,'left');
        if h==0
            sigstar({[k,k+1]},[nan]);
        end
    end

    set(gca,'XTick',x);
    xlabel('Number of clusters','FontSize',14);ylabel('VI','FontSize',14);
    title(strcat(PART,'.',LR,' pairwise VI'),'FontSize',14);

    output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_pairwise_vi.jpg');
    hgexport(gcf,output,hgexport('factorystyle'),'Format','jpeg');

    close;


