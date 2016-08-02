function plot_hi(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,LorR)

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

	m_indi_hi=nanmean(indi_hi);
	std_indi_hi=nanstd(indi_hi);

	hold on;
	plot(x,group_hi(3:end),'-r','Marker','*');
	errorbar(x,m_indi_hi(3:end),std_indi_hi(3:end),'-b','Marker','*');
	hold off;

	set(gca,'XTick',x);
	legend('group hi','indi hi','Location','SouthWest');
	xlabel('Number of clusters','FontSize',14);ylabel('Indice','FontSize',14);
	title(strcat(PART,'.',LR,' hierarchy index'),'FontSize',14);

	output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_hi.jpg');
	hgexport(gcf,output,hgexport('factorystyle'),'Format','jpeg');

	close;


