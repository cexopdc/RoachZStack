% Iterative Weight Least Squares Estiamtion
% 1. get distances to available beacons, along with std (the bias factor).
% 2. do a LS lateration to get the initial est and std.
% 3. Each node do a IWLSE lateration with neighbor nodes.