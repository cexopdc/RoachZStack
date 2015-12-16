error_matrix = [];
for i=1:5
    error_array = [];
    for j=1:3
        mean_error = main_process(i,j);
        error_array = [error_array mean_error];
    end
    error_matrix = [error_matrix;error_array];
end