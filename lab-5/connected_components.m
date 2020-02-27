img = imread('text.png');

visited = zeros(size(img));
comp = 0;

for i = 1:size(img, 1)
    for j = 1:size(img, 2)
        if(img(i, j)==1 && visited(i, j)==0)
           visited = bfs(img, visited, i, j);
           comp = comp+1;
            
        end
    end
end

disp(comp);