% Manuel Manelli 29/10/2018

clear all
close all
clc

o = zeros(3,1)    %pinol

oc = [0;0;-8]      %posizione del centro del cilindro nello spazio
h = 5;            %altezza del cilindro
r = 3;            %raggio del cilindro

n = 10;        %n. di punti

ex = [0,180]      %intervallo
st = (ex(2) - ex(1))/(n/2);
th = [ex(1):st:ex(2)]

stz = h / (n/2)
y = [-h/2:stz:h/2]

x_cil = inline('r*cos((th/180)*pi)');
z_cil = inline('r*sin((th/180)*pi)');

for i = 1:numel(th)
    for j = 1:numel(y)
        M(j,i,1) = (oc(1)-o(1))+x_cil(r,th(i));     %x = (xc'-xc) + rcos(th)   |    M(i,j,1) i _> altezza y, j -> angolo theta
        M(j,i,2) = (oc(3)-o(3))+z_cil(r,th(i));     %z = (zc'-zc) + rsin(th)   |    1 -> X   2 -> Z  3 -> Y rispetto a o
        M(j,i,3) = (oc(2)-o(2)) + y(j);
    end
end

disp(M)
%prof
% ax = inline('acos(x/sqrt(x^2 + y^2 + z^2))');
% ay = inline('acos(y/sqrt(x^2 + y^2 + z^2))');
%io
ax = inline('asin(abs(0-z)/sqrt((0-y)^2 + (0-z)^2))');
ay = inline('asin(abs(0-z)/sqrt((0-z)^2 + (0-x)^2))');

x = oc(1); y = oc(2); z = oc(3);

r_in = [(pi/2 - ax(y,z));(pi/2 - ay(x,z));oc(1);oc(2);1]

for i=1:numel(M(:,1,1))
    for j=1:numel(M(1,:,1))
        plot3(M(i,j,1),M(i,j,3), M(i,j,2),'o'); hold on;
    end
end
xlabel('x')
ylabel('y')
zlabel('z')
