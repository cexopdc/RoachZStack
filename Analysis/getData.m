function data=getData(dataset, starts)
    len = 1000;
    data = [];
    for i=1:length(starts)
        startIndex = starts(i);
        data = cat(3, data, dataset(:,startIndex:startIndex+len-1));
    end

end