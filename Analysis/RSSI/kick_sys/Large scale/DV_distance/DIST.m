%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to calculate the distance between two nodes using real
% position
function dist=DIST(A,B)
%dist=sqrt((A.x-B.x)^2+(A.y-B.y)^2);
dist=sqrt((A.pos(1)-B.pos(1))^2+(A.pos(2)-B.pos(2))^2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%