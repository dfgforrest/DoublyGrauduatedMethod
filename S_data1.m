Din = 'E:\Data\P18\Sdata1\'; 
index = 0;
for M = 10:10:100
    for rep = 1 : 5
       %% Initialization & Grid construction
        N = M; L = 2;
        I = rand(M,N);
       %% Neighborhood system
        LargeNum = 10^5;

       %% Construct neighborhood % 4 neighbors
        % overlapped area
        OA = ones(M,N);
        [OIrow OIcol] = find(OA); OI = [OIrow';OIcol'];
        NB = [OI(1,:);OI(2,:)-1 ; OI(1,:);OI(2,:)+1 ; OI(1,:)-1;OI(2,:) ; OI(1,:)+1;OI(2,:)];
        NB = reshape(NB, 2, []); 
        NB = [kron(OI, ones(1,4)); NB]';
        NB(NB(:,3)<1 | NB(:,3)>M | NB(:,4)<1 | NB(:,4)>N, :) = [];
        NBSparse = sparse(NB(:,1)+(NB(:,2)-1)*M, NB(:,3)+(NB(:,4)-1)*M, ones(size(NB, 1), 1), M*N, M*N);
        % Pause = 1
       %% Objective function
        % Mean-Field, BP objective function
        NB_MF = NB;
        NB_MF((NB_MF(:,1)+(NB_MF(:,2)-1)*M)>(NB_MF(:,3)+(NB_MF(:,4)-1)*M),:)=[];
        NBSparse_MF = sparse(NB_MF(:,1)+(NB_MF(:,2)-1)*M, NB_MF(:,3)+(NB_MF(:,4)-1)*M, 1:size(NB_MF,1), M*N, M*N);
        NBSparse_MF = NBSparse_MF + NBSparse_MF'; % A
        % [s,t,e] = find(triu(NBSparse));
        % m = numel(e);
        % e(:) = 1:m;
        % A = sparse([s;t],[t;s],[e;e]);
        ImgVec = I(:)';
        LVec = (0:1/(L-1):1)';
        nodePot = exp(-(ones(size(LVec))*ImgVec-LVec*ones(size(ImgVec))).^2/.15);
        edgePot = repmat(eye(L),[1, 1, size(NB_MF,1)]);

        % Graph cuts energy %minimization
        % NB_GC = sparse(Prow, Pcol, BV, M*N, M*N);
        CostMatrix = - exp(-(ones(size(LVec))*ImgVec-LVec*ones(size(ImgVec))).^2/.15);
        LabelMatrix = - eye(L); % Ising Model
        NB_GC = NBSparse;
        % Continuous method objective function
        [Prow Pcol] = find(NBSparse);
        V = eye(L);
        [Vrow Vcol Value] = find(V);

        % Non-diagonal entries
        PVrow_PVcol = kron([Prow-1 Pcol-1]*L, ones(size(Vrow,1),1)) + kron(ones(size(Prow,1),1), [Vrow Vcol]);
        PVrow = PVrow_PVcol(:,1); PVcol = PVrow_PVcol(:,2);
        V = kron(ones(size(Prow,1),1),Value);

        % Diagonal entries
        U = exp(-(ones(size(LVec))*ImgVec-LVec*ones(size(ImgVec))).^2/.15); 
        U = U(:);
        Urow = (1:M*N*L)'; Ucol = (1:M*N*L)';

        A = sparse([PVrow; Urow], [PVcol; Ucol], [V; U], M*N*L, M*N*L);
        index = index + 1
        save([Din num2str(index)], 'index', 'M', 'N', 'L', 'NBSparse_MF', 'nodePot', 'edgePot','NBSparse', 'CostMatrix', 'LabelMatrix','NB_GC', 'A');
    end
end
clc
clear
close all
  