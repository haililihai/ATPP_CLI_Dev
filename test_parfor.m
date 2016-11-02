N=10;
dice=zeros(N,2,10);
matlabpool 5

parfor i=1:N
    dice(i,2,i)=5*i;
end

matlabpool close