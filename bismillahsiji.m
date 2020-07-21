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

x = lsim(sysx,u,t,[2;4;8;2;4;9;8;xdx(4)]);
y = lsim(sysy,u,t,[0;0;1;8;8;2;9;xdy(4)]);

x1 = lsim(sysx,u,t,[x(f,1);x(f,2);x(f,3);x(f,4);x(f,5);x(f,6);x(f,7);xdx(4)*2]);
y1 = lsim(sysy,u,t,[y(f,1);y(f,2);y(f,3);y(f,4);y(f,5);y(f,6);y(f,7);xdy(4)*2]);

hold on
plot(x(:,1),y(:,1),'k--', x(:,2),y(:,2),'r--',x(:,3),y(:,3),'b--',x(:,4),y(:,4),'--');
plot([x(1,1) x(1,2) x(1,3) x(1,4)],[y(1,1) y(1,2) y(1,3) y(1,4)], 'o');
plot([x(f,1) x(f,2) x(f,4) x(f,3) x(f,1)],[y(f,1) y(f,2) y(f,4) y(f,3) y(f,1)], '-gx', 'LineWidth',1)
plot([x1(f,1) x1(f,2) x1(f,4) x1(f,3) x1(f,1)],[y1(f,1) y1(f,2) y1(f,4) y1(f,3) y1(f,1)], '-md', 'LineWidth',1)
plot(x1(:,1),y1(:,1),'k--', x1(:,2),y1(:,2),'r--',x1(:,3),y1(:,3),'b--',x1(:,4),y1(:,4),'--');
legend('agent 1 trajectories','agent 2 trajectories','agent 3 trajectories','agent 4 trajectories','initial position')
axis([-4 10 -2 12])
xlabel('x-axis')
ylabel('yaxis')
hold off
