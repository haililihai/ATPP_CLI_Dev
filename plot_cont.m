function plot_cont(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,LorR)

    if LorR == 1
        LR='L';
    elseif LorR == 0
        LR='R';
    end

    sub=textread(SUB_LIST,'%s');
    sub_num=length(sub);

    file1=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_group_continuity.mat');
    load(file1);
    file2=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_indi_continuity.mat');
    load(file2);
    x=2:MAX_CL_NUM;

    m_indi_cont=nanmean(indi_cont');
    std_indi_cont=nanstd(indi_cont');

    hold on;
    plot(x,group_cont(2:end),'-r','Marker','*');
    errorbar(x,m_indi_cont(2:end),std_indi_cont(2:end),'-b','Marker','*');
    hold off;

    set(gca,'XTick',x);
    legend('group cont','indi cont','Location','SouthWest');
    xlabel('Number of clusters','FontSize',14);ylabel('Indice','FontSize',14);
    title(strcat(PART,'.',LR,' continuity'),'FontSize',14);

    output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_continuity.jpg');
    hgexport(gcf,output,hgexport('factorystyle'),'Format','jpeg');

    close;


