Din = 'E:\Data\P18\Sdata1\'; 
Dout = 'E:\Data\P18\Sresult1\'; 
OBJ = [];
T = [];
for index = 1:50
load([Din num2str(index)]);
load([Dout num2str(index)]);

XMFVecTemp = XMF'; 
XMFVec = XMFVecTemp(:);

XBPVecTemp = XBP'; 
XBPVec = XBPVecTemp(:);

XGCVecTemp = XGC'; 
XGCVec = XGCVecTemp(:);



XIPFPVecTemp = XIPFP'; 
XIPFPVec = XIPFPVecTemp(:);

XGNCCPVecTemp = XGNCCP'; 
XGNCCPVec = XGNCCPVecTemp(:);

XOURVecTemp = XOUR'; 
XOURVec = XOURVecTemp(:);

OBJTemp = [XMFVec'*A*XMFVec XBPVec'*A*XBPVec XGCVec'*A*XGCVec XIPFPVec'*A*XIPFPVec XGNCCPVec'*A*XGNCCPVec XOURVec'*A*XOURVec];
OBJ = [OBJ; OBJTemp];
TTemp = [TMF TBP TGC TIPFP TGNCCP TOUR];
T = [T;TTemp];
index
% [index sum(XGC(:,1)) M*N] 
end

OBJ = reshape(OBJ,5,[]); OBJ = mean(OBJ); OBJ = reshape(OBJ,10,[]);

clear
clc
close all
