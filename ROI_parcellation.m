function ROI_parcellation(PWD,PART,SUB_LIST,MAX_CL_NUM,POOLSIZE,METHOD,LEFT,RIGHT)
% ROI parcellation

SUB = textread(SUB_LIST,'%s');

method = METHOD;
N = MAX_CL_NUM-1;

% modify temporary dir
temp_dir=tempname();
mkdir(temp_dir);
if exist('parcluster')
	pc=parcluster('local');
	pc.JobStorageLocation=temp_dir;
else
	sched=findResource('scheduler','type','local');
	sched.DataLocation=temp_dir;
end

% open pool
if exist('parpool')
	p=parpool('local',POOLSIZE);
else
	matlabpool('local',POOLSIZE);
end

parfor i = 1:length(SUB);
	
if LEFT == 1
    outdir_L = strcat(PWD,'/',SUB{i},'/',SUB{i},'_',PART,'_L','_',method);
    if ~exist(outdir_L) mkdir(outdir_L); end
    data = load(strcat(PWD,'/',SUB{i},'/',SUB{i},'_',PART,'_L_matrix/connection_matrix.mat')); 
    coordinates = data.xyz;
    matrix = data.matrix;
    
    panduan = any(matrix');
    coordinates = coordinates(panduan,:);
    matrix = matrix(panduan,:);

	matrix1 = matrix*matrix';
    matrix1 = matrix1-diag(diag(matrix1));

    nii = load_untouch_nii(strcat(PWD,'/',SUB{i},'/',SUB{i},'_',PART,'_L_DTI.nii.gz'));
    image_f=nii.img;

	for k=1:N
		display(strcat(SUB{i},'_',PART,'_L_',num2str(k+1),' processing...'));
        filename=strcat(outdir_L,'/',PART,'_L_',num2str(k+1),'.nii');
		if ~exist(filename)
			index=sc3(k+1,matrix1);   
			image_f(:,:,:)=0;
			for j = 1:length(coordinates)
				image_f(coordinates(j,1)+1,coordinates(j,2)+1,coordinates(j,3)+1)=index(j);
			end
			nii.img=image_f;
			save_untouch_nii(nii,filename);
		end
    end
	disp(strcat(SUB{i},'_',PART,'_L',' Done!'));
end

if RIGHT == 1
	outdir_R = strcat(PWD,'/',SUB{i},'/',SUB{i},'_',PART,'_R','_',method);
    if ~exist(outdir_R)  mkdir(outdir_R); end
    data = load(strcat(PWD,'/',SUB{i},'/',SUB{i},'_',PART,'_R_matrix/connection_matrix.mat')); 
    coordinates = data.xyz;
    matrix = data.matrix;
    
    panduan = any(matrix');
    coordinates = coordinates(panduan,:);
    matrix = matrix(panduan,:);

    matrix1 = matrix*matrix';
    matrix1 = matrix1-diag(diag(matrix1));   

    nii = load_untouch_nii(strcat(PWD,'/',SUB{i},'/',SUB{i},'_',PART,'_R_DTI.nii.gz'));
    image_f=nii.img;
    
	for k=1:N
		display(strcat(SUB{i},'_',PART,'_R_',num2str(k+1),' processing...'));
        filename=strcat(outdir_R,'/',PART,'_R_',num2str(k+1),'.nii');
		if ~exist(filename)
			index=sc3(k+1,matrix1);
			image_f(:,:,:)=0;
			for j = 1:length(coordinates)
				image_f(coordinates(j,1)+1,coordinates(j,2)+1,coordinates(j,3)+1)=index(j);
			end
			nii.img=image_f;
			save_untouch_nii(nii,filename);
		end
    end
end
    disp(strcat(SUB{i},'_',PART,'_R',' Done!'));
end

% close pool
if exist('parpool')
	delete(p);
else
	matlabpool close;
end
