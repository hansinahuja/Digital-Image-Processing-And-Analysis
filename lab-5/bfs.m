function vis = bfs(img, visited, i, j)
    
vis = visited;
vis(i, j) = 1;
qi = [i];
qj = [j];
qsize = 1;
A = img;
while(qsize > 0)
    
    i = qi(1, 1); j = qj(1, 1);
    if(qsize > 1)
       qi = qi(2:qsize);
       qj = qj(2:qsize);
       qsize = qsize - 1;
    else
        qi = [];
        qj = [];
        qsize = qsize - 1;
    end
    
    
    if(i-1>0 && j-1>0 && A(i-1, j-1)==1 && vis(i-1, j-1)==0)
       qi(1, qsize+1) = i-1; qj(1, qsize+1) = j-1; qsize = qsize+1; vis(i-1, j-1) = 1;
    end
    if(j-1>0 && A(i, j-1)==1 && vis(i, j-1)==0)
       qi(1, qsize+1) = i; qj(1, qsize+1) = j-1; qsize = qsize+1; vis(i, j-1) = 1;
    end
    if(i+1<=size(img, 1) && j-1>0 && A(i+1, j-1)==1 && vis(i+1, j-1)==0)
       qi(1, qsize+1) = i+1; qj(1, qsize+1) = j-1; qsize = qsize+1; vis(i+1, j-1) = 1;
    end
    if(i-1>0 && A(i-1, j)==1 && vis(i, j)==0 && vis(i-1, j)==0)
       qi(1, qsize+1) = i-1; qj(1, qsize+1) = j; qsize = qsize+1; vis(i-1, j) = 1;
    end
    if(i+1<=size(img, 1) && A(i+1, j)==1 && vis(i+1, j)==0)
       qi(1, qsize+1) = i+1; qj(1, qsize+1) = j; qsize = qsize+1; vis(i+1, j-1) = 1;
    end
    if(i-1>0 && j+1<=size(img, 2) && A(i-1, j+1)==1 && vis(i-1, j+1)==0)
       qi(1, qsize+1) = i-1; qj(1, qsize+1) = j+1; qsize = qsize+1; vis(i-1, j+1) = 1;
    end
    if(j+1<=size(img, 2) && A(i, j+1)==1 && vis(i, j+1)==0)
       qi(1, qsize+1) = i; qj(1, qsize+1) = j+1; qsize = qsize+1; vis(i, j+1) = 1;
    end
    if(i+1<=size(img, 1) && j+1<=size(img, 2) && A(i+1, j+1)==1 && vis(i+1, j+1)==0)
       qi(1, qsize+1) = i+1; qj(1, qsize+1) = j+1; qsize = qsize+1; vis(i+1, j+1) = 1;
    end
    
end

end