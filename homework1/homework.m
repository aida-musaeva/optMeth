syms a;
syms b;
syms t;
x = [0;1;2;3;4];
y = [-1;2;-1;0;1];
f1 = sum((a*x+b-y).^2);
f2 = sum(abs(a*x+b-y));
fOneVar=@(f)subs(subs(f,a,1+t),b,3);
f1 = fOneVar(f1);
f2 = fOneVar(f2);
collect(f2)
collect(f1)

e = 0.000001;
a = -10;
b = 10;
A = [];
B = [];
C = [];
D = [];
fC = [];
fD = [];
E = [];

[opt, A, B, E, C, D, fC, fD] = dichotomy(f1,a,b,e);
xlswrite('homework.xlsx',A, 'dichotomyF1','A2');
xlswrite('homework.xlsx',B, 'dichotomyF1','B2');
xlswrite('homework.xlsx',E, 'dichotomyF1','C2');
xlswrite('homework.xlsx',C, 'dichotomyF1','D2');
xlswrite('homework.xlsx',D, 'dichotomyF1','E2');
xlswrite('homework.xlsx',fC,'dichotomyF1', 'F2');
xlswrite('homework.xlsx',fD,'dichotomyF1', 'G2');

ezplot(f1);
hold on
plot(opt,subs(f1,t,opt),'g.');
eval(subs(f1,t,opt))
[opt, A, B, E, C, D, fC, fD] = goldenSection(f1,a,b,e);
xlswrite('homework.xlsx',A, 'goldenSectionF1','A2');
xlswrite('homework.xlsx',B, 'goldenSectionF1','B2');
xlswrite('homework.xlsx',E, 'goldenSectionF1','C2');
xlswrite('homework.xlsx',C, 'goldenSectionF1','D2');
xlswrite('homework.xlsx',D, 'goldenSectionF1','E2');
xlswrite('homework.xlsx',fC,'goldenSectionF1', 'F2');
xlswrite('homework.xlsx',fD,'goldenSectionF1', 'G2');

plot(opt,subs(f1,t,opt),'r.');
hold off

[opt, A, B, E, C, D, fC, fD] = dichotomy(f2,a,b,e);
xlswrite('homework.xlsx',A, 'dichotomyF2','A2');
xlswrite('homework.xlsx',B, 'dichotomyF2','B2');
xlswrite('homework.xlsx',E, 'dichotomyF2','C2');
xlswrite('homework.xlsx',C, 'dichotomyF2','D2');
xlswrite('homework.xlsx',D, 'dichotomyF2','E2');
xlswrite('homework.xlsx',fC,'dichotomyF2', 'F2');
xlswrite('homework.xlsx',fD,'dichotomyF2', 'G2');

figure
ezplot(f2);
hold on
plot(opt,subs(f2,t,opt),'g.');

[opt, A, B, E, C, D, fC, fD] = goldenSection(f2,a,b,e);
xlswrite('homework.xlsx',A, 'goldenSectionF2','A2');
xlswrite('homework.xlsx',B, 'goldenSectionF2','B2');
xlswrite('homework.xlsx',E, 'goldenSectionF2','C2');
xlswrite('homework.xlsx',C, 'goldenSectionF2','D2');
xlswrite('homework.xlsx',D, 'goldenSectionF2','E2');
xlswrite('homework.xlsx',fC,'goldenSectionF2', 'F2');
xlswrite('homework.xlsx',fD,'goldenSectionF2', 'G2');

hold on
plot(opt,subs(f2,t,opt),'r.');
hold off
function [ xOpt ,A, B, E, C, D, fC, fD] = dichotomy(f, a, b, epsilon)
	syms t;
    C = [];
    D = [];
	fC = [];
    fD = [];
	ci = 0;
	di = 0;
    A = [];
    B = [];
	xmid = (a+b)/2;
    E = [];
    ei = abs(b-a)/2;
	while ei > epsilon
		ci = xmid - epsilon/2; %%epsilon==delta
		di = xmid + epsilon/2;
		fci = subs(f,t,ci);
		fdi = subs(f,t,di);
		C = [C; ci];
        D = [D; di];
		fC = [fC; eval(fci)];
        fD = [fD; eval(fdi)];
		if fci < fdi
			b = di;
		else
			a = ci;
        end
        A = [A; a];
        B = [B; b];
		xmid = (a+b)/2;
        ei = abs(b-a)/2;
        E = [E; ei];
	end
	xOpt = xmid;
end
function [ xOpt ,A, B, E, C, D, fC, fD] = goldenSection(f, a, b, epsilon)
	syms t;
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
		fci = subs(f,t,ci);
		fdi = subs(f,t,di);
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


    
    