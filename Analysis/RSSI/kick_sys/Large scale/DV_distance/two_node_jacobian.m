function [H_i,H_j,H_k] = two_node_jacobian(A,B,C)

%{
% run this one time to get the partial derivative formula below.
syms x_i y_i x_j y_j x_k y_k;
f = x_i*(2*x_k-2*x_j) + y_i*(2*y_k-2*y_j) + x_j^2 + y_j^2 - x_k^2 - y_k^2;
f_x_i=diff(f,'x_i');
f_y_i=diff(f,'y_i');
f_x_j=diff(f,'x_j');
f_y_j=diff(f,'y_j');
f_x_k=diff(f,'x_k');
f_y_k=diff(f,'y_k');
my_f_x_i=subs(f_x_i,{x_i,y_i,x_j,y_j},{A.est_pos(1),A.est_pos(2),B.est_pos(1),B.est_pos(2)});
my_f_y_i=subs(f_y_i,{x_i,y_i,x_j,y_j},{A.est_pos(1),A.est_pos(2),B.est_pos(1),B.est_pos(2)});
my_f_x_j=subs(f_x_j,{x_i,y_i,x_j,y_j},{A.est_pos(1),A.est_pos(2),B.est_pos(1),B.est_pos(2)});
my_f_y_j=subs(f_y_j,{x_i,y_i,x_j,y_j},{A.est_pos(1),A.est_pos(2),B.est_pos(1),B.est_pos(2)});
%}

x_i = A.est_pos(1);
y_i = A.est_pos(2);
x_j = B.est_pos(1);
y_j = B.est_pos(2);
x_k = C.est_pos(1);
y_k = C.est_pos(2);
% formula obtained from above commented code
global FLOP_COUNT_FLAG;
my_f_x_i = 2*x_k-2*x_j;
my_f_y_i = 2*y_k-2*y_j;
my_f_x_j = 2*x_j - 2*x_i;
my_f_y_j = 2*y_j - 2*y_i;
my_f_x_k = 2*x_i - 2*x_k;
my_f_y_k = 2*y_i - 2*y_k;
if FLOP_COUNT_FLAG == 1
    addflops(3*6*1);
end

H_i = [my_f_x_i my_f_y_i];
H_j = [my_f_x_j my_f_y_j];
H_k = [my_f_x_k my_f_y_k];
end
