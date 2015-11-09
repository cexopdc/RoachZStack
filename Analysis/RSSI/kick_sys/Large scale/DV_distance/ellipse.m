function H=ellipse(A)
sqrt(A.cov(1,1))
sqrt(A.cov(2,2))
if sqrt(A.cov(1,1))>50 || sqrt(A.cov(2,2))>50
    a=3 * sqrt(A.cov(1,1)); % horizontal radius
    b=3 * sqrt(A.cov(2,2)); % vertical radius
elseif sqrt(A.cov(1,1))>5 || sqrt(A.cov(2,2))>5
    a=0.7 * sqrt(A.cov(1,1)); % horizontal radius
    b=0.7 * sqrt(A.cov(2,2)); % vertical radius
elseif sqrt(A.cov(1,1))>3 || sqrt(A.cov(2,2))>3
    a=2 * sqrt(A.cov(1,1)); % horizontal radius
    b=2 * sqrt(A.cov(2,2)); % vertical radius
elseif sqrt(A.cov(1,1))>1.2 || sqrt(A.cov(2,2))>1.2
    a=2.7 * sqrt(A.cov(1,1)); % horizontal radius
    b=2.7 * sqrt(A.cov(2,2)); % vertical radius
elseif sqrt(A.cov(1,1))> 0.8 || sqrt(A.cov(2,2))> 0.8
    a=3.3 * sqrt(A.cov(1,1)); % horizontal radius
    b=3.4 * sqrt(A.cov(2,2)); % vertical radius
elseif sqrt(A.cov(1,1))> 0.6 || sqrt(A.cov(2,2))> 0.6
    a=3.8 * sqrt(A.cov(1,1)); % horizontal radius
    b=3.8 * sqrt(A.cov(2,2)); % vertical radius
elseif sqrt(A.cov(1,1))> 0.4 || sqrt(A.cov(2,2))> 0.4
    a=4.6 * sqrt(A.cov(1,1)); % horizontal radius
    b=4.6 * sqrt(A.cov(2,2)); % vertical radius
elseif sqrt(A.cov(1,1))> 0.2 || sqrt(A.cov(2,2))> 0.2
    a=5.4 * sqrt(A.cov(1,1)); % horizontal radius
    b=5.4 * sqrt(A.cov(2,2)); % vertical radius  
else
    a=6.7 * sqrt(A.cov(1,1)); % horizontal radius
    b=6.7 * sqrt(A.cov(2,2)); % vertical radius
end
x0=A.est_pos(1); % x0,y0 ellipse centre coordinates
y0=A.est_pos(2);
t=-pi:0.01:pi;
x=x0+a*cos(t);
y=y0+b*sin(t);
H = plot(x,y,':','LineWidth',2);
end
