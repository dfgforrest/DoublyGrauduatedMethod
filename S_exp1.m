function S_exp1
Din = 'E:\Data\P18\Sdata1\'; 
Dout = 'E:\Data\P18\Sresult1\'; 
for index = 1:50
load([Din num2str(index)]);

%% OUR
tic;
XOUR = OUR_MRF(A, M*N, L);
TOUR = toc;

%% Result
index
%% save([Dout num2str(index)], 'XMF','XBP','XIPFP','XGC','XGNCCP','XOUR', 'TMF','TBP','TIPFP','TGC','TGNCCP','TOUR','TOURX');
end


clear
clc
close all
end

