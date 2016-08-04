function plot_sil(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,LorR)

    if LorR == 1
        LR='L';
    elseif LorR == 0
        LR='R';
    end

    sub=textread(SUB_LIST,'%s');
    sub_num=length(sub);

    file1=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_group_silhouette.mat');
    load(file1);
    file2=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_indi_silhouette.mat');
    load(file2);
    x=2:MAX_CL_NUM;

    m_indi_sil=nanmean(indi_sil,1);
    std_indi_sil=nanstd(indi_sil,0,1);

    hold on;
    plot(x,group_sil(2:end),'-r','Marker','*');
    errorbar(x,m_indi_sil(2:end),std_indi_sil(2:end),'-b','Marker','*');
    hold off;

    set(gca,'XTick',x);
    legend('group silhouette','indi silhoutte','Location','SouthWest');
    xlabel('Number of clusters','FontSize',14);ylabel('Indice','FontSize',14);
    title(strcat(PART,'.',LR,' silhouette index'),'FontSize',14);

    output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_silhouette.jpg');
    hgexport(gcf,output,hgexport('factorystyle'),'Format','jpeg');

    close;


