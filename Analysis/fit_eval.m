function [angle, dist] = fit_eval(x, y, predicted, data)

    error = zeros(size(squeeze(predicted(:,:,1))));
    for channel = [1,2,3]
        error = error + (predicted(:,:,channel) - data(channel)).^2;
    end
    min_error = min(min(error));
    [i, j] = find(error==min_error);
    i = i(1);
    j = j(1);
    dist = y(i);
    angle = x(j);
end