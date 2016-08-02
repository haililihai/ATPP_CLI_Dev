function plot_vi(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,LorR)

    if LorR == 1
        LR='L';
    elseif LorR == 0
        LR='R';
    end

    sub=textread(SUB_LIST,'%s');
    sub_num=length(sub);

    file1=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_group_hi.mat');
    load(file1);
    file2=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_indi_hi.mat');
    load(file2);
    x=3:MAX_CL_NUM;

    m_indi_vi=nanmean(indi_vi);
    std_indi_vi=nanstd(indi_vi);

    hold on;
    plot(x,group_vi(3:end),'-r','Marker','*');
    errorbar(x,m_indi_vi(3:end),std_indi_vi(3:end),'-b','Marker','*');
    for k=3:MAX_CL_NUM-1
        h1=ttest2(indi_vi(:,k),indi_vi(:,k+1),0.05,'left');
        if h1==1
            sigstar({[k,k+1]},[0.01]);
        end
        h2=ttest2(indi_vi(:,k),indi_vi(:,k+1),0.05,'right');
        if h2==1
            sigstar({[k,k+1]},[0.05]);
        end
    end
    hold off;

    set(gca,'XTick',x);
    legend('group vi','indi vi','Location','SouthWest');
    xlabel('Number of clusters','FontSize',14);ylabel('Indice','FontSize',14);
    title(strcat(PART,'.',LR,' variation of information'),'FontSize',14);

    output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_vi.jpg');
    hgexport(gcf,output,hgexport('factorystyle'),'Format','jpeg');

    close;


