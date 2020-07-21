adjA = [0 1 0 0;
    0 0 0 1;
    0 0 0 1;
    0 1 0 0];
v = [1 1 1 0];
D = diag(v);
L = D - adjA;

xdx = [1;3;1;3];
xdy = [1;1;3;3];

for i = 1:4
    for j = 1:4
        sumA(i,j) = adjA(i,j)*(xdx(i)-xdx(j));
        sumB(i,j) = adjA(i,j)*(xdy(i)-xdy(j));
    end
    rx(i) = -(1/xdx(i)*sum(sumA(i,:)));
    ry(i) = -(1/xdy(i)*sum(sumB(i,:)));
end

Rx = [rx(1) 0 0 0;
    0 rx(2) 0 0;
    0 0 rx(3) 0;
    0 0 0 rx(4)];
    
Ry = [ry(1) 0 0 0;
    0 ry(2) 0 0;
    0 0 ry(3) 0;
    0 0 0 ry(4)];

phix = L + Rx;
phiy = L + Ry;
 
eig(phix);
eig(phiy);
 
Ax = [ -L -Rx; zeros(4) -phix];
Ay = [ -L -Ry; zeros(4) -phiy];

A = rand(4,4);
B = zeros(8,1);
C = eye(8);
D = 0;
t = 0:0.01:50;
u = zeros(size(t));

f = size(t);
f = f(1,2);

sysx = ss(Ax,B,C,D);
sysy = ss(Ay,B,C,D);

x1 = lsim(sysx,u,t,[1,1 1,4 4,1 4,4]);
y1 = lsim(sysy,u,t,[2,2 2,4 5,2 5,4]);

hold on
plot(x1(:,1),y1(:,7),'k--', x1(:,2),y1(:,6),'r--',x1(:,3),y1(:,5),'b--',x1(:,4),y1(:,4),'--');
plot([1,1 1,2 1,3 1,4],[2,1 2,2 2,3 2,4],'o');
plot([1,2 3,4 5,6 7,8 7,6 5,4 3,2 1,8], '-gx', 'LineWidth',1);
plot([x1(1,2) x1(3,4) x1(5,6) x1(7,8)],[y1(7,6) y1(5,4) y1(3,2) y1(1,8)], '-md', 'LineWidth',1);
axis([-4 10 -2 12])
legend('agent 1 trajectories','agent 2 trajectories','agent 3 trajectories','agent 4 trajectories','initial position')
xlabel('x-axis')
ylabel('yaxis')
hold off
