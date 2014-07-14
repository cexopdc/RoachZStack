function [angle, dist] = fit_eval(fits, data)
    x = 0:1:360;
    y = 4:1:24;
    [x,y] = meshgrid(x, y);
    TOLERANCE = 100;
    
    for channel = [1,2,3]
        roots = abs(feval(fits{channel}, x, y) - data(channel)) < TOLERANCE;
        [angles_ind, dists_ind] = find(roots);
        candidates = [y(angles_ind, 1), x(1, dists_ind)'];
        if channel == 1
           remaining_candidates = candidates;
        else
           remaining_candidates = intersect(remaining_candidates, candidates, 'rows');
        end
    end
    
    error = zeros(size(x));
    for channel = [1,2,3]
        error = error + abs(feval(fits{channel}, x, y) - data(channel));
    end
    min_error = min(min(error));
    [i, j] = find(error==min_error);
    dist = y(i, 1);
    angle = x(1, j);
end