function plot_split_half(PWD,PART,SUB_LIST,VOX_SIZE,MAX_CL_NUM,LorR)

	if LorR == 1
        LR='L';
    elseif LorR == 0
        LR='R';
    end

    sub=textread(SUB_LIST,'%s');
    sub_num=length(sub);

	file=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_index_split_half.mat');
	load(file);
	x=2:MAX_CL_NUM;

    m_dice=nanmean(dice);
    std_dice=nanstd(dice);
    m_nmi=nanmean(nminfo);
    std_nmi=nanstd(nminfo);
    m_cv=nanmean(cv);
    std_cv=nanstd(cv);

	hold on;
	errorbar(x,m_dice(2:end),std_dice(2:end),'-r','Marker','*');
	errorbar(x,m_nmi(2:end),std_nmi(2:end),'-b','Marker','*');
	errorbar(x,m_cv(2:end),std_cv(2:end),'-g','Marker','*');
	hold off;

	set(gca,'XTick',x);
	legend('Dice','NMI','CV','Location','SouthWest');
	xlabel('Number of clusters','FontSize',14);ylabel('Indice','FontSize',14);
	title(strcat(PART,'.',LR,' split half'),'FontSize',14);

	output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_split_half.jpg');
	export_fig('test.png','-painters','-nocrop');

	close;

	% VI with non-significant label
	m_vi=nanmean(vi);
	std_vi=nanstd(vi);
	errorbar(x,m_vi(2:end),std_vi(2:end),'-r','Marker','*');
	for k=2:MAX_CL_NUM-1
		h=ttest2(vi(:,k),vi(:,k+1),0.05,'left');
		if h==0
			sigstar({[k,k+1]},[nan]);
		end
	end

	set(gca,'XTick',x);
	xlabel('Number of clusters','FontSize',14);ylabel('VI','FontSize',14);
	title(strcat(PART,'.',LR,' split half VI'),'FontSize',14);

	output=strcat(PWD,'/validation_',num2str(sub_num),'_',num2str(VOX_SIZE),'mm/',PART,'_',LR,'_split_half_vi.jpg');
	hgexport(gcf,output,hgexport('factorystyle'),'Format','jpeg');

	close;


