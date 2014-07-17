function [meshes, x, y] = predict_mesh( fits )
    x = 0:359;
    y = linspace(65, 97, 10);
    [x_mesh, y_mesh] = meshgrid(x, y);
    meshes = [];
    for channel = [1,2,3]
        mesh = feval(fits{channel}, x_mesh, y_mesh);
        meshes = cat(3, meshes, mesh);
    end
end

