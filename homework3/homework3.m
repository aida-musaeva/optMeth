syms a;
syms b;
syms t;
syms lambda;
x = [0;1;2;3;4];
y = [-1;2;-1;0;1];
f1 = sum((a*x+b-y).^2);
f2 = sum(abs(a*x+b-y));
eps = 0.000001;
xi0 = [1,1];
X = [];
fX = [];
G = [];
deltaF = [];
deltaX = [];
eval(f1)
% % [opt, X, fX, deltaX, deltaF] = coordinateDescent(f1,xi0,eps)
% % xlswrite('homework3.xlsx',X, 'coordinateDescentF1','A2');
% % xlswrite('homework3.xlsx',fX, 'coordinateDescentF1','C2');
% % xlswrite('homework3.xlsx',deltaX, 'coordinateDescentF1','D2');
% % xlswrite('homework3.xlsx',deltaF, 'coordinateDescentF1','E2');
% % eval(subs(subs(f1,a,opt(1)),b,opt(2))); %%fOpt
% % 
% % [opt, X, fX, deltaX, deltaF] = coordinateDescent(f2,[0.5,0.5],eps)
% % xlswrite('homework3.xlsx',X, 'coordinateDescentF2','A2');
% % xlswrite('homework3.xlsx',fX, 'coordinateDescentF2','C2');
% % xlswrite('homework3.xlsx',deltaX, 'coordinateDescentF2','D2');
% % xlswrite('homework3.xlsx',deltaF, 'coordinateDescentF2','E2');
% % eval(subs(subs(f2,a,opt(1)),b,opt(2)));  %%fOpt
% % 
% % 
% % [opt, X, fX, G] = steepestDescent(f1,[1,1],0.000001);
% % xlswrite('homework3.xlsx',X, 'steepestDescentF1','A2');
% % xlswrite('homework3.xlsx',fX, 'steepestDescentF1','C2');
% % xlswrite('homework3.xlsx',G, 'steepestDescentF1','D2');
% % eval(subs(subs(f1,a,opt(1,1)),b,opt(1,2)));  %%fOpt
% % 
% % 
% % [opt, X, fX, G] = gradientMethodWcrush(f1,[1,1],0.000001)
% % xlswrite('homework3.xlsx',X, 'gradientMethodWcrushF1','A2');
% % xlswrite('homework3.xlsx',fX, 'gradientMethodWcrushF1','C2');
% % xlswrite('homework3.xlsx',G, 'gradientMethodWcrushF1','D2');
% % eval(subs(subs(f1,a,opt(1,1)),b,opt(1,2)))  %%fOpt

% [opt, X, fX, G] = gradientMethodWconst(f1,[1,1],0.000001)
% xlswrite('homework3.xlsx',X, 'gradientMethodWconstF1','A2');
% xlswrite('homework3.xlsx',fX, 'gradientMethodWconstF1','C2');
% xlswrite('homework3.xlsx',G, 'gradientMethodWconstF1','D2');
% eval(subs(subs(f1,a,opt(1,1)),b,opt(1,2)))  %%fOpt

function [xOpt, X, FX, G] = steepestDescent(f,xk,eps)       
    syms a;
    syms b;
    syms lambda;
    X = [];
    FX = [];
    G = [];
    X = [xk];
    fXk = eval(subs(subs(f,a,xk(1)),b,xk(2)));    
    FX = [fXk];
    mGrad = sqrt(diff(f,a)^2+diff(f,b)^2);
    mGrXk = eval(subs(subs(mGrad,a,xk(1)),b,xk(2)));
    G = [mGrXk];
    while (mGrXk>eps)
        dfXk = [subs(subs(diff(f,a),a,xk(1)),b,xk(2)),subs(subs(diff(f,b),a,xk(1)),b,xk(2))];
        lambdaK = goldenSection(subs(subs(f,a,xk(1)-lambda*dfXk(1)),b,xk(2)-lambda*dfXk(2)),0,500,eps);
        xk = xk - lambdaK*dfXk;
        X = [X;double(xk)];
        fXk = eval(subs(subs(f,a,xk(1,1)),b,xk(1,2)));
        FX = [FX;fXk];
        mGrXk = eval(subs(subs(mGrad,a,xk(1)),b,xk(2)))
        G = [G;mGrXk];
        xOpt = double(xk); 
    end
end
function [xOpt, X, FX, G] = gradientMethodWconst(f,xk,eps)  
    syms a;
    syms b;
    G = [];
    X = [];
    X = [xk];
    FX = [];
    mGrad = sqrt(diff(f,a)^2+diff(f,b)^2);
    mGrXk = eval(subs(subs(mGrad,a,xk(1)),b,xk(2)));
    fXk = eval(subs(subs(f,a,xk(1,1)),b,xk(1,2)));
    FX = [FX; fXk];
    G = [G;mGrXk];
   
    fDiff = diff(f,a)+diff(f,b); %%fDiff->max
    i = -10;
    j = -10;
    fx = subs(subs(fDiff,a,i),b,j);
    L = abs(fx);
    while (i<=10)
        while (j<=10)
            fx = subs(subs(fDiff,a,i),b,j);
            if fx>L
                L = abs(fx);
            end
            j = j+1;
        end
        i = i+1;
    end
    
    while (mGrXk>=eps)
       lambda = (1-0.5)/L;
       dfXk = [subs(subs(diff(f,a),a,xk(1)),b,xk(2)),subs(subs(diff(f,b),a,xk(1)),b,xk(2))];
       xk = xk - lambda*dfXk;
       X = [X;double(xk)];
       fX = double(subs(subs(f,a,xk(1)),b,xk(2)));
       FX = [FX;fX];
       mGrXk = double(subs(subs(mGrad,a,xk(1)),b,xk(2)));
       G = [G;mGrXk]
    end
    xOpt = double(xk);
end
function [xOpt, X, FX, G] = gradientMethodWcrush(f,xk,eps)
    syms a;
    syms b;
    lambda = 1/2;
    lambdaK = lambda;
    delta = 1/2;
    G = [];
    X = [];
    X = [xk];
    FX = [];
    grad = sqrt(diff(f,a)^2+diff(f,b)^2);
    mGrXk = eval(subs(subs(grad,a,xk(1,1)),b,xk(1,2)));
    G = [mGrXk];
    fXk = eval(subs(subs(f,a,xk(1,1)),b,xk(1,2)));
    FX = [FX; fXk];
    G = [G;mGrXk];
    xk1 = xk;
        while (mGrXk>eps)
           dfXk = [subs(subs(diff(f,a),a,xk(1,1)),b,xk(1,2)),subs(subs(diff(f,b),a,xk(1,1)),b,xk(1,2))];
           xk1 = xk - lambdaK*dfXk;
           X = [X;eval(xk1)];
           fX = eval(subs(subs(f,a,xk1(1,1)),b,xk1(1,2)));
           fXk = eval(subs(subs(f,a,xk(1,1)),b,xk(1,2)));
           FX = [FX;fX];
           mGrXk = eval(subs(subs(grad,a,xk(1,1)),b,xk(1,2)));
           if((fX-fXk)<= -lambdaK*delta*mGrXk^2)
               lambdaK = lambda;
               xk = xk1;
           else
               lambdaK = lambdaK/2;
           end
           G = [G;mGrXk];
        end
        xOpt = double(xk);
end
function [xOpt, X, fX, deltaX, deltaF] = coordinateDescent(f,xi0,eps)
    syms a;
    syms b;
    syms lambda;
    X = [];
    fX = [];
    deltaF = [];
    deltaX = [];
    xi = [xi0(1)+lambda,xi0(2);xi0(1),xi0(2)+lambda];
    lambda1 = goldenSection((eval(subs(subs(f,a,xi(1,1)),b,xi(1,2)))),-100,100,eps);
    lambda2 = goldenSection((eval(subs(subs(f,a,xi(2,1)),b,xi(2,2)))),-100,100,eps);
    xi = [xi0(1)+lambda1, xi0(2)+lambda2];
    X = [xi0;xi];
    deltaX = [deltaX;sum((xi-xi0).^2)];
    fi0 = eval(subs(subs(f,a,xi0(1,1)),b,xi0(1,2)));
    fi = eval(subs(subs(f,a,xi(1,1)),b,xi(1,2)));
    fX = [fi0;fi];
    xi0 = xi;
    deltaF = [abs(fi-fi0)];
    while(abs(fi-fi0)>eps)
        xi = [xi0(1)+lambda,xi0(2);xi0(1),xi0(2)+lambda];
        lambda1 = goldenSection((eval(subs(subs(f,a,xi(1,1)),b,xi(1,2)))),-10,10,eps);
        lambda2 = goldenSection((eval(subs(subs(f,a,xi(2,1)),b,xi(2,2)))),-10,10,eps);
        xi = [xi0(1)+lambda1, xi0(2)+lambda2];
        X = [X;xi];
        deltaX = [deltaX;sum((xi-xi0).^2)];
        fi0 = eval(subs(subs(f,a,xi0(1,1)),b,xi0(1,2)));
        fi = eval(subs(subs(f,a,xi(1,1)),b,xi(1,2)));
        deltaF = [deltaF;abs(fi-fi0)]
        fX = [fX; fi];
        xi0 = xi;
    end
    xOpt = xi;
end
function [ xOpt ,A, B, E, C, D, fC, fD] = goldenSection(f, a, b, epsilon)
	syms lambda;
    C = [];
    D = [];
	fC = [];
    fD = [];
	ci = 0;
	di = 0;
    A = [];
    B = [];
    E = [];
    ei = abs(b-a)/2;
    xOpt = 0;
	while ei > epsilon
        ci = a + ((3-sqrt(5))/2)*(b-a);
        di = a + ((sqrt(5)-1)/2)*(b-a);
		fci = subs(f,lambda,ci);
		fdi = subs(f,lambda,di);
		C = [C; ci];
        D = [D; di];
		fC = [fC; eval(fci)];
        fD = [fD; eval(fdi)];
		if fci < fdi
			b = di;
            xOpt = ci;
		else
			a = ci;
            xOpt = di;
        end
        A = [A; a];
        B = [B; b];
        ei = abs(b-a)/2;
        E = [E; ei];
    end
end