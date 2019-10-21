syms a;
syms b;
x = [0;1;2;3;4];
y = [-1;2;-1;0;1];
f1 = sum((a*x+b-y).^2);
f2 = sum(abs(a*x+b-y));
figure
ezsurf(f1);
hold on
plot3(0.2,-0.2,6.4,'r.')

figure
ezsurf(f2);
hold on
plot3(0.5,-1,4,'r.');
