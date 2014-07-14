function m=fit_func(k,a,b,theta)
    m = k .* abs((a+cos(theta*pi/180)).*(b+sin(theta*pi/180)));
end