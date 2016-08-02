function plot_tpd(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM)

    sub=textread(SUB_LIST,'%s');
    sub_num=length(sub);

    file1=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_index_group_tpd.mat');
    load(file1);
    file2=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_index_indi_tpd.mat');
    load(file2);
    x=2:MAX_CL_NUM;

    m_indi_tpd=nanmean(indi_tpd);
    std_indi_tpd=nanstd(indi_tpd);

    hold on;
    plot(x,group_tpd(2:end),'-r','Marker','*');
    errorbar(x,m_indi_tpd(2:end),std_indi_tpd(2:end),'-b','Marker','*');
    hold off;

    set(gca,'XTick',x);
    legend('group TpD','indi TpD','Location','SouthWest');
    xlabel('Number of clusters','FontSize',14);ylabel('Indice','FontSize',14);
    title(strcat(PART,'.TpD index'),'FontSize',14);

    output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_tpd.jpg');
    hgexport(gcf,output,hgexport('factorystyle'),'Format','jpeg');

    close;


