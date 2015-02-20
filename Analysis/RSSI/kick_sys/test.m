
syms x_i y_i x_j y_j;
f = sqrt((x_i - x_j)^2+(y_i-y_j)^2);
f_x_i=diff(f,'x_i');
f_y_i=diff(f,'y_i');
f_x_j=diff(f,'x_j');
f_y_j=diff(f,'y_j');
a1 = 2; a2 = 3; a3 = 4; a4 =5;
my_f_x_i=subs(f_x_i,{x_i,y_i,x_j,y_j},{a1,a2,a3,a4});
my_f_y_i=subs(f_y_i,{x_i,y_i,x_j,y_j},{a1,a2,a3,a4});
my_f_x_j=subs(f_x_j,{x_i,y_i,x_j,y_j},{a1,a2,a3,a4});
my_f_y_j=subs(f_y_j,{x_i,y_i,x_j,y_j},{a1,a2,a3,a4});
f_prime = my_f_x_i*(x_i -a1) + my_f_y_i*(y_i -a2) + my_f_x_j*(x_j -a3) + my_f_y_j*(y_j -a4) + subs(f,{x_i,y_i,x_j,y_j},{a1,a2,a3,a4});

