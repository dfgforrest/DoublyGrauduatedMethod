function X = OUR_MRF(S, N, L)
%% Initialization
X = ones(N,L)/L;
zeta = 1;
eta = 0.00001;
Scale = N * L;
for sigma = 2:-0.01:0
    sigma;
    for FW_i = 1 : 10
        DF = reshape((S+S')*reshape(X', N*L, 1), L, N); DF = DF';
        DC = X.*(X-ones(N,L)).*(2*X-ones(N,L));
        DJ = DF - zeta*DC + 6*zeta*sigma^2*(ones(N,L)-2*X);
        if sum(sum(abs(DJ))) < eta
            Continue;
        end

        %line search     X = X + alpha*DJ;
        Y = MaxY(DJ,N,L);

        XPre = X;
        %divided method
        Xleft = X;
        Xright = Y;
        deltaX = (Xright - Xleft);
        for i = 1:20
            X1 = Xleft + 0.5*deltaX;
            X2 = Xleft + (0.5 + eta)*deltaX;
            J1 = J(S, X1, sigma, zeta, N, L);
            J2 = J(S, X2, sigma, zeta, N, L);

            if J1 < J2
               Xleft = X1;
            else
               Xright = X1;
            end
            deltaX = Xright - Xleft;
        end
        X = Xleft;
        if sum(sum(abs(X-XPre)))< Scale*eta
           break; 
        end
    end
    if sum(sum(abs(X - MaxY(X,N,L)))) < Scale*eta
        break;
    end
end
X = MaxY(X,N,L);
end

function Jsigma = J(S, X, sigma, zeta, N, L)
    vecX = reshape(X',N*L,1);
    F = vecX'*S*vecX;
    C = sum(sum((X.^2).*((1-X).^2)));
    J = F - zeta*C;
    Jsigma = J + 6*zeta*sigma^2*sum(sum(X.*(1-X)));
end
function Y = MaxY(X,N,L)
    Y = zeros(N,L); 
    [ins MaxCol] = max(X, [], 2); 
    Y((1:N)'+ (MaxCol-1)*N) = 1;
end