%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to calculate the distance between two nodes using real
% position
function dist=DIST(A,B)
global FLOP_COUNT_FLAG;
%dist=sqrt((A.x-B.x)^2+(A.y-B.y)^2);
dist=sqrt((A.pos(1)-B.pos(1))^2+(A.pos(2)-B.pos(2))^2);
if FLOP_COUNT_FLAG == 1
    addflops(flops_sqrt + 2*flops_pow(2) + 3*1);
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%