function H=ellipse(A)

a=5 * sqrt(A.cov(1,1)); % horizontal radius
b=5 * sqrt(A.cov(2,2)); % vertical radius
x0=A.est_pos(1); % x0,y0 ellipse centre coordinates
y0=A.est_pos(2);
t=-pi:0.01:pi;
x=x0+a*cos(t);
y=y0+b*sin(t);
H = plot(x,y,':','LineWidth',2);
end
