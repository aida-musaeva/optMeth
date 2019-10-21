syms a;
syms b;
syms p;
double t;
syms f;
syms f1;
x = [0;1;2;3;4];
y = [0;1;2;3;4];
f = @(t)max(abs((1+t).*x+3.-y));
f3 = abs(a*x+b-y);
f1 = sum((a*x+b-y).^2);
collect(f1)
fOneVar=@(f)subs(subs(f,a,1+p),b,3);
f1 = fOneVar(f1);
% f3 = fOneVar(f3);
% L = max(eval(subs(diff(f3),p,10)))
% syms x;
% a = -10;
% b = 10;
% eps = 0.1;      
% e = 0.001;      
% fX = [];
% pX = [];
% dFx = [];
% [opt1,X,fX,pX] = brokenLine(f,a,b,L,e)
% xlswrite('homework2.xlsx',X, 'brokenLine','A2');
% xlswrite('homework2.xlsx',fX, 'brokenLine','B2');
% xlswrite('homework2.xlsx',pX, 'brokenLine','C2');
% xlswrite('homework2.xlsx',[fX-pX], 'brokenLine','D2');
% 
% figure
% plot(linspace(-10,10),f(linspace(-10,10)))
% hold on
% plot(opt1,f(opt1),'r.');
% % f = @(x)sin(x)/x;                         example
% % [opt] = brokenLine(f,10,15,0.11,0.01)
% 
% [opt,X,fX,dFx] = NewtonRaphson(f1,a,b,eps);
% xlswrite('homework2.xlsx',X, 'NewtonRaphson','A2');
% xlswrite('homework2.xlsx',fX, 'NewtonRaphson','B2');
% xlswrite('homework2.xlsx',dFx, 'NewtonRaphson','C2');
% 
% figure
% ezplot(f1);
% hold on
% plot(opt,subs(f1,p,opt),'r.');
% 
% figure
% plot(linspace(-10,10),f(linspace(-10,10)))
% hold on
% plot(opt1,f(opt1),'r.');
% 


function [xi,X,fX,dFx] = NewtonRaphson(f,a,b,e)
    syms p;
    syms x;
    fX = [];
    dFx = [];
    X = [];
    xi0 = 2;    
    xi = xi0-eval(subs(f,p,xi0))/eval(subs(diff(f,p),p,xi0));
    X = [xi0];
    fX = [eval(subs(f,p,xi0))];
    dFx = [eval(subs(diff(f,p),p,xi0))];
    ezplot(eval(subs(f,p,xi0))+eval(subs(diff(f,p),p,xi0)*(x-xi0)));
    hold on
    while (abs(eval(subs(diff(f,p),p,xi)))>e)
        xi0 = xi;
        xi = xi0-eval(subs(f,p,xi0))/eval(subs(diff(f,p),p,xi0));
        X = [X; xi0];
        fX = [fX; eval(subs(f,p,xi0))];
        dFx = [dFx; eval(subs(diff(f,p),p,xi0))];
        ezplot(eval(subs(f,p,xi0))+eval(subs(diff(f,p),p,xi0)*(x-xi0)));
        hold on
        ans = xi-xi0
    end
end

function [xi,X,fX,pX] = brokenLine(f,a,b,L,e)
    x1 = (f(a)-f(b)+L*(a+b))/(2*L);
    p1 = (f(a)+f(b)+L*(a-b))/2;
    fX = [f(x1);];
    pX = [p1];
    delta = (f(x1)-p1)/(2*L);
    p_1 = (f(x1)+p1)/2;
    x_1 = x1-delta;
    x__1 = x1+delta;
    X = [x_1;x__1;];
    P = [p_1;p_1];
    xi = x1;
    pi = p_1;
    while (f(xi)-pi>e)
        [pi,I] = min(P);
        xi = X(I);
        fX = [fX; f(xi)];
        pX = [pX; pi];
        P = [P(1:I-1);P(I+1:size(P))];
        X = [X(1:I-1);X(I+1:size(X))];
        delta = (f(xi)-pi)/(2*L);
        x_ = xi-delta;
        x__ = xi+delta;
        p_ = (f(xi)+pi)/2;
        X = [X;x_;x__;];
        P = [P;p_;p_];
%         g = f(xi)-L*abs(x-xi);
%         ezplot(g)
%         hold on
%         plot(xi,f(xi),'r.');
%         ans = f(xi)-pi
        
    end
end